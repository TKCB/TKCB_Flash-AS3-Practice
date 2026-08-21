package com.dusk.zipcore.utils {
    
    /**
     * Logger class
     */
    public class ZipLog {
        
        /**
         * debug info
         * @param message
         * @param ...rest
         */
        public static function debug(message:String, ...rest):void {
            // user defined
            // log(1, message);
            // trace(message);
        }
        
        /**
         * log info
         * @param message
         * @param ...rest
         */
        public static function info(message:String, ...rest):void {
            // user defined
            // log(2, message);
            // trace(message);
        }
        
        /**
         * warning info
         * @param message
         * @param ...rest
         */
        public static function warn(message:String, ...rest):void {
            // user defined
            // log(3, message);
            // trace(message);
        }
        
        /**
         * error info
         * @param message
         * @param ...rest
         */
        public static function error(message:String, ...rest):void {
            // user defined
            // log(4, message);
            // trace(message);
        }
        
        /**
         * fatal info
         * @param message
         * @param ...rest
         */
        public static function fatal(message:String, ...rest):void {
            // user defined
            // log(5, message);
            // trace(message);
        }
        
        /**
         * log message with level
         * @param level
         * @param message
         * @param ...rest
         */
        public static function log(level:int, message:String, ...rest):void {
            // user defined
            // trace(message);
        }
    }
}
