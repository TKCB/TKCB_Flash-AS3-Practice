package com.tkcb.loader
{
	import flash.net.URLRequest
	import flash.net.URLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.tkcb.interfaces.IDestroy;
	
	/**
	 * XMLLoaderModel 类是xml加载模型，可方便的对xml进行加载。
	 * @langversion ActionScript 3.0
	 * @author TKCB（QQ 2414268040、E-mail tkcb@qq.com）
	 * @创建时间 2013-11-6
	 * @修改时间 2013-11-6
	 */
	public class XMLLoaderModel extends EventDispatcher implements IDestroy
	{
		/** URLLoader对象 */
		public var loader:URLLoader;
		
		/** xml对象 */
		public var xml:XML;
		
		/**
		 * 构造函数
		 * @param url 加载图片的路径地址。
		 */
		public function XMLLoaderModel(url:String) {
			xml = new XML();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoader);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 回收对象时调用此方法（清除侦听、对象null等）。
		 */
		public function destroy():void {
			if (loader.hasEventListener(Event.COMPLETE)) {
				loader.removeEventListener(Event.COMPLETE, xmlLoader);
			}
			loader = null;
			xml = null;
		}
		
		/* xml加载完成 */
		private function xmlLoader(eve:Event):void {
			loader.removeEventListener(Event.COMPLETE, xmlLoader);
			
			xml = XML(loader.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
