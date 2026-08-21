// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Nm（nm.tkcb.cc）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc

package
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	import flash.utils.Timer;
	
	import flash.media.Video;
	import flash.media.Camera;
	
	import jp.maaash.ObjectDetection.ObjectDetector;	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;	
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;	
	
	/**
	 * ...
	 */
	public class WebcamFaceDetector extends MovieClip
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 人脸识别对象 */
		private var detector : ObjectDetector;
		
		/** 人脸识别对象选项（模式） */
		private var options : ObjectDetectorOptions;
		
		/** 当前用于人脸识别的图像 */
		private var bmpTarget : Bitmap;
		
		
		/** 人脸识别，矩形框的颜色 */
		private var rectColor : int = 0xFF0000;
		
		/** 人脸识别，矩形框的数组 */
		private var rects : Array;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数 
		 */
		public function WebcamFaceDetector ()
		{
			// 人脸识别，矩形框的数组
			rects = new Array();
			
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 对象被添加到舞台 */
		private function addedToStage ( eve:Event ) : void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			// 初始化人脸识别器
			_initDetector();
			
			// 人脸识别
			_detection();
		}
		
		/** 初始化人脸识别器 */
		private function _initDetector () : void
		{
			detector = new ObjectDetector();
			// 设置人脸识别识别选项（模式）
			options = new ObjectDetectorOptions();
			options.min_size = 50;
			options.startx = ObjectDetectorOptions.INVALID_POS;
			options.starty = ObjectDetectorOptions.INVALID_POS;
			options.endx = ObjectDetectorOptions.INVALID_POS;
			options.endy = ObjectDetectorOptions.INVALID_POS;
			detector.options = options;
			// 加载人脸识别库
			detector.loadHaarCascades( "face.zip" );
			// 设置人脸识别完成侦听
			detector.addEventListener( ObjectDetectorEvent.DETECTION_COMPLETE , detectionComplete );
		}
		
		/** 人脸识别 */		
		private function _detection () : void
		{
			bmpTarget = new Bitmap( new BitmapData( rlsbMC.width, rlsbMC.height ) );
			bmpTarget.bitmapData.draw( rlsbMC );
			detector.detect( bmpTarget );
		}
		
		/** 识别完成，用矩形框将识别到的人脸显示出来 */
		private function detectionComplete ( eve : ObjectDetectorEvent ) : void
		{
			// 如果没有识别到人脸，则结束函数，不显示任何矩形框
			// 根据lenght属性可以知道，该识别系统可以识别多个人脸
			if ( eve.rects.length == 0 )
			{
				tf.text = "没有识别到人脸！！！";
				return;
			}
			
			tf.text = "识别到了 " + eve.rects.length + " 个人脸。";
			// 便利获取到的人脸数组
			for ( var i : int = 0; i < eve.rects.length ; i++ )
			{
				// 如果发现人脸则创建矩形
				rects[ i ] = createRect();
				rects[ i ].x = eve.rects[ i ].x + rlsbMC.x;
				rects[ i ].y = eve.rects[ i ].y + rlsbMC.y;
				rects[ i ].width = eve.rects[ i ].width;
				rects[ i ].height = eve.rects[ i ].height;
				addChild( rects[ i ] );
			}
		}
		
		/** 创建人脸识别框 */
		private function createRect () : Sprite
		{
			var rectContainer : Sprite = new Sprite();
			rectContainer.graphics.lineStyle( 2 , rectColor , 1 );
			rectContainer.graphics.beginFill( 0x000000, 0 );
			rectContainer.graphics.drawRect( 0, 0, 100, 100 );
			
			return rectContainer;
		}
		
	}
}






