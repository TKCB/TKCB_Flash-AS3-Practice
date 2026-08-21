package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class Polymorphic extends Sprite
	{
		/**
		 * ...
		 */
		function Polymorphic()
		{
			/// 向上转换成功
			var b:B = new B();
			trace("子类对象向上转换为父类类型时：");
			fun(b);
			
			/// 向下转换成功，由于b2原本属于B类型的对象，而以A类型存在，所以能向下转换成功。
			var b2:A = new B();
			trace("\n子对象以父类类型存在时：");
			// fun2(b2);		// 不能直接传参，必须先使用向下转换。如下代码：
			fun2(b2 as B);		// 如果清楚知道对象类型使用as是正确的，如果不确定，则应使用is + as判断。
		}
		
		/** 只接受父类类型的对象，即A类型对象 */
		private function fun(n:A):void
		{
			trace("向上转换成功！！！");
		}
		
		/** 只接受子类类型的对象，即B类型对象 */
		private function fun2(n:B):void
		{
			trace("向下转换成功！！！");
		}

	}
	
}
class A
{
	
}
class B extends A
{
	public var num:Number = 3.14;
}

