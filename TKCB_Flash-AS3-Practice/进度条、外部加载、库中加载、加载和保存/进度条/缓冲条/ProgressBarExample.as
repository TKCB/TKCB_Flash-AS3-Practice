package 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.net.URLRequest;
	
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	
	/**
	 * ProgressBarExample 类，简单形式的进度条。用于给用户一个加载中提示
	 * @author TKCB
	 */
	public class ProgressBarExample extends Sprite
	{
		private var loaderArray:Array;// 存储发送加载的对象
		private var picArray:Array;// 存储加载的图片
		
		private var picTotal:int;// 记录加载的总共的图片数量
		private var picCount:int;// 记录加载的图片数量
		
		private var pb:MovieClip;// 进度条
		
		function ProgressBarExample()
		{
			/// 初始化
			loaderArray = new Array();
			picArray = new Array();
			picTotal= 38;
			picCount = 0;
			
			/// 进度条
			var __pbClass:Class = getDefinitionByName("ProgressBar") as Class;
			pb = new __pbClass();
			pb.x = stage.stageWidth / 2;
			pb.y = stage.stageHeight / 2;
			addChild(pb);
			
			forLoader();
		}
		
		/**
		 * 加载图片
		 */
		private function forLoader():void
		{
			
			loaderArray[picCount] = new Loader();
			loaderArray[picCount].contentLoaderInfo.addEventListener(Event.COMPLETE, picLoaderHandler);
			loaderArray[picCount].load(new URLRequest("pic/图片"+ (picCount + 1) + ".jpg"));
			picCount++;
		}
		
		/**
		 * 侦听器，处理加载完成事件
		 */
		private function picLoaderHandler(eve:Event):void
		{
			eve.target.removeEventListener(Event.COMPLETE, picLoaderHandler);
			
			loadTF.text = "第 " + picCount + " 张图片加载完成";
			
			if(picCount == picTotal)
			{
				picSet();
				loadTF.text = "全部加载完成！！！";
			}
			else
			{
				forLoader();
			}
		}
		
		/**
		 * 设置加载的图片的属性
		 */
		private function picSet():void
		{
			pb.stop();
			removeChild(pb);
			pb = null;
			
			var displayBitmapHandler:Function = function(eve:MouseEvent):void
			{
				
				for(var num:uint = 0; num < 19; num++)
				{
					picArray[num] = loaderArray[num].content as Bitmap;
					picArray[num].x = num * 20 +10;
					picArray[num].y = 120;
					addChild(picArray[num])
				}
			}
			displayBitmap.addEventListener(MouseEvent.CLICK, displayBitmapHandler);
		}
	}
}

