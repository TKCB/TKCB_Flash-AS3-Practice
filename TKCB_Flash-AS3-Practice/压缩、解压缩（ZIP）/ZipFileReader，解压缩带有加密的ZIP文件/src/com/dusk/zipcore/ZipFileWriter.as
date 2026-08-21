/**
 *  Copyright (c)  2009 coltware@gmail.com
 *  http://www.coltware.com
 *
 *  License: LGPL v3 ( http://www.gnu.org/licenses/lgpl-3.0-standalone.html )
 *
 * @author coltware@gmail.com
 */
package com.dusk.zipcore {
    
    import com.dusk.zipcore.crypto.ICrypto;
    import com.dusk.zipcore.crypto.ZipCrypto;
    import com.dusk.zipcore.event.ZipEvent;
    import com.dusk.zipcore.struct.ZipEndRecord;
    import com.dusk.zipcore.struct.ZipEntry;
    import com.dusk.zipcore.utils.ZipLog;
    import com.dusk.zipcore.struct.ZipHeader;
    import com.dusk.zipcore.utils.ZipCRC32;
    
    import flash.events.EventDispatcher;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.utils.setTimeout;
    import flash.utils.CompressionAlgorithm;
    import flash.utils.Endian;
    
    use namespace zip_internal;
    
    [Event(name="zipDataCompress", type="com.dusk.zipcore.event.ZipEvent")]
    [Event(name="zipFileCreated", type="com.dusk.zipcore.event.ZipEvent")]
    
    /**
     *
     *  创建ZIP文件的类
     *
     */
    public class ZipFileWriter extends EventDispatcher {
        
        private var _headers:Array;
        private var _endRecord:ZipEndRecord;
        
        
        private var _stream:FileStream;
        private var _filenameEncoding:String = "utf-8";
        private var _numFiles:int = 0;
        private var _host:int = 0;
        
        public static var HOST_WIN:String = "WIN";
        public static var HOST_UNIX:String = "UNIX";
        
        private var _dirMode:int = parseInt("0770", 8);
        private var _fileMode:int = parseInt("0640", 8);
        
        private var _async:Boolean = false;
        private var _zipStack:Array;
        private var _zipWorking:Boolean = false;
        
        /* 加密时的密码 */
        private var _password:ByteArray;
        private var _isCrypt:Boolean = false;
        private var _crypt:ICrypto;
        
        public function ZipFileWriter(hostType:String = "WIN") {
            _headers = [];
            
            if (hostType == HOST_WIN) _host = 0;
            else if (hostType == HOST_UNIX) _host = 3;

            _crypt = new ZipCrypto();
        }
        
        public function setCrypto(crypto:ICrypto):void {
            _crypt = crypto;
        }
        
        public function setPasswordBytes(bytes:ByteArray):void {
            if (bytes) {
                _password = bytes;
                _password.position = 0;
                _isCrypt = true;
            }
            else {
                _isCrypt = false;
            }
        }
        
        /**
         *  以字符串形式指定密码
         */
        public function setPassword(password:String, charset:String = null):void {
            var ba:ByteArray = new ByteArray();
            if (charset == null) {
                ba.writeUTFBytes(password);
            }
            else {
                ba.writeMultiByte(password, charset);
            }
            _password = ba;
            _password.position = 0;
            
            _isCrypt = true;
        }
        
        /**
         *  指定UNIX类型时注册目录的文件模式
         *
         *  以"0775"这样的八进制字符串指定
         *
         */
        public function setDirMode(mode:String):void {
            _dirMode = parseInt(mode, 8);
        }
        
        /**
         *
         *  指定UNIX类型时注册文件的模式
         *
         *  以"0665"这样的八进制字符串指定
         *
         */
        public function setFileMode(mode:String):void {
            _fileMode = parseInt(mode, 8);
        }
        
        /**
         *  打开ZIP文件
         *  如果文件已存在则覆盖
         */
        public function open(file:File):void {
            ZipLog.debug("open file :" + file.nativePath);
            _stream = new FileStream();
            _stream.open(file, FileMode.WRITE);
            _stream.endian = Endian.LITTLE_ENDIAN;
            _stream.position = 0;
        }
        
        /**
         * 以异步处理模式打开ZIP文件写入
         *
         * 注意：异步处理仅在写入时发生
         * open处理是同步的
         *
         */
        public function openAsync(file:File):void {
            _async = true;
            _zipStack = [];
            open(file);
        }
        
        /**
         *  将File添加到zip文件中
         *  注意：修改日期会自动添加
         */
        public function addFile(file:File, filename:String):void {
            if (_async) {
                var task:Object = new Object();
                task.type = "file";
                task.file = file;
                task.filename = filename;
                _zipStack.push(task);
                execZip();
            }
            else {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                var bytes:ByteArray = new ByteArray();
                fs.readBytes(bytes, 0, file.size);
                fs.close();
                internalAddBytes(false, filename, bytes, file.modificationDate);
            }
        }
        
        /**
         *  将ByteArray数据添加到zip文件中
         */
        public function addBytes(bytes:ByteArray, filename:String, date:Date = null):void {
            if (_async) {
                var task:Object = new Object();
                task.type = "bytes";
                task.filename = filename;
                task.bytes = bytes;
                task.date = date;
                _zipStack.push(task);
                execZip();
            }
            else {
                internalAddBytes(false, filename, bytes, date);
            }
        }
        
        /**
         *  添加目录信息
         */
        public function addDirectory(filename:String):void {
            if (filename.charAt(filename.length - 1) != "/") {
                filename += "/";
            }
            if (_async) {
                var task:Object = new Object();
                task.type = "dir";
                task.filename = filename;
                _zipStack.push(task);
                execZip();
            }
            else {
                internalAddBytes(true, filename);
            }
        }
        
        
        /**
         *  关闭ZipFileWriter
         */
        public function close():void {
            if (_async) {
                var task:Object = new Object();
                task.type = "close";
                _zipStack.push(task);
                execZip();
            }
            else {
                execClose();
            }
            ZipLog.debug("close");
        }
        
        /**
         *  @private
         *
         */
        private function execClose():void {
            var len:int = _headers.length;
            var pos1:Number = _stream.position;
            for (var i:int = 0; i < len; i++) {
                var header:ZipHeader = _headers[i] as ZipHeader;
                header.writeCentralHeader(_stream);
            }
            var pos2:Number = _stream.position;
            
            _endRecord = new ZipEndRecord();
            _endRecord.write(_stream, _numFiles, pos1, pos2 - pos1);
            _stream.close();
        }
        
        /**
         *  @private
         *
         */
        private function execZip(delay:int = 10):void {
            if (_zipStack.length > 0 && _zipWorking == false) {
                _zipWorking = true;
                var task:Object = _zipStack.shift();
                setTimeout(zipAsyncTimeout, delay, task);
            }
        }
        
        private function zipAsyncTimeout(task:Object):void {
            var filename:String;
            var bytes:ByteArray;
            var zipHeader:ZipHeader;
            if (task.type == "file") {
                var file:File = task.file;
                filename = task.filename;
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                bytes = new ByteArray();
                fs.readBytes(bytes, 0, file.size);
                fs.close();
                zipHeader = internalAddBytes(false, filename, bytes, file.modificationDate);
            }
            else if (task.type == "bytes") {
                filename = task.filename;
                bytes = task.bytes;
                var date:Date = task.date;
                zipHeader = internalAddBytes(false, filename, bytes, date);
            }
            else if (task.type == "dir") {
                zipHeader = internalAddBytes(true, task.filename);
            }
            else if (task.type == "close") {
                execClose();
            }
            if (task.type == "close") {
                var end:ZipEvent = new ZipEvent(ZipEvent.ZIP_FILE_CREATED);
                dispatchEvent(end);
            }
            else if (zipHeader) {
                var zip:ZipEvent = new ZipEvent(ZipEvent.ZIP_DATA_COMPRESS);
                zip.$entry = new ZipEntry(_stream);
                zip.$entry.setHeader(zipHeader);
                dispatchEvent(zip);
            }
            _zipWorking = false;
            execZip();
        }
        
        /**
         *
         * @private
         */
        private function internalAddBytes(isDir:Boolean, filename:String, data:ByteArray = null, date:Date = null):ZipHeader {
            
            if (date == null) {
                date = new Date();
            }
            
            var header:ZipHeader = new ZipHeader();
            
            header._lastModTime = uint(date.getSeconds()) | (uint(date.getMinutes()) << 5) | (uint(date.getHours()) << 11);
            header._lastModDate = uint(date.getDate()) | (uint(date.getMonth() + 1) << 5) | (uint(date.getFullYear() - 1980) << 9);
            
            var filenameBytes:ByteArray = new ByteArray();
            filenameBytes.writeMultiByte(filename, _filenameEncoding);
            header._filename = filenameBytes;
            header._filenameLength = filenameBytes.length;
            
            header._extraFieldLength = 0;
            
            // 需要加密的情况下
            if (_isCrypt) {
                header._bitFlag = 0x1;
            }
            else {
                header._bitFlag = 0;
            }
            
            
            /****  从这里开始是 CENTRAL ********/
            
            
            //  注释
            header._commentLength = 0;
            
            header._diskNumber = 0;
            
            header._internalFileAttrs = 0;
            header._externalFileAttrs = 0;
            header._offsetLocalHeader = _stream.position;
            
            if (isDir) {
                header._compressMethod = 0;
                header._version = 10;
                header._versionBy = (_host << 8 | 10);
                header._crc32 = 0;
                header._compressSize = 0;
                header._uncompressSize = 0;
                if (_host == 3) {
                    header._externalFileAttrs = ((ZipHeader.UNIX_DIR | _dirMode) << 16) + ZipHeader.WIN_DIR;
                }
                else {
                    header._externalFileAttrs = ZipHeader.WIN_DIR;
                }
            }
            else if (data.length == 0) {
                header._compressMethod = 0;
                header._version = 10;
                header._versionBy = (_host << 8 | 10);
                header._crc32 = 0;
                header._compressSize = 0;
                header._uncompressSize = 0;
                
                if (_host == 3) {
                    header._externalFileAttrs = ((ZipHeader.UNIX_FILE | _fileMode) << 16);
                }
                else {
                    header._externalFileAttrs = ZipHeader.WIN_FILE;
                }
            }
            else {
                header._compressMethod = 8;
                header._version = 20;
                header._versionBy = (_host << 8 | 20);
                header._crc32 = ZipCRC32.getByteArrayValue(data);
                header._uncompressSize = data.length;
                data.compress(CompressionAlgorithm.DEFLATE);
                header._compressSize = data.length;
                
                if (_host == 3) {
                    header._externalFileAttrs = ((ZipHeader.UNIX_FILE | _fileMode) << 16);
                }
                else {
                    header._externalFileAttrs = ZipHeader.WIN_FILE;
                }
            }
            
            //  实际文件的写入
            if (isDir == false) {
                data.position = 0;
                if (_isCrypt) {
                    _crypt.initEncrypt(_password, header);
                    header.writeLocalHeader(_stream);
                    _stream.writeBytes(_crypt.encrypt(data));
                }
                else {
                    header.writeLocalHeader(_stream);
                    _stream.writeBytes(data);
                }
            }
            else {
                header.writeLocalHeader(_stream);
            }
            
            _headers.push(header);
            _numFiles++;
            return header;
        }
    }
    
}