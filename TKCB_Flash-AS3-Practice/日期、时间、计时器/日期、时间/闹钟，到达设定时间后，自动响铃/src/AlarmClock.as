package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import tkcb.charCodeNumber;
	
	/**
	 * AlarmClock 设置闹钟
	 * @author TKCB
	 * Creation date 2012-05-27
	 * Modified by ...
	 * Modified date ...
	 */
	public class AlarmClock extends MovieClip{
		
		/**
		 * 计时器，用于侦听闹铃时间是否到期
		 */
		private var _timer:Timer;
		
		/**
		 * 用于加载外部的闹铃声音
		 */
		private var _soundAlarm:Sound;
		
		/**
		 * 用于获取当前时间
		 */
		private var _currentTime:Date;
		
		/**
		 * 记录当前设置时间的位置
		 */
		private var _setTime:uint;
		
		// 下面属性用于记录闹铃的时间
		/**
		 * 用于记录闹铃小时时间
		 */
		private var _hour:uint;
		
		/**
		 * 用于记录闹铃分钟时间
		 */
		private var _minute:uint;
		
		/**
		 * 用于记录闹铃秒钟时间
		 */
		private var _second:uint;
		
		// 下面属性用于记录设置状态下的闹钟每一位的时间
		/**
		 * 设置状态下的闹铃小时十位时间
		 */
		private var _setHour1:uint;
		
		/**
		 * 设置状态下的闹铃小时个位时间
		 */
		private var _setHour2:uint;
		
		/**
		 * 设置状态下的闹铃分钟十位时间
		 */
		private var _setMinute1:uint;
		
		/**
		 * 设置状态下的闹铃分钟个位时间
		 */
		private var _setMinute2:uint;
		
		/**
		 * 设置状态下的闹铃秒钟十位时间
		 */
		private var _setSecond1:uint;
		
		/**
		 * 设置状态下的闹铃秒钟个位时间
		 */
		private var _setSecond2:uint;
		
		// ————————————————————属性方法分割线————————————————————
		/**
		 * 沟槽函数 用于初始化计时器
		 */
		public function AlarmClock()
		{
			// 创建计时器，并且注册侦听，侦听闹铃是否到期
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, alarmHandler);
			_timer.start();
			
			//初始设置时间的位置
			_setTime = 1;
			
			//初始化闹铃小时、分钟、秒钟
			_hour = 0;
			_minute = 0;
			_second = 0;
			
			// 初始化设置状态下的闹铃时间
			_setHour1 = 0;
			_setHour2 = 0;
			_setMinute1 = 0;
			_setMinute2 = 0;
			_setSecond1 = 0;
			_setSecond2 = 0;
			
			// 侦听设置时间按钮被点击事件
			setTime.addEventListener(MouseEvent.CLICK, setTimeHandler);
		}
		
		/**
		 * 侦听器 用于侦听闹铃时间是否到期
		 * @param eve 计时器到期事件
		 */
		private function alarmHandler(eve:TimerEvent):void
		{
			// 创建新的时间，用于获取时间
			_currentTime = new Date();
			
			// 判断闹铃时间是否到期，如果到期则执行代码
			if(_hour == _currentTime.getHours() && _minute == _currentTime.getMinutes() && _second == _currentTime.getSeconds())
			{
				// 停止当前闹铃，移除当前侦听
				eve.target.stop();
				eve.target.removeEventListener(TimerEvent.TIMER, alarmHandler);
				
				// 加载外部闹铃声音，闹铃发挥作用
				_soundAlarm = new Sound();
				_soundAlarm.addEventListener(Event.COMPLETE, soundAlarmHandler);
				_soundAlarm.load(new URLRequest("sound/纵横江湖.mp3"));
			}
		}
		
		/**
		 * 侦听器，闹铃声音加载完成
		 * @param eve 闹铃声音加载完成发出的事件
		 */
		private function soundAlarmHandler(eve:Event):void
		{
			// 播放闹铃声音
			eve.target.play();
		}
		
		/**
		 * 侦听器，开始设置闹钟的闹铃时间
		 * @param eve 鼠标点击“设置时间按钮”发出的事件
		 */
		private function setTimeHandler(eve:MouseEvent):void
		{
			// 移除当前侦听
			eve.target.removeEventListener(MouseEvent.CLICK, setTimeHandler);
			
			// 停止当前闹铃
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, alarmHandler);
			
			// 跳转到设置闹铃的画面
			this.gotoAndStop("set1");
			
			// 全局侦听键盘按下事件
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			// 侦听保存设置按钮被点击事件
			saveSet.addEventListener(MouseEvent.CLICK, saveSetHandler);
		}
		
		/**
		 * 侦听器，根据键盘按下的键来设置闹钟的闹铃时间
		 * @param eve 键盘按下事件
		 */
		private function keyUpHandler(eve:KeyboardEvent):void
		{
			// 根据按下的键然后执行相应代码
			// 如果按下的是“←”
			if(eve.keyCode == 37 || eve.keyCode == 65)
			{
				// 如果当前设置的不是小时的十位
				if(_setTime != 1)
				{
					// 当前设置的时间位置向左移动
					_setTime--;
					
					// 跳转到相应的显示画面
					this.gotoAndStop("set" + _setTime);
					
					// 结束函数
					return;
				}
				
				// 如果按下的是“→”
			}else if(eve.keyCode == 39 || eve.keyCode == 68)
			{
				// 如果当前设置的不是秒钟的个位
				if(_setTime != 6)
				{
					// 当前设置的时间位置向右移动
					_setTime++;
					
					// 跳转到相应的显示画面
					this.gotoAndStop("set" + _setTime);
					
					// 结束函数
					return;
				}
				
				// 否则判断是否数字键
			}else
			{
				// 循环判断按下的键是否是数字，循环变量代表0-9这是十个数字的字符值
				for(var i:int = 48; i < 58; i++)
				{
					// 根据当前设置的时间来执行相应操作
					if(eve.charCode == i)
					{
						// 获取当前按下的数字
						var num:uint = charCodeNumber(eve);
						
						// 根据当前设置闹钟的位置
						switch(_setTime)
						{
							// 小时十位
							case 1 :
								if(num < 3)
								{
									_setHour1 = num;
								}else
								{
									_setHour1 = 2;
								}
								time1.text = _setHour1.toString();
								
								// 当前设置的时间位置向右移动
								_setTime++;
								
								// 跳转到下一个设置
								this.gotoAndStop("set" + _setTime);
								
								break;
							
							// 小时个位
							case 2 :
								if(_setHour1 == 2 && num < 4)
								{
									_setHour2 = num;
								}else if(_setHour1 == 2)
								{
									_setHour2 = 3;
								}else
								{
									_setHour2 = num;
								}
								time2.text = _setHour2.toString();
								
								// 当前设置的时间位置向右移动
								_setTime++;
								
								// 跳转到下一个设置
								this.gotoAndStop("set" + _setTime);
								
								break;
							
							// 分钟十位
							case 3 :
								if(num < 6)
								{
									_setMinute1 = num;
								}else
								{
									_setMinute1 = 5;
								}
								time3.text = _setMinute1.toString();
								
								// 当前设置的时间位置向右移动
								_setTime++;
								
								// 跳转到下一个设置
								this.gotoAndStop("set" + _setTime);
								
								break;
							
							// 分钟个位
							case 4 :
								_setMinute2 = num;
								time4.text = _setMinute2.toString();
								
								// 当前设置的时间位置向右移动
								_setTime++;
								
								// 跳转到下一个设置
								this.gotoAndStop("set" + _setTime);
								
								break;
							
							// 秒钟十位
							case 5 :
								if(num < 6)
								{
									_setSecond1 = num;
								}else
								{
									_setSecond1 = 5;
								}
								time5.text = _setSecond1.toString();
								
								// 当前设置的时间位置向右移动
								_setTime++;
								
								// 跳转到下一个设置
								this.gotoAndStop("set" + _setTime);
								
								break;
							
							// 秒钟个位
							case 6 :
								_setSecond2 = charCodeNumber(eve);
								time6.text = _setSecond2.toString();
								break;
						}
						
						return;
						
						// 如果条件成立，说明按下的键不是数字，则结束函数
					}else if(i == 57)
					{
						return;
					}
				}
			}
		}
		
		/**
		 * 侦听器，保存设置的闹铃时间
		 * @param eve 鼠标点击“保存设置按钮”发出的事件
		 */
		private function saveSetHandler(eve:MouseEvent):void
		{
			// 移除当前侦听
			eve.target.removeEventListener(MouseEvent.CLICK, saveSetHandler);
			
			// 将设置位置复位
			_setTime = 1;
			
			// 跳转到设置闹铃的画面
			this.gotoAndStop("alarm");
			
			//将设置的闹铃时间保存下来
			_hour = _setHour1 * 10 + _setHour2;
			_minute = _setMinute1 * 10 + _setMinute2;
			_second = _setSecond1 * 10 + _setSecond2;
			
			// 启动闹铃
			_timer.addEventListener(TimerEvent.TIMER, alarmHandler);
			_timer.start();
			
			// 侦听设置时间按钮被点击事件
			setTime.addEventListener(MouseEvent.CLICK, setTimeHandler);
		}
	}
}
