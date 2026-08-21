package org.linxinboy.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	         * 2014.4.12
	         * @author linxinboy
	         */
	public class BitmapUtil
	{
		/**
		                 * 返回两张图片的相似度   0 - 100   越高越相似
		                 */
		public static function compare(src0:BitmapData,src1:BitmapData):int
		{
			var str0:String = hashBitmap(src0);
			var str1:String = hashBitmap(src1);
			trace(str0);
			trace(str1);
			var diff:uint = 0;
			for (var i:int = 0; i < str0.length; i++)
			{
				if (str0.charAt(i) != str1.charAt(i))
				{
					diff++;
				}
			}

			return (64 - diff) / 64 * 100;
		}

		public static function hashBitmap(src:BitmapData):String
		{
			var bmd:BitmapData = new BitmapData(8,8);
			var w:int = src.width;
			var h:int = src.height;
			var scale:Number = w > h ? w / 8:h / 8;
			bmd.draw(src,new Matrix((1 / scale),0,0,1 / scale));
			var ave:uint = 0;
			var colorList:Vector.<uint >  = new Vector.<uint >   ;
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					var color:uint = bmd.getPixel(i,j);
					var r:uint = (color >> 16) & 0xFF;
					var g:uint = (color >> 8) & 0xFF;
					var b:uint = color & 0xFF;
					color = ((((r * 0.3) + g * 0.59) + b * 0.11) / 4);
					ave +=  color;
					colorList.push(color);
				}
			}
			ave /=  64;
			var str:String = "";
			for (i = 0; i < colorList.length; i++)
			{
				if (colorList[i] >= ave)
				{
					colorList[i] = 1;
				}
				else
				{
					colorList[i] = 0;
				}
				str +=  colorList[i];
			}
			return str;
		}
	}
}