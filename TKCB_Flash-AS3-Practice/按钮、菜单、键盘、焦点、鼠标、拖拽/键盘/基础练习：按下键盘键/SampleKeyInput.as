//这个是殿堂之路140页的例子

package 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;

	public class SampleKeyInput extends Sprite
	{
		private var _input:TextField;

		public function SampleKeyInput()
		{
			_input = new TextField  ;
			_input.border = true;
			_input.type = "input";

			var container:Sprite = new Sprite  ;
			container.addChild(_input);
			addChild(container);

			container.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);    //动态文本框发送事件，Sprie监听键盘
			//stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);    //这个是全局监听键盘
		}

		private function keyHandler(eve:KeyboardEvent):void
		{
			trace("按键：" + String.fromCharCode(eve.charCode) + "\t字符值：" + eve.charCode + "\t键控值：" + eve.keyCode);
		}
	}
}