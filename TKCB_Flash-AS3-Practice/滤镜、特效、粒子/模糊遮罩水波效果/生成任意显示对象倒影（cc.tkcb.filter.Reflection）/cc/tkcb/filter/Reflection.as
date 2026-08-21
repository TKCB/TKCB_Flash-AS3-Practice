/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2017 TKCB, tkcb@qq.com
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
 * 作　　者：TKCB
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
 * v1.0.0 2017-7-2
 */
 
package cc.tkcb.filter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.GradientType;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	/**
	 * Reflection 倒影生成 静态类，用于生成倒影
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2017-7-2
	 * @修改时间 2017-7-2
	 * @version 1.0.0
	 */
	public class Reflection
	{
		//************************ ************************* 静态方法 ******************** *********** *** **////
		
		/**
		 * 生成倒影，可以是任意显示对象或BitmapData对象
		 * @param source 要生成倒影的显示对象
		 * @param heightRatio 倒影高度比例，和原显示对象的比例，最高为1，默认为0.5
		 * @return 倒影对象
		 */
		public static function reflection ( source:*, heightRatio:Number = 0.5 ) : Bitmap
		{
			// 对源显示对象做上下反转处理
			var bd : BitmapData = new BitmapData( source.width, source.height, true, 0 );
			var mtx : Matrix;
			if ( source is BitmapData )
			{
				source = new Bitmap( source );
			}
			mtx = new Matrix();
			mtx.d = -1;
			mtx.ty = bd.height;
			bd.draw( source, mtx );
			
			// 生成一个渐变遮罩
			var width : int = bd.width;
			var height : int = bd.height;
			mtx = new Matrix();
			mtx.createGradientBox( width, height, 0.5 * Math.PI );		// 遮罩高度和遮罩方向
			var shape : Shape = new Shape();
			shape.graphics.beginGradientFill( GradientType.LINEAR, [0x000000, 0x000000], [0.9, 0], [0, 255 * heightRatio], mtx );
			shape.graphics.drawRect( 0, 0, width, height * heightRatio );
			shape.graphics.endFill();
			
			var mask_bd : BitmapData = new BitmapData( width, height, true, 0 );
			mask_bd.draw( shape );
			
			// 先生成最终效果，然后获取最小的倒影高度，再生成一遍最终效果（这样确保生成的倒影不会有多余的空像素值）
			bd.copyPixels( bd, bd.rect, new Point(0, 0), mask_bd, new Point(0, 0), false );
			var minH : int = 0;
			var i:int, len:int = bd.height - 1;
			var j:int, len2:int = bd.width;
			for1:
			for ( i = len; i >= 0; i-- )
			{
				for ( j = 0; j < len; j++ )
				{
					if ( bd.getPixel32(i, j) != 0 )
					{
						minH = i;
						break for1;
					}
				}
			}
			var newBD : BitmapData = new BitmapData( bd.width, minH, true, 0 );
			newBD.copyPixels( bd, newBD.rect, new Point(0, 0) );
			
			// 将倒影对象用BitmapData包裹起来，并返回
			var bit : Bitmap = new Bitmap( newBD );
			
			return bit;
		}
		
	}
}


