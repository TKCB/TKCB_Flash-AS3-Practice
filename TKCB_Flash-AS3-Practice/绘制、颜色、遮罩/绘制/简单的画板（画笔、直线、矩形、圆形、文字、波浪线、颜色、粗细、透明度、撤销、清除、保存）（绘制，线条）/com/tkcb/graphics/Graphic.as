/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */



package com.tkcb.graphics
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	/**
	 * 绘图抽象类（线框）
	 */
	public class Graphic extends Sprite
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 画笔粗细 */
		public var lineSize : int = 1;
		
		/** 画笔颜色 */
		public var lineColor : uint = 0x000000;
		
		/** 画笔透明度 */
		public var lineAlpha : Number = 1;
		
		/** 绘制图形的数组 */
		public var shapeArr : Array;
		
		/** 外部传入的容器，用于所有绘制图形的显示 */
		public var shapeSprite: Sprite;
		
		/** 外部传入的数组，用于存储所有绘制图形的数组 */
		public var allShapeArr : Array;
		
		/** 当前绘制对象 */
		protected var currentShape : Shape;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function Graphic ()
		{
			
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		
		
		/**
		 * 停止侦听，用于删除该对象前调用
		 */
		public function stopDraw () : void
		{
			
		}
		
		
	}
}
