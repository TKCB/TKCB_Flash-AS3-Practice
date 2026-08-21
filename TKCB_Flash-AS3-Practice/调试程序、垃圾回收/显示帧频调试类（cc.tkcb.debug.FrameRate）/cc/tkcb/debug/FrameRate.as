/**
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright TKCB-Gm, www.tkcb.cc
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
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */


/**
 * @version 版本创建时间和修改说明
 * v1.0.0 未知
 * v1.0.1 2017-7-1 修改部分代码格式，统一使用我最新的代码格式，以及添加LGPL协议
 */
package cc.tkcb.debug
{
	import flash.display.Sprite;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.utils.Timer;
	
	
	/**
	 * FrameRate 显示Flash Player的帧频（FPS）的调试类，大小为50*50的方块，可以设置文字、背景、线条颜色、透明度等属性。
	 */
	public class FrameRate extends Sprite
	{
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		/// 文本
		private var tf:TextField;
		private var tformat:TextFormat;
		
		/// 线形图
		private var graph:Sprite;
		private var graphBox:Sprite;
		private var graphCounter:uint;
		private var graphColor:uint;
		
		/// 用于更新显示的计时器
		private var timer:Timer;
		
		/// 计数
		private var count:uint = 0;
		
		
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		/**
		 * 初始化FrameRate对象，并设置背景、文字、线形图属性。
		 * @param background 是否显示背景（底色），默认为true。
		 * @param backgroundColor 背景（底色）颜色，默认为黑色。
		 * @param backgroundAlpha 背景（底色）透明度，默认为0.5。
		 * @param textColor 文字颜色，默认为白色。
		 * @param graphColor_ 线形图颜色，默认为红色。
		 */
		public function FrameRate(background:Boolean = true, backgroundColor:uint = 0x000000, backgroundAlpha:Number = 0.5, textColor:uint = 0xFFFFFF, graphColor_:uint = 0xFF0000)
		{
			/// 设置不可交互，提高效率，减少内存使用
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			/// 设置背景（底色）
			if (background)
			{
				this.graphics.beginFill(backgroundColor, backgroundAlpha);
				this.graphics.drawRect(0, 0, 50, 50);
				this.graphics.endFill();
			}
			
			/// 设置文字
			tformat = new TextFormat();
			tformat.color = textColor;
			tformat.font = "_sans";
			tformat.size = 11;
			tf = new TextField  ;
			tf.width = 100;
			tf.height = 20;
			tf.x = 3;
			tf.y = 3;
			addChild(tf);
			
			/// 设置线形图
			graphColor = graphColor_;
			initGraph();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		
		// ************************ ************************* 方法 ******************** *********** *** ** ** //
		/**
		 * 初始化线形图设置
		 */
		private function initGraph () : void
		{
			graphCounter = 0;
			graph = new Sprite();
			graphBox = new Sprite();
			graphBox.graphics.beginFill(0xFF0000);
			graphBox.graphics.drawRect(0, 0, 36, 50);
			graphBox.graphics.endFill();
			graph.mask = graphBox;
			graph.x = graphBox.x = 5;
			graph.y = graphBox.y = 25;
			graph.graphics.lineStyle(1, graphColor);

			addChild(graph);
			addChild(graphBox);
		}
		
		/**
		 * 帧频计数
		 */
		private function onFrame ( eve:Event ) : void
		{
			count++;
		}
		
		/**
		 * 更新显示帧频信息
		 */
		private function onTimer ( eve:TimerEvent ) : void
		{
			var num:Number = count * 2 - 1;
			count = 0;
			tf.text = "FPS " + Math.floor(num).toString();
			tf.setTextFormat(tformat);
			tf.autoSize = "left";
			
			if (graphCounter > 30)
			{
				graph.x--;
			}
			graphCounter++;
			graph.graphics.lineTo(graphCounter, 1 + stage.frameRate - num / 3);
		}
	}
}