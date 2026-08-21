package com.tkcb.loader
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	import flash.net.URLRequest
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.tkcb.interfaces.IDestroy;
	
	/**
	 * SWFLoaderModel 类是xml加载模型，可方便的对xml进行加载。
	 * @langversion ActionScript 3.0
	 * @author TKCB（QQ 2414268040、E-mail tkcb@qq.com）
	 * @创建时间 2013-11-6
	 * @修改时间 2013-11-6
	 */
	public class SWFLoaderModel extends EventDispatcher implements IDestroy
	{
		/** swf对象 */
		public var swf:*;
		
		/** Loader对象 */
		public var loader:Loader;
		
		/**
		 * 构造函数
		 * @param url 加载图片的路径地址。
		 */
		public function SWFLoaderModel(url:String) {
			swf = new Sprite();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoader);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 回收对象时调用此方法（清除侦听、对象null等）。
		 */
		public function destroy():void {
			if (loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoader);
			}
			loader = null;
			swf = null;
		}
		
		/* swf加载完成 */
		private function swfLoader(eve:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoader);
			
			if (swf is Sprite) {
				swf = loader.content as Sprite;
			} else {
				swf = loader.content as MovieClip;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
