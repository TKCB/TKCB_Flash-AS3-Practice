/**
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright TKCB, www.tkcb.cc
 *
 *
 * This is free software/program/code: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * 这是一个自由软件/程序/代码，您可以自由分发、修改其中的源代码或者重新发布它，
 * 新的任何修改后的重新发布版必须同样在遵守LGPL3或更后续的版本协议下发布。
 * 关于LGPL协议的细则请参考COPYING、COPYING.LESSER文件，
 * 你可以在文件夹中获得LGPL协议的副本，如果没有找到，请连接到 http://www.gnu.org/licenses/ 查看。
 *
 *
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */


/**
 * @version 版本创建时间和修改说明
 * v1.0.0 2025-7-28
 */
package cc.tkcb.utils
{
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.Point;


	/**
	 * NativeWindowTool 窗口工具 静态类，添加一些实用的扩展字符串的方法，比如，字符串插入，文件名称Win7方式排序等等
	 */
	public class NativeWindowTool
	{
		// ************************ ************************* 公共函数 ******************** *********** *** ** ** //
		/**
		 * 获取真实的舞台大小、窗口大小、以及窗口镶边的大小，大小指的是宽度和高度，这是基于舞台自适应大小模式（StageScaleMode.SHOW_ALL）
		 * 最好是在刚设置窗口大小之后，进行获取
		 * @param stageObj 舞台对象
		 * @param nw 指定的窗口宽度
		 * @param nh 指定的窗口高度
		 * @return 真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度的对象
		 */
		public static function getStageShowAllModeRealStageWH(stageObj:Stage, nw:int = 0, nh:int = 0): Object
		{
			//trace("getStageShowAllModeRealStageWH");
			
			// 先设置系统窗口为指定的舞台大小
			if (nw == 0 || nh == 0)
			{
				nw = stageObj.nativeWindow.width;
				nh = stageObj.nativeWindow.height;
			}
			stageObj.nativeWindow.width = nw;
			stageObj.nativeWindow.height = nh;
			//trace(stageObj.nativeWindow.width, stageObj.nativeWindow.height);
			
			// 之后就可以，临时获取到真实的舞台大小
			var realStageWidth: int = stageObj.stageWidth;
			var realStageHeight: int = stageObj.stageHeight;


			// 真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度
			var realObj: Object = {};
			realObj.stageWidth = realStageWidth;
			realObj.stageHeight = realStageHeight;
			realObj.nativeWindowWidth = stageObj.nativeWindow.width;
			realObj.nativeWindowHeight = stageObj.nativeWindow.height;
			realObj.windowBorderWidth = stageObj.nativeWindow.width - realStageWidth;
			realObj.windowBorderHeight = stageObj.nativeWindow.height - realStageHeight;

			return realObj;
		}
		
		
		/**
		 * 设置指定的舞台大小，窗口大小相应改变，其实原理还是调整窗口大小
		 * 因为窗口是包含镶边的，所以需要先获取窗口镶边大小，之后才能设置正确的窗口大小（舞台大小+镶边大小）
		 * @param stageObj 舞台对象
		 * @param stageWidth 指定的舞台宽度
		 * @param stageHeight 指定的舞台高度
		 * @return 真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度的对象
		 */
		public static function setNativeWindowStageWH(stageObj:Stage, stageWidth: int, stageHeight: int): Object
		{
			//trace("setNativeWindowStageWH");
			
			// 获取真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度，这是基于舞台自适应大小模式（StageScaleMode.SHOW_ALL）
			var realObj: Object = NativeWindowTool.getStageShowAllModeRealStageWH(stageObj, stageWidth, stageHeight);

			// 设置系统窗口宽度和高度为指定的舞台大小（例如：960*540、1280*720），加上对应的窗口镶边的宽度和高度
			stageObj.nativeWindow.width = stageWidth + realObj.windowBorderWidth;
			stageObj.nativeWindow.height = stageHeight + realObj.windowBorderHeight;
			
			//trace(stageWidth, realObj.windowBorderWidth, stageObj.nativeWindow.width);
			//trace(stageHeight, realObj.windowBorderHeight, stageObj.nativeWindow.height);
			
			// 重新调整舞台的宽度和高度
			realObj.nativeWindowWidth = stageWidth + realObj.windowBorderWidth;
			realObj.nativeWindowHeight = stageHeight + realObj.windowBorderHeight;
			
			return realObj;
		}


		/**
		 * 窗口居中显示，传入指定的舞台对象
		 * @param stageObj 舞台对象
		 */
		public static function nativeWindowAutoCenter(stageObj:Stage): Point
		{
			var xyPoint: Point = new Point((Screen.mainScreen.bounds.width - stageObj.nativeWindow.width) / 2, (Screen.mainScreen.bounds.height - stageObj.nativeWindow.height) / 2);
			stageObj.nativeWindow.x = xyPoint.x;
			stageObj.nativeWindow.y = xyPoint.y;
			
			return xyPoint;
		}
		
		
		
		
	}
}