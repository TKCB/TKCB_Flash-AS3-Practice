/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2013-2028 TKCB, www.tkcb.cc
 *
 *
 * This is free software/program/code : you can redistribute it and/or modify
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
 * 改　　者：TKCB
 * 改者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 改者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 *
 *
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2018-12-17
 */
package cc.tkcb.draw
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * CarmackBMP 卡马克卷轴滚动算法类，用于平滑的图片滚动平移，常用于卷轴滚动、地图滚动等。
	 * @author TKCB（www.tkcb.cc）（原作者：阿伍 present by Awu，rotaryice@qq.com）
	 * @创建时间 2018-12-17
	 * @修改时间 2018-12-17
	 * @version 1.0.0
	 */
	public class CarmackBMP extends Bitmap
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		private var rx : Number = 0; //真实的坐标
		private var ry : Number = 0;
		//
		private var px : Number = 0; //原始坐标
		private var py : Number = 0;
		//
		private var sw : int = 0; //OSD屏幕大小
		private var sh : int = 0;
		//
		private var buff_x : int = 0; //水平缓冲量
		private var buff_y : int = 0; //垂直缓冲量
		//
		private var source : BitmapData;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 * @param source 要进行滚动的位图数据（BitmapData对象）
		 * @param sw 显示区域的宽度
		 * @param sh 显示区域的高度
		 * @param buff_x 水平缓冲量
		 * @param buff_y 垂直缓冲量
		 */
		public function CarmackBMP ( source:BitmapData, sw:int, sh:int, buff_x:int, buff_y:int ) : void
		{
			this.source = source;

			this.bitmapData = new BitmapData(sw + buff_x * 2, sh + buff_y * 2, true, 0);
			this.sw = sw;
			this.sh = sh;
			this.buff_x = buff_x;
			this.buff_y = buff_y;


			this.rx = 0;
			this.ry = 0;
			this.scrollTo(0, 0);
		}
		
		/**
		 * 直接跳转到某个坐标，会导致重绘OSD与缓冲区
		 * @param x 要跳转的横坐标值X
		 * @param y 要跳转的竖坐标值Y
		 */
		public function scrollTo ( x:int, y:int ) : void
		{
			this.bitmapData.fillRect(this.bitmapData.rect, 0x00000000);
			this.x = this.px;
			this.y = this.py;
			this.rx = x;
			this.ry = y;
			var rectX : Number = -x - buff_x;
			var rectY : Number = -y - buff_y;
			var rectW : int = this.sw + this.buff_x * 2;
			var rectH : int = this.sh + this.buff_y * 2;
			var dp : Point = new Point(0, 0);
			this.bitmapData.copyPixels(source, new Rectangle(rectX, rectY, rectW, rectH), dp);
		}
		
		/**
		 * 设置显示区域的基准坐标
		 * @param nx 基准坐标值X
		 * @param ny 基准坐标值Y
		 */
		public function setPositon ( nx:int, ny:int ) : void
		{
			nx -= this.buff_x;
			ny -= this.buff_y;
			this.px = nx;
			this.py = ny;
			this.x = nx;
			this.y = ny;
		}
		
		/**
		 * 按向量去移动
		 * @param vx 横坐标的量值
		 * @param Vy 竖坐标的量值
		 */
		public function scroll ( vx:int, vy:int ) : void
		{
			//拦截小数
			if (vx)
			{
				this.x += vx;
				this.rx += vx;
				this.chkOverFlowX();
			}
			if (vy)
			{
				this.y += vy;
				this.ry += vy;
				this.chkOverFlowY();
			}
		}
		
		/**
		 * ......
		 */
		private function chkOverFlowX () : void
		{
			var rect : Rectangle = new Rectangle();
			var dp : Point;
			var offset : Point;

			//右边越界
			if (x <= this.px - buff_x)
			{
				offset = new Point(this.px - this.x, this.y - this.py);
				dp = new Point(this.sw + buff_x * 2 - offset.x, 0);
				//源矩形
				rect.x = -this.rx + this.sw + buff_x - offset.x;
				rect.y = -this.ry - buff_y + offset.y;
				rect.width = offset.x;
				rect.height = this.sh + this.buff_y * 2;


				this.bitmapData.scroll(-offset.x, 0);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);

				//                
				this.bitmapData.copyPixels(source, rect, dp);
				this.x += offset.x;
			}
			else if (x >= this.px + buff_x)
			{

				offset = new Point(this.x - this.px, this.y - this.py);
				dp = new Point(0, 0);
				rect.x = -this.rx - buff_x;
				rect.y = -this.ry - buff_y + offset.y;
				rect.width = offset.x;
				rect.height = this.sh + this.buff_y * 2;

				this.bitmapData.scroll(offset.x, 0);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);
				this.bitmapData.copyPixels(source, rect, dp);

				this.x -= offset.x;
			}
		}
		
		/**
		 * ......
		 */
		private function chkOverFlowY () : void
		{
			var rect : Rectangle = new Rectangle();
			var dp : Point;
			var offset : Point;

			//下边越界
			if (y <= this.py - this.buff_y)
			{
				offset = new Point(this.x - this.px, this.py - this.y);
				dp = new Point(0, this.sh + buff_y * 2 - offset.y);
				//源矩形
				rect.x = -this.rx - buff_x + offset.x;
				rect.y = -this.ry + this.sh + buff_y - offset.y;
				rect.width = this.sw + this.buff_x * 2;
				rect.height = offset.y;

				this.bitmapData.scroll(0, -offset.y);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);
				this.bitmapData.copyPixels(source, rect, dp);
				this.y += offset.y;
			}
			else if (y >= this.py + this.buff_y)
			{

				offset = new Point(this.x - this.px, this.y - this.py);
				dp = new Point(0, 0);
				//源矩形
				rect.x = -this.rx - buff_x + offset.x;
				rect.y = -this.ry - buff_y;
				rect.width = this.sw + this.buff_x * 2;
				rect.height = offset.y;

				this.bitmapData.scroll(0, offset.y);
				this.bitmapData.fillRect(new Rectangle(dp.x, dp.y, rect.width, rect.height), 0x000000);
				this.bitmapData.copyPixels(source, rect, dp);
				this.y -= offset.y;
			}
		}
		
		
	}
}