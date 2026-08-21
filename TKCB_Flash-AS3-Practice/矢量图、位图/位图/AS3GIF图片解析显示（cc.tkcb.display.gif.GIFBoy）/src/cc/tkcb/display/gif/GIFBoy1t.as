
package cc.tkcb.display.gif
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	public class GIFBoy1t extends Bitmap {

		private var load:Boolean=false;

		//datas
		private var gifDecoder:GIFDecoder=new GIFDecoder();

		public function GIFBoy1t() {
			
		}

		/**
		 * read data
		 */
		public function loadBytes(gBytes:ByteArray):void {
			if(!gifDecoder){
				gifDecoder=new GIFDecoder();
			}
			
			load=false;
			try {
				gifDecoder.firstFunc=firstView;
				var st:int=gifDecoder.read(gBytes);

				if (st == GIFDecoder.STATUS_OK) {
					parser();
				}

			} catch (e:Error) {
				
			}
		}

		/**
		 * info
		 */
		public function dispose():void {
			this.bitmapData=null;
			gifDecoder.firstFunc=null;
			gifDecoder.disposeObject();
			gifDecoder.disposeFrames();
			gifDecoder=null;
			load=false;
		}

		private function firstView():void {
			this.bitmapData=gifDecoder.getImage();
			load=true;
		}

		private function parser():void {
			while(!load){
				try {
					gifDecoder.readFrame();
				} catch (e:Error) {
					load=true;
				}
			}
			gifDecoder.disposeObject();
		}

	}
}
