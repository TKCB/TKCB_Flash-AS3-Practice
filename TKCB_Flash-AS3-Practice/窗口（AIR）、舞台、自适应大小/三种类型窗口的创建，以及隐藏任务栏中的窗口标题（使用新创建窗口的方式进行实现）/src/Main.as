// ******************************* 作者 ****************** *** ** ** //
// 作者：TKCB-Nm（TKCB乐队队长）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc
// 11RIA 闪客社区：www.11ria.com


package
{
	// ******************************* 类库 ****************** *** ** ** //
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	
	
	/**
	 * Main 文档类
	 */
	public class Main extends MovieClip
	{
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		// 新窗口的舞台对象（后续其他类都得用这个舞台对象进行操作了）
		public static var stageNew: Stage;
		
		// 原始窗口的舞台对象
		public static var stageObj: Stage;
		
		
		
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		/**
		 * 构造函数
		 */
		public function Main()
		{
			if (this.stage) addedToStage(null);
			else this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// 初始化
		private function addedToStage(eve: Event = null): void
		{
			if (eve != null) this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			// 测试按钮
			setBtnMouse();
		}
		
		
		
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// ************************ ************************* 测试按钮 ******************** *********** *** ** ** //
		// 测试按钮
		private function setBtnMouse(): void
		{
			// 创建窗口
			mainMC.btn1.addEventListener(MouseEvent.CLICK, mainMC_btnClick1);
			mainMC.btn2.addEventListener(MouseEvent.CLICK, mainMC_btnClick2);
			mainMC.btn3.addEventListener(MouseEvent.CLICK, mainMC_btnClick3);
			
			// 显示原窗口
			mainMC.btn99.addEventListener(MouseEvent.CLICK, mainMC_btnClick99);
		}
		
		// 典型窗口
		private function mainMC_btnClick1(eve: MouseEvent): void
		{
			newNativeWindow(NativeWindowType.NORMAL);
		}
		
		// 工具调板
		private function mainMC_btnClick2(eve: MouseEvent): void
		{
			newNativeWindow(NativeWindowType.UTILITY);
		}
		
		// 简单窗口
		private function mainMC_btnClick3(eve: MouseEvent): void
		{
			newNativeWindow(NativeWindowType.LIGHTWEIGHT);
		}
		
		// 显示原窗口
		private function mainMC_btnClick99(eve: MouseEvent): void
		{
			// 显示默认的窗口
			if (Main.stageObj != null && Main.stageObj.nativeWindow.closed == false)
			{
				Main.stageObj.nativeWindow.visible = true;
			}
		}

		
		
		
		
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		// ************************ ************************* 创建窗口 ******************** *********** *** ** ** //
		/**
		 * 创建窗口
		 * @param typeStr 窗口类型
		 */
		private function newNativeWindow(typeStr: String): void
		{
			// 关闭默认的窗口
			stage.nativeWindow.visible = false;		// 隐藏
			//stage.nativeWindow.close();		// 关闭
			
			
			// 设置新窗口的参数
			var option: NativeWindowInitOptions = new NativeWindowInitOptions;
			
			// 指定用户是否可以调整窗口大小
			option.resizable = true;
			
			// 指定用户是否可以最大化窗口
			option.maximizable = true;
			
			// 指定用户是否可以最小化窗口
			option.minimizable = false;
			
			// 指定使用此 NativeWindowInitOptions 创建的 NativeWindow 对象的渲染模式
			// AUTO  典型窗口（我推荐使用这个，其他模式我测试发现有一些问题）
			// CPU  CPU 模式窗口
			// DIRECT  直接模式窗口（设计大神推荐这个模式）
			// GPU  GPU 模式窗口。 
			option.renderMode = NativeWindowRenderMode.AUTO;
			
			// 窗口类型
			// NativeWindowType.NORMAL -- 一个典型窗口。普通窗口使用全尺寸镶边，并显示在 Windows 或 Linux 任务栏中。
			// NativeWindowType.UTILITY -- 一个工具调板。实用程序窗口使用较细的系统镶边，而且不显示在 Windows 的任务栏中。
			// NativeWindowType.LIGHTWEIGHT — 简单窗口不能包含系统镶边，而且不显示在 Windows 或 Linux 任务栏中。
			// 此外，在 Windows 中简单窗口没有系统菜单（Alt+空格键）。简单窗口适用于通知气泡和控件，例如用于打开短期显示区域的组合框。使用轻量类型时，必须将 systemChrome 设置为 NativeWindowSystemChrome.NONE。
			option.type = typeStr;
			
			// 指定是否为窗口提供系统镶边
			// ALTERNATE   保留供以后使用
			// NONE   无系统镶边
			// STANDARD   主机操作系统的标准镶边
			if (typeStr != NativeWindowType.LIGHTWEIGHT)
			{
				option.systemChrome = NativeWindowSystemChrome.STANDARD;
			}
			else
			{
				option.systemChrome = NativeWindowSystemChrome.NONE;
			}
			
			// 指定窗口是否支持针对桌面的透明度和 Alpha 混合
			option.transparent  = false;
			
			
			
			
			
			
			// 新窗口对象
			var newWindow: NativeWindow = new NativeWindow(option);
			
			// 窗口大小、XY
			newWindow.width = stage.nativeWindow.width;
			newWindow.height = stage.nativeWindow.height;
			newWindow.x = (Screen.mainScreen.bounds.width - newWindow.width) / 2;
			newWindow.y = (Screen.mainScreen.bounds.height - newWindow.height) / 2;
			
			// 窗口标题
			newWindow.title = "新窗口（" + stage.nativeWindow.title + "）";
			
			// 必须设置这两个，否则会出现缩放问题，不信可以自己注释这两行，试试
			// 当然或许是个人版本原因……
			// 但这是一条善意的提醒……
			newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			newWindow.stage.align = StageAlign.TOP_LEFT;
			
			// 激活显示窗口
			newWindow.activate();
			
			// 由于上面出现了缩放问题，故而尝试打印缩放属性，查找原因，但是最终找到的原因是：scaleMode、align这两个参数导致的
			//trace(this.scaleX);
			//trace(newWindow.stage.scaleX);
			//trace(newWindow.stage.contentsScaleFactor);
			//trace(newWindow.stage.scaleMode);
			
			
			
			
			// 创建窗口
			mainMC.btn1.enabled = false;
			mainMC.btn1.alpha = 0.55;
			mainMC.btn2.enabled = false;
			mainMC.btn2.alpha = 0.55;
			mainMC.btn3.enabled = false;
			mainMC.btn3.alpha = 0.55;
			mainMC.btn1.removeEventListener(MouseEvent.CLICK, mainMC_btnClick1);
			mainMC.btn2.removeEventListener(MouseEvent.CLICK, mainMC_btnClick2);
			mainMC.btn3.removeEventListener(MouseEvent.CLICK, mainMC_btnClick3);
			
			
			
			
			
			// 【下面代码说明】
			// 这里是将默认文档类的对象直接创建或移动到了新窗口上，所以看起来几乎一模一样，只有背景不同
			// 其实实际使用的时候，可能会是新开的窗口，放新的内容，比如就像是浏览器，开一个新的标签页内容应该是新的网页
			
			
			// 新窗口的舞台对象（后续其他类都得用这个舞台对象进行操作了）
			Main.stageNew = newWindow.stage;
		
			// 原始窗口的舞台对象
			Main.stageObj = stage;
			
			
			
			// 【方式1】：将文档类添加到新窗口的舞台上
			newWindow.stage.addChild(mainMC);
			
			
			
			// 【方式2】：新建一个MainMC对象并添加到新窗口的舞台上
			/*var mmc:MainMC = new MainMC();
			mmc.btn1.enabled = false;
			mmc.btn1.alpha = 0.55;
			mmc.btn2.enabled = false;
			mmc.btn2.alpha = 0.55;
			mmc.btn3.enabled = false;
			mmc.btn3.alpha = 0.55;
			mmc.btn1.removeEventListener(MouseEvent.CLICK, mainMC_btnClick1);
			mmc.btn2.removeEventListener(MouseEvent.CLICK, mainMC_btnClick2);
			mmc.btn3.removeEventListener(MouseEvent.CLICK, mainMC_btnClick3);
			newWindow.stage.addChild(mmc);*/
		}
		
		
		
		
		
	}
}