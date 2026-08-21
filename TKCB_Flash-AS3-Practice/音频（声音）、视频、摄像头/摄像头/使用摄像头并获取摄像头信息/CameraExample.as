package
{
	import flash.display.Sprite;

	import flash.events.StatusEvent;
	import flash.events.TimerEvent;

	import flash.media.Camera;
	import flash.media.Video;

	import flash.utils.Timer;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * CameraExample类 用于连接摄像头，并获取摄像头信息
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class CameraExample extends Sprite
	{
		private var cam: Camera; // 摄像头，用于控制摄像头
		private var vid: Video; // 视频，用于显示摄像头中的视频

		private var timer: Timer; // 计时器，用于刷新摄像头的信息
		private var __tf: TextField; // 文本框，用于显示摄像头的信息

		/**
		 * 构造函数
		 */
		function CameraExample()
		{
			__tf = tf;
			// 判断是否安装有摄像头
			if (Camera.names.length > 0)
			{
				trace("有可以使用的摄像头...");
				cam = Camera.getCamera();
				cam.addEventListener(StatusEvent.STATUS, statusHandler);
				cam.setMode(1024, 768, 25);
				vid = new Video();
				vid.attachCamera(cam);
			}
			else
			{
				trace("没有摄像头！！！");
			}
		}

		/** 侦听器，使用摄像头传输视频 */
		private function statusHandler(eve: StatusEvent): void
		{
			cam.removeEventListener(StatusEvent.STATUS, statusHandler);

			// 判断用户是拒绝还是允许访问摄像头
			switch (eve.code)
			{
				case "Camera.Muted":
					trace("用户拒绝访问摄像头！！！");
					break;

				case "Camera.Unmuted":
					trace("用户允许访问摄像头...");
					// 下面代码用于设置摄像头的视频
					vid.x = 50;
					vid.y = 100;
					vid.width = 320;
					vid.height = 240;
					trace(cam.width, cam.height);
					addChild(vid);

					// 下面代码用于设置摄像头的信息文本
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, timerHandler);
					timer.start();

					__tf.border = true;
					// __tf.autoSize = TextFieldAutoSize.LEFT;// 左对齐
					__tf.wordWrap = true; // 自动换行
					addChild(__tf);
					break;
			}
		}

		/** 刷新摄像头信息 */
		private function timerHandler(eve: TimerEvent): void
		{
			__tf.text = "";
			__tf.appendText("摄像头宽度：" + cam.width + "，摄像头高度：" + cam.height);
			__tf.appendText("\nactivityLevel：摄像头正在检测的运动量 — " + cam.activityLevel);
			__tf.appendText("\nbandwidth：当前输出视频输入信号可以使用的最大带宽，以字节为单位 — " + cam.bandwidth);
			__tf.appendText("\ncurrentFPS：摄像头捕获数据的速率，以每秒帧数为单位 — " + cam.currentFPS);
			__tf.appendText("\nfps：摄像头捕获数据的最大速率，以每秒帧数为单位 — " + cam.fps);
			__tf.appendText("\nkeyFrameInterval：完整传输而没有使用视频压缩算法进行插值处理的视频帧（称为关键帧）数 — " + cam.keyFrameInterval);
			__tf.appendText("\nloopback：表示在本地查看摄像头所捕获的图像时是进行压缩和解压缩 (true)，就像使用 Flash Media Server 进行实时传输一样，还是不进行压缩 (false) — " + cam.loopback);
			__tf.appendText("\nmotionLevel：调用 activity 事件所需的运动量 — " + cam.motionLevel);
			__tf.appendText("\nmotionTimeout：摄像头停止检测运动的时间与调用 activity 事件的时间之间相差的毫秒数 — " + cam.motionTimeout);
			__tf.appendText("\nquality：所需的图片品质级别，该级别是由应用于每个视频帧的压缩量决定的 — " + cam.quality + "\n");
		}
	}
}