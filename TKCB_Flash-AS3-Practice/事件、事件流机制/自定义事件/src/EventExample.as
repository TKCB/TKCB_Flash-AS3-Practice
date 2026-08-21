package src{
	
	/**
	* 描 述：文档类，学会使用自定义事件
	* 作 者：TKCB
	* 创建日期：2012.02.14
	* 修改日期：2012.02.14
	*/
	
	import flash.display.MovieClip;
	import src.ball.BallEvent;
	import src.ball.Ball;
	
	public class EventExample extends MovieClip{
		
		//用于创建图形
		private var myBall:Ball;
		
		/*
		* 构造函数
		*/
		public function EventExample(){
			
			initMyBall();
		}
		
		/*
		* 初始化myBall变量
		*/
		public function initMyBall():void{
			
			myBall = new Ball();
			addChild(myBall);
			//注册侦听器，侦听图形超出范围事件
			myBall.addEventListener(BallEvent.OVER_LINE, overLineHandler);
		}
		
		/*
		* 侦听器，处理图形超出范围事件
		*/
		private function overLineHandler(eve:BallEvent):void{
			
			trace(eve.msg);
		}
	}
}