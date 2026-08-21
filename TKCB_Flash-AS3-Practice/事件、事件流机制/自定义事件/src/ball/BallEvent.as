package src.ball{
	
	/**
	* 描 述：自定义事件
	* 作 者：TKCB
	* 创建日期：2012.02.14
	* 修改日期：2012.02.14
	*/
	
	import flash.events.Event;
	
	//还可以扩展其他事件类型，甚至是自定义的事件
	public class BallEvent extends Event{
		
		public static const OVER_LINE:String = "overLine";
		
		//记录图形是否超出边框
		public var msg:String = "";
		
		/*
		* 构造函数
		*/
		public function BallEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false){
			
			super(type, bubbles, cancelable);
		}
		
		/*
		* clone方法必须重写
		*/
		override public function clone():Event{
			
			return new BallEvent(type, bubbles, cancelable);
		}
		/*
		* toString方法可选重写，Adobe建议重写
		*/
		override public function toString():String{
			
			return formatToString("BallEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}
//一百二十列标尺********************************************************************************************************