// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Nm（TKCB乐队队长）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc
// 11RIA 闪客社区：www.11ria.com


package
{
	// ************************ ************************* 类库 ******************** *********** *** ** ** //
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;


	public class Main extends Sprite
	{
		//用于获取库中元件的数据类型
		private var __Key: Class;

		//用于创建库中元件
		private var key: MovieClip;


		/**
		 * 构造函数
		 */
		public function Main()
		{
			//调用类中的方法initView
			initView();

			//变量类型为库中元件的类型
			key = new __Key();
			key.x = stage.stageWidth / 2;
			key.y = stage.stageHeight / 2;
			addChild(key);
		}

		// 获取库中元件数据类型
		private function initView(): void
		{

			//获取库中元件的类型
			__Key = getDefinitionByName("Key") as Class;
		}
	}
}