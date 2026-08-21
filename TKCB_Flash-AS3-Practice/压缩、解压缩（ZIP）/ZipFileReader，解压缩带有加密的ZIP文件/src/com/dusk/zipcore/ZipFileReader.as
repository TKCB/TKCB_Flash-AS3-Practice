/**
 *  Copyright (c)  2009 coltware@gmail.com
 *  http://www.coltware.com
 *
 *  License: LGPL v3 ( http://www.gnu.org/licenses/lgpl-3.0-standalone.html )
 *
 * @author coltware@gmail.com
 */
package com.dusk.zipcore {
    
    import com.dusk.zipcore.constant.ZipCompressionMethod;
    import com.dusk.zipcore.crypto.ICrypto;
    import com.dusk.zipcore.crypto.ZipCrypto;
    import com.dusk.zipcore.crypto.AESCrypto;
    import com.dusk.zipcore.event.ZipErrorEvent;
    import com.dusk.zipcore.event.ZipEvent;
    import com.dusk.zipcore.struct.ZipEndRecord;
    import com.dusk.zipcore.struct.ZipEntry;
    import com.dusk.zipcore.struct.ZipHeader;
    import com.dusk.zipcore.utils.ZipLog;
    
    import flash.events.EventDispatcher;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.Endian;
    import flash.utils.ByteArray;
    import flash.utils.CompressionAlgorithm;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import flash.net.URLStream;
    
    import com.dusk.zipcore.utils.BytesUtil;
    
    import flash.net.URLRequest;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    
    import com.dusk.zipcore.constant.ZipErrorType;
    import com.dusk.zipcore.crypto.ANECrypto;
    
    use namespace zip_internal;
    
    /**
     *  读取ZIP文件的类
     */
    public class ZipFileReader extends EventDispatcher {
        
        /*==================StreamInterface=====================*/
        private var _file:File;
        private var _fileStream:FileStream;
        
        private var _request:URLRequest;
        private var _urlStream:URLStream;
        
        private var _byteStream:ByteArray;
        /*==================StreamInterface=====================*/
        
        private static var _streamMode:int = -1;
        private static const STREAM_MODE_FILE:int = 0;
        private static const STREAM_MODE_URL:int = 1;
        private static const STREAM_MODE_BYTE:int = 2;
        
        private var _charset:String = "gb2312";
        
        private var _hearderParsed:Boolean = false;
        private var _unzipNum:int = 0;
        private var _unzipWorking:Boolean = false;
        private var _unzipStack:Vector.<ZipEntry> = new Vector.<ZipEntry>();
        
        private var _endRecord:ZipEndRecord;
        private var _totalEntries:uint = 0;
        private var _entries:Vector.<ZipEntry> = new Vector.<ZipEntry>();
        
        private var _decryptors:Vector.<ICrypto> = new Vector.<ICrypto>();
        
        /* 加密时的密码 */
        private var _password:ByteArray;
        
        /*================================EventTypes=================================*/
        
        /**
         *  extractDataAsync()命令后数据可以写出状态时的事件
         * @eventType com.dusk.zipcore.event.ZipEvent.ZIP_DATA_UNCOMPRESS
         */
        [Event(name="zipDataUncompress", type="com.dusk.zipcore.event.ZipEvent")]
        
        /**
         *  从url加载数据完成时发出的事件
         * @eventType flash.events.Event.COMPLETE
         */
        [Event(name="complete", type="flash.events.Event")]
        
        /**
         *  从url加载数据进度时发出的事件
         * @eventType flash.events.ProgressEvent.PROGRESS
         */
        [Event(name="progress", type="flash.events.ProgressEvent")]
        
        /**
         *  从url加载数据失败时发出的事件
         * @eventType flash.events.IOErrorEvent.IO_ERROR
         */
        [Event(name="ioError", type="flash.events.IOErrorEvent")]
        
        /*================================EventTypes=================================*/
        
        public function ZipFileReader() {
            addDecrypto(new ZipCrypto);
            addDecrypto(new ANECrypto);		// 20260326 TKCB-Nm：需要引入CryptoANE.ane，可以注释这行，对比解压缩速度
            addDecrypto(new AESCrypto);		// 20260326 TKCB-Nm：不使用ANE也可以解密AES加密，但是速度超慢
        }
        
        /**
         * 添加解密实例
         * @param crypto ICrypto实例
         */
        public function addDecrypto(crypto:ICrypto):void {
            _decryptors.push(crypto);
        }
        
        /**
         * 以字节数组形式指定密码
         * @param bytes
         */
        public function setPasswordBytes(bytes:ByteArray):void {
			//bytes.position = 0;
			//trace(bytes.readUTFBytes(bytes.length));
            _password = bytes;
            _password.position = 0;
        }
        
        /**
         * 以字符串形式指定密码
         * @param password
         * @param charset
         */
        public function setPassword(password:String, charset:String = null):void {
            _password = BytesUtil.fromString(password, charset);
        }
        
        /**
         * 负责stream类型分流
         */
        private function get _stream():* {
            switch (_streamMode) {
                case STREAM_MODE_FILE:
                    return _fileStream;
                case STREAM_MODE_URL:
                    return _urlStream;
                case STREAM_MODE_BYTE:
                    return _byteStream;
                default:
                    return null;
            }
        }
        
        /**
         * 检测文件是否为ZIP格式
         * 0x04034b50开头
         * @param file File对象
         * @return
         */
        public function checkFile(file:File):Boolean {
            if (file.isDirectory) {
                return false;
            }
            else if (file.isSymbolicLink) {
                return false;
            }
            else {
                try {
                    var s:FileStream = new FileStream();
                    s.open(file, FileMode.READ);
                    s.endian = Endian.LITTLE_ENDIAN;
                    s.position = 0;
                    var i:int = s.readInt();
                    s.close();
                    if (i == ZipHeader.HEADER_LOCAL_FILE) {
                        return true;
                    }
                } catch (err:Error) {
                    return false;
                }
                return false;
            }
        }
        
        /**
         * 从本地打开Zip
         * @param file
         */
        public function loadFile(file:File):void {
            _streamMode = STREAM_MODE_FILE;
            // 阻止触发SecurityError
            _file = new File(file.nativePath);
            _fileStream = new FileStream();
            _fileStream.endian = Endian.LITTLE_ENDIAN;
            _fileStream.addEventListener(IOErrorEvent.IO_ERROR, onStreamIOErr);
            
            _fileStream.open(_file, FileMode.READ);
            parseStream();
        }
        
        /**
         * 从二进制数据加载Zip
         * @param bytes
         */
        public function loadBytes(bytes:ByteArray):void {
            _streamMode = STREAM_MODE_BYTE;
            _byteStream = bytes;
            _byteStream.position = 0;
            _byteStream.endian = Endian.LITTLE_ENDIAN;
            parseStream();
        }
        
        /**
         * 从URL打开Zip(异步)
         * @param request
         */
        public function loadURL(request:URLRequest):void {
            _streamMode = STREAM_MODE_URL;
            _request = request;
            _urlStream = new URLStream();
            _urlStream.endian = Endian.LITTLE_ENDIAN;
            _urlStream.addEventListener(Event.COMPLETE, onStreamComplete);
            _urlStream.addEventListener(ProgressEvent.PROGRESS, onStreamProgress);
            _urlStream.addEventListener(IOErrorEvent.IO_ERROR, onStreamIOErr);
            
            _urlStream.load(_request);
        }
        
        /**
         * 从URL下载数据完毕
         * @private
         * @param    evt flash.events.Event
         */
        private function onStreamComplete(evt:Event):void {
            if (evt.target === _urlStream) {
                _byteStream = BytesUtil.empty();
                _urlStream.readBytes(_byteStream);
                _urlStream.close();
                _streamMode = STREAM_MODE_BYTE;
            }
            else if (evt.target === _fileStream) {
                _fileStream.position = 0;
            }
            parseStream();
			try {
				dispatchEvent(evt);
			}catch (err:Error) {
			}
        }
        
        /**
         * 从URL下载数据进度
         * @private
         * @param    evt flash.events.ProgressEvent
         */
        private function onStreamProgress(evt:ProgressEvent):void {
            dispatchEvent(evt);
        }
        
        /**
         * 从URL下载数据IO错误
         * @private
         * @param    evt flash.events.IOErrorEvent
         */
        private function onStreamIOErr(evt:IOErrorEvent):void {
            dispatchEvent(evt);
        }
        
        /**
         * 关闭数据流
         */
        public function close():void {
            if (_fileStream) {
                _fileStream.close();
                _fileStream = null;
            }
            if (_urlStream) {
                _urlStream.close();
                _urlStream = null;
            }
            if (_byteStream) {
                _byteStream.clear();
                _byteStream = null;
            }
        }
        
        /**
         * 解析数据流
         */
        private function parseStream():void {
            _hearderParsed = false;
            _stream.position = _stream.bytesAvailable - ZipEndRecord.LENGTH;
            var pos:Number = 0;
            var sig:int = 0;
            while (_stream.position > 0) {
                pos = _stream.position;
                sig = _stream.readInt();
                if (sig == ZipEndRecord.SIGNATURE) {
                    _endRecord = new ZipEndRecord();
                    _stream.position = pos;
                    _endRecord.read(_stream);
                    
                    _entries.length = 0;
                    _totalEntries = _endRecord.getTotalEntries();
                    
                    ZipLog.debug("ZipEndRecord " + pos);
                    break;
                }
                else if (sig == ZipHeader.HEADER_CENTRAL_DIR) {
                    ZipLog.debug("FOUND CENTRAL " + _stream.position);
                }
                _stream.position = pos - 1;
            }
        }
        
        /**
         * 获取所有ZipEntry
         * @return
         */
        public function getEntries():Vector.<ZipEntry> {
            if (_hearderParsed)
                return _entries;
            parseCentralHeaders();
            return _entries;
        }
        
        /**
         * 获取所有地址为文件夹的Entry
         * @return
         */
        public function getAllDirectoryEntry():Vector.<ZipEntry> {
            var allEntry:Vector.<ZipEntry> = getEntries();
            return allEntry.filter(function (entry:ZipEntry, b:*, c:*) {
                return entry.isDirectory();
            });
        }
        
        /**
         * 获取所有地址为文件的Entry
         * @return
         */
        public function getAllFileEntry():Vector.<ZipEntry> {
            var allEntry:Vector.<ZipEntry> = getEntries();
            return allEntry.filter(function (entry:ZipEntry, b:*, c:*) {
                return !entry.isDirectory();
            });
        }
        
        /**
         * 获取所有文件名称
         * @return
         */
        public function getAllFileName():Array {
            var allEntry:Vector.<ZipEntry> = getEntries();
            var names:Array = [];
            allEntry.forEach(function (zip:ZipEntry, b:*, c:*) {
                names.push(zip.getFilename());
            });
            return names;
        }
        
        /**
         * 获取所有文件夹路径
         * @return
         */
        public function getAllDirectoryPath():Array {
            var allEntry:Vector.<ZipEntry> = getEntries();
            var names:Array = [];
            allEntry.forEach(function (entry:ZipEntry, b:*, c:*) {
                if (entry.isDirectory())
                    names.push(entry.getFilename());
            });
            return names;
        }
        
        /**
         * 获取所有文件路径
         * @return
         */
        public function getAllFilePath():Array {
            var allEntry:Vector.<ZipEntry> = getEntries();
            var names:Array = [];
            allEntry.forEach(function (entry:ZipEntry, b:*, c:*) {
                if (!entry.isDirectory())
                    names.push(entry.getFilename());
            });
            return names;
        }
        
        /**
         * 根据名称获取Entry
         * @param    name
         * @return
         */
        public function getEntryByName(name:String):ZipEntry {
            var allEntry:Vector.<ZipEntry> = getEntries();
            for each (var entry:ZipEntry in allEntry) {
                if (entry.getFilename() == name)
                    return entry;
            }
            return null;
        }
        
        /**
         * 解压ZipEntry
         * @param entry 目标ZipEntry对象
         * @return ZipEntry数据
         */
        public function unzip(entry:ZipEntry):ByteArray {
            ZipLog.debug("Unzip(" + entry.getFilename() + ")");
            
            var pos:Number = entry.getLocalHeaderOffset();
            _stream.position = pos;
            var lzh:ZipHeader = new ZipHeader();
            lzh.readAuto(_stream);
            entry._headerLocal = lzh;
            
            var bytes:ByteArray = BytesUtil.empty();
            var size:int = entry.getCompressSize();
            if (size > 0) {
                _stream.readBytes(bytes, 0, entry.getCompressSize());
            }
            
            if (entry.isEncrypted()) {
                if (_password == null) {
                    throw new ZipError("password is NULL", ZipErrorType.ZIP_ERROR_WRONG_PASSWORD);
                }
                
                var decrypt:ICrypto = null;
                for each (var i:ICrypto in _decryptors) {
					trace(entry)
                    if (i.checkDecrypt(entry)) {
                        decrypt = i;
                        break;
                    }
                }
                if (decrypt == null) {
                    throw new ZipError("No decryptor for " + entry.getFilename(), ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
                }
                decrypt.initDecrypt(_password, lzh);
                try {
                    bytes = decrypt.decrypt(bytes);
                } catch (err:Error) {
                    throw new ZipError("Decrypt error: " + err.message, ZipErrorType.ZIP_ERROR_WRONG_PASSWORD);
                }
            }
            
            var method:int = entry.getCompressMethod();
            if (method == ZipCompressionMethod.METHOD_NONE) {
            }
            else if (method == ZipCompressionMethod.METHOD_DEFLATED || method == ZipCompressionMethod.METHOD_DEFLATED_EXT) {
                ZipLog.debug("uncompress data size is + " + bytes.length);
                if (bytes.hasOwnProperty("inflate")) {
                    try {
                        bytes.inflate();
                    } catch (err:Error) {
                        throw new ZipError("Inflate error: " + err.message, ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
                    }
                }
                else if (new CompressionAlgorithm().hasOwnProperty("DEFLATE")) {
                    try {
                        bytes.uncompress(CompressionAlgorithm.DEFLATE);
                    } catch (err:Error) {
                        throw new ZipError("Inflate error: " + err.message, ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
                    }
                }
                else {
                    throw new ZipError("Inflate not supported", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
                }
            }
            else if (method == ZipCompressionMethod.METHOD_LZMA) {
                if (!new CompressionAlgorithm().hasOwnProperty("LZMA")) {
                    throw new ZipError("LZMA not supported", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
                }
                // zip lzma: [4 byte][5 byte prop][raw data]
                // std lzma: [5 byte prop][8 byte length][raw data]
                var data:ByteArray = BytesUtil.empty();
                var majorV:uint = bytes[0];
                var minorV:uint = bytes[1];
                ZipLog.debug("LZMA version: " + majorV + "." + minorV);
                data.writeBytes(bytes, 4, 5);
                var usize:Number = entry.getHeader().getUncompressSize();
                ZipLog.debug("LZMA Data Length: " + usize);
                data.writeUnsignedInt(usize & 0xFFFFFFFF);
                data.writeUnsignedInt(Math.floor(usize / 0x100000000));
                data.writeBytes(bytes, 9);
                try {
                    data.uncompress(CompressionAlgorithm.LZMA);
                } catch (err:Error) {
                    throw new ZipError("LZMA uncompress error: " + err.message, ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
                }
                bytes.clear();
                bytes = data;
            }
            else {
                throw new ZipError("Unsupport method: " + method, ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
            }
            return bytes;
        }
        
        /**
         * 获取原始数据(未解压状态)
         * @param entry
         * @return
         */
        public function rawdata(entry:ZipEntry):ByteArray {
            var pos:int = entry.getLocalHeaderOffset();
            _stream.position = pos;
            var lzh:ZipHeader = new ZipHeader();
            lzh.readAuto(_stream);
            entry._headerLocal = lzh;
            
            var bytes:ByteArray = BytesUtil.empty();
            var size:int = entry.getCompressSize();
            if (size > 0) {
                _stream.readBytes(bytes, 0, entry.getCompressSize());
            }
            bytes.position = 0;
            return bytes;
        }
        
        /**
         * 以异步处理方式进行解压处理
         * @param entry ZipEntry对象
         * @eventType com.coltware.airxzip.ZipEvent.ZIP_DATA_UNCOMPRESS
         */
        public function unzipAsync(entry:ZipEntry):void {
            _unzipStack.push(entry);
            if (_unzipWorking == false) {
                execUnzip(500);
            }
        }
        
        private function unzipAsyncTimeout(entry:ZipEntry):void {
            try {
                var event:ZipEvent = new ZipEvent(ZipEvent.ZIP_DATA_UNCOMPRESS);
                event.$entry = entry;
                event.$data = unzip(entry);
                dispatchEvent(event);
            } catch (err:ZipError) {
                var errEvent:ZipErrorEvent = new ZipErrorEvent(ZipErrorEvent.ZIP_UNCOMPRESS_ERROR);
                errEvent.error = err;
                dispatchEvent(errEvent);
            }
            _unzipWorking = false;
            _unzipNum++;
            ZipLog.debug("Unzipping " + entry.getFilename() + "..." + _unzipNum);
            execUnzip();
        }
        
        private function execUnzip(delay:int = 20):void {
            if (_unzipStack.length > 0) {
                _unzipWorking = true;
                var entry:ZipEntry = _unzipStack.shift();
                setTimeout(unzipAsyncTimeout, delay, entry);
            }
            else {
            }
        }
        
        /**
         * 解析数据流中的Entry(一次数据流加载只需要执行一次)<br>
         * 此函数只在getEntries中调用
         */
        protected function parseCentralHeaders():void {
            var offset:Number = _endRecord.getOffset();
            var size:int = _endRecord.getSize();
            _stream.position = offset;
            var bytes:ByteArray = BytesUtil.empty();
            _stream.readBytes(bytes, 0, size);
            bytes.position = 0;
            
            var _tmpBytes:ByteArray = BytesUtil.empty();
            
            while (bytes.bytesAvailable) {
                var sig:int = bytes.readInt();
                var header:ZipHeader = new ZipHeader(sig);
                header.read(bytes, _tmpBytes);
                header.dumpLogInfo();
                var entry:ZipEntry = new ZipEntry(_stream);
                entry.setHeader(header);
                _entries.push(entry);
            }
            _hearderParsed = true;
            ZipLog.debug("Parse central header end " + _entries.length);
        }
        
        
        private function readStream(evt:Event):void {
            // trace("byte available " + _stream.bytesAvailable + "/" + _file.size);
            var bytes:ByteArray = BytesUtil.empty();
            _stream.endian = Endian.LITTLE_ENDIAN;
            while (_stream.bytesAvailable) {
                // trace("byte available " + _stream.bytesAvailable);
                var sig:int = _stream.readInt();
                if (sig == ZipHeader.HEADER_LOCAL_FILE) {
                    
                    // LOCAL FILE HEADER
                    var header:ZipHeader = new ZipHeader(sig);
                    header.read(_stream, bytes);
                    
                    var contentByteArray:ByteArray = BytesUtil.empty();
                    if (header.getCompressSize() > 0) {
                        _stream.readBytes(contentByteArray, 0, header.getCompressSize());
                    }
                    var entry:ZipEntry = new ZipEntry(_stream);
                    entry.setHeader(header);
                    // entry.setContent(contentByteArray);
                }
                else if (sig == ZipHeader.HEADER_CENTRAL_DIR) {
                    // CENTRAL DIRECTORY
                    ZipLog.debug("CENTRAL DIR.." + sig.toString(16));
                    var centralHeader:ZipHeader = new ZipHeader(sig);
                    centralHeader.read(_stream, bytes);
                }
                else {
                    // trace("sig NG " + sig.toString(16));
                    break;
                }
            }
        }
    }
}
