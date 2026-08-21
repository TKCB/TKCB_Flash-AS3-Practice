package com.dusk.zipcore.struct {
    
	import com.dusk.zipcore.constant.ZipErrorType;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.Endian;
    import flash.utils.Dictionary;
    
    import com.dusk.zipcore.zip_internal;
    import com.dusk.zipcore.utils.ZipLog;
    import com.dusk.zipcore.ZipError;
    import com.dusk.zipcore.constant.ZipCompressionMethod;
    import com.dusk.zipcore.utils.BytesUtil;
    
    use namespace zip_internal;
    
    /**
     * 管理ZIP文件的头信息
     * @private
     */
    public class ZipHeader {
        
        public static var HEADER_LOCAL_FILE:uint = 0x04034b50;
        public static var HEADER_CENTRAL_DIR:uint = 0x02014b50;
        public static var HEADER_END_CENTRAL_DIR:uint = 0x06054b50;
        
        public static var WIN_DIR:int = 16;
        public static var WIN_FILE:int = 32;
        
        public static var UNIX_DIR:int = 0x4000;
        public static var UNIX_FILE:int = 0x8000;
        
        zip_internal var _signature:uint;
        zip_internal var _version:uint;
        zip_internal var _bitFlag:uint;
        zip_internal var _compressMethod:uint;
        zip_internal var _lastModTime:int;
        zip_internal var _lastModDate:int;
        zip_internal var _crc32:uint;
        zip_internal var _adler32:uint;
        zip_internal var _compressSize:uint;
        zip_internal var _uncompressSize:uint;
        zip_internal var _filenameLength:uint;
        zip_internal var _extraFieldLength:uint;
        zip_internal var _filename:ByteArray;
        zip_internal var _extraField:ByteArray;
        zip_internal var _extraFieldInfo:Dictionary = new Dictionary;
        
        zip_internal var _useAES:Boolean;
        zip_internal var _aesInfo:AESInfo;
        
        //  从这里开始是 CENTRAL DIRECTORY 
        zip_internal var _versionBy:uint;
        zip_internal var _commentLength:uint;
        zip_internal var _diskNumber:uint = 0;
        zip_internal var _internalFileAttrs:uint = 0;
        zip_internal var _externalFileAttrs:uint = 0;
        zip_internal var _offsetLocalHeader:uint;
        zip_internal var _comment:ByteArray;
        
        public function ZipHeader(sig:uint = 0x04034b50) {
            _signature = sig;
        }
        
        public function read(stream:IDataInput, bytes:ByteArray):void {
            if (_signature == HEADER_LOCAL_FILE) {
                readLocalHeader(stream, bytes);
            }
            else if (_signature == HEADER_CENTRAL_DIR) {
                readCentralHeader(stream, bytes);
            }
        }
        
        public function readAuto(stream:IDataInput):void {
            var bytes:ByteArray = BytesUtil.empty();
            stream.endian = Endian.LITTLE_ENDIAN;
            _signature = stream.readInt();
            read(stream, bytes);
        }
        
        /*======================================BitFlag设置接口=========================================*/
        
        public function get isUseAES():Boolean {
            return _useAES;
        }
        
        public function set isUseAES(v:Boolean):void {
            throw new ZipError("FZipHeader:set isUseAES() 暂不支持", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
            _useAES = v;
            if (!_aesInfo)
                _aesInfo = new AESInfo();
        }
        
        /**
         * 是否加密
         */
        public function get isEncrypted():Boolean {
            return (_bitFlag & 0x01) != 0;
        }
        
        public function set isEncrypted(v:Boolean):void {
            if (v)
                _bitFlag |= 0x01;
            else
                _bitFlag &= ~0x01;
        }
        
        /**
         * 是否有数据描述符(WinRar一般都有这个)
         * @return
         */
        public function get isHasDataDescriptor():Boolean {
            return (_bitFlag & 0x08) != 0;
        }
        
        public function set isHasDataDescriptor(v:Boolean):void {
            if (v)
                _bitFlag |= 0x08;
            else
                _bitFlag &= ~0x08;
        }
        
        /**
         * 是否使用UTF8编码文件名称
         * @return
         */
        public function get isUseUTF8():Boolean {
            return (_bitFlag & 0x0800) != 0;
        }
        
        public function set isUseUTF8(v:Boolean):void {
            if (v)
                _bitFlag |= 0x0800;
            else
                _bitFlag &= ~0x0800;
        }
        
        /*======================================BitFlag设置接口=========================================*/
        
        /**
         * 获取压缩方式
         * @return
         */
        public function getCompressMethod():uint {
            return _compressMethod;
        }
        
        /**
         * 获取压缩前的大小
         * @return
         */
        public function getUncompressSize():uint {
            return _uncompressSize;
        }
        
        /**
         * 获取压缩后的大小
         * @return
         */
        public function getCompressSize():uint {
            return _compressSize;
        }
        
        /**
         * 是否为目录
         * @return
         */
        public function isDirectory():Boolean {
            if (_uncompressSize == 0) {
                if (_externalFileAttrs == 0) {
                    return false;
                }
                else {
                    if (_externalFileAttrs & 16) {
                        return true;
                    }
                    else {
                        var num:uint = ((_externalFileAttrs >> 16) & 0xFFFF);
                        if (num & ZipHeader.UNIX_DIR) {
                            return true;
                        }
                    }
                    
                }
            }
            return false;
        }
        
        /**
         * 获取压缩率
         * @return
         */
        public function getCompressRate():Number {
            if (_uncompressSize == 0)
                return 0;
            var num:Number = _compressSize / _uncompressSize;
            return 1 - num;
        }
        
        /**
         * 获取最近修改时间
         * @return
         */
        public function getDate():Date {
            var sec:int = _lastModTime & 0x001f;
            var min:int = (_lastModTime & 0x07e0) >> 5;
            var hour:int = (_lastModTime & 0xf800) >> 11;
            var day:int = (_lastModDate & 0x001f);
            var month:int = (_lastModDate & 0x01e0) >> 5;
            var year:int = ((_lastModDate & 0xfe00) >> 9) + 1980;
            var date:Date = new Date(year, month - 1, day, hour, min, sec, 0);
            return date;
        }
        
        /**
         * 获取LOCAL FILE HEADER头的位置
         * @return
         */
        public function getLocalHeaderOffset():Number {
            return _offsetLocalHeader;
        }
        
        /**
         * 获取文件名
         * @param charset
         * @return
         */
        public function getFilename(charset:String = null):String {
            if (_filenameLength < 1)
                return "";
            if (charset == null)
                charset = isUseUTF8 ? "utf-8" : "gb2312";
            
            //修正日语字符
            // var _char:String = charset.toLowerCase();
            // if (_char == "utf-8") {
            //     return getFilenameUTF8();
            // } else {
            //     _filename.position = 0;
            //     return _filename.readMultiByte(_filename.bytesAvailable, charset);
            // }
            _filename.position = 0;
            return _filename.readMultiByte(_filename.bytesAvailable, charset);
        }
        
        /**
         * 返回LOCAL HEADER的大小
         * @return
         */
        public function getLocalHeaderSize():int {
            return 30 + _filenameLength + _extraFieldLength;
        }
        
        protected function readLocalHeader(stream:IDataInput, bytes:ByteArray):void {
            stream.readBytes(bytes, 0, 26);
            // 版本信息
            bytes.position = 0;
            _version = bytes.readUnsignedShort();
            // 设置位
            bytes.position = 2;
            _bitFlag = bytes.readUnsignedShort();
            // 压缩方式
            bytes.position = 4;
            _compressMethod = bytes.readUnsignedShort();
            if (_compressMethod == ZipCompressionMethod.METHOD_AES)
                _useAES = true;
            //  最终修改时间
            bytes.position = 6;
            _lastModTime = bytes.readUnsignedShort();
            // 最终修改日期时间
            bytes.position = 8;
            _lastModDate = bytes.readUnsignedShort();
            // CRC32
            bytes.position = 10;
            _crc32 = bytes.readUnsignedInt();
            // 压缩后的大小
            bytes.position = 14;
            _compressSize = bytes.readUnsignedInt();
            // 压缩前的大小
            bytes.position = 18;
            _uncompressSize = bytes.readUnsignedInt();
            // 文件名的长度
            bytes.position = 22;
            _filenameLength = bytes.readShort();
            // 扩展域的大小
            bytes.position = 24;
            _extraFieldLength = bytes.readShort();
            
            if (_signature == HEADER_LOCAL_FILE) {
                //  进一步读取文件名和扩展域的大小
                stream.readBytes(bytes, 26, _filenameLength + _extraFieldLength);
                // 文件名
                bytes.position = 26;
                _filename = BytesUtil.empty();
                bytes.readBytes(_filename, 0, _filenameLength);
                // 扩展域
                if (_extraFieldLength > 0) {
                    _extraField = BytesUtil.empty();
                    bytes.readBytes(_extraField, 0, _extraFieldLength);
                    parseExtraField();
                }
            }
        }
        
        public function writeLocalHeader(stream:IDataOutput):void {
            writeHeader(stream, false);
        }
        
        public function writeCentralHeader(stream:IDataOutput):void {
            writeHeader(stream, true);
        }
        
        /**
         * 写入头信息
         * @param stream
         * @param isCentral
         */
        protected function writeHeader(stream:IDataOutput, isCentral:Boolean = false):void {
            if (isCentral) {
                _signature = HEADER_CENTRAL_DIR;
                stream.writeUnsignedInt(HEADER_CENTRAL_DIR);
                stream.writeShort(_versionBy);
            }
            else {
                _signature = HEADER_LOCAL_FILE;
                stream.writeUnsignedInt(HEADER_LOCAL_FILE);
            }
            stream.writeShort(_version);
            stream.writeShort(_bitFlag);
            stream.writeShort(_compressMethod);
            stream.writeShort(_lastModTime);
            stream.writeShort(_lastModDate);
            stream.writeUnsignedInt(_crc32);
            stream.writeUnsignedInt(_compressSize);
            stream.writeUnsignedInt(_uncompressSize);
            stream.writeShort(_filenameLength);
            stream.writeShort(_extraFieldLength);
            
            
            if (_extraFieldLength > 0) {
                _extraField.position = 0;
                stream.writeBytes(_extraField);
            }
            
            if (isCentral) {
                stream.writeShort(_commentLength);
                stream.writeShort(_diskNumber);
                stream.writeShort(_internalFileAttrs);
                stream.writeUnsignedInt(_externalFileAttrs);
                stream.writeUnsignedInt(_offsetLocalHeader);
            }
            
            _filename.position = 0;
            stream.writeBytes(_filename);
            
            if (_extraFieldLength > 0) {
            }
            
        }
        
        protected function readCentralHeader(stream:IDataInput, bytes:ByteArray):void {
            stream.readBytes(bytes, 0, 42);
            // 创建版本
            bytes.position = 0;
            _versionBy = bytes.readUnsignedShort();
            // 版本信息
            bytes.position = 2;
            _version = bytes.readUnsignedShort();
            // 设置位
            bytes.position = 4;
            _bitFlag = bytes.readUnsignedShort();
            // 压缩方式
            bytes.position = 6;
            _compressMethod = bytes.readUnsignedShort();
            //  最终修改时间
            bytes.position = 8;
            _lastModTime = bytes.readUnsignedShort();
            // 最终修改日期
            bytes.position = 10;
            _lastModDate = bytes.readUnsignedShort();
            // CRC32
            bytes.position = 12;
            _crc32 = bytes.readUnsignedInt();
            // 压缩后的大小
            bytes.position = 16;
            _compressSize = bytes.readUnsignedInt();
            // 压缩前的大小
            bytes.position = 20;
            _uncompressSize = bytes.readUnsignedInt();
            // 文件名的长度
            bytes.position = 24;
            _filenameLength = bytes.readShort();
            // 扩展域的大小
            bytes.position = 26;
            _extraFieldLength = bytes.readShort();
            // 注释
            bytes.position = 28;
            _commentLength = bytes.readUnsignedShort();
            // 分卷号
            bytes.position = 30;
            _diskNumber = bytes.readUnsignedShort();
            //文件是否为文本文件(最早用于dos时期分辨Text和Bin,现在直接为0)
            bytes.position = 32;
            _internalFileAttrs = bytes.readUnsignedShort();
            // 文件属性
            bytes.position = 34;
            _externalFileAttrs = bytes.readUnsignedInt();
            //指向这个文件对应的 Local File Header 在ZIP文件里的位置
            bytes.position = 38;
            _offsetLocalHeader = bytes.readUnsignedInt();
            
            //  进一步读取文件名、扩展域和注释的大小
            var len:int = _filenameLength + _extraFieldLength + _commentLength;
            stream.readBytes(bytes, 42, len);
            
            // 文件名
            bytes.position = 42;
            if (_filenameLength > 0) {
                _filename = BytesUtil.empty();
                bytes.readBytes(_filename, 0, _filenameLength);
            }
            
            // 扩展域
            if (_extraFieldLength > 0) {
                _extraField = BytesUtil.empty();
                bytes.readBytes(_extraField, 0, _extraFieldLength);
                parseExtraField();
            }
            
            if (_commentLength > 0) {
                _comment = BytesUtil.empty();
                bytes.readBytes(_comment, 0, _commentLength);
            }
        }
        
        private function parseExtraField():void {
            _extraField.position = 0;
            while (_extraField.bytesAvailable > 4) {
                var headerId:uint = _extraField.readUnsignedShort();
                var dataSize:uint = _extraField.readUnsignedShort();
                if (dataSize > _extraField.bytesAvailable) {
                    throw new Error("Parse error in file " + _filename + ": Extra field data size too big.");
                }
                if (headerId === 0xdada && dataSize === 4) {
                    _adler32 = _extraField.readUnsignedInt();
                }
                else if (headerId === 0x9901 && dataSize >= 7) {
                    // AES Extra Field
                    _useAES = true;
                    var aesBytes:ByteArray = BytesUtil.empty();
                    _extraField.readBytes(aesBytes, 0, dataSize);
                    aesBytes.position = 0;
                    _aesInfo = new AESInfo();
                    _aesInfo.parse(aesBytes);
                    _compressMethod = _aesInfo.compressionMethod;
                }
                else if (headerId == 0x0001) {
                    throw new ZipError("Zip64 not supported");
                    var zip64Bytes:ByteArray = BytesUtil.empty();
                    _extraField.readBytes(zip64Bytes, 0, dataSize);
                    zip64Bytes.position = 0;
                    if (_uncompressSize == 0xFFFFFFFF)
                        _uncompressSize = zip64Bytes.readUnsignedInt(); // 或 readUnsignedLong()
                    if (_compressSize == 0xFFFFFFFF)
                        _compressSize = zip64Bytes.readUnsignedInt();
                }
                else if (dataSize > 0) {
                    var notParsed:ByteArray = BytesUtil.empty();
                    _extraField.readBytes(notParsed, 0, dataSize);
                    _extraFieldInfo[headerId] = notParsed;
                }
            }
        }
        
        /**
         * 获取文件名(修正浊音/半浊音符号)
         * @return
         */
        protected function getFilenameUTF8():String {
            if (!_filename) {
                return "";
            }
            
            _filename.position = 0;
            var ch:int;
            var ba:ByteArray = BytesUtil.empty();
            var ret:String = "";
            while (_filename.bytesAvailable) {
                ch = _filename.readUnsignedByte();
                if (ch >= 0x00 && ch <= 0x7F) {
                    ba.writeByte(ch);
                }
                else if (ch >= 0xC0 && ch <= 0xDF) {
                    // 2字节
                    ba.writeByte(ch);
                    ba.writeByte(_filename.readUnsignedByte());
                }
                else if (ch >= 0xE0 && ch <= 0xEF) {
                    // 3字节
                    
                    var ch1:int = _filename.readUnsignedByte();
                    var ch2:int = _filename.readUnsignedByte();
                    
                    if (ch == 0xe3 && ch1 == 0x82 && ch2 == 0x99) {
                        ba.position--;
                        ch = ba.readUnsignedByte() + 1;
                        ba.position--;
                        ba.writeByte(ch);
                    }
                    else if (ch == 0xe3 && ch1 == 0x82 && ch2 == 0x9a) {
                        ba.position--;
                        ch = ba.readUnsignedByte() + 2;
                        ba.position--;
                        ba.writeByte(ch);
                    }
                    
                    else {
                        ba.writeByte(ch);
                        ba.writeByte(ch1);
                        ba.writeByte(ch2);
                    }
                }
                else if (ch >= 0xF0 && ch <= 0xF7) {
                    // 4字节
                    ba.writeByte(ch);
                    ba.writeByte(_filename.readUnsignedByte());
                    ba.writeByte(_filename.readUnsignedByte());
                    ba.writeByte(_filename.readUnsignedByte());
                    
                }
                
            }
            ba.position = 0;
            ret = ba.readMultiByte(ba.bytesAvailable, "utf-8");
            return ret;
        }
        
        public function getVersion():int {
            return (_versionBy & 0xff);
        }
        
        public function dumpLogInfo():void {
            ZipLog.debug("[" + _signature.toString(16) + "]*************** " + getFilename() + " ****************");
            ZipLog.debug("signature(4) : " + _signature);
            ZipLog.debug("version(2)   : " + _version);
            ZipLog.debug("bit flag(2)  : " + _bitFlag.toString(2));
            ZipLog.debug("method(2)    : " + _compressMethod);
            ZipLog.debug("last mod time(2) : " + _lastModTime);
            ZipLog.debug("last mod date(2) : " + _lastModDate);
            ZipLog.debug("date  : " + getDate());
            ZipLog.debug("crc32(4)     : " + _crc32.toString(16));
            ZipLog.debug("compress size(4)        : " + _compressSize);
            ZipLog.debug("un-compress size(4)     : " + _uncompressSize);
            ZipLog.debug("filename length(2)      : " + _filenameLength);
            ZipLog.debug("extra length(2)         : " + _extraFieldLength);
            
            if (_extraFieldLength > 0) {
                _extraField.position = 0;
                ZipLog.debug("extra field : " + _extraField.toString());
            }
            
            if (_aesInfo) {
                ZipLog.debug("aes info : " + _aesInfo.toString());
            }
            
            if (_signature == HEADER_CENTRAL_DIR) {
                ZipLog.debug("version by1 " + (_versionBy >> 8));
                ZipLog.debug("version by2 " + (_versionBy & 0xff));
                ZipLog.debug("comment size " + _commentLength);
                ZipLog.debug("disk number  " + _diskNumber);
                ZipLog.debug("internal file attrs " + _internalFileAttrs);
                ZipLog.debug("external file attrs " + _externalFileAttrs);
                ZipLog.debug("offset local header " + _offsetLocalHeader);
                
                if (isDirectory()) {
                    ZipLog.debug("is dir");
                }
                else {
                    ZipLog.debug("is file");
                }
            }
        }
    }
}

import com.dusk.zipcore.constant.ZipCompressionMethod;
import flash.utils.ByteArray;
import flash.utils.Endian;

class AESInfo {
    
    // AES bit length
    private const bitLeng:Array = [0, 128, 192, 256];
    
    
    //Vendor version: 1 = AE-1, 2 = AE-2 (通常是 2)
    public var vendorVersion:int;
    //Vendor ID (应该是 "AE")
    public var vendorID:String;
    //AESKey长度 128/192/256
    public var aesKeyBits:int;
    //实际压缩方法
    public var compressionMethod:int;

    public function AESInfo() {
        vendorID = "AE";
        vendorVersion = 2;
        aesKeyBits = 256;
        compressionMethod = ZipCompressionMethod.METHOD_DEFLATED;
    }
    
    public function parse(stream:ByteArray):void {
        stream.endian = Endian.LITTLE_ENDIAN;
        var vendorVersion:int = stream.readUnsignedShort();
        vendorID = "";
        vendorID += String.fromCharCode(stream.readUnsignedByte());
        vendorID += String.fromCharCode(stream.readUnsignedByte());
        var strength:int = stream.readUnsignedByte();
        aesKeyBits = bitLeng[strength];
        compressionMethod = stream.readUnsignedShort();
    }
    
    public function serialize():ByteArray {
        throw new Error("Not implemented");
    }
    
    public function toString():String {
        return "vendorID=" + vendorID + " vendorVersion=" + vendorVersion + " keyBits=" + aesKeyBits + " compressionMethod=" + compressionMethod;
    }
}
