package
{

	/**
	 * 描 述：具体类，用影片剪辑替代Button组件，通过跳帧切换按钮状态。系统自带按钮组件在一定情况，会因为焦点与影片剪辑内元件的相互作用，产生难以解决的问题
	 * 作 者：TKCB-Gm（www.tkcb.cc）
	 * 创建日期：2012.03.16
	 * 修改日期：2012.03.16
	 */

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ButtonStatus extends MovieClip
	{

		/*
		 * 构造函数
		 */
		public function ButtonStatus()
		{
			//初始按钮停留在第一帧，即按钮弹起状态
			stop();

			//注册侦听器，侦听鼠标左键被按下事件
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			//注册侦听器，侦听鼠标左键弹起事件
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			//注册侦听器m，侦听鼠标滑过事件
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			//注册侦听器，侦听鼠标滑出事件
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
		}

		/*
		 * 侦听器，处理按钮状态事件
		 */
		function mouseHandler(eve: MouseEvent): void
		{

			switch (eve.type)
			{
				//鼠标左键弹起
				case MouseEvent.MOUSE_UP:
				case MouseEvent.ROLL_OUT:
					gotoAndStop(1);
					break;

					//鼠标滑入
				case MouseEvent.ROLL_OVER:
					gotoAndStop(2);
					break;

					//鼠标左键被按下
				case MouseEvent.MOUSE_DOWN:
					gotoAndStop(3);
					break;
			}
		}
	}
}
//打印标尺（120列）*****************************************************************************************************