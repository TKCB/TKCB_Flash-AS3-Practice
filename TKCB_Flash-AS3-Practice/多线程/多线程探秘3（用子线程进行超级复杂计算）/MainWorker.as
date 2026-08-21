// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Nm（nm.tkcb.cc）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc




package
{
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 */
	public class MainWorker extends Sprite
	{
		/** 主的SWF的多线程对象 */
		private var mainWorker : Worker;
		
		/** 子的SWF的多线程对象 */
		private var childrenWorker : Worker;
		
		/** 用于 mainWorker 对象向 childrenWorker 对象发送消息和数据的连接通道对象 */
		private var mainToChildrenChannel: MessageChannel;
		
		/** 用于 childrenWorker 对象向 mainWorker 对象发送消息和数据的连接通道对象（这个对象要被发送到 childrenWorker 对象中，以此构想相互通信的机制） */
		private var childrenToMainChannel: MessageChannel;
		
		/** 延迟检测机制使用的计时器，之所以要延迟检测 主线程和子线程 之间的链接，是因为这个链接有一定的延迟 */
		private var delayTestTimer : Timer;
		
		
		/**
		 * ...
		 */
		public function MainWorker ()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		
		/** 对象被添加到舞台 */
		private function addedToStage ( eve : Event ) : void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			mainToChildrenTF.text = "";
			childrenToMainTF.text = "";
			nTF.text = String( int(Math.random() * 4000 + 1000) );
			
			//// 加载子线程使用的SWF文件
			var request : URLRequest = new URLRequest( "ChildrenWorker.swf" );
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener( Event.COMPLETE, swfLoadComplete );
			loader.load( request );
		}
		
		/** SWF加载完成 */
		private function swfLoadComplete ( eve : Event ) : void
		{
			eve.target.removeEventListener( Event.COMPLETE, swfLoadComplete );
			trace( "SWF加载完成！" );
			trace( "是否支持Worker：" + Worker.isSupported  );
			
			
			// 获取当前多线程对象
			mainWorker = Worker.current;
			
			
			//// 获取子SWF对象的Byte对象，然后用其创建子线程对象（childrenWorker）
			var childrenWorkerBytes : ByteArray = eve.target.data as ByteArray;
			childrenWorker = WorkerDomain.current.createWorker( childrenWorkerBytes );
			childrenWorker.addEventListener( Event.WORKER_STATE, childrenWorkerState );
			
			// 创建 主线程 向 子线程 发送消息和传输数据的通道对象
			mainToChildrenChannel = mainWorker.createMessageChannel( childrenWorker );
			// mainToChildrenChannel.addEventListener( Event.CHANNEL_MESSAGE, mainToChildrenChannelMessage );		// 不能在 主线程 中使用这个侦听
			
			
			// 创建 子线程 向 主线程 发送消息和传输数据的通道对象
			childrenToMainChannel = childrenWorker.createMessageChannel( mainWorker );
			childrenToMainChannel.addEventListener( Event.CHANNEL_MESSAGE, childrenToMainChannelMessage );
			
			
			//// 将通道对象传入子进程中
			childrenWorker.setSharedProperty( "mainToChildrenChannel", mainToChildrenChannel ); 
			childrenWorker.setSharedProperty( "childrenToMainChannel", childrenToMainChannel ); 
		
			
			// 子线程对象开始运行（子线程对象的所有代码在开始之前都是不执行的）
			//childrenWorker.start();
			
			childrenWorker.start();
		}
		
		/** 子线程状态改变，如果在运行，则开启延迟检测是否可以正常发送消息机制 */
		private function childrenWorkerState ( eve : Event ) : void
		{
			if ( childrenWorker.state == WorkerState.RUNNING )
			{
				// 不能直接使用send()方法发送消息，因为这时候其实 子线程 还没有构造完成，代码应该延迟
				// mainToChildrenChannel.send( "这是一段主线程发送给子线程的消息" );
				
				//// 延迟检测机制
				delayTestTimer = new Timer( 100 );
				delayTestTimer.addEventListener( TimerEvent.TIMER, delayTestTimerEvent );
				delayTestTimer.start();
			}
		}
		
		/** 延迟检测机制，如果两个线程没有连接，则一直不断地检测 */
		private function delayTestTimerEvent ( eve : TimerEvent ) : void
		{
			// 发送第一条消息，仅仅用于测试链接状态，在 子线程 代码里面应该有忽略这一条消息的判断
			mainToChildrenChannel.send( "发送一条消息看看子线程是否完全启动！" );
		}
		
		/** 获取 子线程给主线程发送消息 的事件 */
		private function childrenToMainChannelMessage ( eve : Event ) : void
		{
			//// 获取消息，并判断是否是第一条测试链接的消息
			var obj = childrenToMainChannel.receive();
			
			if ( obj is String )
			{
				if ( obj == "发送一条消息回应子线程已经完全开启！" )
				{
					//// 停止延迟检测机制
					delayTestTimer.removeEventListener( TimerEvent.TIMER, delayTestTimerEvent );
					delayTestTimer.stop();
					
					// 调用后面的代码，这时候两个 线程之间才是正常的
					mainToChildrenChannelSend();
					mainBtn.addEventListener( MouseEvent.CLICK, mainBtnMouse );
					childrenBtn.addEventListener( MouseEvent.CLICK, childrenBtnMouse );
				}
				else
				{
					childrenToMainTF.appendText( obj + "\n" );
				}
			}
			else if ( obj is Number )
			{
				//// 结果计算出来了，按钮可以使用
				mainBtn.alpha = 1;
				childrenBtn.alpha = 1;
				mainBtn.mouseEnabled = true;
				childrenBtn.mouseEnabled = true;
				
				childrenToMainTF.appendText( obj + "\n" );
				totalTF.text = "最终计算的结果（子线程运算）：" + obj + "\n";
			}
		}
		
		/** 主线程进行计算，动画会很卡 */
		private function mainBtnMouse ( eve : MouseEvent ) : void
		{
			var num : int = int( nTF.text );
			
			//// 没有返回结果之前禁止点击按钮
			mainBtn.alpha = 0.25;
			childrenBtn.alpha = 0.25;
			mainBtn.mouseEnabled = false;
			childrenBtn.mouseEnabled = false;
			
			var totalNum : Number = complexOperation( num );
			totalTF.text = "最终计算的结果（主线程运算）：" + totalNum + "\n";
			
			//// 结果计算出来了，按钮可以使用
			mainBtn.alpha = 1;
			childrenBtn.alpha = 1;
			mainBtn.mouseEnabled = true;
			childrenBtn.mouseEnabled = true;
		}
		
		/** 子线程进行计算，动画不会卡 */
		private function childrenBtnMouse ( eve : MouseEvent ) : void
		{
			//// 没有返回结果之前禁止点击按钮
			mainBtn.alpha = 0.25;
			childrenBtn.alpha = 0.25;
			mainBtn.mouseEnabled = false;
			childrenBtn.mouseEnabled = false;
			
			var num : int = int( nTF.text );
			mainToChildrenChannel.send( num );
			mainToChildrenTF.appendText( "开始从 1+..." + num + "的计算 \n" );
		}
		
		/** 给 子线程 发送消息，并启动侦听器 */
		private function mainToChildrenChannelSend () : void
		{
			var str : String = "这是一段主线程发送给子线程的消息";
			mainToChildrenChannel.send( str );
			mainToChildrenTF.appendText( str + "\n" );
		}
		
		/** 获取 主线程给子线程发送消息 的事件，不能在 主线程 中使用这个侦听 */
		/*private function mainToChildrenChannelMessage ( eve : Event ) : void
		{
			var str : String = mainToChildrenChannel.receive() as String;
			mainToChildrenTF.appendText( "主线程发给子线程的消息：" + str + "\n" );
		}*/
		
		/** 超级复杂计算 */
		private function complexOperation ( numMax : Number ) : Number
		{
			//// 其实复杂计算的算法都需要在子线程中，而不是主线程（为了计算效果明显，多做了100000次循环计算）
			var totalNum : Number = 0;
			for ( var i : int = 0; i < 100000; i++ )
			{
				totalNum = 0;
				for ( var j : int = 1; j <= numMax; j++ )
				{
					totalNum += j;
				}
				trace( i, j );
			}
			return totalNum;
		}
	}
}