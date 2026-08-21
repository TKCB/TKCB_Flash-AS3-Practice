package com.dusk.zipcore.event {
    
    import flash.events.Event;
    import flash.utils.ByteArray;
    
    import com.dusk.zipcore.zip_internal;
    import com.dusk.zipcore.struct.ZipEntry;
    
    use namespace zip_internal;
    
    /**
     *  ZIP解压或压缩时的事件类
     */
    public class ZipEvent extends Event {
        
        public static var ZIP_LOAD_DATA:String = "zipLoadData";
        public static var ZIP_DATA_UNCOMPRESS:String = "zipDataUncompress";
        public static var ZIP_DATA_COMPRESS:String = "zipDataCompress";
        public static var ZIP_FILE_CREATED:String = "zipFileCreated";
        
        zip_internal var $entry:ZipEntry;
        zip_internal var $data:ByteArray;
        
        public function ZipEvent(type:String) {
            super(type);
        }
        
        public function get entry():ZipEntry {
            return $entry;
        }
        
        public function get data():ByteArray {
            return $data;
        }
    }
}
