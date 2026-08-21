package
{
	import flash.display.Sprite;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import events.CustomEvent;
	
	/**
	 * PictureExample 类，用于练习多事件类型的自定义事件
	 * @author TKCB
	 * QQ 2414268040
	 */
	public class EventExample extends Sprite
	{
		private var dispatcher:EventDispatcher;		// 用于发送事件
		
		/**
		 * 构造函数
		 */
		function EventExample()
		{
			dispatcher = new EventDispatcher();
			dispatcher.addEventListener(CustomEvent.TYPE1, typeHandler);
			dispatcher.addEventListener(CustomEvent.TYPE2, typeHandler);
			
			/// 由于是练习，所以在类内部进行接收侦听，实际基本在外部
			eventType1.addEventListener(MouseEvent.CLICK, mouseHandler);
			eventType2.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		/**
		 * 侦听器，按钮事件
		 */
		private function mouseHandler(eve:MouseEvent):void
		{
			var event:CustomEvent;
			
			switch(eve.target)
			{
				case eventType1:
					event = new CustomEvent(CustomEvent.TYPE1);
					dispatcher.dispatchEvent(event);
					break;
				case eventType2:
					event = new CustomEvent(CustomEvent.TYPE2);
					dispatcher.dispatchEvent(event);
					break;
			}
		}
		
		/**
		 * 侦听器，自定义事件
		 */
		private function typeHandler(eve:CustomEvent):void
		{
			switch(eve.type)
			{
				case CustomEvent.TYPE1:
					tf.text = "发送CustomEvent事件，事件类型为：TYPE1";
					break;
				case CustomEvent.TYPE2:
					tf.text = "发送CustomEvent事件，事件类型为：TYPE2";
					break;
			}
		}
	}
}