package display
{
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	
	/**
	 * CustomDisplay 类，自定义的显示对象类，用于存放目录子元素
	 * @author TKCB
	 * QQ 2414268040
	 */
	public class CustomDisplay extends Sprite
	{
		/** 当前目录XML */
		public var currentDisplay:XML;
		/** 当前目录文本 */
		public var tf:TextField;
		
		/** 目录对象数组 */
		private var directory:Array;
		
		/**
		 * 构造函数
		 */
		function CustomDisplay()
		{
			init();
			generateDirectoryC.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		/** 变量初始化 */
		private function init():void
		{
			currentDisplay = null;
			directory = new Array();
		}
		/**
		 * 根据传入的xml参数创建目录
		 * @param 
		 */
		public function newDisplay(xml:XML):void
		{
			if(xml.hasOwnProperty(name) == true)
			{
				/// 设置自身属性
				currentDisplay = xml;
				var num1:Number = 5;	// 偏移参数
				var num2:Number = 1.5;	// 偏移参数
				tf = new TextField();
				tf.text = xml.@name;
				tf.width = tf.textWidth + num1;
				tf.height = tf.textHeight + num1;
				tf.selectable = false;
				tf.addEventListener(MouseEvent.CLICK, tfMouseHandler);
				addChild(tf);
			}else{
				tfMouseHandler(null);
			}
		}
		/** 创建子目录 */
		private function tfMouseHandler(eve:MouseEvent = null):void
		{
			var len:int = currentDisplay.chapter.length();
			if(len > 0)
			{
				for(var i:int = 0; i < len; i++)
				{
					var c:CustomDisplay = new CustomDisplay();
					c.newDisplay(currentDisplay.chapter[i]);
					directory[i] = c;
				}
			}
		}
		/** 设置子目录位置 */
		private function tfMouseHandler(arr:Array):void
		{
			var len:int = arr.length;
			if(len > 0)
			{
				if()
				{
					
				}
				for(var i:int = 0; i < len; i++)
				{
					arr
				}
				var len2:int = currentDisplay.chapter.length();
			}
			
		}
	}
}













