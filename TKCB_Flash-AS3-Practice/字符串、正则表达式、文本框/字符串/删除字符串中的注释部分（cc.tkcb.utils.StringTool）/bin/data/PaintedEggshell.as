/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2017 TKCB, tkcb@qq.com
 *
 *
 * This is free software/program/code: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * 这是一个自由软件/程序/代码，您可以自由分发、修改其中的源代码或者重新发布它，
 * 新的任何修改后的重新发布版必须同样在遵守LGPL3或更后续的版本协议下发布。
 * 关于LGPL协议的细则请参考COPYING、COPYING.LESSER文件，
 * 你可以在文件夹中获得LGPL协议的副本，如果没有找到，请连接到 http://www.gnu.org/licenses/ 查看。
 *
 *
 * 作　　者：TKCB
 * 作者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 作者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 *
 *
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */


/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2014-8-8
 * v1.0.1 2016-12-12 重新对整个类进行编写，大改
 * v1.0.2 2017-6-26 添加区域点击激活彩蛋的功能方法，在触摸屏上特别有用
 * v1.0.3 2017-7-11 修改了一点点小BUG
 * v1.0.4 2017-9-26 发现任何按钮点击或者其他情况引发舞台丢失焦点后，舞台监听的键盘事件会无效，所以要给舞台任意点击加上重置焦点功能
 * v2.0.0 2017-9-30 修改了舞台监听，可定义是否锁定焦点，以及将类所在包做了调整移动，放在了TKCB专属包里面，这样更合理
 * v2.1.0 2017-10-20 精简了按键switch这块的代码，让整个类看起来更简单一些
 * v2.2.0 2018-1-1 统一调整我的专属类库的黑色遮罩，为程序自动创建，这样简单很多，省的每次都调整尺寸
 */
 
package cc.tkcb.exclusive
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * PaintedEggshell 彩蛋类（软件隐藏功能），通常为显示我的个人程序名片。
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2014-8-8
	 * @修改时间 2018-1-1
	 * @version 2.2.0
	 */
	public class PaintedEggshell extends Sprite
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		//// 测试的各种特殊字符串
		private var str : String = "//";
		
		private var str2 : String = "123\"456\"789" + "123456" + "//" + "\'\'"; //123456
		
		private /***/var /***/str3 : String = '123\\\'456\\\'789' + '123456' + '//' + '""'; /*//123456*/ trace(0) /*//*123123
		
		// 下面这行实际是/*注释掉的部分，但是目前我的代码算法还是无法识别，，有待改进
		private var str4 : String = '123\\\'456\\\'789' + '123456' + '//' + '""'; //123456*/
		
		//// 主要属性
		/** 彩蛋显示对象，在彩蛋按键启动之后显示的对象 */
		private var paintedEggshellDO : DisplayObject;	//萨达撒大所多
		
		/** 彩蛋持续时间（彩蛋可以在设定的时间内才会有效果） */
		private var continueTimer : Timer;
		
		/** 彩蛋结束时间计时器，彩蛋出现会在一定时间内自动消失，如果将此计时器设置为很大的数字，则相当于不自动消失，但点击后仍然会消失 */
		private var endTimer : Timer;
		
		/** 彩蛋持续时间 */
		private var timeContinue : Number;
		
		/** 彩蛋自动消失时间 */
		private var timeEnd : Number;
		
		/** 否只显示一次，如果为true则彩蛋只会出现一次，否则没有限制次数 */
		private var peIsDisplayOnce : Boolean;
		
		/** 彩蛋是否正在显示，如果是则不在触发彩蛋 */
		private var displayState : Boolean = false;
		
		/** 是否锁定舞台焦点，这样保证永远能监听到键盘事件 */
		private var stageFocus : Boolean = true;
		
		
		//// 键盘按键相关
		/** 正确的彩蛋按键字符串数组（连续按下数组中任意一串按键即可激活彩蛋），支持0-9、A-Z（字母统一使用大写，不支持大小写区分）、* + Enter - . / ← ↑ → ↓ F1-F15 */
		private var peKeyboardArr : Array;
		
		/** 当前按下的连续按键，用于记录当前按下的按键字符串 */
		private var cuttentKeyboard : String = "";
		
		/** 连续按键时间计时器，键盘每两次按键之间间隔时间如果大于该计时器设定时间，则删除记录的连续按键字符串 */
		private var keyTimer : Timer;
		
		/** 所有键盘按键的数组集合，用于简化按键字符串获取的代码 */
		private var keyCodeArr = [  48,  96,  49,  97,  50,  98,  51,  99,  52, 100,  53, 101,  54, 102,  55, 103,  56, 104,  57, 105, 
									65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,
									106, 107,  108,    109, 110, 111,  34,   38,  39,   40,
									112,  113,  114,  115,  116,  117,  118,  119,  120,  121,   122,   123,   124,   125,   126 ];
		
		/** 键盘按键对应的字符（字符串）数组，用于简化按键字符串获取的代码 */
		private var keyCharArr = [ "0", "0", "1", "1", "2", "2", "3", "3", "4", "4", "5", "5", "6", "6", "7", "7", "8", "8", "9", "9", 
								   "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
								   "*",  "+", "Enter", "-", ".", "/", "←", "↑", "→", "↓",
								   "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15" ];
		
		
		//// 触摸点击相关
		/** 正确的触摸区域序列，可以定义数个连续的矩形点击区域，连续点击正确则激活彩蛋，目前只可以为一个彩蛋定义一组触摸区域序列 */
		private var peTouchArr : Array;
		
		/** 当前舞台点击的连续区域，用于记录当前舞台天机的连续区域 */
		private var cuttentTouchArr : Array;
		
		/** 连续点击时间计时器，舞台每两次点击之间间隔时间如果大于该计时器设定时间，则删除记录的连续舞台点击区域数组 */
		private var touchTimer : Timer;
		
		
		//// 黑色遮罩
		/* 黑色遮罩 */
		private var blackMask : Sprite;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 * @param peDisplayObject 彩蛋显示对象，在键盘或者触摸正确时会显示这个彩蛋对象
		 * @param isDisplayOnce 是否只显示一次，如果为true则彩蛋只会出现一次，否则没有限制次数
		 * @param hideTime 彩蛋自动消失时间（彩蛋可以在设定的时间内才会有效果），默认为999999999（毫秒）
		 * @param continueTime 彩蛋持续时间，彩蛋出现会在一定时间内自动消失，如果将此计时器设置为很大的数字，则相当于不自动消失，但点击后仍然会消失
		 * @param stageFocus 是否锁定舞台焦点，这样保证永远能监听到键盘事件
		 */
		public function PaintedEggshell ( peDisplayObject:DisplayObject, isDisplayOnce:Boolean = false, hideTime:Number = 999999999, continueTime:Number = 999999999, stageFocus:Boolean = true )
		{
			paintedEggshellDO = peDisplayObject;
			
			peIsDisplayOnce = isDisplayOnce;
			timeEnd = hideTime;
			timeContinue = continueTime;
			
			this.stageFocus = stageFocus;
			
			// 如果需要一直持续存在彩蛋，则应使用默认参数 999999999
			continueTimer = new Timer( timeContinue, 1 );
			continueTimer.addEventListener( TimerEvent.TIMER_COMPLETE, continueTimerComplete );
			continueTimer.start();
			
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			

			// 特殊情况1
			this[ "str1" ] = "//" + "/**/";	// /* */

			// 特殊情况2
			this[ "str2" ] = "//" + "/**/";	/*//
			*/

			trace( this[ "str2" ] );
		}
		
		
		//************************ ************************* 公开方法（激活键盘、激活触摸） ******************** *********** *** **////
		/**
		 * 激活键盘彩蛋触发器，可设置多个激活此彩蛋的字符串，此方法必须在对象添加到显示列表之前调用
		 * @param keyboardArr 正确的彩蛋按键字符串数组，支持0-9、A-Z（字母统一使用大写，不支持大小写区分）、* + Enter - . / ← ↑ → ↓ F1-F15
		 */
		public function activateKeyboard ( keyboardArr:Array ) : void
		{
			peKeyboardArr = keyboardArr;
		}
		
		/**
		 * 激活触摸彩蛋触发器，按照顺序定义触摸区域（X左值，X右值，Y上值，Y下值），此方法必须在对象添加到显示列表之前调用
		 * @param touchArr 正确的触摸区域序列，可以定义数个连续的矩形点击区域，连续点击正确则激活彩蛋，目前只可以为一个彩蛋定义一组触摸区域序列
		 */
		public function activateTouch ( touchArr:Array ) : void
		{
			peTouchArr = touchArr;
			cuttentTouchArr = []; 
		}
		
		
		
		//************************ ************************* 初始化 ******************** *********** *** **////
		/**
		 * 对象被添加到舞台
		 */
		private function addedToStage ( eve:Event ) : void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			// 全局侦听键盘
			if ( peKeyboardArr != null )
			{
				stage.focus = stage;
				stage.addEventListener( KeyboardEvent.KEY_UP, stageKeyDown );
				
				// 重置焦点，让舞台侦听永远有效
				if ( stageFocus )
				{
					stage.addEventListener( MouseEvent.CLICK, stageClickFocus );
					stage.addEventListener( FocusEvent.FOCUS_OUT, stageFocusOut );
				}
			}
			
			// 全局监听舞台
			if ( peTouchArr != null )
			{
				stage.addEventListener( MouseEvent.CLICK, stageClick );
			}
			
			// 黑色遮罩
			blackMask = new Sprite();
			blackMask.graphics.beginFill( 0x000000, 0.25 );
			blackMask.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			blackMask.graphics.endFill();
			
			// 重新调整相对位置
			paintedEggshellDO.x = stage.stageWidth / 2 - paintedEggshellDO.width / 2;
			paintedEggshellDO.y = stage.stageHeight / 2 - paintedEggshellDO.height / 2;
		}
		
		//************************ ************************* 键盘相关 ******************** *********** *** **////
		/**
		 * 任意舞台对象被点击，重置焦点，让舞台侦听永远有效
		 */
		private function stageClickFocus ( eve:MouseEvent ) : void
		{
			stage.focus = stage;
		}
		
		/**
		 * 焦点丢失，重置焦点，让舞台侦听永远有效
		 */
		private function stageFocusOut ( eve:FocusEvent ) : void
		{
			stage.focus = stage;
		}
		
		/**
		 * 键盘按键被按下，记录按键字符串，判断是否激活彩蛋，启动连续按键时间计时器
		 */
		private function stageKeyDown ( eve:KeyboardEvent ) : void
		{
			// 彩蛋没有显示
			if ( displayState == false )
			{
				// 记录连续按键，简化了之前的switch结构，因为实在代码太长了
				var index : int = keyCodeArr.indexOf( eve.keyCode );
				if ( index != -1 )
				{
					cuttentKeyboard += keyCharArr[ index ];
				}
				else
				{
					cuttentKeyboard += ".";
				}
				//trace( "按键字符串：" + cuttentKeyboard );
				
				// 判断是否连续按键正确，如果连续按键正确则激活彩蛋效果
				var i:int, len:int = peKeyboardArr.length;
				for ( i = 0; i < len; i++ )
				{
					if ( cuttentKeyboard == peKeyboardArr[ i ] )
					{
						jhPaintedEggshell();
						break;
					}
				}
				
				// 启动连续按键时间计时器
				setKeyTimer();
			}
		}
		
		/**
		 * 连续按键时间，间隔时间到期后删除记录的按键字符串
		 */
		private function setKeyTimer () : void
		{
			//// 重新启动连续按键时间计时器
			if ( keyTimer != null )
			{
				keyTimer.stop();
				keyTimer.removeEventListener( TimerEvent.TIMER, keyTimerTime );
				keyTimer = null;
			}
			keyTimer = new Timer( 2000, 1 );		//////////////////////////////// 此参数可以修改 //////////
			keyTimer.addEventListener( TimerEvent.TIMER, keyTimerTime );
			keyTimer.start();
		}
		
		/**
		 * 连续按键时间，间隔时间到期，则清除记录的按键字符串
		 */
		private function keyTimerTime ( eve:TimerEvent ) : void
		{
			cuttentKeyboard = "";
			//trace( "清除记录的按键字符串!!!" );
		}
		
		
		//************************ ************************* 触摸相关 ******************** *********** *** **////
		/**
		 * 舞台被点击（触摸），记录按键字符串，判断是否激活彩蛋，启动连续按键时间计时器
		 */
		private function stageClick ( eve:MouseEvent ) : void
		{
			// 彩蛋没有显示
			if ( displayState == false )
			{
				//// 记录连续点击舞台坐标
				cuttentTouchArr.push( [eve.stageX, eve.stageY] );
				//trace( "舞台坐标：" + eve.stageX, eve.stageY );
				
				//// 判断是否连续点击正确，如果连续点击正确则激活彩蛋效果
				if ( cuttentTouchArr.length >= peTouchArr.length )
				{
					var booX : Boolean = false;
					var booY : Boolean = false;
					var i:int, len:int = peTouchArr.length;
					for ( i = 0; i < len; i++ )
					{
						booX = cuttentTouchArr[i][0] > peTouchArr[i][0] && cuttentTouchArr[i][0] < peTouchArr[i][1];
						booY = cuttentTouchArr[i][1] > peTouchArr[i][2] && cuttentTouchArr[i][1] < peTouchArr[i][3];
						if ( booX && booY && (i+1) == len )
						{
							jhPaintedEggshell();
							break;
						}
						else if ( booX == false || booY == false )
						{
							break;
						}
					}
				}
				
				// 启动连续点击时间计时器
				setTouchTimer();
			}
		}
		
		/**
		 * 连续点击时间，间隔时间到期后删除记录的点击区域数组
		 */
		private function setTouchTimer () : void
		{
			//// 重新启动连续点击时间计时器
			if ( touchTimer != null )
			{
				touchTimer.stop();
				touchTimer.removeEventListener( TimerEvent.TIMER, touchTimerTime );
				touchTimer = null;
			}
			touchTimer = new Timer( 2000, 1 );		//////////////////////////////// 此参数可以修改 //////////
			touchTimer.addEventListener( TimerEvent.TIMER, touchTimerTime );
			touchTimer.start();
		}
		
		/**
		 * 连续点击时间，间隔时间到期，则清除记录的点击区域数组
		 */
		private function touchTimerTime ( eve:TimerEvent ) : void
		{
			cuttentTouchArr = [];
			//trace( "清除记录的点击区域数组!!!" );
		}
		
		
		//************************ ************************* 彩蛋相关 ******************** *********** *** **////
		/**
		 * 激活彩蛋效果
		 */
		private function jhPaintedEggshell () : void
		{
			displayState = true;
			
			blackMask.alpha = 0;
			blackMask.addEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			stage.addChild( blackMask );
			
			paintedEggshellDO.alpha = 0;
			paintedEggshellDO.addEventListener( Event.ENTER_FRAME, drPaintedEggshell );
			paintedEggshellDO.addEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			stage.addChild( paintedEggshellDO );
				
			setEndTimer();
		}
		
		/**
		 * 彩蛋淡入效果，彩蛋激活
		 */
		private function drPaintedEggshell ( eve:Event ) : void
		{
			if ( paintedEggshellDO.alpha < 1 )
			{
				blackMask.alpha += 0.05;				//////////////////////////////// 此参数可以修改 //////////
				paintedEggshellDO.alpha += 0.05;		//////////////////////////////// 此参数可以修改 //////////
			}
			else
			{
				blackMask.alpha = 1;
				paintedEggshellDO.alpha = 1;
				paintedEggshellDO.removeEventListener( Event.ENTER_FRAME, drPaintedEggshell );
			}
		}
		
		/**
		 * 彩蛋淡出效果，彩蛋关闭
		 */
		private function dcPaintedEggshell ( eve:Event ) : void
		{
			if ( paintedEggshellDO.alpha > 0 )
			{
				blackMask.alpha -= 0.05;				//////////////////////////////// 此参数可以修改 //////////
				paintedEggshellDO.alpha -= 0.05;		//////////////////////////////// 此参数可以修改 //////////
			}
			else
			{
				blackMask.alpha = 0;
				paintedEggshellDO.alpha = 0;
				paintedEggshellDO.removeEventListener( Event.ENTER_FRAME, dcPaintedEggshell );
				
				closePaintedEggshell();
			}
		}
		
		/**
		 * 彩蛋被点击，则关闭彩蛋
		 */
		private function paintedEggshellDOMouse ( eve:MouseEvent ) : void
		{
			blackMask.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			paintedEggshellDO.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			
			paintedEggshellDO.removeEventListener( Event.ENTER_FRAME, drPaintedEggshell );
			if ( endTimer != null )
			{
				endTimer.stop();
				endTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, endTimerComplete );
				endTimer = null;
			}
			
			paintedEggshellDO.addEventListener( Event.ENTER_FRAME, dcPaintedEggshell );
		}
		
		/**
		 * 设置彩蛋激活后的持续时间，持续时间结束后自动消失
		 */
		private function setEndTimer () : void
		{
			endTimer = new Timer( timeEnd, 1 );
			endTimer.addEventListener( TimerEvent.TIMER_COMPLETE, endTimerComplete );
			endTimer.start();
		}
		
		/**
		 * 彩蛋持续时间结束，则关闭彩蛋
		 */
		private function endTimerComplete ( eve:TimerEvent ) : void
		{
			blackMask.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			paintedEggshellDO.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			
			paintedEggshellDO.addEventListener( Event.ENTER_FRAME, dcPaintedEggshell );
		}
		
		/**
		 * 关闭彩蛋
		 */
		private function closePaintedEggshell () : void
		{
			displayState = false;
			
			if ( endTimer != null )
			{
				endTimer.stop();
				endTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, endTimerComplete );
				endTimer = null;
			}
			
			blackMask.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			paintedEggshellDO.removeEventListener( MouseEvent.CLICK, paintedEggshellDOMouse );
			
			stage.removeChild( blackMask );
			stage.removeChild( paintedEggshellDO );
			
			// 如果彩蛋只出现一次
			if ( peIsDisplayOnce )
			{
				continueTimerComplete( null );
			}
		}
		
		
		/**
		 * 如果彩蛋持续时间结束，则关闭彩蛋（此彩蛋无法被人激活）
		 */
		private function continueTimerComplete ( eve:TimerEvent ) : void
		{
			stage.removeEventListener( KeyboardEvent.KEY_UP, stageKeyDown );
			stage.removeEventListener( MouseEvent.CLICK, stageClick );
			
			if ( continueTimer != null )
			{
				continueTimer.stop();
				continueTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, continueTimerComplete );
				continueTimer = null;
			}
			
			if ( keyTimer != null )
			{
				keyTimer.stop();
				keyTimer.removeEventListener( TimerEvent.TIMER, keyTimerTime );
				keyTimer = null;
			}
			
			if ( touchTimer != null )
			{
				touchTimer.stop();
				touchTimer.removeEventListener( TimerEvent.TIMER, touchTimerTime );
				touchTimer = null;
			}
			
			// 其他关闭代码
		}
		
		
	}
}


