package
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	import flash.events.MouseEvent;
	
	/**
	 * MaskEnlarge 类用于
	 * @author TKCB
	 */
	public class MaskEnlarge extends Sprite
	{
		/** 原始图片 */
		private var originalBitmap:MovieClip;
		/** 原始图片宽度的二分之一，用于判断遮罩的位置是在左边、右边或者中间 */
		private var originalBitmapWidthHalf:Number;
		/** 原始图片高度的二分之一，用于判断遮罩的位置是在左边、右边或者中间  */
		private var originalBitmapHeightHalf:Number;
		/** 偏移宽度的长度，用于计算大图X坐标位置 */
		private var originalBitmapOffsetWidth:Number;
		/** 偏移高度的长度，用于计算大图Y坐标位置 */
		private var originalBitmapOffsetHeight:Number;
		/** 放大图片 */
		private var enlargeBitmap:MovieClip;
		/** 放大图片偏移宽度的长度，用于计算大图X坐标位置 */
		private var enlargeBitmapOffsetWidth:Number;
		/** 放大图片偏移高度的长度，用于计算大图Y坐标位置 */
		private var enlargeBitmapOffsetHeight:Number;
		
		/** 放大比例、倍数，用于计算大图相对坐标 */
		private var enlargeProportion:Number;
		
		/** 遮罩 */
		private var maskShape:Shape;
		/** 遮罩宽度，用于计算遮罩X坐标 */
		private var maskWidth:Number;
		/** 遮罩宽度的二分之一，用于计算遮罩X坐标 */
		private var maskWidthHalf:Number;
		/** 遮罩高度，用于计算遮罩Y坐标 */
		private var maskHeight:Number;
		/** 遮罩高度的二分之一，用于计算遮罩Y坐标 */
		private var maskHeightHalf:Number;
		/** 鼠标在最右边的遮罩X坐标位置1 */
		private var maskMouseX1:Number;
		/** 鼠标在最右边的遮罩X坐标位置2 */
		private var maskMouseX2:Number;
		/** 鼠标在最下边的遮罩Y坐标位置1 */
		private var maskMouseY1:Number;
		/** 鼠标在最下边的遮罩Y坐标位置2 */
		private var maskMouseY2:Number;
		
		/** 遮罩边框，更好的显示 */
		private var maskBorder:Shape;
		
		public function MaskEnlarge()
		{
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			maskWidth = 25;
			maskHeight = 25;
		}
		
		/**
		 * 设置
		 */
		public function maskDisplay(ob:MovieClip, eb:MovieClip, ms:Shape, mw:Number, mh:Number):void
		{
			originalBitmap = ob;
			originalBitmap.x = 0;
			originalBitmap.y = 0;
			addChild(originalBitmap);
			
			originalBitmapWidthHalf = originalBitmap.width >> 1;
			originalBitmapHeightHalf = originalBitmap.height >> 1;
			
			enlargeBitmap = eb;
			enlargeBitmap.x = 0;
			enlargeBitmap.y = 0;
			addChild(enlargeBitmap);
			
			enlargeProportion = (enlargeBitmap.width / originalBitmap.width) - 1;
			
			maskWidth = mw;
			maskHeight = mh;
			
			if(ms == null)
			{
				maskShape = new Shape();
				maskShape.graphics.beginFill(0xFF0000, 1);
				maskShape.graphics.drawRect(0, 0, maskWidth, maskHeight);
				maskShape.graphics.endFill();
				addChild(maskShape);
			}
			enlargeBitmap.mask = maskShape;
			
			maskWidthHalf = maskWidth >> 1;
			maskHeightHalf = maskHeight >> 1;
			
			maskMouseX1 = originalBitmap.width - maskWidthHalf;
			maskMouseX2 = originalBitmap.width - maskWidth;
			maskMouseY1 = originalBitmap.height - maskHeightHalf;
			maskMouseY2 = originalBitmap.height - maskHeight;
			
			originalBitmapOffsetWidth = originalBitmapWidthHalf - maskWidthHalf;
			originalBitmapOffsetHeight = originalBitmapHeightHalf - maskHeightHalf;
			
			enlargeBitmapOffsetWidth = maskWidthHalf * enlargeProportion;
			enlargeBitmapOffsetHeight = maskHeightHalf * enlargeProportion;
			
			maskBorder = new Shape();
			maskBorder.graphics.lineStyle(1, 0xFFFFFF, 1);
			maskBorder.graphics.lineTo(maskWidth, maskShape.y);
			maskBorder.graphics.lineTo(maskWidth, maskHeight);
			maskBorder.graphics.lineTo(maskShape.x, maskHeight);
			maskBorder.graphics.lineTo(maskShape.x, maskShape.y);
			maskBorder.graphics.endFill();
			addChild(maskBorder);
			
			addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}
		
		/**
		 * 侦听器，处理鼠标移动的大图显示
		 */
		private function mouseHandler(eve:MouseEvent):void
		{
			// 下面代码设置遮罩和边框的坐标位置
			// 鼠标在最左边
			if(mouseX < maskWidthHalf)
			{
				maskShape.x = 0;
				maskBorder.x = 0;
			}
			// 鼠标在最右边
			else if(mouseX > maskMouseX1)
			{
				maskShape.x = maskMouseX2;
				maskBorder.x = maskMouseX2;
			}
			// 鼠标在中间
			else
			{
				maskShape.x = mouseX - maskWidthHalf;
				maskBorder.x = maskShape.x;
			}
			
			// 鼠标在最上边
			if(mouseY < maskHeightHalf)
			{
				maskShape.y = 0;
				maskBorder.y = 0;
			}
			// 鼠标在最下边
			else if(mouseY > maskMouseY1)
			{
				maskShape.y = maskMouseY2;
				maskBorder.y = maskMouseY2;
			}
			// 鼠标在中间
			else
			{
				maskShape.y = mouseY - maskHeightHalf;
				maskBorder.y = maskShape.y;
			}
			
			// 下面代码用于处理大图片的坐标位置
			// 遮罩在左边
			if((maskShape.x + maskWidthHalf) < originalBitmapWidthHalf)
			{
				var numX1:Number = maskShape.x * enlargeProportion;// 首先，计算遮罩以外的左边部分向左边的偏移量
				var numX2:Number = (maskShape.x / originalBitmapOffsetWidth) * enlargeBitmapOffsetWidth;// 然后，计算偏移坐标
				enlargeBitmap.x = -(numX1 + numX2);// 最后，计算准确坐标
			}
			// 遮罩在中间
			else if((maskShape.x + maskWidthHalf) == originalBitmapWidthHalf)
			{
				enlargeBitmap.x = -(originalBitmapWidthHalf * enlargeProportion);
			}
			// 遮罩在右边
			else
			{
				var numX3:Number = (maskShape.x + maskShape.width) * enlargeProportion;// 首先，计算遮罩以外的左边部分向左边的偏移量
				var numX4:Number = ((originalBitmap.width - (maskShape.x + maskWidth)) / originalBitmapOffsetWidth) * enlargeBitmapOffsetWidth;// 然后，计算偏移坐标
				enlargeBitmap.x = -(numX3 - numX4);// 最后，计算准确坐标
			}
			
			// 遮罩在上边
			if((maskShape.y + maskHeightHalf) < originalBitmapHeightHalf)
			{
				var numY1:Number = maskShape.y * enlargeProportion;// 首先，计算遮罩以外的左边部分向左边的偏移量
				var numY2:Number = (maskShape.y / originalBitmapOffsetHeight) * enlargeBitmapOffsetHeight;// 然后，计算偏移坐标
				enlargeBitmap.y = -(numY1 + numY2);// 最后，计算准确坐标
			}
			// 遮罩在中间
			else if((maskShape.y + maskHeightHalf) == originalBitmapHeightHalf)
			{
				enlargeBitmap.y = -(originalBitmapHeightHalf * enlargeProportion);
			}
			// 遮罩在下边
			else
			{
				var numY3:Number = (maskShape.y + maskShape.height) * enlargeProportion;// 首先，计算遮罩以外的左边部分向左边的偏移量
				var numY4:Number = ((originalBitmap.height - (maskShape.y + maskHeight)) / originalBitmapOffsetHeight) * enlargeBitmapOffsetHeight;// 然后，计算偏移坐标
				enlargeBitmap.y = -(numY3 - numY4);// 最后，计算准确坐标
			}
			
		}
	}
}