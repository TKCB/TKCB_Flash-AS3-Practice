package tkcb.loader
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	
	import flash.events.Event;
	
	import flash.net.URLRequest;
	
	/**
	 * LoaderPictureSWF 类，用于批量加载外部图片或swf。可以设置加载的路径、创建简单形式的加载路径、根据路径加载外部图片或swf、获取是否加载完成、设置加载完成后的回调函数
	 * @author TKCB
	 * QQ 2414268040
	 */
	public class LoaderPictureSWF
	{
		private var _urlVector:Vector.<String>;// 加载图片或swf的路径
		private var _loaderVector:Vector.<Loader>;// 用于加载的Loader对象
		private var _loaderObjectVector:*;// 加载到的图片或swf
		
		private var _total:uint;// 要加载的图片或swf总数
		private var _loadNumber:uint;// 当前加载的图片或swf个数
		
		private var _type:String;// 加载的对象转换类型，Bitmap、MovieClip、Sprite
		private var _isComplete:Boolean;// 是否加载完成，如果加载完成则为true，否则为false
		private var _callbackFunction:Function;// 回调函数，加载完成后调度
		
		/**
		 * 构造函数，设置要加载图片或swf的转换类型、url路径、加载完成后调度的函数
		 * @param typ 加载的对象转换类型，Bitmap、MovieClip、Sprite
		 * @param url 加载图片或swf的路径数组
		 * @param callbackFunction 回调函数，加载完成后调度此函数
		 */
		function LoaderPictureSWF(typ:String = null, url:Vector.<String> = null, callbackFun:Function = null)
		{
			_total = 1;
			_loadNumber = 0;
			_isComplete = false;
			
			if(typ != null)
			{
				_type = typ;
				setType();
			}
			
			if(url != null)
			{
				_urlVector = url;
				_total = _urlVector.length;
			}
			
			if(callbackFun != null)
			{
				_callbackFunction = callbackFun;
			}
			else
			{
				_callbackFunction = function():void
				{
					trace("回调函数为空");
				}
			}
		}
		
		//// 下面代码用于：实现部分属性的get和set方法
		/** 加载图片或swf的路径数组 */
		public function get urlVector():Vector.<String>
		{
			return _urlVector;
		}
		public function set urlVector(url:Vector.<String>):void
		{
			_urlVector = url;
			_total = _urlVector.length;
		}
		/** 加载到的图片或swf数组 */
		public function get loaderObjectVector():Vector.<Bitmap>
		{
			return _loaderObjectVector;
		}
		/** 要加载的图片或swf总数 */
		public function get total():uint
		{
			return _total;
		}
		/** 当前加载的图片或swf个数 */
		public function get loadNumber():uint
		{
			return _loadNumber;
		}
		/** 加载的对象转换类型，Bitmap、MovieClip、Sprite */
		public function get type():String
		{
			return _type;
		}
		public function set type(typ:String):void
		{
			_type = typ;
			setType();
		}
		/** 是否加载完成，如果加载完成则为true，否则为false */
		public function get isComplete():Boolean
		{
			_isComplete = (_total ==_loadNumber);
			return _isComplete;
		}
		/** 回调函数，加载完成后调度 */
		public function set callbackFunction(callbackFun:Function):void
		{
			_callbackFunction = callbackFun;
		}
		
		/**
		 * 设置加载的对象转换类型
		 */
		private function setType():void
		{
			switch(_type)
			{
				case "Bitmap":
					_loaderObjectVector = new Vector.<Bitmap>();
					break;
				case "MovieClip":
					_loaderObjectVector = new Vector.<MovieClip>();
					break;
				case "Sprite":
					_loaderObjectVector = new Vector.<Sprite>();
					break;
			}
		}
		
		/**
		 * 创建加载图片的url地址数组。仅支持“XXX[1-num]XXX.XXX”创建这种形式类似的序列图片或swf的url地址
		 * @param urlHead 加载图片或swf的url的头部字符串
		 * @param num 加载图片或swf的url的序列号总数
		 * @param urlTail 加载图片或swf的url的尾部字符串
		 */
		public function newURL(urlHead:String, num:uint, urlTail:String):void
		{
			_urlVector = new Vector.<String>();
			_urlVector.length = num;
			_total = num;
			
			var i:uint = 0;
			while(i < num)
			{
				_urlVector[i] = urlHead + (i + 1).toString() + urlTail;
				i++;
			}
		}
		
		/**
		 * 加载外部图片。根据传入的图片或swf的url地址数组或者使用newURL()方法创建的url地址数组加载外部图片或swf
		 * @param typ 加载的对象转换类型，Bitmap、MovieClip、Sprite
		 * @param url 加载图片或swf的路径数组
		 * @param callbackFunction 回调函数，加载完成后调度此函数
		 */
		public function load(typ:String = null, url:Vector.<String> = null, callbackFun:Function = null):void
		{
			_loaderVector = new Vector.<Loader>();
			
			if(typ != null)
			{
				_type = typ;
				setType();
			}
			
			if(url != null)
			{
				_urlVector = url;
				_total = _urlVector.length;
			}
			
			if(callbackFun != null)
			{
				_callbackFunction = callbackFun;
			}
			
			_loaderVector.length = _total;
			_loaderObjectVector.length = _total;
			
			// 测试数据是否初始化
			trace(_urlVector.length);
			trace(_loaderVector.length);
			trace(_loaderObjectVector.length);
			
			trace(_total);
			trace(_loadNumber);
			
			trace(_type);
			trace(_isComplete);
			//*/
			
			forLoader();
		}
		
		/**
		 * 循环加载
		 */
		private function forLoader():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest(_urlVector[_loadNumber]));
			_loaderVector[_loadNumber] = loader;
			
			_loadNumber++;
		}
		
		/**
		 * 侦听器，处理加载完成事件
		 */
		private function completeHandler(eve:Event):void
		{
			eve.target.removeEventListener(Event.COMPLETE, completeHandler);
			
			if(_loadNumber == _total)
			{
				var i:int = 0;
				while(i < _loadNumber)
				{
					switch(_type)
					{
						case "Bitmap":
							if(_loaderVector[i].content is Bitmap)
							_loaderObjectVector[i] = _loaderVector[i].content as Bitmap;
							break;
						case "MovieClip":
							if(_loaderVector[i].content is MovieClip)
							_loaderObjectVector[i] = _loaderVector[i].content as MovieClip;
							break;
						case "Sprite":
							if(_loaderVector[i].content is Sprite)
							_loaderObjectVector[i] = _loaderVector[i].content as Sprite;
							break;
					}
					i++;
				}
				_callbackFunction();
			}
			else
			{
				forLoader();
			}
		}
	}
}