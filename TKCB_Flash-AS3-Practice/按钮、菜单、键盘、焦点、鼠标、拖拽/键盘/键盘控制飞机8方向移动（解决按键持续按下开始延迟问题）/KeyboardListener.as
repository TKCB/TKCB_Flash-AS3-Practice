/*
 * 描  述：静态工具类，用于监听键盘某键是否按下
 * 作  者：TKCB
 * 创建日期：2012.01.04
 * 修改日期：2012.01.04
 */
package
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class KeyboardListener
	{
		//数组keyArr，用于记录键盘中的键是否按下
		private static var keyArr: Array = [];
		/*
		 * 方法keyListener，用于注册对键盘的侦听事件。无参数，返回值为void类型
		 * 代码1，用于注册对键盘键是否按下的侦听，侦听器为isKeyDown
		 * 代码2，用于注册对键盘键是否弹起的侦听，侦听器为isKeyup
		 */
		public static function keyListener(sta: Stage): void
		{
			sta.addEventListener(KeyboardEvent.KEY_DOWN, isKeyDown);
			sta.addEventListener(KeyboardEvent.KEY_UP, isKeyUp);
		}
		/*
		 * 方法isDown，用于判断传入参数对应的键是否按下。返回值为Boolean类型
		 * 参数key，用于记录键在数组keyArr中的索引
		 * 代码1，用于返回数组keyArr中索引为key的键是否按下
		 */
		public static function isDown(key: uint): Boolean
		{
			return keyArr[key] == true;
		}
		/*
		 * 侦听器isKeyDown，侦听事件KeyboardEvent.KEY_DOWN，用于记录传入参数对应的键是否按下。返回值为void类型
		 * 参数key，是侦听到的事件对象
		 * 代码1，使用数组keyArr记录按下的键
		 */
		private static function isKeyDown(key: KeyboardEvent): void
		{
			keyArr[key.keyCode] = true;
		}
		/*
		 * 侦听器idKeyUp，侦听事件KeyboardEvent.KEY_UP，用于记录传入参数对应的键是否弹起。返回值为void类型
		 * 参数key，是侦听到的事件对象
		 * 代码1，使用数组keyArr记录弹起的键
		 */
		private static function isKeyUp(key: KeyboardEvent): void
		{
			keyArr[key.keyCode] = [];
		}
	}
}
//一百二十列标尺********************************************************************************************************