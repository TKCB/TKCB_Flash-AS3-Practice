package {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.*;
	import flash.net.URLRequest;
	public class waveclass extends Sprite {
		private var mouseDown:Boolean = false;
		private var damper,result,result2,source,buffer,output,surface:BitmapData;
		var pic:Bitmap;
		private var bounds:Rectangle;
		private var origin:Point;
		private var matrix,matrix2:Matrix;
		private var wave:ConvolutionFilter;
		private var damp:ColorTransform;
		private var water:DisplacementMapFilter;
		//
		private var imgW:Number = 400;
		private var imgH:Number = 300;

		public function waveclass () {
			super ();
			buildwave ();
		}
		private function buildwave () {
			damper = new BitmapData(imgW, imgH, false, 128);
			result = new BitmapData(imgW, imgH, false, 128);
			result2 = new BitmapData(imgW*2, imgH*2, false, 128);
			source = new BitmapData(imgW, imgH, false, 128);
			buffer = new BitmapData(imgW, imgH, false, 128);
			output = new BitmapData(imgW*2, imgH*2, true, 128);
			bounds = new Rectangle(0, 0, imgW, imgH);
			origin = new Point();
			matrix = new Matrix();
			matrix2 = new Matrix();
			matrix2.a = matrix2.d=2;
			wave = new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9, 0);
			damp = new ColorTransform(0, 0, 9.960937E-001, 1, 0, 0, 2, 0);
			water = new DisplacementMapFilter(result2, origin, 4, 4, 48, 48);
			var _bg:Sprite = new Sprite();
			addChild (_bg);
			_bg.graphics.beginFill (0xFFFFFF,0);
			_bg.graphics.drawRect (0,0,imgW,imgH);
			_bg.graphics.endFill ();
			addChild (new Bitmap(output));
			buildImg ();
		}
		private function frameHandle (_e:Event):void {

			var _x:Number = mouseX/2;
			var _y:Number = mouseY/2;
			source.setPixel (_x+1, _y, 16777215);
			source.setPixel (_x-1, _y, 16777215);
			source.setPixel (_x, _y+1, 16777215);
			source.setPixel (_x, _y-1, 16777215);
			source.setPixel (_x, _y, 16777215);
			result.applyFilter (source, bounds, origin, wave);
			result.draw (result, matrix, null, BlendMode.ADD);
			result.draw (buffer, matrix, null, BlendMode.DIFFERENCE);
			result.draw (result, matrix, damp);
			result2.draw (result, matrix2, null, null, null, true);
			output.applyFilter (surface, new Rectangle(0, 0, imgW, imgH), origin, water);
			buffer = source;
			source = result.clone();
		}
		private function buildImg ():void {
			surface = new pic00(10,10);
			addEventListener (Event.ENTER_FRAME,frameHandle);
		}
	}
}