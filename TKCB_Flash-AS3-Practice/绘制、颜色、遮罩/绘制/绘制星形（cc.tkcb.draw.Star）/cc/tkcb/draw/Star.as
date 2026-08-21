/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright TKCB, tkcb@qq.com
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
 * v1.0.0 2019-3-6
 */

package cc.tkcb.draw
{
	import flash.display.Shape;
	
	
	/**
	 * Star 星形绘制 类，用于绘制星形对象
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2019-3-6
	 * @修改时间 2019-3-6
	 * @version 1.0.0
	 */
	public class Star
	{
		//************************ ************************* 静态方法 ******************** *********** *** **////
		/**
		 * 绘制星形，设置相应参数
		 * @param vertex 顶点（角）的个数
		 * @param radius 星形的半径
		 * @param ratio 星形边长比，越大则星形的角也尖细，默认0.3846为正五角星的值设置
		 * @param lineThickness 线条粗细值，默认为1，如果传递0则不绘制线条。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineColor 线条颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.lineStyle() 方法
		 * @param lineAlpha 线条透明度，默认为1（不透明），如果传递0则不绘制线条。具体可以查看 Graphics.lineStyle() 方法
		 * @param fillColor 填充颜色值，默认为0x000000（黑色）。具体可以查看 Graphics.beginFill() 方法
		 * @param fillAlpha 填充透明度，默认为1（不透明），如果传递0则不进行填充。具体可以查看 Graphics.beginFill() 方法
		 **/
		public static function drawStar ( vertex:int = 5, radius:int = 60, ratio:Number = 0.3846, lineThickness:Number = 1, lineColor:uint = 0x000000, 
										  lineAlpha:Number = 1, fillColor:uint = 0x000000, fillAlpha:Number = 1 ) : Shape
		{
			if ( vertex >= 2 )
			{
				var shape : Shape = new Shape();
				if ( lineThickness > 0 && lineAlpha > 0 ) shape.graphics.lineStyle( lineThickness, lineColor, lineAlpha );
				if ( fillAlpha > 0 ) shape.graphics.beginFill( fillColor, fillAlpha );
				shape.graphics.moveTo( radius, 0 );

				//for循环画线条 vertex*2需要经过的顶点数
				var radius2 : Number;
				var angle : Number;
				var i:int, len:int = vertex * 2;
				for ( i = 1; i < len; i++ )
				{
					// 半径
					radius2 = radius;

					// 求模，余数不等于0，这里其实就是奇、偶数的判断
					if ( i % 2 !=0 )
					{
						// i为奇数的时候重新计算半径
						radius2 = radius * ratio;
					}
					
					// 当前角度
					angle = Math.PI * 2 / (vertex * 2) * i;
					
					// 点的坐标（通过角度与半径计算每一个顶点的坐标）
					shape.graphics.lineTo( Math.cos(angle) * radius2, Math.sin(angle) * radius2 );
				}
				
				// 填充颜色
				if ( fillAlpha > 0 ) shape.graphics.endFill();
				
				// 旋转图形，计算方法为：内角和 / 2 / 角数
				shape.rotation = 180 * (vertex - 2) / 2 / vertex;
				
				return shape;
			}
			else
			{
				return null;
			}
		}
		
		
	}
}