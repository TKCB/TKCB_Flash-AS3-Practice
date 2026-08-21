// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Nm（TKCB乐队队长）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc
// 11RIA 闪客社区：www.11ria.com



// ************************ ************************* 请开始你的表演 ******************** *********** *** ** ** //
package 
{
	// 系统类库
	import flash.display.*;
	import flash.events.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Scene;
	
	/**
	 * ...
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class MovieClipScene extends MovieClip 
	{
		private var tf:TextField;		// 显示场景相关数据
		
		/**
		 * 构造函数
		 */
		function MovieClipScene() {
			tf = new TextField();
			tf.border = true;
			tf.multiline = true;		// 是否多行文本字段
			tf.wordWrap = true;			// 是否自动换行
			tf.width = 500;
			tf.height = 70;
			tf.x = 25;
			tf.y = 40;
			addChild(tf);
			
			addEventListener(Event.ENTER_FRAME, ef);;
		}
		
		/** 显示场景相关 */
		private function ef(eve:Event):void {
			tf.text = "当前帧：" + String(currentFrame) + "\t总帧数：" + String(totalFrames);
			var len:uint = this.scenes.length;
			for (var i:uint = 0 ; i < len; i++) {
				var sce:Scene = scenes[i];
				tf.appendText("\n当前场景名称：" + sce.name + "\t当前场景总帧数：" + sce.numFrames);
			}
			
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, ef);;
				this.stop();
				trace("影片播放结束！！！");
			}
		}
		
	}
	
}