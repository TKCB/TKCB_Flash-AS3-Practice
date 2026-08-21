package com.dusk.zipcore.struct {
    
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.events.EventDispatcher;
    
    import com.dusk.zipcore.zip_internal;
    
    use namespace zip_internal;
    
    /**
     *  Zip文件信息
     */
    public class ZipEntry extends EventDispatcher {
        
        zip_internal var _header:ZipHeader;
        zip_internal var _headerLocal:ZipHeader;
        private var _content:ByteArray;
        
        private var _stream:IDataInput;
        
        public function ZipEntry(stream:IDataInput) {
            _stream = stream;
        }
        
        /**
         * 设置头信息
         * @param h
         */
        public function setHeader(h:ZipHeader):void {
            _header = h;
        }
        
        /**
         * 获取头信息
         * @return
         */
        public function getHeader():ZipHeader {
            return _header;
        }
        
        /**
         * 获取压缩方式
         * @return
         */
        public function getCompressMethod():int {
            return _header.getCompressMethod();
        }
        
        /**
         * 获取是否压缩
         * @return
         */
        public function isCompressed():Boolean {
            return _header.getCompressMethod() !== 0;
        }
        
        /**
         * 获取文件名
         * 如果不指定字符编码，会自动判断
         * 由于作者为日本人，因此会自动判断是否是日文字符集shift_jis
         * @param charset
         * @return
         */
        public function getFilename(charset:String = null):String {
            return _header.getFilename(charset);
        }
        
        /**
         * 是否为目录
         * @return
         */
        public function isDirectory():Boolean {
            return _header.isDirectory();
        }
        
        /**
         * 获取压缩率
         * @return
         */
        public function getCompressRate():Number {
            return _header.getCompressRate();
        }
        
        /**
         * 获取未压缩大小
         * @return
         */
        public function getUncompressSize():int {
            return _header.getUncompressSize();
        }
        
        /**
         * 获取压缩后大小
         * @return
         */
        public function getCompressSize():int {
            return _header.getCompressSize();
        }
        
        /**
         * 获取修改日期
         * @return
         */
        public function getDate():Date {
            return _header.getDate();
        }
        
        /**
         * 获取压缩版本
         * 在unzip命令中描述为"minimum software version required to extract"
         * @return
         */
        public function getVersion():int {
            return _header._version;
        }
        
        /**
         * 获取压缩主机的版本
         * 在unzip命令中描述为"version of encoding software"
         * @return
         */
        public function getHostVersion():int {
            return _header.getVersion();
        }
        
        /**
         * 获取CRC32的值
         * @return
         */
        public function getCrc32():String {
            return _header._crc32.toString(16);
        }
        
        /**
         * 是否加密
         * 加密方法为AES还是zipCrypto还需通过CompressionMethod判断
         * @return
         */
        public function isEncrypted():Boolean {
            return _header.isEncrypted;
        }
        
        /**
         * 是否使用AES加密
         */
        public function isUseAES():Boolean {
            return _header.isUseAES;
        }
        
        /**
         * 是否有数据描述符
         * @return
         */
        public function hasDataDescriptor():Boolean {
            return _header.isHasDataDescriptor;
        }
        
        /**
         * 是否使用utf-8编码文件名称
         * @return
         */
        public function isUseUTF8():Boolean {
            return _header.isUseUTF8;
        }
        
        /**
         * 获取LOCAL HEADER的偏移位置
         * @return
         */
        public function getLocalHeaderOffset():Number {
            return _header.getLocalHeaderOffset();
        }
        
        /**
         * 获取LOCAL HEADER的大小
         * @return
         */
        public function getLocalHeaderSize():int {
            return _header.getLocalHeaderSize();
        }
        
        /**
         * 显示文件详细信息
         */
        zip_internal function dumpLogInfo():void {
            _header.dumpLogInfo();
        }
        
    }
    
}
