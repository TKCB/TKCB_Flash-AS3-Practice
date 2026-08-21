package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * @author GavinGao
	 */	
	public class CloudsTest extends Sprite
	{
		private var _bitmap:BitmapData;
		//偏移
		private var _xoffset:int = 1;
		public function CloudsTest()
		{
			_bitmap = new BitmapData(stage.stageWidth, stage.stageHeight,
				true, 0xffffffff);
			var image:Bitmap = new Bitmap(_bitmap);
			addChild(image);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(evt:Event):void{
			_xoffset+=10;
			var point:Point = new Point(_xoffset, 0);
			_bitmap.perlinNoise(200, 100, 2, 1000, false, true,1, true, [point, point]);
		}
	}
}
