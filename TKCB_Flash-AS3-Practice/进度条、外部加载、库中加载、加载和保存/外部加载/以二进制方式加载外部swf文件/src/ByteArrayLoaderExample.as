package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	import flash.utils.ByteArray;
	
	import com.oaxoa.components.FrameRater;
	
	/**
	 * ByteArrayLoaderExample 类，使用二进制形式加载外部swf资源，并使用Loader类读取二进制
	 * @author TKCB
	 */
	public class ByteArrayLoaderExample extends Sprite
	{
		private var req:URLRequest;
		private var loa:URLLoader;
		
		private var byteArray:ByteArray;// 存储加载的二进制资源
		
		private var num:uint;// 记录数量
		
		function ByteArrayLoaderExample()
		{
			num = 0;
			
			/// 以二进制形式加载外部资源
			req = new URLRequest("swf/Animation.swf");
			loa = new URLLoader();
			loa.dataFormat = URLLoaderDataFormat.BINARY;
			loa.addEventListener(Event.COMPLETE, loaHandler);
			try
			{
				trace("开始加载外部资源");
				loa.load(req);
			}
			catch(err:Error)
			{
				trace("错误异常：" + err);
			}
			
			
			var fr:FrameRater=new FrameRater(0x000000, true);
			fr.x = 50;
			fr.y = 50;
			addChild(fr);
		}
		
		/**
		 * 侦听器，以二进制形式加载外部资源
		 */
		private function loaHandler(eve:Event):void
		{
			trace("加载完成");
			
			byteArray = eve.target.data as ByteArray;
			
			for(var i:int = 0; i < 50; i++)
			{
				var loader:Loader = new Loader();
				var spr:Sprite;
				var loaderHandler:Function = function(eve:Event):void
				{
					num++;
					trace(num);
					
					spr = eve.target.loader.content as Sprite;
					addChild(spr);
					spr.x = Math.random() * 150;
					spr.y = Math.random() * 150;
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler);
				loader.loadBytes(byteArray);
			}
			
			
			loaderByteArray.addEventListener(MouseEvent.CLICK, loaderByteArrayHandler);
		}
		
		/**
		 * 侦听器，从内存中加载swf
		 */
		private function loaderByteArrayHandler(eve:MouseEvent):void
		{
			for(var i:int = 0; i < 50; i++)
			{
				var loader:Loader = new Loader();
				var spr:Sprite;
				var loaderHandler:Function = function(eve:Event):void
				{
					num++;
					trace(num);
					
					spr = eve.target.loader.content as Sprite;
					addChild(spr);
					spr.x = Math.random() * 150;
					spr.y = Math.random() * 150;
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler);
				loader.loadBytes(byteArray);
			}
			
		}
		
	}
}