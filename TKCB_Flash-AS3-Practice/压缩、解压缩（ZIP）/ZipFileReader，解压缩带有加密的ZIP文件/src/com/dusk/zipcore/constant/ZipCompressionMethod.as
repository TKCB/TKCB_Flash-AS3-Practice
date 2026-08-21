package com.dusk.zipcore.constant {

    public class ZipCompressionMethod {
        public static const METHOD_NONE:int =               0;  //usual
        public static const METHOD_SHRUNK:int =             1;  //shrink(deprecated)
        public static const METHOD_REDUCED_1:int =          2;  //reduced(deprecated)
        public static const METHOD_REDUCED_2:int =          3;  //reduced(deprecated)
        public static const METHOD_REDUCED_3:int =          4;  //reduced(deprecated)
        public static const METHOD_REDUCED_4:int =          5;  //reduced(deprecated)
        public static const METHOD_IMPLODED:int =           6;  //(PKWARE)
        public static const METHOD_TOKENIZED:int =          7;  //rarely
        public static const METHOD_DEFLATED:int =           8;  //usual
        public static const METHOD_DEFLATED_EXT:int =       9;  //usual
        public static const METHOD_IMPLODED_PKWARE:int =    10; //(PKWARE)
        public static const METHOD_LZMA:int =               14; //unstandard
        public static const METHOD_AES:int =                99; //usual
    }
}
