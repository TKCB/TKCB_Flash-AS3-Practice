package gyuque.effects
{
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.events.*;
	public class PantsGlow extends Sprite
	{
		private var mSrcBmp:BitmapData;
		private var mEdgeBmp:BitmapData;
		private var mSampPoints:Array;
		private var mSampPointsOuter:Array;
		private var mSampPointOffsets:Array;
		private static var mEdgeFilt:ConvolutionFilter;

		// params
		private var mLoopEnd:int = -1;
		private var mSampling:Number = 0.1;
		private var mTargetRect:Rectangle = new Rectangle(0, 0, 10, 10);
		private var mCenterX:int;
		private var mCenterY:int;
		private var mEffectWidth:int = -1;

		// status
		private var mTickCount:int;

		private static const N_LAYERS:uint = 3;
		private var mLayers:Array = [];

		function PantsGlow(b:BitmapData)
		{
			initStatic();

			for (var i:int = 0;i < N_LAYERS;i++)
			{
				var s:Sprite = new Sprite();
				addChild(s);
				mLayers.push(s);
				s.blendMode = BlendMode.ADD;
			}

			mSrcBmp = b;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function set loopEnd(e:int):void
		{
			mLoopEnd = e;
		}

		public function set sampling(s:Number):void
		{
			mSampling = s;
		}

		public function setTargetRect(x:int, y:int, w:int, h:int):void
		{
			mTargetRect.x = x;
			mTargetRect.y = y;
			mTargetRect.width  = w;
			mTargetRect.height = h;
		}

		public function setEffectCenter(x:int, y:int):void
		{
			mCenterX = x;
			mCenterY = y;
		}

		public function set effectWidth(w:int):void
		{
			mEffectWidth = w;
		}

		private function initStatic():void
		{
			if (!mEdgeFilt)
				mEdgeFilt = new ConvolutionFilter(3, 3, [
					 0, -1,  0,
					-1,  4, -1, // 4-dir Laplacian
					 0, -1,  0,
				]);
		}

		public function prepare():void
		{
			if (mEdgeBmp)
				mEdgeBmp.dispose();

			if (mEffectWidth < 0)
				mEffectWidth = mCenterX*3/2;

			mEdgeBmp = new BitmapData(mSrcBmp.width, mSrcBmp.height, true, 0);

			var rc:Rectangle = new Rectangle(0, 0, mSrcBmp.width, mSrcBmp.height);
			mEdgeBmp.applyFilter(mSrcBmp, rc, new Point(0, 0), mEdgeFilt);
			pickPoints();

		}

		private function pickPoints():void
		{
			var w:int = mEdgeBmp.width;
			var h:int = mEdgeBmp.height;
			mSampPoints = [];
			mSampPointsOuter = [];
			mSampPointOffsets = [];

			var x:int, y:int;
			for (y = 0;y < h;y++)
			{
				for (x = 0;x < w;x++)
				{
					if (Math.random() > mSampling)
						continue;
					if ((mEdgeBmp.getPixel(x, y)&0xf0f0f0) == 0)
						continue;

					mSampPoints.push((x << 16)|y);
					mSampPointsOuter.push(calcOuter(x, y));
					mSampPointOffsets.push(x / mTargetRect.width + (Math.random()*0.2-0.1));
				}
			}
		}

		private function calcOuter(x:Number, y:Number):uint
		{
			var cx:Number = mCenterX - mEffectWidth/2+(x / mTargetRect.width * mEffectWidth);

			var len:Number = Math.random()*3 + 3;
			var ox:int = x + (x-cx)*len;
			var oy:int = y + (y-mCenterY)*len*1.3;

			return ((ox << 16)|(oy&0xffff));
		}

		private function tick():void
		{
			var x:int, y:int, k:uint;
			var ox:int, oy:int;
			var len:int = mSampPoints.length;

			var i:int;

			for(i = 0;i < N_LAYERS;i++)
				mLayers[i%N_LAYERS].graphics.clear();

			for(i = 0;i < len;i++)
			{
				drawFin(mLayers[i%N_LAYERS].graphics, mLayers[(i+1)%N_LAYERS].graphics, mLayers[(i+2)%N_LAYERS].graphics, i, mSampPointOffsets[i]);
			}


			mTickCount++;
		}

		public static const RED_PRESET_COLORS1:Array = [0xffeedd, 0xddaa55, 0xaa3300, 0x660000];
		public static const RED_PRESET_COLORS2:Array = [0x883322, 0x772211, 0x550000, 0x440000];
		public static const RED_PRESET_ALPHAS:Array = [0.8, 0.8, 0.6, 0];
		public static const RED_PRESET_RATIOS:Array = [90, 180, 220, 255];
		public static const RED_PRESET_RATIOS2:Array = [10, 40, 120, 255];

		private static function rotateX(v:Vec2, r:Number):Number
		{
			var y:Number = v.y;
			if (y<0) y=-y;
			return Math.cos(r)*v.x - Math.sin(r)*y;
		}

		private static var _gmat:Matrix = new Matrix();
		private function drawFin(g:Graphics, g2:Graphics, g3:Graphics, idx:int, ofs:Number):void
		{
			var x:int, y:int, k:uint;
			var ox:int, oy:int;
			k = mSampPoints[idx];
			x = (k & 0xffff0000) >> 16;
			y = k & 0xffff;

			k = mSampPointsOuter[idx];
			ox = (k & 0xffff0000) >> 16;
			oy = k & 0xffff;
			if (oy >= 32768) oy -= 65536;
			
			var vP:Vec2 = new Vec2(x, y);
			var vO:Vec2 = new Vec2(ox, oy);
			var vMid:Vec2 = Vec2.makeAtoB(vP, vO);

			var localTick:int = mTickCount - int(ofs*44);
			var gph:Number = localTick*0.2;
			vMid.x += localTick*mEffectWidth/32;
			if (gph < 0 || gph > 3.14) return;
			vMid.smul(Math.sin(gph)*2);

			var vLeft:Vec2 = vMid.clone().normalize().smul(19).left();
			var vRight:Vec2 = vLeft.clone().smul(-1);

			var gw:Number = vMid.norm();
			_gmat.createGradientBox(gw, gw, Math.atan2(vMid.y, vMid.x), x-gw/2, y-gw/2);
			g.beginGradientFill(
				GradientType.LINEAR, 
				RED_PRESET_COLORS2,
				RED_PRESET_ALPHAS,
				RED_PRESET_RATIOS,
				_gmat,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				0);

			g.moveTo(x, y);
			g.lineTo(vP.x + vMid.x + vLeft.x,  vP.y + vMid.y + vLeft.y);
			g.lineTo(vP.x + vMid.x + vRight.x, vP.y + vMid.y + vRight.y);
			g.endFill();

			vLeft.smul(0.3);
			vRight.smul(0.3);
			vMid.smul(2);

			gw = vMid.norm();
			_gmat.createGradientBox(gw, gw, Math.atan2(vMid.y, vMid.x), x-gw/2, y-gw/2);
			g2.beginGradientFill(
				GradientType.LINEAR, 
				RED_PRESET_COLORS1,
				RED_PRESET_ALPHAS,
				RED_PRESET_RATIOS,
				_gmat,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				0);
			g2.moveTo(x, y);
			g2.lineTo(vP.x + vMid.x + vLeft.x,  vP.y + vMid.y + vLeft.y);
			g2.lineTo(vP.x + vMid.x + vRight.x, vP.y + vMid.y + vRight.y);
			g2.endFill();

			var r:Number = Math.sin(gph) * 41;
			if (r<0) r = 0;
			_gmat.createGradientBox(r, r, 0, x-r/2, y-r/2);
			g2.beginGradientFill(
				GradientType.RADIAL, 
				RED_PRESET_COLORS1,
				RED_PRESET_ALPHAS,
				RED_PRESET_RATIOS2,
				_gmat,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				0);
			g2.drawCircle(x, y, r);
			g2.endFill();

		}


		private function onEnterFrame(e:Event):void
		{
			tick();
			if (mLoopEnd >= 0 && mTickCount > mLoopEnd)
				mTickCount = 0;
		}
	}
}