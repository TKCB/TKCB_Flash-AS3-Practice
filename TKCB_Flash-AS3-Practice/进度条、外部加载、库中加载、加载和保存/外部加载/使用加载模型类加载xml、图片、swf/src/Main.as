package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.tkcb.loader.BitmapLoaderModel;
	import com.tkcb.loader.SWFLoaderModel;
	import com.tkcb.loader.XMLLoaderModel;
	
	/**
	 * ...
	 * @author TKCB(QQ 2414268040、E-mail tkcb@qq.com)
	 */
	public class Main extends Sprite
	{
		/// 图片、swf和xml对象
		private var bitmap:BitmapLoaderModel;
		private var swf:SWFLoaderModel;
		private var xml:XMLLoaderModel;
		
		
		/**
		 * 构造函数
		 */
		public function Main() {
			bitmap = new BitmapLoaderModel("image/图片1.jpg");
			bitmap.addEventListener(Event.COMPLETE, bitmapLoader);
			
			swf = new SWFLoaderModel("swf/Animation.swf");
			swf.addEventListener(Event.COMPLETE, swfLoader);
			
			xml = new XMLLoaderModel("xml/myxml.xml");
			xml.addEventListener(Event.COMPLETE, xmlLoader);
		}
		
		private function bitmapLoader(eve:Event):void {
			bitmap.removeEventListener(Event.COMPLETE, bitmapLoader);
			
			bitmap.bitmap.x = bitmap.bitmap.y = 50;
			bitmap.bitmap.scaleX = bitmap.bitmap.scaleY = 0.1;
			addChild(bitmap.bitmap);
		}
		
		private function swfLoader(eve:Event):void {
			swf.removeEventListener(Event.COMPLETE, swfLoader);
			
			addChild(swf.swf);
		}
		
		private function xmlLoader(eve:Event):void {
			xml.removeEventListener(Event.COMPLETE, xmlLoader);
			
			trace(xml.xml);
		}
	}
}