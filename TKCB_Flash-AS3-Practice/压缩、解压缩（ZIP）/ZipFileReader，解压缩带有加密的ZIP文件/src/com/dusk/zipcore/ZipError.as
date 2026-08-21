package com.dusk.zipcore {
    public class ZipError extends Error {
        public function ZipError(message:String = "", id:int = 0) {
            super(message, id);
        }
    }
}