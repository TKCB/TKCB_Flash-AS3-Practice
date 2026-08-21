package com.dusk.zipcore.utils {
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    public class BytesUtil {
        
        /**
         * 创建一个空的字节数组
         * @param endian 字节序
         * @return
         */
        public static function empty(endian:String = Endian.LITTLE_ENDIAN):ByteArray {
            var ba:ByteArray = new ByteArray;
            ba.endian = endian;
            return ba;
        }

        /**
         * 获取随机字节
         * @param length 字节长度
         * @param endian 字节序
         */
        public static function getRandom(length:int, endian:String = Endian.LITTLE_ENDIAN):ByteArray {
            var ba:ByteArray = empty(endian);
            while (length > 0) {
				ba[--length] = int(Math.random() * 256);
			}
            ba.position = 0;
            return ba;
        }
        
        /**
         * 创建一个固定值填充字节数组
         * @param value 填充值
         * @param length 目标长度
         * @param endian 字节序
         * @return
         */
        public static function fill(value:int, length:int, endian:String = Endian.LITTLE_ENDIAN):ByteArray {
            var ba:ByteArray = empty(endian);
            for (var i:int = 0; i < length; i++) {
                ba.writeByte(value);
            }
            ba.position = 0;
            return ba;
        }
        
        /**
         * 快速比较两者是否相等
         * @param ba1
         * @param ba2
         * @return
         */
        public static function isEqual(ba1:ByteArray, ba2:ByteArray):Boolean {
            if (ba1.length != ba2.length) {
                return false;
            }
            for (var i:int = 0; i < ba1.length; i++) {
                if (ba1[i] != ba2[i]) {
                    return false;
                }
            }
            return true;
        }
        
        /**
         * 从字符串创建字节数组
         * @param str
         * @param charset
         * @return
         */
        public static function fromString(str:String, charset:String = null):ByteArray {
            if (charset == null)
                charset = "utf-8";
            var ba:ByteArray = new ByteArray();
            ba.writeMultiByte(str, charset);
            ba.position = 0;
            return ba;
        }
    }
    
}
