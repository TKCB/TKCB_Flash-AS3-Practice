/*
 * 描  述：具体类，用于侦听W、S、A、D是否按下，如果按下则，移动显示对象，并且可以设传入显示对象，和上下左右边界的数值
 * 作  者：TKCB
 * 创建日期：2012.01.04
 * 修改日期：2012.01.11
 */
package
{
	import flash.display.MovieClip;

	public class Main extends MovieClip
	{
		//变量man，创建可键盘控制的显示对象man
		private var man: KeyWSAD;
		/*
		 * 构造函数KeyWSAD，用于创建KeyWSAD类
		 * 代码1，执行方法initView，初始化各项数据
		 */
		public function Main()
		{
			initView();
		}
		/*
		 * 方法initView，用于初始化各个数据
		 * 代码1，使用静态工具类KeyboardListener中的keyListener方法侦听键盘
		 * 代码2，建立一个KeyWSAD类的实例并赋值给变量man
		 * 代码3，将显示对象man加入显示列表
		 */
		private function initView(): void
		{
			KeyboardListener.keyListener(stage);
			man = new KeyWSAD();
			addChild(man);
		}
	}
}
//一百二十列标尺********************************************************************************************************