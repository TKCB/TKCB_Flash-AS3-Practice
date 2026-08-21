package{
	
	/**
	* 描 述：文档类，指定间隔指定摸个任务，只要没有停止语句，则无限期执行
	* 作 者：TKCB
	* 创建日期：2012.02.19
	* 修改日期：2012.02.19
	*/
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	public class TimerExample extends Sprite{
		
		//用于指定间隔执行某个任务
		private var _myTimer:Timer;
		
		/*
		* 构造函数
		*/
		public function TimerExample(){
			
			//创建并设置计时器
			initTimer();
		}
		
		/*
		* 创建并设置计时器
		*/
		private function initTimer():void{
			
			//设置执行任务的间隔和次数
			_myTimer = new Timer(500, 100);
			//注册侦听器，侦听计时器到期事件
			_myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			//启动侦听器
			_myTimer.start();
		}
		
		/*
		* 侦听器，处理计时器到期事件
		*/
		private function timerHandler(eve:TimerEvent):void{
			
			trace(eve.target.currentCount);
			
			//如果，执行次数等于10，则，停止计时器
			if(eve.target.currentCount == 10){
				
				eve.target.stop();
				
				trace("计时器到期");
			}
		}
	}
}