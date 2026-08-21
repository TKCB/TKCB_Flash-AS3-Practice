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
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	
	/**
	 * 文字类，用于输入文字
	 */
	public class Text extends GraphicFill
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 当前坐标X，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentX : Number;
		
		/** 当前坐标Y，用于记录绘制的每一次绘制直线的开始点坐标 */
		private var currentY : Number;
		
		/** 文本格式 */
		private var textFormat : TextFormat;
		
		/** 文本框 */
		private var textField : TextField;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function Text ()
		{
			init();
			
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 初始化 */
		private function init () : void
		{
			isLine = true;
			
			lineSize = 1;
			
			lineColor = 0x000000;
			
			lineAlpha = 1;
			
			isFill = true;
			
			fillColor = 0xFFFFFF;
			
			fillAlpha = 1;
			
			shapeArr = [];
		}
		
		/** 对象被添加到舞台 */
		private function addedToStage ( eve : Event ) : void
		{
			shapeSprite["shapeBackground"].addEventListener( MouseEvent.CLICK, stageMouse );
		}
		
		/** 鼠标绘制 */
		private function stageMouse ( eve : MouseEvent ) : void
		{
			switch ( eve.type )
			{
				// 放开鼠标
				case MouseEvent.CLICK:
					// 文本格式
					textFormat = new TextFormat();
					textFormat.bold = true;// 粗体，默认为false
					textFormat.color = lineColor;
					if ( lineSize == 2 )
					{
						textFormat.size = 15;
					}
					else if ( lineSize == 5 )
					{
						textFormat.size = 20;
					}
					else if ( lineSize == 10 )
					{
						textFormat.size = 30;
					}
					else if ( lineSize == 15 )
					{
						textFormat.size = 40;
					}
					else if ( lineSize == 25 )
					{
						textFormat.size = 60;
					}
					// 文本框
					textField = new TextField();
					textField.defaultTextFormat = textFormat;
					textField.type = TextFieldType.INPUT;// 输入文本框，默认值为TextFieldType.DYNAMIC
					textField.embedFonts = false;
					textField.text = "|";
					this.stage.focus = textField;
					textField.width = 100;
					textField.height = textField.textHeight + 5;
					textField.x = eve.stageX;
					textField.y = eve.stageY;
					// 处理文本框输入事件
					textField.addEventListener(Event.CHANGE, changeHandler);
					
					
					shapeSprite.addChild( textField );
					shapeArr.push( textField );
					allShapeArr.push( textField );
					break;
			}
		}
		
		/**
		 * 输入完成后，删除默认输入的字符，并自动调整文本框长度
		 */
		private function changeHandler ( eve:Event ) : void
		{
			if ( textField.text.length > 1 && textField.text.charAt(textField.text.length-1) == "|" )
			{
				textField.text = textField.text.slice(0, textField.text.length-1);
			}
			textField.width = textField.textWidth + 50;
			textField.scrollH = 0;
		}
		
		/**
		 * 停止侦听，用于删除该对象前调用
		 */
		override public function stopDraw () : void
		{
			shapeSprite["shapeBackground"].removeEventListener( MouseEvent.CLICK, stageMouse );
			textField.removeEventListener(Event.CHANGE, changeHandler);
		}
		
	}
}
