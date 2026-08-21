package com.tkcb.graphics
{
	import flash.display.Sprite;
	import flash.display.Shape;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import flash.display.Shader;



	/**
	 * 直线类，用于绘制直线
	 */
	public class WaveLine extends Graphic
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 当前坐标X，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentX:Number;

		/** 当前坐标Y，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentY:Number;

		public var A:Number = 2;//定义振幅A
		public var yuandx:Number;
		public var yuandy:Number;
		public var ii:int;
		public var i:Number = 0;
		public var maxX:Number;
		private var sshape:Shape;





		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function WaveLine()
		{
			init();

			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}


		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 初始化 */
		private function init():void
		{
			lineSize = 1;

			lineColor = 0x000000;

			lineAlpha = 1;

			shapeArr = [];
		}

		/** 对象被添加到舞台 */
		private function addedToStage( eve : Event ):void
		{
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
		}

		private function drawx():void
		{
			i +=  60;
			if (maxX>=currentX)
			{
				currentShape.graphics.lineTo((currentX+i/20),(currentY-A*Math.sin (i*Math.PI/180)));
				if (((currentX+i/20))>=maxX)
				{
					clearInterval(ii);
					if ( currentShape != null )
					{
						shapeArr.push( currentShape );
						allShapeArr.push( currentShape );
						currentShape = null;
					}
					stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
				}
			}
			else
			{
				currentShape.graphics.lineTo((currentX-i/20),(currentY-A*Math.sin (i*Math.PI/180)));
				if (((currentX-i/20))<=maxX)
				{
					clearInterval(ii);
					if ( currentShape != null )
					{
						shapeArr.push( currentShape );
						allShapeArr.push( currentShape );
						currentShape = null;
					}
					stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
				}
			}
		}

		/** 鼠标绘制 */
		private function stageMouse( eve : MouseEvent ):void
		{
			switch ( eve.type )
			{
					// 按下鼠标
				case MouseEvent.MOUSE_DOWN :
					//// 记录坐标点
					i = 0;
					currentX = eve.stageX;
					currentY = eve.stageY;
					if ( currentShape == null )
					{
						//// 每一次按下的时候都会新建绘制对象
						currentShape = new Shape();
						shapeSprite.addChild( currentShape );
					}
					currentShape.graphics.lineStyle( lineSize, lineColor, lineAlpha );
					currentShape.graphics.moveTo( currentX, currentY );
					//clearInterval(ii);
					sshape=new Shape();
					shapeSprite.addChild( sshape );
					sshape.graphics.lineStyle( lineSize, lineColor, lineAlpha );
					sshape.graphics.moveTo( currentX, currentY );
					//// 开启绘制侦听;
					stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.addEventListener( MouseEvent.MOUSE_UP, stageMouse );
					break;

					// 移动鼠标，绘制线条
				case MouseEvent.MOUSE_MOVE :
					sshape.graphics.lineTo( eve.stageX, currentY );
					sshape.alpha = 0.2;
					break;

					// 放开鼠标
				case MouseEvent.MOUSE_UP :
					trace( "绘制图形完成！" );
					maxX = eve.stageX;
					//clearInterval(ii);
					ii = setInterval(drawx,1);
					trace("upup");
					//// 清除当前绘制的对象
					shapeSprite.removeChild(sshape);
					trace( allShapeArr.length );
					stopDraw1();
					//// 停止绘制侦听
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
					break;
			}
		}
		
		public function stopWave():void
		{
			clearInterval(ii);
		}
		/**
		 * 停止侦听，用于删除该对象前调用
		 */
		 public function stopDraw1():void
		{
			if(stage.hasEventListener( MouseEvent.MOUSE_DOWN))
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
			if(stage.hasEventListener( MouseEvent.MOUSE_MOVE ))
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
			if(stage.hasEventListener( MouseEvent.MOUSE_UP ))
			stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
		}

		override public function stopDraw():void
		{
			clearInterval(ii);
			if(stage.hasEventListener( MouseEvent.MOUSE_DOWN))
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
			if(stage.hasEventListener( MouseEvent.MOUSE_MOVE ))
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
			if(stage.hasEventListener( MouseEvent.MOUSE_UP ))
			stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
		}

	}
}