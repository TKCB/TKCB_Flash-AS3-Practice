package 
{
	import flash.display.Sprite;
	import flash.display.Screen;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.KeyboardEvent;
	
	import flash.ui.Keyboard;
	
	/**
	 * KeyboardScreenExample 类，使用方向键控制程序所在屏幕
	 * @author TKCB
	 * QQ 2414268040
	 */
	public class KeyboardScreenExample extends Sprite
	{
		/**
		 * 构造函数
		 */
		function KeyboardScreenExample()
		{
			stage.align = StageAlign.TOP_LEFT;				// 指定舞台在 Flash Player 或浏览器中的对齐方式，顶对齐 左对齐
			stage.scaleMode = StageScaleMode.NO_SCALE;		// 指定缩放模式，无缩放模式
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		/**
		 * 侦听器，移动此程序到另一个屏幕
		 */
		private function onKey(event:KeyboardEvent):void
		{
			// 如果屏幕数量大于1
			if (Screen.screens.length > 1)
			{
				switch (event.keyCode)
				{
					// 左
					case Keyboard.LEFT:
						moveLeft();
						break;
					// 右
					case Keyboard.RIGHT:
						moveRight();
						break;
					// 上
					case Keyboard.UP:
						moveUp();
						break;
					// 下
					case Keyboard.DOWN:
						moveDown();
						break;
				}
			}
		}
		
		/**
		 * 左，设置此程序的坐标位置
		 */
		private function moveLeft():void
		{
			var currentScreen = getCurrentScreen();		// 获取当前主屏幕对象
			
			var left:Array = Screen.screens;	// 获取当前可用的屏幕对象数组
			left.sort(sortHorizontal);			// 使用自定义的函数进行排序，横向排序，从小到大
			
			for (var i:int = 0; i < left.length - 1; i++)
			{
				// 如果屏幕对象i的“屏幕的范围矩形”左上角的X坐标 小于 此舞台的NativeWindow对象的“屏幕的范围矩形”左上角的X坐标
				if (left[i].bounds.left < stage.nativeWindow.bounds.left)
				{
					// 此舞台的NativeWindow对象的X轴，加上，屏幕对象i的“屏幕的范围矩形”左上角的X坐标 减去 当前主屏幕对象的“屏幕的范围矩形”左上角的X坐标
					stage.nativeWindow.x += left[i].bounds.left - currentScreen.bounds.left;
					// 注释类似上面上
					stage.nativeWindow.y +=  left[i].bounds.top - currentScreen.bounds.top;
				}
			}
		}
		
		/**
		 * 右，注释类似上面上
		 */
		private function moveRight():void
		{
			var currentScreen:Screen = getCurrentScreen();
			
			var left:Array = Screen.screens;
			left.sort(sortHorizontal);
			
			for (var i:int = left.length - 1; i > 0; i--)
			{
				if (left[i].bounds.left > stage.nativeWindow.bounds.left)
				{
					stage.nativeWindow.x += left[i].bounds.left - currentScreen.bounds.left;
					stage.nativeWindow.y +=  left[i].bounds.top - currentScreen.bounds.top;
				}
			}
		}
		
		/**
		 * 上，注释类似上面上
		 */
		private function moveUp():void
		{
			var currentScreen:Screen = getCurrentScreen();
			
			var top:Array = Screen.screens;
			top.sort(sortVertical);
			
			for (var i:int = 0; i < top.length - 1; i++)
			{
				if (top[i].bounds.top < stage.nativeWindow.bounds.top)
				{
					stage.nativeWindow.x +=  top[i].bounds.left - currentScreen.bounds.left;
					stage.nativeWindow.y +=  top[i].bounds.top - currentScreen.bounds.top;
					break;
				}
			}
		}
		
		/**
		 * 下，注释类似上面上
		 */
		private function moveDown():void
		{
			var currentScreen:Screen = getCurrentScreen();
			
			var top:Array = Screen.screens;
			top.sort(sortVertical);
			
			for (var i:int = top.length - 1; i > 0; i--)
			{
				if (top[i].bounds.top > stage.nativeWindow.bounds.top)
				{
					stage.nativeWindow.x +=  top[i].bounds.left - currentScreen.bounds.left;
					stage.nativeWindow.y +=  top[i].bounds.top - currentScreen.bounds.top;
					break;
				}
			}
		}
		
		/**
		 * 获取当前主屏幕对象，无法直接实例化 Screen 类。调用 new Screen() 构造函数将引发 ArgumentError 异常
		 */
		private function getCurrentScreen():Screen
		{
			var current:Screen;
			
			// 将此舞台的NativeWindow对象 传入 getScreensForRectangle()方法中，
			// 然后返回与本程序相交的屏幕对象数组（通常此程序相交的屏幕对象仅为1）
			var screens:Array = Screen.getScreensForRectangle(stage.nativeWindow.bounds);
			
			// 如果相交的屏幕对象数量大于0，则获取第一个相交的屏幕对象，否则获取主屏幕对象
			(screens.length > 0) ? current = screens[0] : current = Screen.mainScreen;
			
			return current;
		}
		
		/**
		 * 根据X坐标自定义排序，从小到大
		 */
		private function sortHorizontal(a:Screen, b:Screen):int
		{
			// 如果屏幕对象a的“屏幕的范围矩形”左上角的X坐标 大于 屏幕对象b的“屏幕的范围矩形”左上角的X坐标，则 a 排 b 后面
			if (a.bounds.left > b.bounds.left)
			{
				return 1;
			}
			// 否则，如果屏幕对象a的“屏幕的范围矩形”左上角的X坐标 小于 屏幕对象b的“屏幕的范围矩形”左上角的X坐标，则 a 排 b 前面
			else if (a.bounds.left < b.bounds.left)
			{
				return -1;
			}
			// a、b排序不分先后
			else
			{
				return 0;
			}
		}
		
		/**
		 * 根据Y坐标自定义排序，注释类似上，从小到大
		 */
		private function sortVertical(a:Screen, b:Screen):int
		{
			if (a.bounds.top > b.bounds.top)
			{
				return 1;
			}
			else if (a.bounds.top < b.bounds.top)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		
	}
}



















