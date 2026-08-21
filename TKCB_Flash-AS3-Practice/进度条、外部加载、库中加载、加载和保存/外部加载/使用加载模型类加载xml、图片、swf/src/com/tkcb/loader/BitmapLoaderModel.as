package com.tkcb.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flash.net.URLRequest
	
	import com.tkcb.interfaces.IDestroy;
	
	/**
	 * BitmapLoaderModel 类是图片加载模型，可用于方便的控制图片的加载、显示、控制。
	 * @langversion ActionScript 3.0
	 * @author TKCB（QQ 2414268040、E-mail tkcb@qq.com）
	 * @创建时间 未知
	 * @修改时间 2013-11-6
	 */
	public class BitmapLoaderModel extends EventDispatcher implements IDestroy
	{
		/** Loader对象 */
		public var loader:Loader;
		/** 位图对象 */
		public var bitmap:Bitmap;
		
		/**
		 * 构造函数
		 * @param url 加载图片的路径地址。
		 */
		public function BitmapLoaderModel(url:String) {
			bitmap = new Bitmap();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapLoader);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 回收对象时调用此方法（清除侦听、对象null等）。
		 */
		public function destroy():void {
			if (loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bitmapLoader);
			}
			loader = null;
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
		
		/* 图片加载完成 */
		private function bitmapLoader(eve:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bitmapLoader);
			
			bitmap = loader.content as Bitmap;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}
