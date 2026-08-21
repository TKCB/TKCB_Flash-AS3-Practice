package com.dusk.zipcore.crypto {
	import com.dusk.zipcore.constant.ZipErrorType;
    import com.dusk.zipcore.struct.ZipHeader;
    import com.dusk.zipcore.utils.BytesUtil;
    import com.dusk.zipcore.struct.ZipEntry;
    import com.dusk.zipcore.zip_internal;
    import com.dusk.zipcore.ZipError;
    import flash.utils.ByteArray;
	import com.dusk.crypto.CryptoANE;
	import com.dusk.crypto.hash.Digest;
	import com.dusk.crypto.hash.HMAC;
	import com.dusk.crypto.symmetric.CipherMode;
	import com.dusk.crypto.symmetric.PaddingMode;
	import com.dusk.crypto.symmetric.AESCipher;
    
    use namespace zip_internal;
    
    /**
     * AES加密解密实现类
     * 兼容WinZip AES格式
     */
    public class ANECrypto implements ICrypto {
        
        private var _header:ZipHeader;
        
        private var _password:ByteArray;
        
        private var _salt:ByteArray;
        // 加盐长度
        private var _saltLength:int;
        // 迭代密钥长度
        private var _keyLength:int;
        
        private var _aesKey:ByteArray;
        private var _hmacKey:ByteArray;
        
        public function ANECrypto() {
        }
        
        public function checkDecrypt(entry:ZipEntry):Boolean {
            return CryptoANE.isSupported && entry.isEncrypted() && entry.isUseAES();
        }
        
        public function initDecrypt(password:ByteArray, header:ZipHeader):void {
            _password = password;
            _header = header;
            if (!_header._aesInfo)
                throw new ZipError("AES info missing in entry header", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
			if (_header._aesInfo.aesKeyBits != 256)
				throw new ZipError("KeyBits must be 256", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
            _saltLength = _header._aesInfo.aesKeyBits / 16;
            _keyLength = _header._aesInfo.aesKeyBits / 8;
        }
        
        public function decrypt(data:ByteArray):ByteArray {
            if (_header._uncompressSize == 0) return new ByteArray();
            
            if (_header._compressSize != data.length)
                throw new ZipError("Corrupted AES zip entry: length mismatch", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
            
            _salt = BytesUtil.empty();
            data.readBytes(_salt, 0, _saltLength);
            var pwVerifier:uint = data.readUnsignedByte() + (data.readUnsignedByte() << 8);
            var remaining:int = _header._compressSize - _saltLength - 2; // CipherText + AuthCode(10 bytes)
            if (remaining < 10)
                throw new ZipError("Corrupted AES zip entry: not enough data", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
            // 提取 CipherText 和 AuthCode
            var cipherText:ByteArray = BytesUtil.empty();
            data.readBytes(cipherText, 0, remaining - 10);
            var authCode:ByteArray = BytesUtil.empty();
            data.readBytes(authCode, 0, 10);
            
            // 密钥派生
            var keyVerifier:uint = deriveAESKeys();
            // 验证密钥正确性
            if (keyVerifier != pwVerifier)
                throw new ZipError("Wrong password", ZipErrorType.ZIP_ERROR_WRONG_PASSWORD);
            // 验证密文完整性
            if (!verifyHMAC(cipherText, authCode))
                throw new ZipError("Corrupted AES zip entry: invalid content", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
			
            return aesCTRDecrypt(cipherText);
        }
        
        public function initEncrypt(password:ByteArray, header:ZipHeader):void {
            throw new ZipError("Method not implemented", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
        }
        
        public function encrypt(data:ByteArray):ByteArray {
            throw new ZipError("Method not implemented", ZipErrorType.ZIP_ERROR_UNSUPPORT_METHOD);
        }
        
        /**
         * 迭代衍生密钥
         * @return 密钥验证码
         */
        private function deriveAESKeys():uint {
            var totalLen:int = 2 * _keyLength + 2;
			var derived:ByteArray;
			
			//使用ANE实现的密钥迭代
            derived = CryptoANE.instance.pbkdf2Derive(Digest.SHA1, _password, _salt, 1000, totalLen);
            
            _aesKey = BytesUtil.empty();
            _hmacKey = BytesUtil.empty();
            
            derived.position = 0;
            derived.readBytes(_aesKey, 0, _keyLength);
            derived.readBytes(_hmacKey, 0, _keyLength);
            return derived.readUnsignedByte() + (derived.readUnsignedByte() << 8);
        }
        
        /**
         * 验证 cipherText是否被篡改
         * @param cipherText 密文Raw
         * @param authCode   文件里保存的 10 字节校验码
         * @return
         */
        private function verifyHMAC(cipherText:ByteArray, authCode:ByteArray):Boolean {
            if (!_hmacKey)
                throw new ArgumentError("HMAC key is not set, please derive key first");
            
            var calc:ByteArray = HMAC.compute(Digest.SHA1, _hmacKey, cipherText);
            
            var expected:ByteArray = BytesUtil.empty();
            calc.position = 0;
            calc.readBytes(expected, 0, 10);
            return BytesUtil.isEqual(expected, authCode);
        }
        
        /**
         * AES-CTR 加密/解密(修改原文)
         * @param cipherText 加密数据
         * @return
         */
        private function aesCTRDecrypt(cipherText:ByteArray):ByteArray {
            if (!_aesKey)
                throw new ArgumentError("AES key is not set, please derive key first");
            // 初始化AES引擎
            const blockSize:int = 16;
            var iv:ByteArray = BytesUtil.fill(0, blockSize);
            iv[0] = 1;
            var aes:AESCipher = new AESCipher(_aesKey, CipherMode.CTR, PaddingMode.NONE, iv);
            return aes.decrypt(cipherText);
        }
    }
}