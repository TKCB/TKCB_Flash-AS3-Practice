package
{
	
	/**
	 * 自定义的对象，用于测试主线程和子线程之间的自定义对象传输
	 */
	public class CustomObject
	{
		/** 一个属性 */
		public var attribute : String = "我是自定义的对象的属性！";
		
		
		/**
		 * ...
		 */
		public function CustomObject ()
		{
			
		}
		
		/**
		 * 一个方法，用来改变自身对象的属性，在子线程中使用这个方法，测试是否可以改变并返回一个对象
		 */
		public function method () : void
		{
			attribute = "我是自定义的对象的属性！（被 method 方法改变过的~~~）";
		}
		
		
	}
}