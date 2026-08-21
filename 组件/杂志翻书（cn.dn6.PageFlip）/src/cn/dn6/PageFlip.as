/**
*
* 6dn PageFlip

*----------------------------------------------------------------
* @notice 6dn PageFlip翻页类
* @author 6dn
* @as version3.0
* @date 2009-1-4
*
* AUTHOR ******************************************************************************
* 
* authorName : 黎新苑 - www.6dn.cn
* QQ :160379558(小星@6dn)
* MSN :xdngo@hotmail.com
* email :6dn@6dn.cn
* webpage :       http://www.6dn.cn
* 
* LICENSE ******************************************************************************
* 
* ① 此类是在AS3基础上编写,只能对使用as3的swf文件完全支持!
* ② 基本上实现了现有的杂志功能,支持显示阴影,支持拖动翻页以及点击翻页，支持单页和双页显示，支持页面跳转；
* ③ 使用内部xml或外部xml，支持外部读取jpg、gif、png、swf并可混合使用；
* ④ 可扩展实现缩略图预览，可扩展添加loading；
* ⑤ 可自由设置Timer，值越小翻页越流畅，值越大占用CPU越小；
* ⑥ 此类作为开源使用，但请重视作者劳动成果，请使用此类的朋友保留作者信息。
* Please, keep this header and the list of all authors
* 
*/


/**
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 6dn
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
 * 修 改 者：TKCB
 * 改者网站：www.tkcb.cc
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
 * v1.0.0 2016-2-8
 * v1.1.1 2022-11-10 之前几天优化了阴影的问题，今天增加了onPageStart回调函数，并且允许禁止翻到首页和尾页（book_banHomeLast）
 * v1.2.2 2023-1-5 允许禁止手动拖拽翻页（book_banDrag）
 * v2.0.3 2025-5-31 优化BUG，以及给pageGoto()函数添加了强制翻页的参数，另外重要的是，制作了单页翻书的版本PageFlipOne，后续如果有优化和修改，尽量做到两个版本同步进行（PageFlip、PageFlipOne）
 */

package cn.dn6
{
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;

	/**
	 * PageFlip 翻书效果组件，双页翻书
	 */
	public class PageFlip
	{
		//可设置或可调用接口,页数以单页数计算~---------------------------------------
		public var myXML: XML;
		public var book_root: MovieClip; //装载book的MC
		public var book_initpage: Number = 0; //初始化到第N页
		public var book_totalpage: Number = 0; //总页数
		public var book_TimerNum: Number = 30; //Timer的间隔时间
		public var book_page: Number = 0; //当前页
		public var book_banHomeLast: Boolean = false; //禁止翻到首页和尾页
		public var book_banDrag: Boolean = false; //禁止手动拖拽翻页

		public var onLoadinit: Function = null; //加载外部影片或图片时调用
		public var onLoading: Function = null; //正在加载外部影片或图片时调用
		public var onLoadEnd: Function = null; //加载外部影片或图片完毕时调用
		public var onPageStart: Function = null; //翻页动作开始时调用
		public var onPageEnd: Function = null; //翻页动作结束时调用
		//pageGoto:Function;//翻页跳转
		//pageDraw:Function;//绘制缩略图
		//initBook:Function;//初始化
		//END!!--------------------------------------------------------------------

		private var book_width: Number;
		private var book_height: Number;
		private var book_topage: Number;

		private var book_CrossGap: Number;
		private var bookArray_layer1: Array;
		private var bookArray_layer2: Array;

		private var book_TimerFlag: String = "stop";
		private var book_TimerArg0: Number = 0;
		private var book_TimerArg1: Number = 0;
		private var u: Number;
		private var book_px: Number = 0;
		private var book_py: Number = 0;
		private var book_toposArray: Array;
		private var book_myposArray: Array;
		private var book_timer: Timer;

		private var Bmp0: BitmapData;
		private var Bmp1: BitmapData;
		private var bgBmp0: BitmapData;
		private var bgBmp1: BitmapData;

		private var pageMC: Sprite = new Sprite();
		private var bgMC: Sprite = new Sprite();

		private var render0: Shape = new Shape();
		private var render1: Shape = new Shape();
		private var shadow0: Shape = new Shape();
		private var shadow1: Shape = new Shape();

		private var Mask0: Shape = new Shape();
		private var Mask1: Shape = new Shape();

		private var p1: Point;
		private var p2: Point;
		private var p3: Point;
		private var p4: Point;

		private var limit_point1: Point;
		private var limit_point2: Point;



		// 强行翻页页数，再pageGoto()函数中传递的翻页页码数
		private var topageForce: int;

		// 是否在动画翻页结束之后，强行调用一次pageGoto()函数进行翻页
		private var isForceFlip: Boolean = false;

		//**init Parts------------------------------------------------------------------------
		public function initBook(wNum: int, hNum: int): void
		{
			book_width = wNum;
			book_height = hNum;
			book_totalpage = myXML.child("page").length();
			book_page = book_topage = book_initpage;
			book_CrossGap = Math.sqrt(book_width * book_width + book_height * book_height);

			p1 = new Point(0, 0);
			p2 = new Point(0, book_height);
			p3 = new Point(book_width + book_width, 0);
			p4 = new Point(book_width + book_width, book_height);

			limit_point1 = new Point(book_width, 0);
			limit_point2 = new Point(book_width, book_height);

			book_toposArray = [p3, p4, p1, p2];
			book_myposArray = [p1, p2, p3, p4];

			book_root.addChild(pageMC);
			book_root.addChild(bgMC);
			SetFilter(pageMC);
			SetFilter(bgMC);

			book_root.addChild(Mask0);
			book_root.addChild(Mask1);

			book_root.addChild(render0);
			book_root.addChild(shadow0);
			book_root.addChild(render1);
			book_root.addChild(shadow1);

			SetLoadMC();
			SetPageMC(book_page);
			book_timer = new Timer(book_TimerNum, 0);

			if (book_banDrag == false)
			{
				book_root.stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseOnDown);
				book_root.stage.addEventListener(MouseEvent.MOUSE_UP, MouseOnUp);
			}

			book_timer.addEventListener("timer", bookTimerHandler);

		}
		//End init------------------------------------------------------------------------

		//**DrawPage Parts------------------------------------------------------------------------
		private function DrawPage(num: Number, _movePoint: Point, bmp1: BitmapData, bmp2: BitmapData): void
		{

			//var _movePoint:Point=new Point(mouseX,mouseY);
			var _actionPoint: Point;

			var book_array: Array;
			var book_Matrix1: Matrix = new Matrix();
			var book_Matrix2: Matrix = new Matrix();
			var Matrix_angle: Number;

			if (num == 1)
			{
				_movePoint = CheckLimit(_movePoint, limit_point1, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point2, book_CrossGap);

				book_array = GetBook_array(_movePoint, p1, p2);
				_actionPoint = book_array[1];
				GetLayer_array(_movePoint, _actionPoint, p1, p2, limit_point1, limit_point2);

				DrawShadowShap(1, shadow0, Mask0, book_width * 1.5, book_height * 4, p1, _movePoint, new Array(p1, p3, p4, p2), 0.5);
				DrawShadowShap(2, shadow1, Mask1, book_width * 1.5, book_height * 4, p1, _movePoint, bookArray_layer1, 0.45);


				Matrix_angle = angle(_movePoint, _actionPoint) + 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = book_array[3].x;
				book_Matrix1.ty = book_array[3].y;

				book_Matrix2.tx = p1.x;
				book_Matrix2.ty = p1.y;
			}
			else if (num == 2)
			{
				_movePoint = CheckLimit(_movePoint, limit_point2, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point1, book_CrossGap);

				book_array = GetBook_array(_movePoint, p2, p1);
				_actionPoint = book_array[1];
				GetLayer_array(_movePoint, _actionPoint, p2, p1, limit_point2, limit_point1);

				DrawShadowShap(1, shadow0, Mask0, book_width * 1.5, book_height * 4, p2, _movePoint, new Array(p1, p3, p4, p2), 0.5);
				DrawShadowShap(2, shadow1, Mask1, book_width * 1.5, book_height * 4, p2, _movePoint, bookArray_layer1, 0.45);

				Matrix_angle = angle(_movePoint, _actionPoint) - 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = book_array[2].x;
				book_Matrix1.ty = book_array[2].y;

				book_Matrix2.tx = p1.x;
				book_Matrix2.ty = p1.y;
			}
			else if (num == 3)
			{
				_movePoint = CheckLimit(_movePoint, limit_point1, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point2, book_CrossGap);

				book_array = GetBook_array(_movePoint, p3, p4);
				_actionPoint = book_array[1];
				GetLayer_array(_movePoint, _actionPoint, p3, p4, limit_point1, limit_point2);


				DrawShadowShap(1, shadow0, Mask0, book_width * 1.5, book_height * 4, p3, _movePoint, new Array(p1, p3, p4, p2), 0.5);
				DrawShadowShap(2, shadow1, Mask1, book_width * 1.5, book_height * 4, p3, _movePoint, bookArray_layer1, 0.4);

				Matrix_angle = angle(_movePoint, _actionPoint) + 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = _movePoint.x;
				book_Matrix1.ty = _movePoint.y;

				book_Matrix2.tx = limit_point1.x;
				book_Matrix2.ty = limit_point1.y;
			}
			else
			{
				_movePoint = CheckLimit(_movePoint, limit_point2, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point1, book_CrossGap);

				book_array = GetBook_array(_movePoint, p4, p3);
				_actionPoint = book_array[1];
				GetLayer_array(_movePoint, _actionPoint, p4, p3, limit_point2, limit_point1);

				DrawShadowShap(1, shadow0, Mask0, book_width * 1.5, book_height * 4, p4, _movePoint, new Array(p1, p3, p4, p2), 0.5);
				DrawShadowShap(2, shadow1, Mask1, book_width * 1.5, book_height * 4, p4, _movePoint, bookArray_layer1, 0.4);

				Matrix_angle = angle(_movePoint, _actionPoint) - 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = _actionPoint.x;
				book_Matrix1.ty = _actionPoint.y;

				book_Matrix2.tx = limit_point1.x;
				book_Matrix2.ty = limit_point1.y;
			}
			//trace(bookArray_layer2)
			//
			DrawShape(render1, bookArray_layer1, bmp1, book_Matrix1);
			DrawShape(render0, bookArray_layer2, bmp2, book_Matrix2);
		}

		private function CheckLimit($point: Point, $limitPoint: Point, $limitGap: Number): Point
		{

			var $Gap: Number = Math.abs(pos($limitPoint, $point));
			var $Angle: Number = angle($limitPoint, $point);
			if ($Gap > $limitGap)
			{
				var $tmp1: Number = $limitGap * Math.sin(($Angle / 180) * Math.PI);
				var $tmp2: Number = $limitGap * Math.cos(($Angle / 180) * Math.PI);
				$point = new Point($limitPoint.x - $tmp2, $limitPoint.y - $tmp1);
			}
			return $point;

		}
		private function GetBook_array($point: Point, $actionPoint1: Point, $actionPoint2: Point): Array
		{

			var array_return: Array = new Array();
			var $Gap1: Number = Math.abs(pos($actionPoint1, $point) * 0.5);
			var $Angle1: Number = angle($actionPoint1, $point);
			var $tmp1_2: Number = $Gap1 / Math.cos(($Angle1 / 180) * Math.PI);
			var $tmp_point1: Point = new Point($actionPoint1.x - $tmp1_2, $actionPoint1.y);

			var $Angle2: Number = angle($point, $tmp_point1) - angle($point, $actionPoint2);
			var $Gap2: Number = pos($point, $actionPoint2);
			var $tmp2_1: Number = $Gap2 * Math.sin(($Angle2 / 180) * Math.PI);
			var $tmp2_2: Number = $Gap2 * Math.cos(($Angle2 / 180) * Math.PI);
			var $tmp_point2: Point = new Point($actionPoint1.x + $tmp2_2, $actionPoint1.y + $tmp2_1);

			var $Angle3: Number = angle($tmp_point1, $point);
			var $tmp3_1: Number = book_width * Math.sin(($Angle3 / 180) * Math.PI);
			var $tmp3_2: Number = book_width * Math.cos(($Angle3 / 180) * Math.PI);

			var $tmp_point3: Point = new Point($tmp_point2.x + $tmp3_2, $tmp_point2.y + $tmp3_1);
			var $tmp_point4: Point = new Point($point.x + $tmp3_2, $point.y + $tmp3_1);

			array_return.push($point);
			array_return.push($tmp_point2);
			array_return.push($tmp_point3);
			array_return.push($tmp_point4);

			return array_return;

		}
		private function GetLayer_array($point1: Point, $point2: Point, $actionPoint1: Point, $actionPoint2: Point, $limitPoint1: Point, $limitPoint2: Point): void
		{

			var array_layer1: Array = new Array();
			var array_layer2: Array = new Array();
			var $Gap1: Number = Math.abs(pos($actionPoint1, $point1) * 0.5);
			var $Angle1: Number = angle($actionPoint1, $point1);

			var $tmp1_1: Number = $Gap1 / Math.sin(($Angle1 / 180) * Math.PI);
			var $tmp1_2: Number = $Gap1 / Math.cos(($Angle1 / 180) * Math.PI);

			var $tmp_point1: Point = new Point($actionPoint1.x - $tmp1_2, $actionPoint1.y);
			var $tmp_point2: Point = new Point($actionPoint1.x, $actionPoint1.y - $tmp1_1);

			var $tmp_point3 = $point2;

			var $Gap2: Number = Math.abs(pos($point1, $actionPoint2));
			//---------------------------------------------
			if ($Gap2 > book_height)
			{
				array_layer1.push($tmp_point3);
				//
				var $pos: Number = Math.abs(pos($tmp_point3, $actionPoint2) * 0.5);
				var $tmp3: Number = $pos / Math.cos(($Angle1 / 180) * Math.PI);
				$tmp_point2 = new Point($actionPoint2.x - $tmp3, $actionPoint2.y);

			}
			else
			{
				array_layer2.push($actionPoint2);
			}
			array_layer1.push($tmp_point2);
			array_layer1.push($tmp_point1);
			array_layer1.push($point1);
			bookArray_layer1 = array_layer1;

			array_layer2.push($limitPoint2);
			array_layer2.push($limitPoint1);
			array_layer2.push($tmp_point1);
			array_layer2.push($tmp_point2);
			bookArray_layer2 = array_layer2;

		}

		private function DrawShape(shape: Shape, point_array: Array, myBmp: BitmapData, matr: Matrix): void
		{

			var num = point_array.length;
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(myBmp, matr, false, true);

			shape.graphics.moveTo(point_array[0].x, point_array[0].y);
			for (var i = 1; i < num; i++)
			{
				shape.graphics.lineTo(point_array[i].x, point_array[i].y);
			}

			shape.graphics.endFill();

		}

		private function DrawShadowShap(type: int, shape: Shape, maskShape: Shape, g_width: Number, g_height: Number, $point1: Point, $point2: Point, $maskArray: Array, $arg: Number): void
		{

			var fillType: String = GradientType.LINEAR;

			var colors1: Array;
			var alphas1: Array;
			var ratios1: Array;

			var colors2: Array;
			var alphas2: Array;
			var ratios2: Array;

			// 翻页阴影1（旧页内侧）
			if (type == 1)
			{
				colors1 = [0x000000, 0x000000];
				alphas1 = [0, 0.88];
				ratios1 = [66, 255];
			}
			// 翻页阴影2（新页1，正在翻页中）
			else
			{
				colors1 = [0x000000, 0x000000, 0x000000];
				alphas1 = [0, 0.18, 0];
				ratios1 = [110, 126, 200];
			}

			// 翻页阴影3（新页1，正在翻页中，+高光）
			if (type == 2)
			{
				colors2 = [0x000000, 0x000000, 0x000000];
				alphas2 = [0.18, 0.33, 0];
				ratios2 = [126, 140, 155];
			}
			// 翻页阴影4（新页2，不动页面）
			else
			{
				colors2 = [0x000000, 0x000000];
				alphas2 = [0.66, 0];
				ratios2 = [0, 255];
			}

			var matr: Matrix = new Matrix();
			var spreadMethod: String = SpreadMethod.PAD;
			var myscale: Number;
			var myalpha: Number;

			shape.graphics.clear();
			matr.createGradientBox(g_width, g_height, (0 / 180) * Math.PI, -g_width * 0.5, -g_height * 0.5);

			shape.graphics.beginGradientFill(fillType, colors1, alphas1, ratios1, matr, spreadMethod);
			shape.graphics.drawRect(-g_width * 0.5, -g_height * 0.5, g_width * 0.5, g_height);

			shape.graphics.beginGradientFill(fillType, colors2, alphas2, ratios2, matr, spreadMethod);
			shape.graphics.drawRect(0, -g_height * 0.5, g_width * 0.5, g_height);

			shape.x = $point2.x + ($point1.x - $point2.x) * $arg;
			shape.y = $point2.y + ($point1.y - $point2.y) * $arg;
			shape.rotation = angle($point1, $point2);
			myscale = Math.abs($point1.x - $point2.x) * 0.5 / book_width;
			myalpha = 1 - myscale * myscale;

			shape.scaleX = myscale + 0.1;
			shape.alpha = myalpha + 0.1;

			var tmp_Bmp: BitmapData = new BitmapData(book_width * 2, book_height, true, 0x0);
			DrawShape(maskShape, $maskArray, tmp_Bmp, new Matrix());
			shape.mask = maskShape;

		}
		//End DrawPage------------------------------------------------------------------------

		//**Setting Parts------------------------------------------------------------------------
		private function SetFilter(obj): void
		{
			var filter: DropShadowFilter = new DropShadowFilter();
			filter.blurX = filter.blurY = 10;
			filter.alpha = 0.5;
			filter.distance = 0;
			filter.angle = 0;
			obj.filters = [filter];
		}
		private function SetLoadMC(): void
		{
			var pageRequest: URLRequest;
			var u1: String;
			var u2: String;
			var u3: String;

			for (var i: Number = 1; i <= book_totalpage; i++)
			{
				pageRequest = new URLRequest(myXML.child("page")[i - 1].attribute("src"));
				book_root["pload_" + i] = new MovieClip();
				book_root["pload_" + i].id = i;
				book_root["pload_" + i].loadedflag = false;
				book_root["pload_" + i].loadedtype = "";
				book_root["pload_" + i].brotherMC = null;
				book_root["pload_" + i].isWidthPage = false;

				if (i > 1)
				{
					u1 = myXML.child("page")[i - 2].attribute("src");
					u2 = myXML.child("page")[i - 1].attribute("src");
					if (u1 == u2)
					{
						book_root["pload_" + i].brotherMC = book_root["pload_" + (i - 1)];
						book_root["pload_" + i].isWidthPage = true;
					}
				}
				book_root["pload_" + i]["loader"] = new Loader();
				book_root["pload_" + i]["loader"].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				book_root["pload_" + i]["loader"].contentLoaderInfo.addEventListener(Event.COMPLETE, LoadEnd);
				book_root["pload_" + i]["loader"].load(pageRequest);

				book_root["pload_" + i].addChild(book_root["pload_" + i]["loader"]);
				onLoadinit != null ? onLoadinit(book_root["pload_" + i]) : null;
			}
		}
		private function SetPageMC(pageNum: Number): void
		{
			var p_mc1: MovieClip = new MovieClip();
			var p_mc2: MovieClip = new MovieClip();
			var MC_content1: MovieClip;
			var MC_content2: MovieClip;

			if (pageNum > 0 && pageNum <= book_totalpage)
			{
				p_mc1 = book_root["pload_" + pageNum];
			}
			if ((pageNum + 1) > 0 && (pageNum + 1) <= book_totalpage)
			{
				p_mc2 = book_root["pload_" + (pageNum + 1)];
			}

			if (p_mc2.isWidthPage)
			{
				pageMC.addChild(p_mc1);
				p_mc1.x = p_mc1.y = 0;
				if (p_mc1.loadedflag == true && p_mc1.loadedtype == "application/x-shockwave-flash")
				{
					MC_content1 = p_mc1["loader"].content;
					MC_content1.gotoAndPlay(2);
				}
			}
			else
			{
				pageMC.addChild(p_mc1);
				pageMC.addChild(p_mc2);
				p_mc1.x = p_mc1.y = 0;
				p_mc2.x = book_width;
				p_mc2.y = 0;
				if (p_mc1.loadedflag == true && p_mc1.loadedtype == "application/x-shockwave-flash")
				{
					MC_content1 = p_mc1["loader"].content;
					MC_content1.gotoAndPlay(2);
				}
				if (p_mc2.loadedflag == true && p_mc2.loadedtype == "application/x-shockwave-flash")
				{
					MC_content2 = p_mc2["loader"].content;
					MC_content2.gotoAndPlay(2);
				}
			}

		}
		//End Setting------------------------------------------------------------------------

		//**Loader Parts------------------------------------------------------------------------
		private function LoadFindLoader(LoaderObj): Number
		{
			var i: Number;
			var tmpageMC: MovieClip;

			for (i = 1; i <= book_totalpage; i++)
			{
				tmpageMC = book_root["pload_" + i];
				if (tmpageMC["loader"].contentLoaderInfo == LoaderObj)
				{
					return i;
				}
			}
			return 0;
		}
		private function loadProgress(evtObj: ProgressEvent): void
		{
			var obj = evtObj.currentTarget;
			var n: Number = (LoadFindLoader(obj));
			var percentLoaded: Number = evtObj.bytesLoaded / evtObj.bytesTotal;

			percentLoaded = Math.round(percentLoaded * 100);
			if (onLoading != null)
			{
				onLoading(book_root["pload_" + n], percentLoaded);
			}
		}
		private function LoadEnd(evtObj: Event): void
		{
			var obj = evtObj.target.loader.parent;
			var n: Number = obj.id;
			var tmpPageMC: MovieClip;

			obj.loadedtype = evtObj.target.contentType;
			obj.loadedflag = true;

			if (obj.loadedtype == "application/x-shockwave-flash")
			{
				tmpPageMC = obj["loader"].content;
				if (obj.parent == null)
				{
					tmpPageMC.gotoAndStop(1);
				}
				else
				{
					tmpPageMC.gotoAndPlay(2);
				}
			}
			evtObj.target.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			evtObj.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, LoadEnd);
			if (onLoadEnd != null)
			{
				onLoadEnd(obj);
			}
		}
		//Loader End---------------------------------------------------------------------------------

		//**MouseEvent Parts------------------------------------------------------------------------
		private function MouseOnDown(evt: Event): void
		{
			if (book_TimerFlag != "autoplay")
			{
				book_TimerArg0 = MouseFindArea(new Point(book_root.mouseX, book_root.mouseY));
				book_TimerArg0 = book_TimerArg0 < 0 ? -book_TimerArg0 : book_TimerArg0;

				//trace( book_banHomeLast );
				//trace( book_page );
				//trace( book_totalpage );
				//trace( book_TimerArg0 );

				// 正常状态的翻译
				if (book_banHomeLast == false)
				{
					MouseOnDown2(evt);
				}
				// 限制翻到封页和封底
				else if (book_banHomeLast && book_page == 2 && (book_TimerArg0 == 1 || book_TimerArg0 == 2))
				{
					// 不翻页
				}
				else if (book_banHomeLast && (book_page + 2) == book_totalpage && (book_TimerArg0 == 3 || book_TimerArg0 == 4))
				{
					// 不翻页
				}
				else if (book_banHomeLast)
				{
					MouseOnDown2(evt);
				}
			}
		}
		private function MouseOnDown2(evt: Event): void
		{
			if (book_TimerFlag != "stop" || evt.target.hasEventListener(MouseEvent.CLICK))
			{
				//不处于静止状态
				return;
			}
			//mouseOnDown时取area绝对值;
			book_TimerArg0 = MouseFindArea(new Point(book_root.mouseX, book_root.mouseY));
			book_TimerArg0 = book_TimerArg0 < 0 ? -book_TimerArg0 : book_TimerArg0;
			if (book_TimerArg0 == 0)
			{
				//不在area区域
				return;
			}
			else if ((book_TimerArg0 == 1 || book_TimerArg0 == 2) && book_page <= 1)
			{
				//向左翻到顶
				return;
			}
			else if ((book_TimerArg0 == 3 || book_TimerArg0 == 4) && book_page >= book_totalpage)
			{
				//向右翻到顶
				return;
			}
			else
			{
				book_TimerFlag = "startplay";
				PageUp();
			}
		}

		private function MouseOnUp(evt: Event): void
		{
			if (book_TimerFlag == "startplay")
			{
				//处于mousedown状态时
				book_TimerArg1 = MouseFindArea(new Point(book_root.mouseX, book_root.mouseY));
				book_TimerFlag = "autoplay";
			}
		}
		private function MouseFindArea(point: Point): Number
		{
			/* 取下面的四个区域,返回数值:
			 *   --------------------
			 *  | -1|     |     | -3 |
			 *  |---      |      ----|
			 *  |     1   |   3      |
			 *  |---------|----------|
			 *  |     2   |   4      |
			 *  |----     |      ----|
			 *  | -2 |    |     | -4 |
			 *   --------------------
			 */
			var tmpn: Number;
			var minx: Number = 0;
			var maxx: Number = book_width + book_width;
			var miny: Number = 0;
			var maxy: Number = book_height;
			var areaNum: Number = 50;

			if (point.x > minx && point.x <= maxx * 0.5)
			{
				tmpn = (point.y > miny && point.y <= (maxy * 0.5)) ? 1 : (point.y > (maxy * 0.5) && point.y < maxy) ? 2 : 0;
				if (point.x <= (minx + areaNum))
				{
					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -1 : (point.y > (maxy - areaNum) && point.y < maxy) ? -2 : tmpn;
				}
				return tmpn;
			}
			else if (point.x > (maxx * 0.5) && point.x < maxx)
			{
				tmpn = (point.y > miny && point.y <= (maxy * 0.5)) ? 3 : (point.y > (maxy * 0.5) && point.y < maxy) ? 4 : 0;
				if (point.x >= (maxx - areaNum))
				{
					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -3 : (point.y > (maxy - areaNum) && point.y < maxy) ? -4 : tmpn;
				}
				return tmpn;
			}
			return 0;
		}
		//End MouseEvent------------------------------------------------------------------------

		//**Page Parts------------------------------------------------------------------------
		public function pageGoto(topage: int, isForce: Boolean = false): void
		{
			//trace( "pageGoto" );
			// 如果传递了强制翻页，则设置对应的参数变量用于之后的强制翻页调用
			if (isForce)
			{
				topageForce = topage;
				isForceFlip = true;
			}


			var n: int;
			topage = topage % 2 == 1 ? topage - 1 : topage;
			n = topage - book_page;
			if (book_TimerFlag == "stop" && topage >= 0 && topage <= book_totalpage && n != 0)
			{
				book_TimerArg0 = n < 0 ? 1 : 3;
				book_TimerArg1 = -1;
				book_topage = topage > book_totalpage ? book_totalpage : topage;
				book_TimerFlag = "autoplay";
				PageUp();

				// 如果翻页调用成功，则将强制翻页设置为false，因为没必要强制翻页了
				isForceFlip = false;
			}
		}
		public function pageDraw(pageNum: Number): BitmapData
		{
			//trace( "pageDraw" );

			var myBmp: BitmapData = new BitmapData(book_width, book_height, true, 0x000000);
			if (pageNum > 0 && pageNum <= book_totalpage)
			{
				if (book_root["pload_" + pageNum].isWidthPage)
				{
					myBmp.draw(book_root["pload_" + pageNum].brotherMC, new Matrix(1, 0, 0, 1, -book_width, 0));
				}
				else
				{
					myBmp.draw(book_root["pload_" + pageNum]);
				}
			}
			return myBmp;
			//
		}
		private function PageUp(): void
		{
			//trace( "PageUp" );

			// 调用回调函数
			if (onPageStart != null)
			{
				onPageStart();
			}

			var page1: Number;
			var page2: Number;
			var page3: Number;
			var page4: Number;
			var point_mypos: Point = book_myposArray[book_TimerArg0 - 1];
			var b0: Bitmap;
			var b1: Bitmap;

			if (book_TimerArg0 == 1 || book_TimerArg0 == 2)
			{

				book_topage = book_topage == book_page ? book_page - 2 : book_topage;
				page1 = book_page;
				page2 = book_topage + 1;
				page3 = book_topage;
				page4 = book_page + 1;

			}
			else if (book_TimerArg0 == 3 || book_TimerArg0 == 4)
			{

				book_topage = book_topage == book_page ? book_page + 2 : book_topage;
				page1 = book_page + 1;
				page2 = book_topage;
				page3 = book_page;
				page4 = book_topage + 1;

			}

			book_px = point_mypos.x;
			book_py = point_mypos.y;

			Bmp0 = pageDraw(page1);
			Bmp1 = pageDraw(page2);
			bgBmp0 = pageDraw(page3);
			bgBmp1 = pageDraw(page4);

			b0 = new Bitmap(bgBmp0);


			b1 = new Bitmap(bgBmp1);
			b1.x = book_width;

			bgMC.addChild(b0);
			bgMC.addChild(b1);
			bgMC.visible = false;
			book_timer.start();

		}
		//End Page------------------------------------------------------------------------


		//**Timer Parts------------------------------------------------------------------------
		private function bookTimerHandler(event: TimerEvent): void
		{

			var point_topos: Point = book_toposArray[book_TimerArg0 - 1];
			var point_mypos: Point = book_myposArray[book_TimerArg0 - 1];

			var PageObj: Object;
			var array_point1: Array;
			var array_point2: Array;
			var numpoint1: Number;
			var numpoint2: Number;

			var tmpMC0: MovieClip;
			var tmpageMC0: MovieClip;

			var tox: Number;
			var toy: Number;
			var toflag: Number;
			var tmpx: Number;
			var tmpy: Number;

			var arg: Number;
			var r: Number;
			var a: Number;

			bgMC.visible = true;

			while (pageMC.numChildren > 0)
			{
				pageMC.removeChildAt(0);
				if (book_page > 0 && book_page <= book_totalpage)
				{
					tmpMC0 = book_root["pload_" + book_page];
					if (tmpMC0.loadedflag == true && tmpMC0.loadedtype == "application/x-shockwave-flash")
					{
						tmpageMC0 = tmpMC0["loader"].content;
						tmpageMC0.gotoAndStop(1);
					}
				}
				if ((book_page + 1) > 0 && (book_page + 1) <= book_totalpage)
				{
					tmpMC0 = book_root["pload_" + (book_page + 1)];
					if (tmpMC0.loadedflag == true && tmpMC0.loadedtype == "application/x-shockwave-flash")
					{
						tmpageMC0 = tmpMC0["loader"].content;
						tmpageMC0.gotoAndStop(1);
					}
				}
			}
			if (book_TimerFlag == "startplay")
			{
				u = 0.4;
				render0.graphics.clear();
				render1.graphics.clear();
				book_px = ((render0.mouseX - book_px) * u + book_px) >> 0;
				book_py = ((render0.mouseY - book_py) * u + book_py) >> 0;

				DrawPage(book_TimerArg0, new Point(book_px, book_py), Bmp1, Bmp0);

				//book_timer.stop();

			}
			else if (book_TimerFlag == "autoplay")
			{
				render0.graphics.clear();
				render1.graphics.clear();
				if (Math.abs(point_topos.x - book_px) > book_width && book_TimerArg1 > 0)
				{
					//不处于点翻区域并且翻页不过中线时
					tox = point_mypos.x;
					toy = point_mypos.y;
					toflag = 0;
				}
				else
				{
					tox = point_topos.x;
					toy = point_topos.y;
					toflag = 1;
				}
				tmpx = (tox - book_px) >> 0;
				tmpy = (toy - book_py) >> 0;

				if (book_TimerArg1 < 0)
				{
					//处于点翻区域时
					u = 0.3; //降低加速度
					book_py = Arc(book_width, tmpx, point_topos.y);
				}
				else
				{
					u = 0.4; //原始加速度
					book_py = tmpy * u + book_py;
				}
				book_px = tmpx * u + book_px;

				//trace(book_px>>0, book_py>>0);

				DrawPage(book_TimerArg0, new Point(book_px, book_py), Bmp1, Bmp0);

				//trace(book_TimerFlag, book_timer.currentCount);
				if (tmpx == 0 && tmpy == 0)
				{
					render0.graphics.clear();
					render1.graphics.clear();
					shadow0.graphics.clear();
					shadow1.graphics.clear();

					Bmp0.dispose();
					Bmp1.dispose();
					bgBmp0.dispose();
					bgBmp1.dispose();

					while (bgMC.numChildren > 0)
					{
						bgMC.removeChildAt(0);
					}
					book_topage = toflag == 0 ? book_page : book_topage;
					book_page = book_topage;

					SetPageMC(book_page);

					book_TimerFlag = "stop"; //恢得静止状态

					bgMC.visible = false;
					book_timer.reset();

					//trace(book_TimerFlag, book_page, book_topage);
					if (onPageEnd != null)
					{
						onPageEnd();
					}

					// 如果在pageGoto()函数中传递了强制翻页参数，则在翻页动画结束之后，再调用一次翻页函数，进行对应的翻页
					// 因为目前还没开发强行跳转翻页的功能，只能等动画结束后再进行翻页
					if (isForceFlip)
					{
						isForceFlip = false;
						pageGoto(topageForce);
					}
				}
			}
		}
		//End Timer ------------------------------------------------------------------------

		//**Tools Parts------------------------------------------------------------------------
		private function Arc(arg_R, arg_N1, arg_N2): Number
		{
			//------圆弧算法-----------------------
			var arg = arg_R * 2;
			var r = arg_R * arg_R + arg * arg;
			var a = Math.abs(arg_N1) - arg_R;
			var R_arg: Number = arg_N2 - (Math.sqrt(r - a * a) - arg);
			return R_arg;
		}
		private function angle(target1, target2): Number
		{
			var tmp_x: Number = target1.x - target2.x;
			var tmp_y: Number = target1.y - target2.y;
			var tmp_angle: Number = Math.atan2(tmp_y, tmp_x) * 180 / Math.PI;
			tmp_angle = tmp_angle < 0 ? tmp_angle + 360 : tmp_angle;
			return tmp_angle;
		}
		private function pos(target1, target2): Number
		{

			var tmp_x: Number = target1.x - target2.x;
			var tmp_y: Number = target1.y - target2.y;
			var tmp_s: Number = Math.sqrt(tmp_x * tmp_x + tmp_y * tmp_y);
			return target1.x > target2.x ? tmp_s : -tmp_s;

		}
		//End Tools------------------------------------------------------------------------
	}
}