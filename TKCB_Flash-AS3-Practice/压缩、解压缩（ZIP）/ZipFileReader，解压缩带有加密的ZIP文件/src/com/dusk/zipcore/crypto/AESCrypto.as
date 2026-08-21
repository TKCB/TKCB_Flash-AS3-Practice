package com.dusk.zipcore.crypto {
   // import com.dusk.tool.Logger;
    import com.dusk.zipcore.constant.ZipErrorType;
    import com.dusk.zipcore.struct.ZipEntry;
    import com.dusk.zipcore.struct.ZipHeader;
    import com.dusk.zipcore.zip_internal;
    import com.dusk.zipcore.ZipError;
    import com.hurlant.crypto.hash.HMAC;
    import com.hurlant.crypto.symmetric.AESKey;
    import com.hurlant.crypto.hash.SHA1;
    import flash.utils.ByteArray;
    import com.dusk.zipcore.utils.BytesUtil;

    use namespace zip_internal;

    /**
     * AES加密解密实现类
     * 兼容WinZip AES格式
     */
    public class AESCrypto implements ICrypto {

        private var _header:ZipHeader;

        private var _password:ByteArray;

        private var _salt:ByteArray;
        // 加盐长度
        private var _saltLength:int;
        // 迭代密钥长度
        private var _keyLength:int;

        private var _aesKey:ByteArray;
        private var _hmacKey:ByteArray;

        public function AESCrypto() {
        }

        public function checkDecrypt(entry:ZipEntry):Boolean {
            return entry.isEncrypted() && entry.isUseAES();
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
			trace(123456);
            if (!_header)
                throw new ArgumentError("Decrypt header is not initialized");
            if (!_password)
                throw new ArgumentError("Decrypt password is not initialized");
            if (_header._uncompressSize == 0)
                return new ByteArray();
            if (!data)
                throw new ZipError("AES data is null", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);
            if (_header._compressSize != data.length)
                throw new ZipError("Corrupted AES zip entry: length mismatch", ZipErrorType.ZIP_ERROR_UNCOMPRESS_ERROR);

            _salt = BytesUtil.empty();
            data.readBytes(_salt, 0, _saltLength);
            var pwVerifier:uint = data.readUnsignedByte() | (data.readUnsignedByte() << 8);
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

            aesCTRHandler(cipherText);
            cipherText.position = 0;
            return cipherText;
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

            var derived:ByteArray = (new PBKDF2).derive(_password, _salt, 1000, totalLen);

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
            var hmac:HMAC = new HMAC(new SHA1);
            var calc:ByteArray = hmac.compute(_hmacKey, cipherText);

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
        private function aesCTRHandler(cipherText:ByteArray):ByteArray {
            if (!_aesKey)
                throw new ArgumentError("AES key is not set, please derive key first");
            // 初始化AES引擎
            var aes:AESKey = new AESKey(_aesKey);
            const blockSize:int = 16;
            var iv:ByteArray = BytesUtil.fill(0, blockSize);
            iv[0] = 1;

            // hurlant CTRMode
            // 增加了边界检查/更改了Block迭代顺序
            var X:ByteArray = new ByteArray;
            var Xenc:ByteArray = new ByteArray;
            X.writeBytes(iv);
            for (var i:uint = 0; i < cipherText.length; i += blockSize) {
                Xenc.position = 0;
                Xenc.writeBytes(X);
                aes.encrypt(Xenc);
                // 边界修正
                var leftLen:uint = Math.min(blockSize, cipherText.length - i);
                for (var j:uint = 0; j < leftLen; j++)
                    cipherText[i + j] ^= Xenc[j];
                for (j = 0; j < blockSize; j++) {
                    X[j]++;
                    if (X[j] != 0)
                        break;
                }
            }

            return cipherText;
        }
    }
}

import flash.utils.ByteArray;

import com.hurlant.crypto.hash.HMAC;
import com.hurlant.crypto.hash.SHA1;
import com.dusk.zipcore.utils.BytesUtil;

/** PBKDF2 算法实现 - From GPT5 */
class PBKDF2 {
    private var hmac:HMAC;

    public function PBKDF2() {
        hmac = new HMAC(new SHA1);
    }

    /**
     * PBKDF2-HMAC-SHA1
     * @param password   密码 (ByteArray)
     * @param salt       盐 (ByteArray)
     * @param iterations 迭代次数（ZIP AES 固定 1000）
     * @param dkLen      需要的字节长度
     * @return ByteArray 派生结果
     */
    public function derive(password:ByteArray, salt:ByteArray, iterations:int, dkLen:int):ByteArray {
        var hLen:int = 20; // SHA1 输出 20 字节
        var l:int = Math.ceil(dkLen / hLen);
        var r:int = dkLen - (l - 1) * hLen;

        var result:ByteArray = BytesUtil.empty();
        for (var i:int = 1; i <= l; i++) {
            var t:ByteArray = F(password, salt, iterations, i);
            result.writeBytes(t, 0, (i == l) ? r : hLen);
        }
        result.position = 0;
        return result;
    }

    private function F(password:ByteArray, salt:ByteArray, iterations:int, blockIndex:int):ByteArray {
        var u:ByteArray = BytesUtil.empty();
        var block:ByteArray = BytesUtil.empty();

        // salt + INT(blockIndex) big-endian
        block.writeBytes(salt);
        block.writeByte(blockIndex >>> 24);
        block.writeByte(blockIndex >>> 16);
        block.writeByte(blockIndex >>> 8);
        block.writeByte(blockIndex);

        // U1 = PRF(password, salt||INT(i))
        u = hmac.compute(password, block);

        var result:ByteArray = new ByteArray();
        result.writeBytes(u);

        // U2...Uc
        var ui:ByteArray = u;
        for (var j:int = 2; j <= iterations; j++) {
            ui = hmac.compute(password, ui);
            // xorBytes(result, ui);
            for (var k:int = 0; k < u.length; k++)
                result[k] ^= ui[k];
        }

        result.position = 0;
        return result;
    }
}