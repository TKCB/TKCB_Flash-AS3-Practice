package 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Loader;
	
	import flash.events.Event;
	
	import flash.geom.Point;    //使用案例原方法时，需导入此类
	import flash.geom.Rectangle;    //使用案例原方法时，需导入此类
	
	import flash.net.URLRequest;
	
	/**
	 *  LoadBitmap文档类，载入位图并访问位图原始数据
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class LoadBitmap extends Sprite{
		
		/*
		* 构造函数
		*/
		public function LoadBitmap():void{
			
			//用于加载外部的图片
			var loader:Loader = new Loader();
			//注册侦听器，侦听加载完成事件
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,bitmapLoadedHandler);
			//发送加载外部图片的请求
			loader.load(new URLRequest("pic/图片.jpg"));
		}
		
		/*
		* 侦听器，处理加载完成事件
		*/
		private function bitmapLoadedHandler(eve:Event):void{
			
			//用于储存加载的图片
			var bitmap:Bitmap = Bitmap(eve.target.loader.content);
			bitmap.scaleX = 4;
			bitmap.scaleY = 4;
			bitmap.x = 40;
			bitmap.y = 90;
			addChild(bitmap);
			
			//将加载的位图复制一份
			copyBitmap(bitmap);
		}
		
		/*
		* 用于将传入位图复制一份
		* 参数bit，存储用于复制的位图
		*/
		private function copyBitmap(bit:Bitmap):void{
			
			//案例原方法：
			//用于储存像素信息，并指定宽高
			//var newBitmapData:BitmapData = new BitmapData(bit.width, bit.height);
			//复制像素信息
			//newBitmapData.copyPixels(bit.bitmapData, new Rectangle(0, 0, bit.width, bit.height), new Point(0, 0));
			//用于存储复制的图片
			//var newBitmap:Bitmap = new Bitmap(newBitmapData);
			
			//新方法：
			//用于存储复制的图片
			var newBitmap:Bitmap = new Bitmap(bit.bitmapData.clone());
			newBitmap.smoothing = true;		// 设置插值，使图片在放大的时候进行优化处理，而不会出现像素锯齿感觉
			newBitmap.scaleX = 4;
			newBitmap.scaleY = 4;
			newBitmap.x = 300;
			newBitmap.y = 90;
			addChild(newBitmap);
		}
	}
}
//一百二十列标尺********************************************************************************************************