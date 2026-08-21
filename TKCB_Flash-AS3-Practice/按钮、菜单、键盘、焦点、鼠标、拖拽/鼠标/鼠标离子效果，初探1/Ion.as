package
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * ...
	 * @author TKCB
	 */
	public class Ion extends MovieClip
	{
		private var speedXY: Number; // XY总速度
		private var speedX: Number; // X速度
		private var speedY: Number; // Y速度
		private var speedZ: Number; // Z速度

		private var disappearZ: Number; // Z消失距离

		private var widthHalf: Number; // 宽度的二分之一
		private var heightHalf: Number; // 高度的二分之一

		/**
		 * 构造函数
		 */
		public function Ion()
		{
			init();
			this.addEventListener(Event.ADDED_TO_STAGE, addHandler);
		}

		/** 初始化 */
		private function init(): void
		{
			// 随机速度。2 2 都是速度参数，越高移动速度越快，前面参数越大速度变化越大，后面是基数
			speedXY = Math.random() * 4 + 6;
			var num: Number = Math.random();
			speedX = speedXY * num;
			speedY = speedXY * (1 - num);
			speedZ = -(Math.random() * 2 + 2);

			// 随机方向。默认即可
			if (Math.random() > 0.5) speedX = -speedX;
			if (Math.random() > 0.5) speedY = -speedY;

			// 随机大小，宽高同比例缩放，1 1 都是大小参数，前面参数越大大小变化越大，后面是基数
			this.scaleX = Math.random() * 1 + 0.5;
			this.scaleY = this.scaleX;

			// 获取二分之一宽高，用于做计算
			widthHalf = this.width / 2;
			heightHalf = this.height / 2;

			// 随机旋转。默认即可
			this.rotationX = Math.random() * 360;
			this.rotationY = Math.random() * 360;
			this.rotationZ = Math.random() * 360;

			// 随机透明度，0.3 透明度参数，1为最高不透明。0.3为基数
			this.alpha = Math.random() + 0.3;

			disappearZ = -50;
		}

		/** 对象被添加到显示列表 */
		private function addHandler(eve: Event): void
		{
			eve.target.removeEventListener(Event.ENTER_FRAME, addHandler);
			this.addEventListener(Event.ENTER_FRAME, mobileHandler);
		}

		/** 移动事件 */
		private function mobileHandler(eve: Event): void
		{
			var xBoo: Boolean = this.x < (-widthHalf) || this.x > (stage.stageWidth + widthHalf);
			var yBoo: Boolean = this.y < (-heightHalf) || this.y > (stage.stageHeight + heightHalf);
			var zBoo: Boolean = this.z < disappearZ;
			if (xBoo || yBoo || zBoo)
			{
				eve.target.removeEventListener(Event.ENTER_FRAME, mobileHandler);
				this.parent.removeChild(this);
			}
			else
			{
				this.x += speedX;
				this.y += speedY;
				this.y -= speedZ;
			}
		}
	}
}