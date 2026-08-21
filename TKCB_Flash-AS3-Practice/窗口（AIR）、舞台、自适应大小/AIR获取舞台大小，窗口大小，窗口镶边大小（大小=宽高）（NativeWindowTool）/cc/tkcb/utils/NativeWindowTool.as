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
 * v1.1.1 2025-9-24 增加了一些注释
 */
package cc.tkcb.utils
{
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.Point;


	/**
	 * NativeWindowTool 窗口工具 静态类，获取和设置窗口有关的扩展方法
	 * 比如：
	 * getStageShowAllModeRealStageWH() 获取真实的舞台大小、窗口大小、以及窗口镶边的大小
	 * setNativeWindowStageWH() 设置指定的舞台大小，窗口大小相应改变
	 * nativeWindowAutoCenter() 窗口居中显示
	 */
	public class NativeWindowTool
	{
		// ************************ ************************* 公共函数 ******************** *********** *** ** ** //
		/**
		 * 获取真实的舞台宽高、窗口宽高、以及窗口镶边宽高，这是基于舞台自适应模式（StageScaleMode.SHOW_ALL）
		 * 最好是在刚设置窗口之后，进行获取
		 * @param stageObj 舞台对象
		 * @param nw 指定的窗口宽度
		 * @param nh 指定的窗口高度
		 * @return 真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度的对象
		 */
		public static function getStageShowAllModeRealStageWH(stageObj:Stage, nw:int = 0, nh:int = 0): Object
		{
			trace("getStageShowAllModeRealStageWH");
			
			// 先设置系统窗口为指定的舞台大小
			if (nw == 0 || nh == 0)
			{
				nw = stageObj.nativeWindow.width;
				nh = stageObj.nativeWindow.height;
			}
			//stageObj.nativeWindow.width = nw;
			//stageObj.nativeWindow.height = nh;
			trace(stageObj.nativeWindow.width, stageObj.nativeWindow.height);
			
			// 之后就可以，临时获取到真实的舞台大小
			var realStageWidth: int = stageObj.stageWidth;
			var realStageHeight: int = stageObj.stageHeight;


			// 真实的舞台宽度和高度，以及窗口镶边的镶边宽度和高度
			var realObj: Object = {};
			realObj.stageWidth = realStageWidth;											// 舞台宽度（width）
			realObj.stageHeight = realStageHeight;											// 舞台高度（height）
			
			realObj.nativeWindowWidth = stageObj.nativeWindow.width * stageObj.contentsScaleFactor;						// 窗口宽度（width）
			realObj.nativeWindowHeight = stageObj.nativeWindow.height * stageObj.contentsScaleFactor;						// 窗口高度（height）
			
			realObj.windowBorderWidth = stageObj.nativeWindow.width * stageObj.contentsScaleFactor - realStageWidth * stageObj.contentsScaleFactor;		// 镶边宽度（width）
			realObj.windowBorderHeight = stageObj.nativeWindow.height * stageObj.contentsScaleFactor - realStageHeight * stageObj.contentsScaleFactor;	// 镶边高度（height）

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
			//// 窗口居中显示
			// 由于经过了系统缩放值（contentsScaleFactor），则计算窗口居中就不是那么简单的事情了
			// 1. 先计算在设定的1920*1080下，AIR窗口(舞台)默认宽高下，应该的居中坐标值，其实这个就是最基础的计算方法
			// 举例：stage.contentsScaleFactor = 1.25，percentage = 1，则假如舞台尺寸为800*600，实际的AIR窗口(舞台)宽高为1000*750，但在此处依旧是800*600为计算
			// 但由于这个contentsScaleFactor是系统和AIR的行为，所以为了不影响程序的代码编写，所以在计算的时候，还应该以基础的默认的设定为准，也就是以1920*1080下，窗口800*600这两组数组进行计算坐标值
			// 所以看到，第一步中，就是以设计的基准屏幕宽高(screenInitWidth) 和 舞台宽高(stageWidth)为基准（含二次缩放）
			var defaultX: int = (1920 - 1920) / 2;
			var defaultY: int = (1080 - 1080) / 2;

			// 2. 由于第一步只是做了默认设定下的舞台宽高坐标值，并没有计算实际屏幕超出设定的部分，则第二步就是要把超出的部分计算出来。
			// 举例：如果实际屏幕为2560*1440，contentsScaleFactor = 1.25，则计算出来的值为2400（1920*1.25）* 1350（1080*1.25），所以需要计算出差值2560-2400=160，1440-1350=90,
			// 之后160,90，需要再用contentsScaleFactor值，还原为未缩放的比例值，才能计算出正确的补偿值，所以需要 / stage.contentsScaleFactor
			var compensateX: int = (Screen.mainScreen.bounds.width - 1920 * stageObj.contentsScaleFactor) / 2 / stageObj.contentsScaleFactor;
			var compensateY: int = (Screen.mainScreen.bounds.height - 1080 * stageObj.contentsScaleFactor) / 2 / stageObj.contentsScaleFactor;

			stageObj.nativeWindow.x = defaultX + compensateX;
			stageObj.nativeWindow.y = defaultY + compensateY;
			
			
			
			var xyPoint: Point = new Point((Screen.mainScreen.bounds.width - stageObj.nativeWindow.width) / 2, (Screen.mainScreen.bounds.height - stageObj.nativeWindow.height) / 2);
			/*stageObj.nativeWindow.x = xyPoint.x;
			stageObj.nativeWindow.y = xyPoint.y;
			*/
			return xyPoint;
		}
		
		
		
		
	}
}