package com.dusk.zipcore.crypto {
    import com.dusk.zipcore.struct.ZipEntry;
    import com.dusk.zipcore.struct.ZipHeader;
    
    import flash.utils.ByteArray;
    
    public interface ICrypto {
        /**
         * check if the entry can be decrypted
         */
        function checkDecrypt(entry:ZipEntry):Boolean;
        
        /**
         *   initialize decrypto
         */
        function initDecrypt(password:ByteArray, header:ZipHeader):void;
        
        /**
         *   decrypto
         */
        function decrypt(data:ByteArray):ByteArray;
        
        /**
         *   initialize encrypto
         */
        function initEncrypt(password:ByteArray, header:ZipHeader):void;
        
        /**
         *  encrypto
         */
        function encrypt(data:ByteArray):ByteArray;
    }
}