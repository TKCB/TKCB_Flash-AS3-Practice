package 
{
	import flash.display.Sprite;
	import flash.display.NativeMenuItem;
	
	// ContextMenu类管理整个上下文菜单
	// ContextMenuItem类管理每一条菜单选项
	// ContextMenuClipboardItems类 管理文本框的上下文菜单
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuClipboardItems;
	
	import flash.events.ContextMenuEvent;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import flash.geom.ColorTransform;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ContextMenu 类控制上下文菜单，清除原有的选项、给上下文菜单添加选项、控制原有的选项（包括剪贴、复制、粘贴、删除、全选等等）
	 * @author TKCB
	 * @QQ 2414268040
	 * @E-mail tkcb@qq.com
	 */
	public class ContextMenuC extends Sprite
	{
		private var spr:Sprite;		// 加载外部的声音
		private var tf:TextField;	// 加载外部的声音
		
		/**
		* 构造函数
		*/
		public function ContextMenuC() {
			// 清除舞台的上下文菜单中的多余选项，因为设置和关于无法清除
			stage.showDefaultContextMenu = false;
			
			// 下面代码用于创建一个显示对象，并控制这个现实对象的上下文菜单
			spr = new Sprite();
			spr.graphics.beginFill(0xFFFF00);
			spr.graphics.drawRect(0, 0, 550, 200);
			spr.graphics.endFill();
			
			tf = new TextField();
			tf.text = "my name is TKCB！";
			tf.background = true;
			tf.border = true;
			tf.type = TextFieldType.INPUT;
			tf.width = 300;
			tf.height = 20;
			tf.x = 100;
			tf.y = 75;
			spr.addChild(tf);
			
			spr.contextMenu = createContextMenu();
			addChild(spr);
		}

		/**
		 * 用于设置上下文菜单，并返回设置好的上下文菜单
		 * @return 上下文菜单
		 */
		private function createContextMenu():ContextMenu {
			var editContextMenu:ContextMenu = new ContextMenu();
			editContextMenu.hideBuiltInItems();
			
			// 由于ContextMenuItem类不允许使用Cut、Copy、Paste这些词单独作为菜单的名称，所以以下代码等于无效
			var cutItem:ContextMenuItem = new ContextMenuItem("Cut");
			cutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, doCutHandler);
			editContextMenu.customItems.push(cutItem);
			
			// ContextMenuItem类管理每一条菜单选项
			var menu1:ContextMenuItem = new ContextMenuItem("菜单1，仅仅改变背景色");
			menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu1Handler);
			editContextMenu.customItems.push(menu1);
			
			var menu2:ContextMenuItem = new ContextMenuItem("菜单2，改变整个spr的颜色");
			menu2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu2Handler);
			editContextMenu.customItems.push(menu2);
			
			// 设置文本框的上下文菜单
			editContextMenu.clipboardItems = contextMenuCI();
			return editContextMenu;
		}
		
		/** 用于设置文本框的上下文菜单，并返回设置好的上下文菜单。返回文本框的上下文菜单 */
		private function contextMenuCI():ContextMenuClipboardItems {
			// 该类无法设置使用TextField类创建的文本框
			var cmci:ContextMenuClipboardItems = new ContextMenuClipboardItems();
			// 禁用文本框的所有菜单选项
			cmci.clear = false;
			cmci.copy = false;
			cmci.cut = false;
			cmci.paste = false;
			cmci.selectAll = false;
			return cmci;
		}

		/** 侦听器，Cut */
		private function doCutHandler(eve:ContextMenuEvent):void {
			trace("执行Cut命令");
		}
		
		/** 侦听器，菜单1，仅仅改变背景色 */
		private function menu1Handler(eve:ContextMenuEvent):void {
			spr.graphics.clear();
			// 随机获取颜色
			spr.graphics.beginFill(Math.random() * 0xFFFFFF + 0xFF000000);
			spr.graphics.drawRect(0, 0, 550, 200);
			spr.graphics.endFill();
		}
		
		/** 侦听器，菜单2，用于改变spr的背景色 */
		private function menu2Handler(eve:ContextMenuEvent):void {
			spr.transform.colorTransform = getColor();
		}
		
		/** 菜单2，改变整个spr的颜色 */
		private function getColor():ColorTransform {
			// 随机三原色
			var red:uint = (Math.random() * 512) - 255;
			var green:uint = (Math.random() * 512) - 255;
			var blue:uint = (Math.random() * 512) - 255;
			// 调整颜色，组合颜色
			var color:ColorTransform = new ColorTransform(1, 1, 1, 1, red, green, blue, 0);
			return color;
		}
	}
}