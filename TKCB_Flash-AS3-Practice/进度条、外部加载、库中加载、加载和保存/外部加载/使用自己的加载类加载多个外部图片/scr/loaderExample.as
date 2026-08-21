package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	import tkcb.loader.LoaderPictureSWF;
	import tkcb.loader.LoaderPictureSWFType;
	
	public class loaderExample extends Sprite
	{
		private var loadPic:LoaderPictureSWF;
		
		function loaderExample()
		{
			/// 注释掉其余的方式，只留下需要测试的方式即可
			/*// 加载方式1，构造函数传参法
			var url:Vector.<String> = new <String>["pic/图片1.jpg", "pic/图片2.jpg", "pic/图片3.jpg", "pic/图片4.jpg", "pic/图片5.jpg"];
			loadPic = new LoaderPictureSWF(LoaderPictureSWFType.BITMAP, url, setBitmap);
			loadPic.load();*/
			
			/*// 加载方式2，设置属性法
			var url:Vector.<String> = new <String>["pic/图片1.jpg", "pic/图片2.jpg", "pic/图片3.jpg", "pic/图片4.jpg", "pic/图片5.jpg"];
			loadPic = new LoaderPictureSWF();
			loadPic.type = LoaderPictureSWFType.BITMAP;
			loadPic.urlVector = url;
			loadPic.callbackFunction = setBitmap;
			loadPic.load();*/
			
			/*// 加载方式3，load()方法传参法
			var url:Vector.<String> = new <String>["pic/图片1.jpg", "pic/图片2.jpg", "pic/图片3.jpg", "pic/图片4.jpg", "pic/图片5.jpg"];
			loadPic = new LoaderPictureSWF();
			loadPic.load(LoaderPictureSWFType.BITMAP, url, setBitmap);*/
			
			/*// 加载方式4，通过newURL()方法创建url法*/
			loadPic = new LoaderPictureSWF();
			loadPic.newURL("pic/图片", 5, ".jpg");
			loadPic.load(LoaderPictureSWFType.BITMAP, null, setBitmap);
		}
		
		private function setBitmap():void
		{
			trace(loadPic.isComplete);
			var bit:Vector.<Bitmap> = loadPic.loaderObjectVector;
			for(var i:int = 0; i < 5; i++)
			{
				bit[i].x = i * 20;
				bit[i].y = (i + 1) * 30;
				addChild(bit[i]);
			}
		}
	}
}

