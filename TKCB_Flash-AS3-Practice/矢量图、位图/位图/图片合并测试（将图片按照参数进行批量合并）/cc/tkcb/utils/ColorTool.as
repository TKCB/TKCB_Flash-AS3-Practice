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
	 * @修改时间 2019-4-12
	 * @version 1.0.0
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
		
		/**
		 * 随机HSV颜色数字对象（Object），对象分别有三个属性：hue、saturation、value
		 * @return 随机的HSV颜色数字对象
		 */
		public static function randomHSV () : Object
		{
			var hsv : Object = {};
			hsv.hue = Math.round( Math.random() * 360 );
			hsv.saturation = Math.round( Math.random() * 100 );
			hsv.value = Math.round( Math.random() * 100 );
			return hsv;
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
		 * 10进制转RGB对象（Object），对象分别有三个属性：red、green、blue
		 * @param rgb 全称为 red green blue 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToRGB ( rgb:uint ) : Object
		{
			var color : Object = {};
			color.red = (rgb >> 16) & 0xFF;
			color.green = (rgb >> 8) & 0xFF;
			color.blue = rgb & 0xFF;
			return color;
		}
		
		/**
		 * 10进制转ARGB对象（Object），对象分别有四个属性：alpha、red、green、blue
		 * @param argb 全称为 alpha red green blue 透明度 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToARGB ( argb:uint ) : Object
		{
			var color : Object = {};
			color.alpha = (argb >> 24) & 0xFF;
			color.red = (argb >> 16) & 0xFF;
			color.green = (argb >> 8) & 0xFF;
			color.blue = argb & 0xFF;
			return color;
		}
		
		/**
		 * 10进制转ARGB对象（Object），这个方法是为透明度和RGB颜色分为两块，专门设计的
		 * @param argb 全称为 alpha red green blue 透明度 红色 绿色 蓝色
		 * @return 单独的颜色数字（十进制）
		 */
		public static function numberToARGB2 ( a:uint, rgb:uint ) : Object
		{
			var color : Object = {};
			color.alpha = a;
			color.red = (rgb >> 16) & 0xFF;
			color.green = (rgb >> 8) & 0xFF;
			color.blue = rgb & 0xFF;
			return color;
		}
		
		
		
		//************************ ************************* RGB 和 HSV 相互转换  系列方法 ******************** *********** *** **////
		/**
		 * RGB颜色 转换 HSV颜色 对象（Object），对象分别有三个属性：hue、saturation、value
		 * @param r 红色
		 * @param g 绿色
		 * @param b 蓝色
		 * @param isRound 是否对HSV数字进行四舍五入保留了两位小数
		 * @param isInt 是否对HSV数字进行整数处理，如果是，则忽略isRound参数，使用Math.round()方法求整数
		 * return HSV对象，hue 色调 0-360°，saturation 饱和度 0-100%，value 明度 0-100%
		 */
		public static function rgbToHSV ( r:Number, g:Number, b:Number, isRound:Boolean = true, isInt:Boolean = false ) : Object
		{
			var h : Number = 0;
			var s : Number = 0;
			var v : Number = 0;
			
			var min : Number = Math.min( r, Math.min( g, b ));
			var max : Number = Math.max( r, Math.max( g, b ));
			v = max;
			var delta : Number = max - min;
			if( max != 0 )
			{
				s = delta / max;
			}
			else
			{
				return [ 0, 0, 0 ];
			}
			
			if( r == max )
			{
				h = ( g - b ) / delta;		// between yellow & magenta
			}
			else if( g == max )
			{
				h = 2 + ( b - r ) / delta;		// between cyan & yellow
			} 
			else
			{
				h = 4 + ( r - g ) / delta;		// between magenta & cyan
			}
			h *= 60;		// degrees
			
			if( h < 0 )
			{
				h += 360;
			}
			
			if( !h )
			{
				h = 0;
			}
			
			s = s * 100;
			
			v = v / 255 * 100;
			
			var color : Object = {};
			color.hue = h;
			color.saturation = s;
			color.value = v;
			
			if ( isRound )
			{
				color.hue = Math.round(h * 100) / 100;
				color.saturation = Math.round(s * 100) / 100;
				color.value = Math.round(v * 100) / 100;
			}
			
			if ( isInt )
			{
				color.hue = Math.round( h );
				color.saturation = Math.round( s );
				color.value = Math.round( v );
			}
			
			return color;
		}
		
		/**
		 * HSV颜色 转换 RGB颜色 对象（Object），对象分别有三个属性：red、green、blue
		 * @param h 色调
		 * @param s 饱和度
		 * @param v 明度
		 * return RGB对象，red 红色 0-255，green 绿色 0-255，blue 蓝色 0-255
		 */
		public static function hsvToRGB ( h:Number, s:Number, v:Number ) : Object
		{
			s /= 100;
			v /= 100;
			
			var r : Number = 0;
			var g : Number = 0;
			var b : Number = 0;
			
			var H : uint = h / 60;
			
			var f : Number = h / 60 - H;
			var p : Number = v * ( 1 - s );
			var q : Number = v * ( 1 - s * f );
			var t : Number = v * ( 1 - s * ( 1 - f ) );
			
			switch ( H )
			{　　　　
				case 0 :
					r = v;
					g = t;
					b = p;
					break;
				case 1 :
					r = q;
					g = v;
					b = p;
					break;
				case 2 :
					r = p;
					g = v;
					b = t;
					break;
				case 3 :
					r = p;
					g = q;
					b = v;
					break;
				case 4 :
					r = t;
					g = p;
					b = v;
					break;
				case 5 :
					r = v;
					g = p;
					b = q;
					break;
			}
			
			var color : Object = {};
			color.red = Math.round(r * 255);
			color.green = Math.round(g * 255);
			color.blue = Math.round(b * 255);
			
			return color;
		}

	}
}