/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */



package com.tkcb.graphics
{
	import flash.display.Sprite;
	
	/**
	 * 图形抽象类（形状）
	 */
	public class GraphicFill extends Graphic
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 是否绘制边框，true为有边框，false为没有边框 */
		public var isLine : Boolean = true;
		
		/** 是否填充颜色，true为有填充，false为没有填充  */
		public var isFill : Boolean = true;
		
		/** 填充颜色 */
		public var fillColor : uint = 0xFFFFFF;
		
		/** 线条透明度 */
		public var fillAlpha : Number = 1;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function GraphicFill ()
		{
			
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		
		
		
		
	}
}
