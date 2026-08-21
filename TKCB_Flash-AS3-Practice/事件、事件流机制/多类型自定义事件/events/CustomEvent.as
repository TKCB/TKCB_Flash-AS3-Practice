package events
{
	import flash.events.Event;
	
	/**
	 * CustomEvent 类，多事件类型自定义事件
	 * @author TKCB
	 */
	public class CustomEvent extends Event
	{
		/** 事件1 */
		public static const TYPE1:String = "Type1";
		/** 事件2 */
		public static const TYPE2:String = "Type2";
		
		/**
		 * 构造函数
		 * @param type 设置事件类型
		 */
		function CustomEvent(type:String = TYPE1)
		{
			super(type);
		}
	}
}