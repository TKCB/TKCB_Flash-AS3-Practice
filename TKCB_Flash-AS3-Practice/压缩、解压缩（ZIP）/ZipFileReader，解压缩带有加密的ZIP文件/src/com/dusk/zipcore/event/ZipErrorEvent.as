package com.dusk.zipcore.event {
	import com.dusk.zipcore.ZipError;
    import flash.events.ErrorEvent;
    
    public class ZipErrorEvent extends ErrorEvent {
        
        /**
         *  File uncompress error
         */
        public static const ZIP_UNCOMPRESS_ERROR:String = "zipUncompressError";
        
        public function ZipErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = null, id:int = 0) {
            super(type, bubbles, cancelable, text, id);
        }
		
		public var error:ZipError;
        
    }
}