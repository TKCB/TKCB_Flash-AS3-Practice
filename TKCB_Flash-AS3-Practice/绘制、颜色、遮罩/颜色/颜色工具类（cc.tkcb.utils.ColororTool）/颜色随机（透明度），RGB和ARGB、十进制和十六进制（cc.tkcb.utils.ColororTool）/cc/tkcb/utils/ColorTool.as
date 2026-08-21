/*
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
 * v1.0.0 2019-4-11～12 将颜色转换、颜色随机、颜色和16进制转换、HSV转换都整合到了一个工具类中，更加方便实用
 * v1.1.1 2019-4-22 对“RGB和HSV相互转换系列方法”进行修正BUG
 * v1.2.2 2019-5-2 添加色差计算的方法
 */
package cc.tkcb.utils
{
	// 没有import，这个是参考别人的代码写的，我不生成代码，我是代码的搬运工
	// 参考：https://blog.51cto.com/ragged/1743873
	// 参考资料：https://blog.csdn.net/zeng622peng/article/details/6931485
	
	// 这是参考资料对应的文字说明：
	// 十六进制颜色值在 ActionScript 中, 与 BitmapData 类结合使用的颜色值应使用 32 位十六进制数表示。
	// 32 位十六进制数是四对十六进制数字的序列。每个十六进制对定义四个颜色通道 (红、绿、蓝和 Alpha) 中每个颜色通道的强度。
	// 颜色通道的强度为以范围介于 0 到 255 之间的十进制数的十六进制表示法；FF 是指全强度 (255), 00 是指通道中无颜色 (0)。
	// 如您所见, 由于颜色值长度需要两位数字, 因此您需要填充一个通道, 例如用 01 代替 1。这样可确保十六进制数中始终具有八个数字。还应确保指定十六进制数前缀 0x。
	// 例如, 白色 (所有通道中都是全强度) 用十六进制记数法表示为: 0xFFFFFFFF。而黑色正好相反；它在红色、绿色和蓝色中的任何一个通道中都无颜色: 0xFF000000。
	// 请注意, Alpha 通道 (第一对) 仍然为全强度 (FF)。Alpha 通道中的全强度意味着没有 alpha (FF), 无强度 (00) 意味着全 alpha。
	// 因此, 透明像素颜色值为 0x00FFFFFF。
	// 从 ARGB 转换为十六进制值对于特定的颜色, 人们通常容易记住它的 Alpha、红色、绿色和蓝色 (ARGB) 值, 而记不住其十六进制值。
	// 如果您也有同样的情况, 那么您应当了解如何从 ARGB 转换为十六进制值。
	// 这可通过下面的 ActionScript 函数来实现: 
	// function argbtohex(a:Number, r:Number, g:Number, b:Number) { return (a<<24 | r<<16 | g<<8 | b) } 
	// 您可以按如下所示的方式使用该函数: hex=argbtohex(255,0,255,0) 
	// 输出基于 10 进制数的 32 位红色十六进制值从十六进制转换为 ARGB 值要将十六进制颜色值转换回范围介于 0 到 255 之间的四个十进制数 (每个数代表 ARGB 中的一个通道) ,
	// 请使用下面的 ActionScript 函数: function hextoargb(val:Number) { var col={} col.alpha = (val › › 24) & 0xFF col.red = (val › › 16) & 0xFF col.green = (val › › 8) & 0xFF col.blue = val & 0xFF return col } 
	// 您可以按如下所示的方式使用该函数: argb=hextoargb(0xFFFFCC00); alpha=argb.alpha; red=argb.red; green=argb.green; blue=argb.blue; ***************** 测试 argb=hextoargb(0xcc000000); alpha=argb.alpha; red=argb.red; green=argb.green; blue=argb.blue; trace(alpha) 
	// 结果：204 改变cc位置的值，如ff，d6……，可以知道它们具体的十进制值是多少。比如：for(r=0;r<=0xFF;r+=0x33){……} 该句中的0xFF，0x33，测试可知分别是255和51。（0xFF写全应该是0x000000FF）
	
	
	
	/** 
	 * ColorTool 颜色转换、随机等的 静态工具类
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2019-4-11
	 * @修改时间 2019-5-2
	 * @version 1.2.2
	 */
	public class ColorTool
	{
		//************************ ************************* 随机ARGB颜色  系列方法 ******************** *********** *** **////
		/**
		 * 随机RGB颜色数字
		 * @return 随机的RGB颜色数字
		 */
		public static function randomRGB () : uint
		{
			var r : uint = Math.random() * 256;
			var g : uint = Math.random() * 256;
			var b : uint = Math.random() * 256;
			return r<<16 | g<<8 | b;
		}
		
		/**
		 * 随机ARGB颜色数字
		 * @return 随机的ARGB颜色数字
		 */
		public static function randomARGB () : uint
		{
			var a : uint = Math.random() * 256;
			var r : uint = Math.random() * 256;
			var g : uint = Math.random() * 256;
			var b : uint = Math.random() * 256;
			return a<<24 | r<<16 | g<<8 | b;
		}
		
		/**
		 * 随机RGB颜色，返回16进制字符串
		 * @param prefix 16进制的前缀，AS中是“0x”，其他语言或者软件也有使用“#”或者其他字符的，也可以设置为""空字符，则不需要前缀
		 * @param isCapital 是否将小写16进制字符转换为大写字符
		 * @return 随机的16进制字符串的RGB颜色
		 */
		public static function randomRGB16 ( prefix:String = "0x", isCapital:Boolean = true ) : String
		{
			return ColorTool.rgbTo16Number( uint(Math.random() * 256), uint(Math.random() * 256), uint(Math.random() * 256), prefix, isCapital );
		}
		
		/**
		 * 随机ARGB颜色，返回16进制字符串
		 * @param prefix 16进制的前缀，AS中是“0x”，其他语言或者软件也有使用“#”或者其他字符的，也可以设置为""空字符，则不需要前缀
		 * @param isCapital 是否将小写16进制字符转换为大写字符
		 * @return 随机的16进制字符串的ARGB颜色
		 */
		public static function randomARGB16 ( prefix:String = "0x", isCapital:Boolean = true ) : String
		{
			return ColorTool.argbTo16Number( uint(Math.random() * 256), uint(Math.random() * 256), uint(Math.random() * 256), uint(Math.random() * 256), prefix, isCapital );
		}
		
		
		//************************ ************************* ARGB转数字（10进制） 系列方法 ******************** *********** *** **////
		/**
		 * RGB转10进制（Flash中默认是10进制，可以随时用 toString(16) 转换为16进制，但是在R高位不足16时候，转换时候会存在一些不算是BUG的BUG）
		 * @param r 全称为 red 红色
		 * @param g 全称为 green 绿色
		 * @param b 全称为 blue 蓝色
		 * @return 合并后的10进制的RGB数字
		 */
		public static function rgbToNumber ( r:uint, g:uint, b:uint ) : uint
		{
			return r<<16 | g<<8 | b;
		}
		
		/**
		 * ARGB转10进制（Flash中默认是10进制，可以随时用 toString(16) 转换为16进制，但是在A高位不足16时候，转换时候会存在一些不算是BUG的BUG）
		 * @param a 全称为 alpha 透明度
		 * @param r 全称为 red 红色
		 * @param g 全称为 green 绿色
		 * @param b 全称为 blue 蓝色
		 * @return 合并后的10进制的ARGB数字
		 */
		public static function argbToNumber ( a:uint, r:uint, g:uint, b:uint ) : uint
		{
			return a<<24 | r<<16 | g<<8 | b;
		}
		
		/**
		 * ARGB转10进制，这个方法是为透明度和RGB颜色分为两块，专门设计的
		 * @param a 全称为 alpha 透明度
		 * @param rgb 全称为 red green blue 红色 绿色 蓝色
		 * @return 合并后的10进制的ARGB数字
		 */
		public static function argbToNumber2 ( a:uint, rgb:uint ) : uint
		{
			return a<<24 | rgb;
		}
		
		
		
		//************************ ************************* ARGB转数字（16进制） 系列方法 ******************** *********** *** **////
		
		/**
		 * RGB转16进制字符串（因为10进制数字使用toString会有一些问题，所以才创建了这个系列的方法）
		 * @param r 全称为 red 红色
		 * @param g 全称为 green 绿色
		 * @param b 全称为 blue 蓝色
		 * @param prefix 16进制的前缀，AS中是“0x”，其他语言或者软件也有使用“#”或者其他字符的，也可以设置为""空字符，则不需要前缀
		 * @param isCapital 是否将小写16进制字符转换为大写字符
		 * @return 合并后的16进制的RGB数字，数字的16进制形式的字符串
		 */
		public static function rgbTo16Number ( r:uint, g:uint, b:uint, prefix:String = "0x", isCapital:Boolean = true ) : String
		{
			var rgb : uint;
			if ( r < 16 )
			{
				var r2 : uint = 16;
				rgb = r2<<16 | g<<8 | b;
				var rgbStr : String = rgb.toString(16);
				rgbStr = rgbStr.substring( 2 );
				if ( isCapital ) return prefix + ("0" + r.toString(16) + rgbStr).toLocaleUpperCase();
				else return prefix + "0" + r.toString(16) + rgbStr;
			}
			else
			{
				rgb = r<<16 | g<<8 | b;
				if ( isCapital ) return prefix + rgb.toString(16).toLocaleUpperCase();
				else return prefix + rgb.toString(16);
			}
		}
		
		/**
		 * ARGB转16进制字符串（因为10进制数字使用toString会有一些问题，所以才创建了这个系列的方法）
		 * @param a 全称为 alpha 透明度
		 * @param r 全称为 red 红色
		 * @param g 全称为 green 绿色
		 * @param b 全称为 blue 蓝色
		 * @param prefix 16进制的前缀，AS中是“0x”，其他语言或者软件也有使用“#”或者其他字符的，也可以设置为""空字符，则不需要前缀
		 * @param isCapital 是否将小写16进制字符转换为大写字符
		 * @return 合并后的16进制的ARGB数字，数字的16进制形式的字符串
		 */
		public static function argbTo16Number ( a:uint, r:uint, g:uint, b:uint, prefix:String = "0x", isCapital:Boolean = true ) : String
		{
			var argb : uint;
			if ( a < 16 )
			{
				var a2 : uint = 16;
				argb = a2<<24 | r<<16 | g<<8 | b;
				var argbStr : String = argb.toString(16);
				argbStr = argbStr.substring( 2 );
				if ( isCapital ) return prefix + ("0" + a.toString(16) + argbStr).toLocaleUpperCase();
				else return prefix + "0" + a.toString(16) + argbStr;
			}
			else
			{
				argb = a<<24 | r<<16 | g<<8 | b;
				if ( isCapital ) return prefix + argb.toString(16).toLocaleUpperCase();
				else return prefix + argb.toString(16);
			}
		}
		
		/**
		 * ARGB转16进制字符串，这个方法是为透明度和RGB颜色分为两块，专门设计的
		 * @param a 全称为 alpha 透明度
		 * @param rgb 全称为 red green blue 红色 绿色 蓝色
		 * @param prefix 16进制的前缀，AS中是“0x”，其他语言或者软件也有使用“#”或者其他字符的，也可以设置为""空字符，则不需要前缀
		 * @return 合并后的16进制的ARGB数字，数字的16进制形式的字符串
		 */
		public static function argbTo16Number2 ( a:uint, rgb:uint, prefix:String = "0x", isCapital:Boolean = true ) : String
		{
			var rgbStr : String = rgb.toString(16);
			if ( rgbStr.length == 1 ) rgbStr = "00000" + rgbStr;
			else if ( rgbStr.length == 2 ) rgbStr = "0000" + rgbStr;
			else if ( rgbStr.length == 3 ) rgbStr = "000" + rgbStr;
			else if ( rgbStr.length == 4 ) rgbStr = "00" + rgbStr;
			else if ( rgbStr.length == 5 ) rgbStr = "0" + rgbStr;
			
			var argbStr : String = a.toString(16) + rgbStr;
			if ( argbStr.length == 7 ) argbStr = "0" + argbStr;
			
			if ( isCapital ) return prefix + argbStr.toLocaleUpperCase();
			else return prefix + argbStr;
		}
		
		
		
		
		//************************ ************************* 数字转ARGB 系列方法 ******************** *********** *** **////
		/**
		 * 10进制转RGB对象（Object），对象分别有三个属性：r、g、b
		 * @param rgb 全称为 red green blue 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToRGB ( rgb:uint ) : Object
		{
			var color : Object = {};
			color.r = (rgb >> 16) & 0xFF;
			color.g = (rgb >> 8) & 0xFF;
			color.b = rgb & 0xFF;
			return color;
		}
		
		/**
		 * 10进制转ARGB对象（Object），对象分别有四个属性：a、r、g、b
		 * @param argb 全称为 alpha red green blue 透明度 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToARGB ( argb:uint ) : Object
		{
			var color : Object = {};
			color.a = (argb >> 24) & 0xFF;
			color.r = (argb >> 16) & 0xFF;
			color.g = (argb >> 8) & 0xFF;
			color.b = argb & 0xFF;
			return color;
		}
		
		/**
		 * 10进制转ARGB对象（Object），这个方法是为透明度和RGB颜色分为两块，专门设计的
		 * @param a 全称为 alpha 透明度
		 * @param rgb 全称为 red green blue 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToARGB2 ( a:uint, rgb:uint ) : Object
		{
			var color : Object = {};
			color.a = a;
			color.r = (rgb >> 16) & 0xFF;
			color.g = (rgb >> 8) & 0xFF;
			color.b = rgb & 0xFF;
			return color;
		}
		
		
		
		//************************ ************************* RGB 和 HSV 相互转换  系列方法 ******************** *********** *** **////
		/**
		 * RGB颜色 转换 HSV颜色 对象（Object），对象分别有三个属性：h、s、v
		 * @param r 红色
		 * @param g 绿色
		 * @param b 蓝色
		 * return HSV对象，hue 色调 0-360°，saturation 饱和度 0-100%，value 明度 0-100%
		 */
		public static function rgbToHSV ( r:Number, g:Number, b:Number ) : Object
		{
			// 超过范围的极限值修正
			if ( r < 0 ) r = 0;
			else if ( r > 255 ) r = 255;
			if ( g < 0 ) g = 0;
			else if ( g > 255 ) g = 255;
			if ( b < 0 ) b = 0;
			else if ( b > 255 ) b = 255;
			
			var h:Number, s:Number, v:Number, max:Number, min:Number, temp:Number;
			r = r / 255;
			g = g / 255;
			b = b / 255;
			
			max = Math.max(r,g,b);
			min = Math.min(r,g,b);
			
			temp = max-min;
			
			if ( temp == 0 ) h = 0;
			if ( r == max ) h = 60 * (((g-b)/temp)%6);
			if ( g == max ) h = 60 * ( 2 + (b-r)/temp);
			if ( b == max ) h = 60 * (4 + (r-g)/temp);
			
			if ( isNaN(h) )
			{
				h = 0;
			}
			else if ( h < 0 )
			{
				h = 360 + h;
			}
			
			if ( max == 0 )
			{
				s = 0;
			}
			else
			{
				s = Math.round(temp / max * 100);			
			}
			
			v = Math.round(max * 100);
			
			var color : Object = {};
			color.h = Math.round( h );
			color.s = Math.round( s );
			color.v = Math.round( v );
			
			return color;
		}
		
		/**
		 * HSV颜色 转换 RGB颜色 对象（Object），对象分别有三个属性：r、g、b
		 * @param h 色调
		 * @param s 饱和度
		 * @param v 明度
		 * return RGB对象，red 红色 0-255，green 绿色 0-255，blue 蓝色 0-255
		 */
		public static function hsvToRGB ( h:Number, s:Number, v:Number ) : Object
		{
			s *= 0.01;
			v *= 0.01;
			
			// 超过范围的极限值修正
			if ( h < 0 ) h = 0;
			else if ( h >= 360 ) h = 359.99;
			if ( s < 0 ) s = 0;
			else if ( s > 100 ) s = 100;
			if ( v < 0 ) v = 0;
			else if ( v > 100 ) v = 100;
			
			var c : Number, x : Number, m : Number, r : Number, g : Number, b : Number;
			c = v * s;
			x = c * (1 - Math.abs((h / 60) % 2 - 1))
			m = v - c;
			if ( h >= 0 && h < 60 )
			{
				r = c, g = x, b = 0
			}
			else if ( h >= 60 && h < 120 )
			{
				r = x, g = c, b = 0;
			}
			else if ( h >= 120 && h < 180 )
			{
				r = 0, g = c, b = x;
			}
			else if ( h >= 180 && h < 240 )
			{
				r = 0, g = x, b = c;
			}
			else if ( h >= 240 && h < 300 )
			{
				r = x, g = 0, b = c;
			}
			else if ( h >= 300 && h < 360 )
			{
				r = c, g = 0, b = x;
			}
			
			var color : Object = {};
			color.r = Math.round((r + m) * 255)
			color.g = Math.round((g + m) * 255);
			color.b = Math.round((b + m) * 255);
			
			return color;
		}
		
		/**
		 * RGB颜色 转换 XYZ颜色坐标 对象（Object），对象分别有三个属性：x、y、z
		 * 参考：https://blog.csdn.net/gubenpeiyuan/article/details/60577008 
		 * @param r 红色
		 * @param g 绿色
		 * @param b 蓝色
		 * return 转换后的XYZ对象
		 */
		public static function rgbToXYZ ( r:Number, g:Number, b:Number ) : Object
		{
			var matrixM : Array=[[0.436052025, 0.385081593, 0.143087414], 
								 [0.222491598, 0.716886060, 0.060621486],
								 [0.013929122, 0.097097002, 0.714185470]];
			
			var rgb : Array=[r/255, g/255, b/255];
			
			rgb[0] = rgbToXYZGamma( rgb[0] );
			rgb[1] = rgbToXYZGamma( rgb[1] );
			rgb[2] = rgbToXYZGamma( rgb[2] );
			
			var xyz : Object = {};
			xyz.x = 100 * (matrixM[0][0] * rgb[0] + matrixM[0][1] * rgb[1] + matrixM[0][2] * rgb[2]);
			xyz.y = 100 * (matrixM[1][0] * rgb[0] + matrixM[1][1] * rgb[1] + matrixM[1][2] * rgb[2]);
			xyz.z = 100 * (matrixM[2][0] * rgb[0] + matrixM[2][1] * rgb[1] + matrixM[2][2] * rgb[2]);
			
			return xyz;
		}
		
		
		/**
		 * 校正函数
		 */
		private static function rgbToXYZGamma ( num:Number ) : Number {
			if ( num > 0.04045 )
			{
				num = Math.pow((num + 0.055) / 1.055, 2.4);
			}
			else
			{
				num /= 12.92;
			}
			return num;
		}
		
		/**
		 * XYZ颜色坐标 转换 LAB颜色坐标 对象（Object），对象分别有三个属性：l、a、b
		 * 参考：https://blog.csdn.net/tian_110/article/details/45575869
		 * @param x X颜色坐标
		 * @param y Y颜色坐标
		 * @param z Z颜色坐标
		 * return 转换后的XYZ对象
		 */
		public static function xyzToLAB ( x:Number, y:Number, z:Number ) : Object
		{
			x /= 96.4221;
			y /= 100;
			z /= 82.5221;
			
			var fx : Number = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x +0.137931);
			var fy : Number = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y +0.137931);
			var fz : Number = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z +0.137931);
			
			var lab : Object = {};
			lab.l = y > 0.008856 ? (116.0 * fy - 16.0) : (903.3 * y);
			lab.a = 500 * (fx - fy);
			lab.b = 200 * (fy - fz);
			
			return lab;
		}
		
		
		//************************ ************************* HSV 和 CIEDE2000 两个计算色差的方法 ******************** *********** *** **////
		/**
		 * 使用 HSV 进行色差计算，可以通过色差值，判断出颜色是否相近或者差别很大
		 * @param r1 红色值1，范围0-255整数
		 * @param g1 绿色值1，范围0-255整数
		 * @param b1 蓝色值1，范围0-255整数
		 * @param r2 红色值2，范围0-255整数
		 * @param g2 绿色值2，范围0-255整数
		 * @param b2 蓝色值2，范围0-255整数
		 * @return 计算出的色差值
		 */	
		public static function distanceHSV ( r1:Number, g1:Number, b1:Number, r2:Number, g2:Number, b2:Number ) : Number
		{
			var R : Number = 100;
			var angle : Number = 30;
			var h : Number = R * Math.cos(angle / 180 * Math.PI);
			var r : Number = R * Math.sin(angle / 180 * Math.PI);
			
			var hsv1 : Object = rgbToHSV( r1, g1, b1 );
			var hsv2 : Object = rgbToHSV( r2, g2, b2 );
			
			var x1 : Number = r1 * hsv1.v / 100 * hsv1.s / 100 * Math.cos(hsv1.h / 180 * Math.PI);
			var y1 : Number = r1 * hsv1.v / 100 * hsv1.s / 100 * Math.sin(hsv1.h / 180 * Math.PI);
			var z1 : Number = h * (1 - hsv1.v / 100);
			
			var x2 : Number = r * hsv2.v / 100 * hsv2.s / 100 * Math.cos(hsv2.h / 180 * Math.PI);
			var y2 : Number = r * hsv2.v / 100 * hsv2.s / 100 * Math.sin(hsv2.h / 180 * Math.PI);
			var z2 : Number = h * (1 - hsv2.v / 100);
			
			var dx : Number = x1 - x2;
			var dy : Number = y1 - y2;
			var dz : Number = z1 - z2;
			
			var distance : Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
			return distance;
		}
		
		/**
		 * 使用 CIEDE2000 计算颜色色差，CIEDE2000是根据人类眼睛视觉差，计算出的更适合人类的颜色差别计算方法
		 * 人类的眼睛接收颜色的明暗度，亮度是不一样的，即使同样纯度的红色和蓝色，还是会感觉一个更亮，一个更暗
		 * 参考资料：
		 * https://www.colortell.com/3424.html  具体色差公式
		 * https://www.colortell.com/colorde 在线色差计算工具 （当前算法与这个在线工具得到的值偏差0.1）
		 * https://blog.51cto.com/tangchao/764248 案例
		 * @param r1 红色值1，范围0-255整数
		 * @param g1 绿色值1，范围0-255整数
		 * @param b1 蓝色值1，范围0-255整数
		 * @param r2 红色值2，范围0-255整数
		 * @param g2 绿色值2，范围0-255整数
		 * @param b2 蓝色值2，范围0-255整数
		 * @return 计算出的色差值
		 */	
		public static function distanceCIEDE2000 ( r1:Number, g1:Number, b1:Number, r2:Number, g2:Number, b2:Number ) : Number
		{
			var xyz1 : Object = rgbToXYZ( r1, g1, b1 );
			var xyz2 : Object = rgbToXYZ( r2, g2, b2 );
			
			var lab1 : Object = xyzToLAB( xyz1.x, xyz1.y, xyz1.z );
			var lab2 : Object = xyzToLAB( xyz2.x, xyz2.y, xyz2.z );
			
			var L1:Number,A1:Number,B1:Number,L2:Number,A2:Number,B2:Number;
			L1=lab1.l;
			A1=lab1.a;
			B1=lab1.b;
			
			L2=lab2.l;
			A2=lab2.a;
			B2=lab2.b;
			
			
			var G:Number;//G表示CIELab 颜色空间a轴的调整因子,是彩度的函数
			var KL:Number=1, KC:Number=1, KH:Number=1;// 参考实验条件
			var Cab:Number = distanceE2000Saturation(A1, B1) + distanceE2000Saturation(A2, B2);
			var meanCab:Number=Cab/2;
			var meanCabpow7:Number=Math.pow(meanCab,7);
			G=0.5*(1-Math.pow(meanCabpow7/(meanCabpow7+Math.pow(25,7)),0.5));
			
			var LL1:Number,AA1:Number,BB1:Number,LL2:Number,AA2:Number,BB2:Number;
			
			LL1=L1;
			AA1=A1*(1+G);
			BB1=B1;
			
			LL2=L2;
			AA2=A2*(1+G);
			BB2=B2;
			
			var CC1:Number,CC2:Number;//两样本的彩度值
			CC1 = distanceE2000Saturation(AA1, BB1);
			CC2 = distanceE2000Saturation(AA2, BB2);
			
			var HH1:Number,HH2:Number;//两样本的色调角
			HH1 = distanceE2000HueAngle(AA1,BB1);
			HH2 = distanceE2000HueAngle(AA2,BB2);
			
			var delta_LL:Number=LL1-LL2;
			var delta_CC:Number=CC1-CC2;
			var delta_HH:Number=2 * Math.sin(Math.PI*(HH1-HH2) / 360) * Math.pow(CC1 * CC2, 0.5);
			
			//计算公式中的加权函数SL,SC,SH,T
			var mean_LL:Number,mean_CC:Number,mean_HH:Number;
			mean_LL=(LL1+LL2)/2;
			mean_HH=(HH1+HH2)/2;
			mean_CC=(CC1+CC2)/2;
			
			var SL:Number,SC:Number,SH:Number,T:Number;
			SL=1+0.015*Math.pow(mean_LL-50,2)/Math.pow(20+Math.pow(mean_LL-50,2),0.5);
			SC=1+0.045*mean_CC;
			T = 1 - 0.17 * Math.cos((mean_HH - 30) * Math.PI / 180) + 0.24 * Math.cos((2 * mean_HH) * Math.PI / 180) + 0.32 * Math.cos((3 * mean_HH + 6) * Math.PI / 180) - 0.2 * Math.cos((4 * mean_HH - 63) * Math.PI / 180);
			SH=1+0.015*mean_CC*T;
			
			//计算公式中的RT
			var meanCCpow7:Number=Math.pow(mean_CC,7);
			var RC:Number=2*Math.pow(meanCCpow7/(meanCCpow7+Math.pow(25,7)),0.5);
			var deltaXita:Number=30*Math.exp(-Math.pow((mean_HH - 275) / 25, 2));      //△θ 以°为单位
			var RT:Number=-Math.sin((2*deltaXita)*Math.PI/180)*RC;
			
			
			var L_item:Number,C_item:Number,H_item:Number;
			L_item=delta_LL/(KL*SL);
			C_item=delta_CC/(KC*SC);
			H_item=delta_HH/(KH*SH);
			
			
			var E00 : Number = Math.pow(L_item * L_item + C_item * C_item + H_item * H_item + RT * C_item * H_item, 0.5);
			return E00;
		}
		
		/**
		 * 彩度计算
		 */
		private static function distanceE2000Saturation ( a:Number, b:Number ) : Number
		{
			return Math.pow(a * a + b * b, 0.5);
		}
		
		/**
		 * 
		 */
		private static function distanceE2000HueAngle ( a:Number, b:Number ) : Number
		{
			var h : Number = (180/Math.PI)*Math.atan(b/a);  //有正有负
			var hab : Number = 0;
			
			if ( a > 0 && b > 0 )
			{
				hab = h;
			}
			else if ( a < 0 && b > 0 )
			{
				hab = 180 + h;
			}
			else if ( a < 0 &&b < 0 )
			{
				hab = 180 + h;
			}
			else
			{
				hab = 360 + h;
			}
			return hab;
		}
		

	}
}