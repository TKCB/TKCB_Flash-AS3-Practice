package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	/**
	 * XMLDirectoryExample 类，加载XML，然后根绝XML内容生成对应的目录以及控制子目录
	 * @author TKCB
	 * QQ 2414268040
	 */
	public class XMLDirectoryExample extends Sprite
	{
		private var xml:XML;					// 存放外部加载的XML文件
		private var directorySprite:Sprite;		// 目录容器
		
		/**
		 * 构造函数
		 */
		function XMLDirectoryExample()
		{
			init();
			generateDirectoryC.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		/** 变量初始化 */
		private function init():void
		{
			directorySprite = new Sprite();
			directorySprite.x = 20;
			directorySprite.y = 50;
			addChild(directorySprite);
		}
		
		/** 加载外部XML */
		private function mouseHandler(eve:MouseEvent):void
		{
			var url:String = "xml/directory.xml";
			var req:URLRequest = new URLRequest(url);
			var loa:URLLoader = new URLLoader();
			loa.addEventListener(Event.COMPLETE, loaHandler);
			loa.load(req);
		}
		
		/** 获取加载的XML */
		private function loaHandler(eve:Event):void
		{
			eve.target.removeEventListener(Event.COMPLETE, loaHandler);
			xml = new XML(eve.target.data);
			generateDirectory();
		}
		
		/** 生成目录 */
		private function generateDirectory():void
		{
			var recursionXML:XML;	// 递归XML
			var tf:TextField;
			var num1:Number = 5;	// 偏移参数
			var num2:Number = 1.5;	// 偏移参数
			var len:int = xml.chapter.length();
			for(var i:int = 0; i < len; i++)
			{
				if(xml.chapter[i].chapter.length() > 0)
				{
					recursionXML = xml.chapter[i];
				}
				trace(xml.hasOwnProperty(name));
				tf = new TextField();
				tf.text = xml.chapter[i].@name;
				tf.width = tf.textWidth + num1;
				tf.height = tf.textHeight + num1;
				tf.y = i * tf.textHeight * num2;
				//tf.border = true;
				tf.selectable = false;
				tf.addEventListener(MouseEvent.CLICK, tfMouseHandler);
				directorySprite.addChild(tf);				
			}
		}
		
		private function tfMouseHandler(eve:MouseEvent):void
		{
			trace(eve.target.text);
		}
	}
}












