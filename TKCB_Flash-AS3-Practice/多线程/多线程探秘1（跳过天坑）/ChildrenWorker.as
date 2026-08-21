package
{
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	
	/**
	 * ...
	 */
	public class ChildrenWorker extends Sprite
	{
		/** 子的SWF的多线程对象 */
		private var childrenWorker : Worker;
		
		/** 用于 mainWorker 对象向 childrenWorker 对象发送消息和数据的连接通道对象 */
		private var mainToChildrenChannel: MessageChannel;
		
		/** 用于 childrenWorker 对象向 mainWorker 对象发送消息和数据的连接通道对象（这个对象要被发送到 childrenWorker 对象中，以此构想相互通信的机制） */
		private var childrenToMainChannel: MessageChannel;
		
		/** 仅仅是用于测试发送消息时候的数字编号 */
		private var num : int = 1;
		
		
		/**
		 * ...
		 */
		public function ChildrenWorker ()
		{
			// 获取当前多线程对象（即子线程）
			childrenWorker = Worker.current;
			
			//// 获取 主线程和子线程 之间通信的通道对象
			mainToChildrenChannel = childrenWorker.getSharedProperty( "mainToChildrenChannel" ) as MessageChannel;
			if ( mainToChildrenChannel != null )
			{
				mainToChildrenChannel.addEventListener( Event.CHANNEL_MESSAGE, mainToChildrenChannelMessage );
				childrenToMainChannel = childrenWorker.getSharedProperty( "childrenToMainChannel" ) as MessageChannel;
				
			}
		}
		
		/** 接收 主线程 发送过来的消息或数据对象  */
		private function mainToChildrenChannelMessage ( eve : Event ) : void
		{
			var str : String = mainToChildrenChannel.receive() as String;
			// trace( "获取父进程发送的消息" + str );		// 子进程里面trace是不起作用的
			
			if ( str == "发送一条消息看看子线程是否完全启动！" )
			{
				childrenToMainChannel.send( "发送一条消息回应子线程已经完全开启！" );
				// 忽略用于检测连接状态的消息
			}
			else
			{
				childrenToMainChannel.send( "这是一段子线程发送给主线程的消息" + num );
				num++;
				childrenToMainChannel.send( "这是一段子线程发送给主线程的消息" + num );
				num++;
				childrenToMainChannel.send( "这是一段子线程发送给主线程的消息" + num );
				num++;
			}
			
		}
		
		
		
		
	}
}