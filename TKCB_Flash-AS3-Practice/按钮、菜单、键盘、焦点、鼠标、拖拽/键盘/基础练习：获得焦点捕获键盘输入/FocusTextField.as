package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * FocusTextField 类用于获取按键信息，当按下【Shift】键时改变文本框颜色
	 * @author TKCB
	 * Creation date 2012-07-11
	 * Modified by ...
	 * Modified date ...
	 */
	public class FocusTextField extends Sprite
	{
		/**
		 * 用于输入控制的文本
		 */
		private var tf:TextField ;
		
		// ———————————————————— 属性、方法分割线 ————————————————————
		
		/**
		* 构造函数
		*/
		public function FocusTextField()
		{
			// 下面代码用于设置文本框属性
			tf = new TextField();
			tf.x = 100;
			tf.y = 100;
			// 文本边框属性
			tf.border = true;
			tf.type = "input"
			tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			tf.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			addChild(tf);
		}
		
		/**
		 * 侦听器，用于输出按键信息
		 */
		private function keyDownHandler(eve:KeyboardEvent):void
		{
			trace("按下的键的信息——↓——");
			trace("键：" +　String.fromCharCode(eve.charCode));
			trace("键控代码：" +　eve.keyCode);
			trace("字符代码：" +　eve.charCode);
			
			if(eve.keyCode == Keyboard.SHIFT)
			{
				tf.borderColor = 0xFF0000;
			}
		}
		
		/**
		 * 侦听器，用于输出按键信息
		 */
		private function keyUpHandler(eve:KeyboardEvent):void
		{
			trace("弹起的键的信息——↓——");
			trace("键：" +　String.fromCharCode(eve.charCode));
			trace("键控代码：" +　eve.keyCode);
			trace("字符代码：" +　eve.charCode);
			
			if(eve.keyCode == Keyboard.SHIFT)
			{
				tf.borderColor = 0x000000;
			}
		}
		
	}//class
}//package