package 
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Bitmap;
	
	import flash.events.Event;
	
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	
	/**
	 * LoadBitmap 类，从外部加载多张图片
	 * @author TKCB
	 */
	public class LoadBitmap extends MovieClip
	{
		private var loaderArray:Array = new Array();// 存储发送加载的对象
		private var picArray:Array = new Array();// 存储加载的图片
		
		private var picTotal:uint = 19;// 记录加载的总共的图片数量
		private var picCount:uint = 0;// 记录加载的图片数量
		
		public function LoadBitmap():void
		{
			stop();
			
			//for循环，num是加载图片的索引值， picTotal是加载图片的数量
			for(var num:uint = 0; num < picTotal; num++)
			{
				loaderArray[num] = new Loader();
				loaderArray[num].contentLoaderInfo.addEventListener(Event.COMPLETE, picLoaderHandler);
				loaderArray[num].load(new URLRequest("pic/图片"+ (num + 1) + ".jpg"));
			}
		}
		
		/**
		 * 侦听器，处理加载完成事件
		 */
		private function picLoaderHandler(eve:Event):void
		{
			trace("第 " + picCount + "张图片加载完成");
			picCount++;
			if(picCount == picTotal)
			{
				picSet();
				trace("全部加载完成！！！");
			}
		}
		
		/**
		 * 设置加载的图片的属性
		 */
		private function picSet():void
		{
			gotoAndStop(2);
			
			var displayBitmapHandler:Function = function(eve:MouseEvent):void
			{
				
				for(var num:uint = 0; num < 19; num++)
				{
					picArray[num] = loaderArray[num].content as Bitmap;
					picArray[num].x = num * 20 +10;
					picArray[num].y = 100;
					addChild(picArray[num])
				}
			}
			displayBitmap.addEventListener(MouseEvent.CLICK, displayBitmapHandler);
		}
	}
}

