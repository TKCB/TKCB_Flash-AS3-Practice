package
{
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import flash.utils.Timer;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.easing.Regular;
	
	/**
	 * ...
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class Particle extends MovieClip
	{
		/** 时间。控制粒子动画的整体时间，默认值为25 */
		public var time:Number;
		/** 是否使用秒数，而不是帧数。默认值为false（使用帧数） */
		public var useSeconds:Boolean;
		
		/** x的初始位置。用于控制离子开始动画时的位置（X），默认值为0 */
		public var xStart:Number;
		/** x的结束位置。用于控制离子结束动画时的位置（X），默认值为25 */
		public var xEnd:Number;
		
		/** scale的初始比例大小。用于控制离子开始动画时的比例大小，默认值为0.5-1.5之间（随机产生） */
		public var scaleStart:Number;
		/** scale的结束比例大小。用于控制离子结束动画时的比例大小，默认值为（0.5-1.5）+0.5 */
		public var scaleEnd:Number;
		
		/** alpha的初始值。用于控制离子开始动画时的透明度，默认值为1 */
		public var alphaStart:Number;
		/** alpha的初始值。用于控制离子结束动画时的透明度，默认值为0 */
		public var alphaEnd:Number;
		
		/**
		 * 构造函数
		 */
		function Particle()
		{
			init();
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		/** 初始化 */
		private function init():void
		{
			time = 25;
			useSeconds = false;
			
			xStart = 0;
			xEnd = 25;
			
			var scale:Number = Math.random() * 1 + 0.5;
			scaleStart = scale;
			scaleEnd = scale - 0.5;
			
			alphaStart = 1;
			alphaEnd = 0;
			
			this.rotation = Math.random() * 360 - 180;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		/** 侦听器，类对象被添加到舞台 */
		private function addedHandler(eve:Event):void
		{
			eve.target.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			var tween1:Tween = new Tween(this.particleObject, "x", Strong.easeOut, xStart, xEnd, time, useSeconds);
			var tween2:Tween = new Tween(this.particleObject, "scaleX", Regular.easeOut, scaleStart, scaleEnd, time, useSeconds);
			var tween3:Tween = new Tween(this.particleObject, "scaleY", Regular.easeOut, scaleStart, scaleEnd, time, useSeconds);
			var tween4:Tween = new Tween(this.particleObject, "alpha", Regular.easeOut, alphaStart, alphaEnd, time, useSeconds);
			
			var timeNumber:Number;
			if(!useSeconds)
			{
				timeNumber = time * (1000 / this.stage.frameRate) + 50;
			}
			else
			{
				timeNumber = timeNumber * 1000 + 50;
			}
			var timer:Timer = new Timer(timeNumber, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			timer.start();
		}
		
		/** 侦听器，动画结束，清除对象 */
		private function timerHandler(eve:TimerEvent):void
		{
			eve.target.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
			this.parent.removeChild(this);
		}
	}
}