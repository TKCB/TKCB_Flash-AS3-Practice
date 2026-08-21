package
{
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
	
	import flash.system.IME;
	import flash.system.System;// 静态类，只包含静态方法和属性
	import flash.events.FocusEvent;
	import flash.system.Capabilities;
	
	/**
	 * SystemExample类 进行系统级别的操作，摄像头和麦克风设置，与共享对象相关的操作和剪贴板的使用
	 * @author TKCB
	 */
	public class SystemExample extends Sprite
	{
		function SystemExample()
		{
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init()
		{
			//// 下面代码用于：获取System的属性信息
			var systemPropertiesHandler:Function = function(eve:MouseEvent):void
			{
				systemPropertiesTF.text = "分配给Player或AIR的内存量以及未使用的内存量：" + System.freeMemory + "字节";
				systemPropertiesTF.appendText("\n" + "应用程序使用的内存总量：" + System.privateMemory + "字节");
				systemPropertiesTF.appendText("\n" + "运行时正使用的由Player或AIR直接分配的内存量：" + System.totalMemory + "字节");
				systemPropertiesTF.appendText("\n" + "同上，但是由于Number类型，所以在内存量的数值大于uint时候使用：" + System.totalMemoryNumber + "字节");
				
				systemPropertiesTF.appendText("\n\r" + "当前安装的系统IME：" + System.ime);
				systemPropertiesTF.appendText("\n" + "一个布尔值，它决定使用哪个代码页来解释外部文本文件：" + System.useCodePage);
			}
			systemProperties.addEventListener(MouseEvent.CLICK, systemPropertiesHandler);
			
			//// 下面代码用于：将自定义字符串设置为剪贴板的内容
			var setClipboardHandler:Function = function(eve:MouseEvent):void
			{
				System.setClipboard(setClipboardTF1.text);
			}
			setClipboard.addEventListener(MouseEvent.CLICK, setClipboardHandler);
			
			//// 下面代码用于：设置文本框在失去和获得焦点时候的状态
			var tfFocusInHandler:Function = function(eve:FocusEvent):void
			{
				if(eve.target == setClipboardTF1)
				{
					var boo1:Boolean = setClipboardTF1.text == "自定义字符串" || setClipboardTF1.text == "自定义字符串\r" || setClipboardTF1.text.length == 0;
					if(boo1)
					{
						setClipboardTF1.text = "";
					}
				}
				else if(eve.target == setClipboardTF2)
				{
					var boo2:Boolean = setClipboardTF2.text == "此文本框可测试剪贴板中的内容是否为自定义" || setClipboardTF2.text == "此文本框可测试剪贴板中的内容是否为自定义\r" || setClipboardTF2.text.length == 0;
					if(boo2)
					{
						setClipboardTF2.text = "";
					}
				}
			}
			var tfFocusOutHandler:Function = function(eve:FocusEvent):void
			{
				if(eve.target.text.length == 0)
				{
					if(eve.target == setClipboardTF1)
					{
						setClipboardTF1.text = "自定义字符串";
					}
					else if(eve.target == setClipboardTF2)
					{
						setClipboardTF2.text = "此文本框可测试剪贴板中的内容是否为自定义";
					}
				}
			}
			setClipboardTF1.addEventListener(FocusEvent.FOCUS_IN, tfFocusInHandler);
			setClipboardTF1.addEventListener(FocusEvent.FOCUS_OUT, tfFocusOutHandler);
			setClipboardTF2.addEventListener(FocusEvent.FOCUS_IN, tfFocusInHandler);
			setClipboardTF2.addEventListener(FocusEvent.FOCUS_OUT, tfFocusOutHandler);
			
			//// 下面代码用于：获取当前的Flsah Player的版本
			var flashPlayerHandler:Function = function(eve:MouseEvent):void
			{
				var versionString:String = Capabilities.version;
				var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
				var result:Object = pattern.exec(versionString);
				if (result != null)
				{
					flashPlayerTF.text = "";
					flashPlayerTF.appendText("input: " + result.input);
					flashPlayerTF.appendText("\n" + "platform: " + result[1]);
					flashPlayerTF.appendText("\n" + "majorVersion: " + result[2]);
					flashPlayerTF.appendText("\n" + "minorVersion: " + result[3]);
					flashPlayerTF.appendText("\n" + "buildNumber: " + result[4]);
					flashPlayerTF.appendText("\n" + "internalBuildNumber: " + result[5]);
				}
				else
				{
					trace("Unable to match RegExp.");
				}
				
			}
			flashPlayer.addEventListener(MouseEvent.CLICK, flashPlayerHandler);
			
			exit.addEventListener(MouseEvent.CLICK, exitHandler);
		}
		
		/** 关闭Flash Player */
		private function exitHandler(eve:MouseEvent):void
		{
			System.exit(0);
		}
		
	}
}






