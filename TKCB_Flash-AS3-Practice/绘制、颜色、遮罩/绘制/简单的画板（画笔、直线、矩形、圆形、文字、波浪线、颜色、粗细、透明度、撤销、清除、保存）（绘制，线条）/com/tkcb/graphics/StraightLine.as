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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 直线类，用于绘制直线
	 */
	public class StraightLine extends Graphic
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 当前坐标X，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentX : Number;
		
		/** 当前坐标Y，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentY : Number;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function StraightLine ()
		{
			init();
			
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 初始化 */
		private function init () : void
		{
			lineSize = 1;
			
			lineColor = 0x000000;
			
			lineAlpha = 1;
			
			shapeArr = [];
		}
		
		/** 对象被添加到舞台 */
		private function addedToStage ( eve : Event ) : void
		{
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
		}
		
		/** 鼠标绘制 */
		private function stageMouse ( eve : MouseEvent ) : void
		{
			switch ( eve.type )
			{
				// 按下鼠标
				case MouseEvent.MOUSE_DOWN:
					//// 记录坐标点
					currentX = eve.stageX;
					currentY = eve.stageY;
					
					//// 开启绘制侦听
					stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.addEventListener( MouseEvent.MOUSE_UP, stageMouse );
					break;
				
				// 移动鼠标，绘制线条
				case MouseEvent.MOUSE_MOVE:
					if ( currentShape == null )
					{
						//// 每一次按下的时候都会新建绘制对象
						currentShape = new Shape();
						shapeSprite.addChild( currentShape );
					}
					currentShape.graphics.clear();
					currentShape.graphics.lineStyle( lineSize, lineColor, lineAlpha );
					currentShape.graphics.moveTo( currentX, currentY );
					currentShape.graphics.lineTo( eve.stageX, eve.stageY );
					break;
					
				// 放开鼠标
				case MouseEvent.MOUSE_UP:
					trace( "绘制图形完成！" );
					
					//// 清除当前绘制的对象
					if ( currentShape != null )
					{
						shapeArr.push( currentShape );
						allShapeArr.push( currentShape );
						currentShape = null;
					}
					trace( allShapeArr.length );
					//// 停止绘制侦听
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
					break;
			}
		}
		
		/**
		 * 停止侦听，用于删除该对象前调用
		 */
		override public function stopDraw () : void
		{
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
			stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
		}
		
	}
}
