/*
 * 作　　者：TKCB
 * 作者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import flash.geom.Point;
	
	/**
	 * BitmapChip 位图碎片类，图片裁切的核心方法之一，利用了AS3的位图填充技术，进行位图的裁切分割（实际为改变填充区域）
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2016-9-27
	 * @修改时间 2016-10-2
	 */
	public class BitmapChip extends Sprite 
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		/** 多边形顶点数组 */
		private var _pointArr : Array;
		
		/** 位图数据对象 */
		private var bitmapData : BitmapData;
		
		//************************ ************************* get  set ******************** *********** *** **////
		public function get pointArr () : Array
		{
			return _pointArr;
		}
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * ...
		 */
		public function BitmapChip ( $bitmapData:BitmapData )
		{
			bitmapData = $bitmapData;
			mouseChildren = false;
		}
		
		
		//************************ ************************* 属性 ******************** *********** *** **////
		/**
		 * 设置多边形顶点
		 */
		public function setPoint ( $pointArr:Array ) : void
		{
			_pointArr = $pointArr;
			
			var len : int = _pointArr.length - 1;
			
			// 清除原有的图形，并初始化绘制设置
			graphics.clear();
			graphics.beginBitmapFill( bitmapData );
			graphics.lineStyle( 1, 0x000000, 1 );	// 线条粗细、颜色、透明度
			graphics.moveTo( _pointArr[len].x, _pointArr[len].y );
			
			// 按照多边形顶点绘制线条，最终形成封闭的多边形
			var i : int;
			for ( i = 0; i < len; i++ )
			{		
				this.graphics.lineTo(_pointArr[i].x, _pointArr[i].y);
			}
			
			this.graphics.endFill();			
		}
		
		
	}

}