/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */
 
package utils
{
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flash.events.ContextMenuEvent;
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * 自定义右键菜单类
	 */
	public class CustomRightMenu
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 右键菜单对象 */
		private var contextMenu : ContextMenu;
		
		/** 菜单选项1 */
		private var menu1 : ContextMenuItem;
		
		/** 菜单选项2 */
		private var menu2 : ContextMenuItem;
		
		/** 菜单选项3 */
		private var menu3 : ContextMenuItem;
		
		/** 菜单选项4 */
		private var menu4 : ContextMenuItem;
		
		/** 菜单选项5 */
		private var menu5 : ContextMenuItem;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function CustomRightMenu ()
		{
			
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/**
		 * 用于设置右键菜单，并返回设置好的右键菜单
		 */
		public function setMenu () : ContextMenu
		{
			// 创建菜单，并屏蔽多余的菜单选项（放大、缩小、100%……）
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			//// ContextMenuItem是菜单项类
			
			menu1 = new ContextMenuItem( "开发单位：TKCB Band", false );		// 第一个参数设置菜单选项名称，第二个参数设置是否显示上分隔线
			menu1.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menu1Select );
			//menu1.enabled = false;		// 设置是否启动该菜单选项（不启动为灰色）
			contextMenu.customItems.push( menu1 );
			
			menu2 = new ContextMenuItem( "网　　址：http://www.tkcb.cc", false );
			menu2.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menu2Select );
			// menu2.enabled = false;
			contextMenu.customItems.push( menu2 );
			
			menu3 = new ContextMenuItem( "产　　品：King Soft", true );
			menu3.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menu3Select );
			menu3.enabled = false;
			contextMenu.customItems.push( menu3 );
			
			menu4 = new ContextMenuItem( "版　　本：v1.0.0", false );
			menu4.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menu4Select );
			menu4.enabled = false;
			contextMenu.customItems.push( menu4 );
			
			menu5 = new ContextMenuItem( "版权声明：未经允许不得以任何方式复制、盗用、链接。", true );
			menu5.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menu5Select );
			menu5.enabled = false;
			contextMenu.customItems.push( menu5 );
			
			return contextMenu;
		}
		
		/**
		 * 菜单选项1
		 */
		private function menu1Select ( eve : ContextMenuEvent ) : void
		{
			// navigateToURL( new URLRequest("http://www.tkcb.cc") );
		}
		
		/**
		 * 菜单选项2
		 */
		private function menu2Select ( eve : ContextMenuEvent ) : void
		{
			navigateToURL( new URLRequest("http://www.tkcb.cc") );
		}
		
		/**
		 * 菜单选项3
		 */
		private function menu3Select ( eve : ContextMenuEvent ) : void
		{
			// navigateToURL( new URLRequest("http://www.tkcb.cc") );
		}
		
		/**
		 * 菜单选项4
		 */
		private function menu4Select ( eve : ContextMenuEvent ) : void
		{
			// navigateToURL( new URLRequest("http://www.tkcb.cc") );
		}
		
		/**
		 * 菜单选项5
		 */
		private function menu5Select ( eve : ContextMenuEvent ) : void
		{
			// navigateToURL( new URLRequest("http://www.tkcb.cc") );
		}
		
	}
}


