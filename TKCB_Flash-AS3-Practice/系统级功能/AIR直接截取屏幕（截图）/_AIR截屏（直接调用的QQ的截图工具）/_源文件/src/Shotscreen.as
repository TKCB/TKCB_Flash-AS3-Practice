package 
{

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	public class Shotscreen extends Sprite
	{

		private var scrshot:ScreenShot;
		public function Shotscreen()
		{
			stage.scaleMode="noScale";
			scrshot = new ScreenShot()  ;
			bt.addEventListener(MouseEvent.CLICK, clk);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			scrshot.addEventListener(ScreenShot.SHOT_COMPLETE,onComplete);
			scrshot.shot();
		}
        private function onKDown(e:KeyboardEvent):void {
			if (e.altKey && e.ctrlKey && e.keyCode == 65) {
				scrshot.shot();
			}
		}


		private function clk(e:MouseEvent)
		{
			scrshot.shot();

		}
		private function onComplete(e:Event)
		{
			while (mc.numChildren>0)
			{
				mc.removeChildAt(0);
			}
			mc.addChild(new Bitmap(scrshot.bitmapData));
			
			
		}

	}

}