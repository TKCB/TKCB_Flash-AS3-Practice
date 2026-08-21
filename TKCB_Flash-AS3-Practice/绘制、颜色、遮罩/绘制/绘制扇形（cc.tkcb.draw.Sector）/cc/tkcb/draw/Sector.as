/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2013-2018 TKCB, tkcb@qq.com
 *
 *
 * This is free software/program/code :  you can redistribute it and/or modify
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
 * 作    者：TKCB
 * 作者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 作者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
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
 * v1.0.0 2018-8-17
 * v1.1.0 2018-8-19 增加currentAngle属性，表示角度制
 */

package cc.tkcb.draw
{
	import flash.display.Graphics;
	import flash.display.Shape;
	


	/**
	 * Sector 扇形绘制 类，用于绘制扇形对象
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-8-17
	 * @修改时间 2018-8-19
	 * @version 1.1.0
	 */
	public class Sector extends Shape
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		/** 当前扇形的度数 */
		public var currentAngle : Number = 0;
		
		
		//// 扇形必备参数
		/** 扇形圆心相对于父显示对象注册点的 x 位置（以像素为单位） */
		private var _x : Number = 0;
		
		/** 扇形圆心相对于父显示对象注册点的 y 位置（以像素为单位） */
		private var _y : Number = 0;
		
		/** 扇形的半径值，单位像素 */
		private var _radius : Number = 10;
		
		/** 扇形的绘制开始角度，从那个角度开始绘制 */
		private var _fromAngle : Number = 0;
		
		/** 扇形的绘制角度，也就是扇形的度数，从fromAngle开始，转多少角度 */
		private var _angle : Number = 90;
		
		
		//// 绘制通用参数
		/** 线条粗细值，默认为1。具体可以查看 Graphics.lineStyle() 方法 */
		private var _lineThickness : Number = 1;
		
		/** 线条颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.lineStyle() 方法 */
		private var _lineColor : uint = 0x000000;
		
		/** 线条颜色值，默认为1（不透明）。具体可以查看 Graphics.lineStyle() 方法 */
		private var _lineAlpha : Number = 1;
		
		/** 填充颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.beginFill() 方法 */
		private var _fillColor : uint = 0x000000;
		
		/** 填充颜色值，默认为1（不透明）。具体可以查看 Graphics.beginFill() 方法 */
		private var _fillAlpha : Number = 1;
		
		/** 两倍的IP值，用于绘制计算 */
		private const TWO_PI : Number = Math.PI * 2;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 创建扇形，设置相应参数，也可以暂时不设置，后续使用 setLineAndFill() 方法进行设置
		 * @param lineThickness 线条粗细值，默认为1。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineColor 线条颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineAlpha 线条颜色值，默认为1（不透明）。具体可以查看 Graphics.lineStyle() 方法
		 * @param fillColor 填充颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.beginFill() 方法
		 * @param fillAlpha 填充颜色值，默认为1（不透明）。具体可以查看 Graphics.beginFill() 方法
		 */
		public function Sector ( lineThickness:Number = 1, lineColor:uint = 0x000000, lineAlpha:Number = 1, fillColor:uint = 0x000000, fillAlpha:Number = 1 )
		{
			setLineAndFill( lineThickness, lineColor, lineAlpha, fillColor, fillAlpha );
		}
		
		
		//************************ ************************* 方法 ******************** *********** *** **////
		/**
		 * 设置线条样式和填充
		 * @param lineThickness 线条粗细值，默认为1。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineColor 线条颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineAlpha 线条颜色值，默认为1（不透明）。具体可以查看 Graphics.lineStyle() 方法
		 * @param fillColor 填充颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.beginFill() 方法
		 * @param fillAlpha 填充颜色值，默认为1（不透明）。具体可以查看 Graphics.beginFill() 方法
		 */
		public function setLineAndFill ( lineThickness:Number = 1, lineColor:uint = 0x000000, lineAlpha:Number = 1, fillColor:uint = 0x000000, fillAlpha:Number = 1 ) : void
		{
			_lineThickness = lineThickness;
			_lineColor = lineColor;
			_lineAlpha = lineAlpha;
			_fillColor = fillColor;
			_fillAlpha = fillAlpha;
		}
		
		/**
		 * 绘制扇形，如果已经绘制过扇形，只是想修改绘制半径、开始角度、角度、逆时针绘制等参数，则可以使用 modifySector () 方法
		 * @param x 扇形圆心相对于父显示对象注册点的 x 位置（以像素为单位）
		 * @param y 扇形圆心相对于父显示对象注册点的 y 位置（以像素为单位）
		 * @param radius 扇形的半径值，单位像素
		 * @param fromAngle 扇形的绘制开始角度，从那个角度开始绘制
		 * @param angle 扇形的绘制角度，也就是扇形的度数，从fromAngle开始，转多少角度
		 * @param isClockwise 是否顺时针绘制，true表示顺时针绘制，false表示逆时针绘制
		 */
		public function drawSector( x:Number, y:Number, radius:Number, fromAngle:Number, angle:Number, isClockwise:Boolean = true ) : void
		{
			_x = x;
			_y = y;
			_radius = radius;
			_fromAngle = fromAngle;
			_angle = angle;
			
			// 角度值（0-360这种，当然也可以大于360）转换成弧度制，也就是PIπ的值
			fromAngle = fromAngle / 180 * Math.PI;
			angle = angle / 180 * Math.PI;
			
			// 清除之前的绘制，并设置样式
			var g : Graphics = this.graphics;
			g.clear();
			g.lineStyle( _lineThickness, _lineColor, _lineAlpha );
			g.beginFill( _fillColor, _fillAlpha );
			
			while ( angle < 0 )
			{
				angle += TWO_PI;
			}
			while ( angle > TWO_PI )
			{
				angle -= TWO_PI;
			}

			if ( Math.abs(angle) >= TWO_PI )
			{
				g.drawCircle( x, y, radius );
			}
			else
			{
				g.moveTo( x, y );
				var sx : Number = x + Math.cos(fromAngle) * radius;
				var sy : Number = y + Math.sin(fromAngle) * radius;
				g.lineTo( sx, sy );

				var count : int = Math.ceil(angle * 4 / Math.PI);
				var perAngle : Number = angle / count;
				var angleMid : Number;
				var bx1 : Number;
				var by1 : Number;
				var bx : Number;
				var by : Number;
				var cx : Number;
				var cy : Number;
				var divValue : Number = Math.cos(perAngle * 0.5);
				
				var i:int, len:int = count;
				for ( i = 0; i < len; i++ )
				{
					if ( isClockwise )
					{
						fromAngle += perAngle;
						angleMid = fromAngle - perAngle * 0.5;
					}
					else
					{
						fromAngle -= perAngle;
						angleMid = fromAngle + perAngle * 0.5;
					}
					bx1 = radius * Math.cos(angleMid);
					by1 = radius * Math.sin(angleMid);
					bx = x + bx1 / divValue;
					by = y + by1 / divValue;
					cx = x + radius * Math.cos(fromAngle);
					cy = y + radius * Math.sin(fromAngle);
					g.curveTo( bx, by, cx, cy );
					
					/* 不绘制辅助线
					//if ( isShowAssistPoint )
					//{
						g.drawCircle(bx, by, 2);
						g.drawCircle(x + bx1, y + by1, 4);
					//}*/
				}
				g.lineTo( x, y );
			}
			g.endFill();
			
			currentAngle = angle / TWO_PI * 360;
		}
		
		/**
		 * 修改绘制扇形，增加或减少半径值、新的绘制开始角度、增加或者减小绘制角度、是否逆时针绘制
		 * @param radius 增加或减少半径值
		 * @param fromAngle 新的绘制开始角度（考虑到实际情况，用不到增加或者减小开始角度值，所以是新的绘制开始角度值）
		 * @param angle 增加或者减小绘制角度
		 * @param isClockwise 是否顺时针绘制，true表示顺时针绘制，false表示逆时针绘制
		 */
		public function modifySector( radius:Number, fromAngle:Number, angle:Number, isClockwise:Boolean = true ) : void
		{
			_radius += radius;
			_fromAngle = fromAngle;
			_angle += angle;
			
			drawSector( _x, _y, _radius, _fromAngle, _angle, isClockwise );
		}
		
		
	}
}