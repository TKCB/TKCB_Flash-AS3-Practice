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
 * v1.0.0 2017-2-4
 */

package cc.tkcb.utils
{
	import flash.display.BitmapData;
	
	import flash.geom.Matrix;


	/**
	 * BitmapSimilarity 图片相似度判定类，可以获取图片的相似度、判断图片的相似度
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2017-2-4
	 * @修改时间 2017-2-4
	 * @version 1.0.0
	 */
	public class BitmapSimilarity
	{
		/*
		寻找相似图片的基本原理是对每张图片生成一个"指纹"（fingerprint）字符串，然后比较不同图片的指纹。结果越接近，就说明图片越相似。
		算法很多种，由简单到复杂，但基本都是对每张图片的关键信息进行提取，然后生成一个指纹，最后进行各种比对。
		目前我知道的有：感知哈希算法、颜色分布法、内容特征法。还有更多我不知道的（但基本原理都是类似的）……
		*/
		
		
		//************************ ************************* 感知哈希算法（Perceptual hash algorithm） ******************** *********** *** **////
		/**
		 * 直接判断两个图片对象的相似度，从0-100，越高越相似（100为最高）
		 * @param bitA 要比较的位图对象
		 * @param bitB 要比较的位图对象
		 * @return 图片的相似度
		 */
		public static function compareBitmapData ( bitA:BitmapData, bitB:BitmapData ) : int
		{
			var strA : String = BitmapSimilarity.hashBitmap( bitA );
			var strB : String = BitmapSimilarity.hashBitmap( bitB );
			var similarity : int = BitmapSimilarity.compareFingerprint( strA, strB );
			return similarity;
		}
		
		/**
		 * 根据指纹判断两个图片的相似度，从0-100，越高越相似（100为最高）
		 * @param strA 要比较的指纹字符串
		 * @param strB 要比较的指纹字符串
		 * @return 图片的相似度
		 */
		public static function compareFingerprint ( strA:String, strB:String ) : int
		{
			var diff : int = 0;
			var i:int, len:int = strA.length;
			for ( i = 0; i < len; i++ )
			{
				if ( strA.charAt(i) != strB.charAt(i) )
				{
					diff++;
				}
			}
			var similarity : int = (64 - diff) / 64 * 100;
			return similarity;
		}
		
		/**
		 * 生成图片的指纹，也就是通过感知哈希算法得出的字符串
		 * @param bit 要生成指纹的图片
		 * @return 图片的指纹
		 */
		public static function hashBitmap ( bit:BitmapData ) : String
		{
			var bmd : BitmapData = new BitmapData( 8, 8 );
			var w : int = bit.width;
			var h : int = bit.height;
			var scale : Number = (w > h) ? (w / 8) : (h / 8);
			bmd.draw( bit, new Matrix( (1 / scale), 0, 0, 1 / scale ) );
			var ave : uint = 0;
			var colorList : Vector.<uint > = new Vector.<uint >;
			
			var i:int, len:int = 8;
			var j:int, len2:int = 8;
			for ( i = 0; i < len; i++ )
			{
				for ( j = 0; j < len2; j++ )
				{
					var color : uint = bmd.getPixel( i, j );
					var r : uint = (color >> 16) & 0xFF;
					var g : uint = (color >> 8) & 0xFF;
					var b : uint = color & 0xFF;
					color = ((((r * 0.3) + g * 0.59) + b * 0.11) / 4);
					ave += color;
					colorList.push( color );
				}
			}
			ave /= 64;
			var str : String = "";
			len = colorList.length;
			for ( i = 0; i < len; i++ )
			{
				if ( colorList[i] >= ave )
				{
					colorList[i] = 1;
				}
				else
				{
					colorList[i] = 0;
				}
				str +=  colorList[i];
			}
			return str;
		}
	}
}