package src.ball{
	
	/**
	* 描 述：发送自定义事件的类
	* 作 者：TKCB
	* 创建日期：2012.02.14
	* 修改日期：2012.02.14
	*/
	
	import flash.display.Sprite;
	import flash.events.Event;
	import src.ball.BallEvent;
	
	public class Ball extends Sprite{
		
		//用于设置图形坐标
		private var speedX:Number;
		private var speedY:Number;
		
		//限制碰撞边沿不会多次触发事件
		private var inOnBoundary:Boolean = false;
		//限制碰撞边沿不会多次触发事件
		private var inUnderBoundary:Boolean = false;
		//限制碰撞边沿不会多次触发事件
		private var inLeftBoundary:Boolean = false;
		//限制碰撞边沿不会多次触发事件
		private var inRightBoundary:Boolean = false;
		
		//用于发送自定义的事件
		private var ballEve:BallEvent;
		
		/*
		* 构造函数
		*/
		public function Ball(){
			
			//在实例中创建一个背景图
			buildBall();
			
			//设置实例坐标
			setLocal();
			
			//设置随机移动的方向和速度
			initSoeed();
			
			//注册侦听器，侦听帧频事件
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		public function initSoeed():void{
			
			speedX = Math.random() * 10 - 5;
			speedY = Math.random() * 10 - 5;
		}
		
		/*
		* 在实例中创建一个背景图
		*/
		private function buildBall():void{
			
			//设置填色
			this.graphics.beginFill(0xFF0000);
			//设置线条样式
			this.graphics.lineStyle(1);
			//绘制图形，这是绘制的是圆形
			this.graphics.drawCircle(0, 0, 30);
		}
		
				/*
		* 设置实例坐标
		*/
		private function setLocal():void{
			
			//设置实例坐标
			this.x = 550 / 2 - this.width / 2;
			this.y = 400 / 2 - this.height / 2;
		}
		
		/*
		* 侦听器，处理帧频事件
		*/
		public function enterFrameHandler(eve:Event):void{
			
			//设置实例坐标
			this.x += speedX;
			this.y += speedY;
			
			if(this.x < 0 + this.width / 2 && inLeftBoundary == false){
				
				//碰到左边的边界
				inLeftBoundary = true;
				
				//重新设置移动速度和移动方向
				//取随机整数
				speedX = Math.random() * 5;
				//取随机数
				speedY = Math.random() * 10 - 5;
				
				ballEve = new BallEvent(BallEvent.OVER_LINE);
				//设置自定义事件附带的信息
				ballEve.msg = "碰到了左边";
				//发送自定义事件
				this.dispatchEvent(ballEve);
			
			}else if(this.x > 0 + this.width / 2){
				
				//离开左边的边界
				inLeftBoundary = false;
				
			}
			
			if(this.x > 550 - this.width / 2 && inRightBoundary == false){
				
				//碰到右边的边界
				inRightBoundary = true;
				
				//重新设置移动速度和移动方向
				//获取随机整数并求反
				speedX = -(Math.random() * 5);
				//取随机数
				speedY = Math.random() * 10 - 5;
				
				ballEve = new BallEvent(BallEvent.OVER_LINE);
				//设置自定义事件附带的信息
				ballEve.msg = "碰到了右边";
				//发送自定义事件
				this.dispatchEvent(ballEve);
			}else if(this.x < 550 - this.width / 2){
				
				//离开右边的边界
				inRightBoundary = false;
			
			}
			
			if(this.y < 0 + this.height / 2 && inOnBoundary == false){
				
				//碰到上边的边界
				inOnBoundary = true;
				
				//重新设置移动速度和移动方向
				//取随机数
				speedX = Math.random() * 10 - 5;
				//取随机整数
				speedY = Math.random() * 5;
				
				ballEve = new BallEvent(BallEvent.OVER_LINE);
				//设置自定义事件附带的信息
				ballEve.msg = "碰到了上边";
				//发送自定义事件
				this.dispatchEvent(ballEve);
				
			}else if(this.y > 0 + this.height / 2){
				
				//离开上边的边界
				inOnBoundary = false;
			
			}
			
			if(this.y > 400 - this.height / 2 && inUnderBoundary == false){
				
				//碰到下边的边界
				inUnderBoundary  = true;
				
				//重新设置移动速度和移动方向
				//取随机数
				speedX = Math.random() * 10 - 5;
				//获取随机整数并求反
				speedY = -(Math.random() * 5);
				
				ballEve = new BallEvent(BallEvent.OVER_LINE);
				//设置自定义事件附带的信息
				ballEve.msg = "碰到了下边";
				//发送自定义事件
				this.dispatchEvent(ballEve);
			}else if(this.y < 400 - this.height / 2){
				
				//离开下边的边界
				inUnderBoundary = false;
			
			}
		}
	}
}
//一百二十列标尺********************************************************************************************************