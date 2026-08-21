// 原作者:cordy
// http://www.cordyblog.cn

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
 * v1.0.0 2016-9-9
 */

package cc.tkcb.filter
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.BevelFilter;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	
	/**
	 * PhotoFilter 图片基本滤镜类，这是一个静态类，包括了常用的一些滤镜效果（底片、黑白、浮雕、凸起、陈旧、噪音等等，共19种效果），用起来很方便
	 * @author cordy（修改者TKCB（www.tkcb.cc））
	 * @创建时间 未知
	 * @修改时间 2016-9-9
	 * @version 1.0.0
	 */
	public class PhotoFilter
	{
		//************************ ************************* 静态属性 ******************** *********** *** **////
		/** 原始位图数据对象 */
		private static var sourceBitmap : Bitmap;
		
		/** 返回的新的位图数据对象 */
		private static var returnBitmapData : BitmapData;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function PhotoFilter ()
		{
			
		}
		
		
		//************************ ************************* 效果类似的滤镜组（5个）：反色滤镜、灰度滤镜、旧照片滤镜、浮雕滤镜、光照滤镜 ******************** *********** *** **////
		/**
		 * 反色滤镜（底片效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function invert ( source:BitmapData ) : BitmapData
		{
			sourceBitmap = new Bitmap( source );
			var tempSprite = new Sprite();
			tempSprite.addChild( sourceBitmap );
			var mytmpmc:Sprite = new Sprite();
			mytmpmc.graphics.lineStyle( 0,0x000000, 100 );
			mytmpmc.graphics.moveTo( 0,0 );
			mytmpmc.graphics.beginFill( 0x000000 );
			mytmpmc.graphics.lineTo( sourceBitmap.width, 0 );
			mytmpmc.graphics.lineTo( sourceBitmap.width, sourceBitmap.height );
			mytmpmc.graphics.lineTo( 0, sourceBitmap.height );
			mytmpmc.graphics.lineTo( 0,0 );
			mytmpmc.graphics.endFill();
			mytmpmc.blendMode = "invert";
			tempSprite.addChild( mytmpmc );
			returnBitmapData = new BitmapData( tempSprite.width, tempSprite.height, true, 0x00FFFFFF );
			returnBitmapData.draw( tempSprite );
			tempSprite.removeChild( mytmpmc );
			tempSprite.removeChild( sourceBitmap );
			mytmpmc = null;
			
			return returnBitmapData;
		}
		
		/**
		 * 灰度滤镜（黑白效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function grayFilter ( source:BitmapData ) : BitmapData
		{
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ getGrayFilter() ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 旧照片滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function oldPictureFilter ( source:BitmapData ) : BitmapData
		{
			var filter = getGrayFilter();
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			source = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			source.draw( sourceBitmap );
			var matrix : Array = new Array();
			matrix = matrix.concat( [ 0.94, 0, 0, 0, 0 ] );
			matrix = matrix.concat( [ 0, 0.9, 0, 0, 0 ] );
			matrix = matrix.concat( [ 0, 0, 0.8, 0, 0 ] );
			matrix = matrix.concat( [ 0, 0, 0, 0.8, 0 ] );
			filter = new ColorMatrixFilter( matrix );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 浮雕滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param angle 浮雕投影角度，0-360（单位：度）
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function embossFilter ( source:BitmapData, angle:uint = 315 ) : BitmapData
		{
			//var angle=315;
			var radian = angle * Math.PI / 180;
			var pi4 = Math.PI / 4;
			var clamp : Boolean = false;
			var clampColor : Number = 0xFF0000;
			var clampAlpha : Number = 256;
			var bias : Number = 128;
			var preserveAlpha : Boolean = false;
			var matrix:Array = [ Math.cos( radian + pi4 ) * 256, Math.cos( radian + 2 * pi4 ) * 256, Math.cos( radian + 3 * pi4 ) * 256,
			                     Math.cos( radian ) * 256, 0, Math.cos( radian + 4 * pi4 ) * 256,
			                     Math.cos( radian - pi4 ) * 256, Math.cos( radian - 2 * pi4 ) * 256, Math.cos( radian - 3 * pi4 ) * 256 ];
			var matrixCols : Number = 3;
			var matrixRows : Number = 3;
			var filter : ConvolutionFilter = new ConvolutionFilter( matrixCols, matrixRows, matrix, matrix.length, bias, preserveAlpha, clamp, clampColor, clampAlpha );
			var myFilters : Array = new Array();
			myFilters.push( filter );
			myFilters.push( getGrayFilter() );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = myFilters;
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 光照滤镜（高光效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param power 光照强度，合理的范围应该是1-256之间
		 * @param posx 光源X轴坐标位置，0-1（比例位置），0.5为中间
		 * @param posy 光源Y轴坐标位置，0-1（比例位置），0.5为中间
		 * @param r 光源半径值（单位：像素），默认根据强度自动计算
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function lightingFilter ( source:BitmapData, power: Number = 128, posx:Number = 0.5, posy:Number = 0.5, r:Number = 0 ) : BitmapData
		{
			//power 0-255
			var midx = int( source.width * posx );
			var midy = int( source.height * posy );
			if ( r == 0 )
			{
				r = Math.sqrt( midx * midx + midy * midy );
			}
			if ( r == 0 )
			{
				r = Math.sqrt( source.width * source.width / 4 + source.height * source.height / 4 );
			}
			var radius = int(r);
			var sr = r * r;
			returnBitmapData = source.clone();
			var sd, color, r, g, b, distance, brightness;
			for ( var y = 0; y < source.height; y++ )
			{
				for ( var x = 0; x < source.width; x++ )
				{
					sd = (x - midx) * (x - midx) + (y - midy) * (y - midy);
					if ( sd < sr )
					{
						color = source.getPixel(x, y);
						r = (color & 0xff0000) >> 16;
						g = (color & 0x00ff00) >> 8;
						b = color & 0x0000ff;
						distance = Math.sqrt( sd );
						brightness = int( power * (radius - distance) / radius );
						r = r + brightness > 255 ? 255 : r + brightness;
						g = g + brightness > 255 ? 255 : g + brightness;
						b = b + brightness > 255 ? 255 : b + brightness;
						returnBitmapData.setPixel( x, y, r * 65536 + g * 256 + b );
					}
				}
			}
			
			return returnBitmapData;
		}
		
		
		//************************ ************************* 效果类似的滤镜组（5个）：模糊滤镜、马赛克滤镜、扩散滤镜、锐化滤镜、噪声滤镜 ******************** *********** *** **////
		/**
		 * 模糊滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param blurX 水平模糊的值（单位：像素）
		 * @param blurY 垂直模糊的值（单位：像素）
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function blurFilter ( source:BitmapData, blurX:Number = 5, blurY:Number = 5 ) : BitmapData
		{
			var filter : BlurFilter = new BlurFilter( blurX, blurY, BitmapFilterQuality.HIGH );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 马赛克滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param block 马赛克大小（单位：像素）
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function mosaicFilter ( source:BitmapData, block:Number = 6 ) : BitmapData
		{
			//block 1-32
			returnBitmapData = source.clone();
			var sumr, sumg, sumb, product, color, r, g, b, br, bg, bb;
			for ( var y = 0; y < source.height; y += block )
			{
				for ( var x = 0; x < source.width; x += block )
				{
					sumr = 0;
					sumg = 0;
					sumb = 0;
					product = 0;
					for ( var j = 0; j < block; j++ )
					{
						for ( var i = 0; i < block; i++ )
						{
							if ( x + i < source.width && y + j < source.height )
							{
								color = source.getPixel (x + i, y + j );
								r = (color & 0xff0000) >> 16;
								g = (color & 0x00ff00) >> 8;
								b = color & 0x0000ff;
								sumr += r;
								sumg += g;
								sumb += b;
								product++;
							}
						}
					}
					br = int(sumr / product);
					bg = int(sumg / product);
					bb = int(sumb / product);
					for ( j = 0; j < block; j++ )
					{
						for ( i = 0; i < block; i++ )
						{
							if ( x + i < source.width && y + j < source.height )
							{
								returnBitmapData.setPixel( x + i, y + j, br * 65536 + bg * 256 + bb );
							}
						}
					}
				}
			}
			
			return returnBitmapData;
		}
		
		/**
		 * 扩散滤镜（毛玻璃效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param scaleX X径向扩散（方向和强度），合理的范围应该是0-100之间
		 * @param scaleY Y径向扩散（方向和强度），合理的范围应该是0-100之间
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function diffuseFilter ( source:BitmapData, scaleX:Number = 5, scaleY:Number = 5 ) : BitmapData
		{
			var componentX : Number = 1;
			var componentY : Number = 1;
			var color: Number = 0x000000;
			var alpha: Number = 0x000000;
			var tempBitmap = new BitmapData( source.width, source.height, true, 0x00FFFFFF );
			tempBitmap.noise( 888888 );
			sourceBitmap = new Bitmap( source );
			var filter : DisplacementMapFilter = new DisplacementMapFilter( tempBitmap, new Point(0, 0), componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 锐化滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param sharp 锐化强度值，合理的范围应该是0-5之间
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function sharpenFilter ( source:BitmapData, sharp:Number = 0.7 ) : BitmapData
		{
			var matrix : Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			matrix[1] = matrix[3] = matrix[5] = matrix[7] = -sharp;
			matrix[4] = 1 + sharp * 4;
			var filter : ConvolutionFilter = new ConvolutionFilter( 3, 3, matrix );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 噪声滤镜（杂点效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param degree 噪声强度值，合理的范围应该是1-256之间（设置超大的噪声强度1000，可实现生成杂点图片）
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function noiseFilter ( source:BitmapData, degree:Number = 128 ) : BitmapData
		{
			//degree 0-255
			var noise, color, r, g, b;
			returnBitmapData = source.clone();
			for ( var i = 0; i < source.height; i++ )
			{
				for ( var j = 0; j < source.width; j++ )
				{
					noise = int( Math.random() * degree * 2 ) - degree;
					color = source.getPixel( j, i );
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					r = r + noise < 0 ? 0 : r + noise > 255 ? 255 : r + noise;
					g = g + noise < 0 ? 0 : g + noise > 255 ? 255 : g + noise;
					b = b + noise < 0 ? 0 : b + noise > 255 ? 255 : b + noise;
					returnBitmapData.setPixel( j, i, r * 65536 + g * 256 + b );
				}
			}
			
			return returnBitmapData;
		}
		
		
		//************************ ************************* 效果类似的滤镜组（3个）：凸起滤镜、球面滤镜、挤压滤镜 ******************** *********** *** **////
		/**
		 * 凸起滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param distance 凸起强度值，合理的范围应该是1-10之间
		 * @param angleInDegrees 凸起角度值，0-360（单位：度），一般设置为45度（默认值）
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function raiseFilter ( source:BitmapData, distance:int = 5, angleInDegrees:int = 45 ) : BitmapData
		{
			//var distance:Number       = 5;
			//var angleInDegrees:Number = 45;
			var highlightColor : Number = 0xCCCCCC;
			var highlightAlpha : Number = 0.8;
			var shadowColor : Number = 0x808080;
			var shadowAlpha : Number = 0.8;
			var blurX : Number = 5;
			var blurY : Number = 5;
			var strength : Number = 5;
			var quality : Number = BitmapFilterQuality.HIGH;
			var type : String = BitmapFilterType.INNER;
			var knockout : Boolean = false;
			var filter : BevelFilter = new BevelFilter( distance,
														angleInDegrees,
														highlightColor,
														highlightAlpha,
														shadowColor,
														shadowAlpha,
														blurX,
														blurY,
														strength,
														quality,
														type,
														knockout );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 球面滤镜（鱼眼效果）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function spherizeFilter ( source:BitmapData ) : BitmapData
		{
			var midx = int(source.width / 2);
			var midy = int(source.height / 2);
			var maxmidxy = midx > midy ? midx : midy;
			var radian, radius, offsetX, offsetY, color, r, g, b;
			returnBitmapData = source.clone();
			for ( var i = 0; i < source.height - 1; i++ )
			{
				for ( var j = 0; j < source.width - 1; j++ )
				{
					offsetX = j - midx;
					offsetY = i - midy;
					radian = Math.atan2( offsetY, offsetX );
					radius = ( offsetX * offsetX + offsetY * offsetY ) / maxmidxy;
					var x = int( radius * Math.cos(radian) ) + midx;
					var y = int( radius * Math.sin(radian) ) + midy;
					if ( x < 0 )
					{
						x = 0;
					}
					if ( x >= source.width )
					{
						x = source.width - 1;
					}
					if ( y < 0 )
					{
						y = 0;
					}
					if ( y >= source.height )
					{
						y = source.height - 1;
					}
					color = source.getPixel( x, y );
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel( j, i, r * 65536 + g * 256 + b );
				}
			}
			
			return returnBitmapData;
		}
		
		/**
		 * 挤压滤镜（与球面滤镜相反）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param degree 挤压深度，建议10左右
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function pinchFilter ( source:BitmapData, degree:Number = 16 ) : BitmapData
		{
			var midx = int(source.width / 2);
			var midy = int(source.height / 2);
			var radian, radius, offsetX, offsetY, color, r, g, b;
			returnBitmapData = source.clone();
			for ( var i = 0; i < source.height - 1; i++ )
			{
				for ( var j = 0; j < source.width - 1; j++ )
				{
					offsetX = j - midx;
					offsetY = i - midy;
					radian = Math.atan2( offsetY, offsetX );
					radius = Math.sqrt( offsetX * offsetX + offsetY * offsetY );
					radius = Math.sqrt( radius ) * degree;
					var x = int( radius * Math.cos(radian) ) + midx;
					var y = int( radius * Math.sin(radian) ) + midy;
					if ( x < 0 )
					{
						x = 0;
					}
					if ( x >= source.width )
					{
						x = source.width - 1;
					}
					if ( y < 0 )
					{
						y = 0;
					}
					if ( y >= source.height )
					{
						y = source.height - 1;
					}
					color = source.getPixel( x, y );
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel( j, i, r * 65536 + g * 256 + b );
				}
			}
			
			return returnBitmapData;
		}
		
		
		//************************ ************************* 效果类似的滤镜组（5个）：素描滤镜、铅笔素描滤镜、水彩滤镜、油画滤镜、颜色阈值滤镜 ******************** *********** *** **////
		/**
		 * 素描滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param threshold 颜色阈值，建议值20-50之间
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function sketchFilter ( source:BitmapData, threshold:Number = 30 ) : BitmapData
		{
			//threshold 0-100
			var filter = getGrayFilter();
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			var color, gray1, gray2;
			for ( var i = 0; i < source.height - 1; i++ )
			{
				for ( var j = 0; j < source.width - 1; j++ )
				{
					color = source.getPixel( j, i );
					gray1 = ( color & 0xff0000 ) >> 16;
					color = source.getPixel( j + 1, i + 1 );
					gray2 = ( color & 0xff0000 ) >> 16;
					if ( Math.abs(gray1 - gray2) >= threshold )
					{
						returnBitmapData.setPixel( j, i, 0x222222 );
					}
					else
					{
						returnBitmapData.setPixel( j, i, 0xFFFFFF );
					}
				}
			}
			for ( i = 0; i < source.height; i++ )
			{
				returnBitmapData.setPixel( source.width - 1, i, 0xFFFFFF );
			}
			for ( i = 0; i < source.width; i++ )
			{
				returnBitmapData.setPixel( i, source.height - 1, 0xFFFFFF );
			}
			
			return returnBitmapData;
		}
		
		/**
		 * 铅笔素描滤镜
		 * @param threshold 要应用滤镜效果的位图数据对象
		 * @param grayNum 灰度阈值，默认为1，合理范围0～2
		 * @param exquisiteNum 精美细腻等级，1 粗燥简单，2 一般良好，3 精美细腻
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function pencilSketch ( source:BitmapData, grayNum:Number = 1, exquisiteNum:int = 1 ) : BitmapData
		{
			var newbm: BitmapData = new BitmapData(source.width, source.height, false, 0);
			var string: String = "";
			for (var x: uint = 0; x < source.width; x++)
			{
				for (var y: uint = 0; y < source.height; y++)
				{
					var rgb: uint = source.getPixel32(x, y);

					var r: uint = (rgb & 0xff0000) >> 16;
					var g: uint = (rgb & 0xff00) >> 8;
					var b: uint = (rgb & 0xff);
					var gray: uint = (int)(r * 0.3 + g * 0.59 + b * 0.11); //这里生成了灰度值

					var nextrgb: uint = source.getPixel32(x + 1, y + 1);
					var nextr: uint = (nextrgb & 0xff0000) >> 16;
					var nextg: uint = (nextrgb & 0xff00) >> 8;
					var nextb: uint = (nextrgb & 0xff);
					var nextgray: uint = (int)(nextr * 0.3 + nextg * 0.59 + nextb * 0.11); //这里生成了灰度值
					
					var tempGray : uint = gray + nextgray;
					
					//trace( tempGray );
					// 将颜色分为多个等级，分别设置为不同的灰度颜色（等级越多图形越细腻，还可以考虑使用其他颜色代替）
					var tempColor : uint;
					// 粗燥简单，四个等级
					if ( exquisiteNum == 1 )
					{
						// 白色
						if ( tempGray >= (240*grayNum) ) tempColor = 0xFFFFFF;
						// 灰色
						else if ( tempGray >= (200*grayNum) ) tempColor = 0xCCCCCC;
						else if ( tempGray >= (160*grayNum) ) tempColor = 0x888888;
						// 黑色
						else tempColor = 0x000000;
					}
					// 一般良好，八个等级
					else if ( exquisiteNum == 2 )
					{
						// 白色
						if ( tempGray >= (350*grayNum) ) tempColor = 0xFFFFFF;
						// 灰色
						else if ( tempGray >= (300*grayNum) ) tempColor = 0xDDDDDD;
						else if ( tempGray >= (250*grayNum) ) tempColor = 0xB9B9B9;
						else if ( tempGray >= (200*grayNum) ) tempColor = 0x959595;
						else if ( tempGray >= (150*grayNum) ) tempColor = 0x717171;
						else if ( tempGray >= (100*grayNum) ) tempColor = 0x4B4B4B;
						else if ( tempGray >= (50*grayNum) ) tempColor = 0x282828;
						// 黑色
						else tempColor = 0x000000;
					}
					// 精美细腻，十二个等级
					else if ( exquisiteNum == 3 )
					{
						// 白色
						if ( tempGray >= (385*grayNum) ) tempColor = 0xFFFFFF;
						// 灰色
						else if ( tempGray >= (350*grayNum) ) tempColor = 0xEBEBEB;
						else if ( tempGray >= (315*grayNum) ) tempColor = 0xD4D4D4;
						else if ( tempGray >= (280*grayNum) ) tempColor = 0xBCBCBC;
						else if ( tempGray >= (245*grayNum) ) tempColor = 0xA4A4A4;
						else if ( tempGray >= (210*grayNum) ) tempColor = 0x8D8D8D;
						else if ( tempGray >= (175*grayNum) ) tempColor = 0x757575;
						else if ( tempGray >= (140*grayNum) ) tempColor = 0x5F5F5F;
						else if ( tempGray >= (105*grayNum) ) tempColor = 0x464646;
						else if ( tempGray >= (70*grayNum) ) tempColor = 0x303030;
						else if ( tempGray >= (35*grayNum) ) tempColor = 0x181818;
						// 黑色
						else tempColor = 0x000000;
					}
					newbm.setPixel32( x, y, tempColor );

				}
			}
			return newbm;
		}
		
		/**
		 * 水彩滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param scaleX X径向晕彩（方向和强度），合理的范围应该是1-100之间
		 * @param scaleY Y径向晕彩（方向和强度），合理的范围应该是1-100之间
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function waterColorFilter ( source:BitmapData, scaleX:Number = 5, scaleY:Number = 5 ) : BitmapData
		{
			var componentX : Number = 1;
			var componentY : Number = 1;
			var color : Number = 0x000000;
			var alpha : Number = 0x000000;
			var tempBitmap = new BitmapData( source.width, source.height, true, 0x00FFFFFF );
			tempBitmap.perlinNoise( 3, 3, 1, 1, false, true, 1, false );
			sourceBitmap = new Bitmap( source );
			var filter : DisplacementMapFilter = new DisplacementMapFilter( tempBitmap, new Point(0, 0), componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 油画滤镜
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param brushSize 笔刷大小，合理的范围应该是1-10之间
		 * @param coarseness 笔刷粗糙度值，合理的范围应该是1-256之间
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function oilPaintingFilter ( source:BitmapData, brushSize:Number = 1, coarseness:Number = 32 ) : BitmapData
		{
			//brushSize 1-8
			//coarseness 1-255
			var color, gray, r, g, b, a;
			var arraylen = coarseness + 1;
			var CountIntensity : Array = new Array();
			var RedAverage : Array = new Array();
			var GreenAverage : Array = new Array();
			var BlueAverage : Array = new Array();
			var AlphaAverage : Array = new Array();

			var filter = getGrayFilter();
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			var tempData : BitmapData;
			tempData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			tempData.draw( sourceBitmap );
			returnBitmapData = tempData.clone();
			var top, bottom, left, right;
			
			for ( var y = 0; y < source.height; y++ )
			{
				top = y - brushSize;
				bottom = y + brushSize + 1;
				if ( top < 0 )
				{
					top = 0;
				}
				if ( bottom >= source.height )
				{
					bottom = source.height - 1;
				}
				for ( var x = 0; x < source.width; x++ )
				{
					left = x - brushSize;
					right = x + brushSize + 1;
					if ( left < 0 )
					{
						left = 0;
					}
					if ( right >= source.width )
					{
						right = source.width;
					}
					for ( var i = 0; i < arraylen; i++ )
					{
						CountIntensity[i] = 0;
						RedAverage[i] = 0;
						GreenAverage[i] = 0;
						BlueAverage[i] = 0;
						AlphaAverage[i] = 0;
					}
					for ( var j = top; j < bottom; j++ )
					{
						for ( i = left; i < right; i++ )
						{
							color = tempData.getPixel( i, j );
							gray = (color & 0xff0000) >> 16;
							color = source.getPixel32( i, j );
							a = color >> 24 & 0xFF;
							r = color >> 16 & 0xFF;
							g = color >> 8 & 0xFF;
							b = color & 0xFF;
							var intensity = int( coarseness * gray / 255 );
							CountIntensity[ intensity ]++;
							RedAverage[ intensity ] += r;
							GreenAverage[ intensity ] += g;
							BlueAverage[ intensity ] += b;
							AlphaAverage[ intensity ] += a;
						}
					}
					var closenIntensity = 0;
					var maxInstance = CountIntensity[0];
					for ( i = 1; i < arraylen; i++ )
					{
						if ( CountIntensity[i] > maxInstance )
						{
							closenIntensity = i;
							maxInstance = CountIntensity[i];
						}
					}
					a = int( AlphaAverage[ closenIntensity ] / maxInstance );
					r = int( RedAverage[ closenIntensity ] / maxInstance );
					g = int( GreenAverage[ closenIntensity ] / maxInstance );
					b = int( BlueAverage[ closenIntensity ] / maxInstance );
					returnBitmapData.setPixel32( x, y, a * 16777216 + r * 65536 + g * 256 + b );
				}
			}
			
			return returnBitmapData;
		}
		
		/**
		 * 颜色阈值滤镜（和PS中的颜色阈值效果一样）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param threshold 颜色阈值，建议范围100-250
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function thresholdFilter ( source:BitmapData, threshold:uint = 128 ) : BitmapData
		{
			var returnBitmapData : BitmapData = new BitmapData( source.width, source.height, true, 0xFF000000 );
			var pt : Point = new Point( 0, 0 );
			var rect : Rectangle = new Rectangle( 0, 0, source.width, source.height );
			threshold = threshold < 0 ? 0 : threshold > 255 ? 255 : threshold;
			var thre : uint = 255 * 0xFFFFFF + threshold * 0xFFFF + threshold * 0xFF + threshold;
			var color : uint = 0x00FFFFFF;
			var maskColor : uint = 0xFFFFFFFF;
			returnBitmapData.threshold( source, rect, pt, ">", thre, color, maskColor, false );
			
			return returnBitmapData;
		}
		
		
		//************************ ************************* 效果类似的滤镜组（2个）：色彩饱和度调整滤镜、色彩调整滤镜 ******************** *********** *** **////
		/**
		 * 色彩饱和度调整滤镜（调整图片中的红、绿、蓝中的某一个）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param rp 红色饱和度，合理的范围应该是-1～1
		 * @param gp 绿色饱和度，合理的范围应该是-1～1
		 * @param bp 蓝色饱和度，合理的范围应该是-1～1
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function saturation ( source:BitmapData, rp:Number = 1, gp:Number = 1, bp:Number = 1 ) : BitmapData
		{
			var matrix : Array = new Array();
			matrix = matrix.concat( [rp, 0, 0, 0, 0] ); // red
			matrix = matrix.concat( [0, gp, 0, 0, 0] ); // green
			matrix = matrix.concat( [0, 0, bp, 0, 0] ); // blue
			matrix = matrix.concat( [0, 0, 0, 1, 0] ); // alpha
			var filter : BitmapFilter = new ColorMatrixFilter( matrix );
			sourceBitmap = new Bitmap( source );
			sourceBitmap.filters = [ filter ];
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sourceBitmap );
			
			return returnBitmapData;
		}
		
		/**
		 * 色彩调整滤镜（使整个图片的颜色偏向红、绿、蓝）
		 * @param source 要应用滤镜效果的位图数据对象
		 * @param ro 红色偏移值，合理的范围应该是-255～255
		 * @param go 绿色偏移值，合理的范围应该是-255～255
		 * @param bo 蓝色偏移值，合理的范围应该是-255～255
		 * @return 应用滤镜效果后的位图数据对象
		 */
		public static function colorTrans ( source:BitmapData, ro:Number = 0, go:Number = 0, bo:Number = 0 ) : BitmapData
		{
			var resultColorTransform : ColorTransform = new ColorTransform();
			resultColorTransform.redOffset = ro;
			resultColorTransform.greenOffset = go;
			resultColorTransform.blueOffset = bo;
			sourceBitmap = new Bitmap( source );
			var sp = new Sprite();
			sp.addChild( sourceBitmap );
			var sp2 = new Sprite();
			sp2.addChild( sp );
			sp.transform.colorTransform = resultColorTransform;
			returnBitmapData = new BitmapData( sourceBitmap.width, sourceBitmap.height, true, 0x00FFFFFF );
			returnBitmapData.draw( sp2 );
			sp2 = null;
			sp = null;
			sourceBitmap = null;
			
			return returnBitmapData;
		}
		
		
		//************************ ************************* 一些公用方法 ******************** *********** *** **////
		/**
		 * 获取灰色滤光图片，很多滤镜效果都会用到这个方法
		 * @param source 要应用滤镜效果的位图数据对象
		 * @return 灰色滤光后的位图数据
		 */
		private static function getGrayFilter () : ColorMatrixFilter
		{
			var myElements_array : Array = [ 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0 ];
			var myColorMatrix_filter : ColorMatrixFilter = new ColorMatrixFilter( myElements_array );
			
			return myColorMatrix_filter;
		}
	}
}