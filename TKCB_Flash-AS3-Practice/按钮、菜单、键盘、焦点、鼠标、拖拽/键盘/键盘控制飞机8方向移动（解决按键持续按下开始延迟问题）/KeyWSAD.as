/*
 * 描  述：具体类，用于侦听W、S、A、D是否按下，如果按下则，移动显示对象，并且可以设传入显示对象，和上下左右边界的数值
 * 作  者：TKCB
 * 创建日期：2012.01.04
 * 修改日期：2012.01.11
 */
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class KeyWSAD extends Sprite
	{
		//变量__Man，用于存储的库中元件的类型
		private var __Man: Class;
		//变量man，用于创建指定的库中元件的类型的显示对象
		private var man: Sprite;
		//变量top，用于记录顶部数值，控制的对象向上移动不可以超过这个数值
		private var top: int;
		//变量bottom，用于记录底部数值，控制的对象向下移动不可以超过这个数值
		private var bottom: int;
		//变量left，用于记录左边数值，控制的对象向左移动不可以超过这个数值
		private var left: int;
		//变量right，用于记录右边数值，控制的对象向右移动不可以超过这个数值
		private var right: int;
		//变量speed，用于控制显示对象的移动速度
		private var speed: Number;
		/*
		 * 构造函数KeyWSAD，用于创建KeyWSAD类
		 * 代码1，执行方法initView，初始化各项数据
		 */
		public function KeyWSAD()
		{
			initView();
		}
		/*
		* 方法initObj，用于初始化各个数据，并且注册侦听器
		* 代码1，获取库中元件的类型，并赋值给变量__Man
		* 代码2，将__Man获取的类型赋给显示对象man
		* 代码3，设置变量man的X轴为275
		* 代码4，设置变量man的Y轴为200
		* 代码5，将显示对象man加入KeyWSAD类实例的显示列表
		* 代码6，初始化变量top，赋值为0
		* 代码7，初始化变量bottom，赋值为400
		* 代码8，初始化变量left，赋值为0
		* 代码9，初始化变量right，赋值为550
		* 代码10，初始化变量speed，赋值为3
		* 代码11，使用KeyWSAD类的实例注册注册侦听器，侦听显示对象controlObj发出的Event.ENTER_FRAME事件，并用侦听器
			keyControlDirection来处理。返回值为void类型
		*/
		public function initView(): void
		{
			__Man = getDefinitionByName("Man") as Class;
			man = new __Man();
			man.x = 275;
			man.y = 200;
			this.addChild(man);
			top = 0;
			bottom = 400;
			left = 0;
			right = 550;
			speed = 4;
			this.addEventListener(Event.ENTER_FRAME, keyControlDirection);
		}
		/*
		 * 侦听器keyControlDirection，侦听事件Event.ENTER_FRAME，用于控制显示对象controlObj的上下左右。返回值为void类型
		 * 参数eve，是侦听到的事件对象
		 * 代码1，判断w（87）是否按下和显示对象man的Y轴位置是否大于规定值，如果两个条件都为true，则控制显示对象man向上移动
		 * 代码2，判断s（83）是否按下和显示对象man的Y轴位置是否小于规定值，如果两个条件都为true，则控制显示对象man向下移动
		 * 代码3，判断a（65）是否按下和显示对象man的X轴位置是否大于规定值，如果两个条件都为true，则控制显示对象man向左移动
		 * 代码4，判断d（68）是否按下和显示对象man的X轴位置是否小于规定值，如果两个条件都为true，则控制显示对象man向右移动
		 * 代码5，判断↑（38）是否按下和显示对象man的Y轴位置是否大于规定值，如果两个条件都为true，则控制显示对象man向上移动
		 * 代码6，判断↓（40）是否按下和显示对象man的Y轴位置是否小于规定值，如果两个条件都为true，则控制显示对象man向下移动
		 * 代码7，判断←（37）是否按下和显示对象man的X轴位置是否大于规定值，如果两个条件都为true，则控制显示对象man向左移动
		 * 代码8，判断→（39）是否按下和显示对象man的X轴位置是否小于规定值，如果两个条件都为true，则控制显示对象man向右移动
		 */
		private function keyControlDirection(eve: Event): void
		{
			if (KeyboardListener.isDown(87) && man.y > top) man.y -= speed;
			if (KeyboardListener.isDown(83) && man.y < bottom) man.y += speed;
			if (KeyboardListener.isDown(65) && man.x > left) man.x -= speed;
			if (KeyboardListener.isDown(68) && man.x < right) man.x += speed;
			if (KeyboardListener.isDown(38) && man.y > top) man.y -= speed;
			if (KeyboardListener.isDown(40) && man.y < bottom) man.y += speed;
			if (KeyboardListener.isDown(37) && man.x > left) man.x -= speed;
			if (KeyboardListener.isDown(39) && man.x < right) man.x += speed;
		}
	}
}
//一百二十列标尺********************************************************************************************************