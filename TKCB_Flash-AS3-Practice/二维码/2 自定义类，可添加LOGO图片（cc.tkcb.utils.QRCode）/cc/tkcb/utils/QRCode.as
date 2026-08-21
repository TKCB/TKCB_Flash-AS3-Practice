/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2018 TKCB, tkcb@qq.com
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
 * v1.0.0 2018-6-4
 */

package cc.tkcb.utils
{
	import flash.display.BitmapData;

	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.Binarizer;
	import com.google.zxing.BinaryBitmap;
	import com.google.zxing.BufferedImageLuminanceSource;
	import com.google.zxing.Writer;
	import com.google.zxing.Reader;
	import com.google.zxing.Result;
	import com.google.zxing.EncodeHintType;
	import com.google.zxing.DecodeHintType;
	import com.google.zxing.NotFoundException;

	import com.google.zxing.common.BitMatrix;
	import com.google.zxing.common.flexdatatypes.HashTable;
	import com.google.zxing.common.GlobalHistogramBinarizer;

	import com.google.zxing.qrcode.QRCodeWriter;
	import com.google.zxing.qrcode.QRCodeReader;
	import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
	
	/**
	 * QRCode 二维码生成类，用于快速生成基础的二维码图像（BitmapData）
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-6-4
	 * @修改时间 2018-6-4
	 * @version 1.0.0
	 */
	public class QRCode
	{
		//************************ ************************* 二维码需要的参数 ******************** *********** *** **////
		/** 用于生成二维码的字符串 */
		public static var strQRCode : String;

		/** 二维码宽度和高度（二维码长宽是一样的） */
		public static var widthHeight : int = 1000;

		/** 字符集，默认为：ISO-8859-1，但是UTF-8比较常用（所以我将它设置为默认值），其他还有：GBK、Shift_JIS等等 */
		public static var characterSet : String = "UTF-8";

		/** 纠错级别（也相当于允许遮挡的图像比例），从低到高分别为：L（7%校正）、M（15%校正）、Q（25%校正）、H（30%校正） */
		public static var quality : String = "H";

		/** 纠错级别（也相当于允许遮挡的图像比例），为了简化设置，所以将实际的参数隐藏了，使用L、M、Q、H来代替 */
		private static var qualityECL : ErrorCorrectionLevel = ErrorCorrectionLevel.H;

		/** 前景颜色，对应的是默认的黑色 */
		public static var foregroundColor : uint = 0x000000;

		/** 背景颜色，对应的是默认的白色 */
		public static var backgroundColor : uint = 0xFFFFFF;

		/** LOGO图像，居中显示，建议根据二维码宽度和高度传入相符比例的图像 */
		public static var logo : BitmapData;


		/** 生成二维码的对象 */
		private static var writer : Writer = new QRCodeWriter() as Writer;

		/** 读取二维码的对象 */
		private static var reader : Reader = new QRCodeReader() as Reader;

		
		//************************ ************************* 生成二维码 ******************** *********** *** **////
		/**
		 * 生成二维码
		 * @param str 必须传入生成二维码的字符串，才可以生成二维码，也可以使用静态属性进行设置二维码字符串
		 * @return 生成的二维码图像对象
		 */
		public static function generateQRCode ( str:String = "" ) : BitmapData
		{
			if ( str != "" ) strQRCode = str;
			var bm : BitMatrix = generateBitMatrix();
			var bd : BitmapData = generateBitmapData( bm );
			return bd;
		}
		
		/**
		 * 生成二维码矩阵
		 * @return 生成二维码矩阵对象，BitMatrix
		 */
		private static function generateBitMatrix () : BitMatrix
		{
			// 设置参数
			setErrorCorrectionLevel();
			var ht : HashTable = new HashTable(2);
			ht.Add( EncodeHintType.CHARACTER_SET, characterSet );		// 字符集
			ht.Add( EncodeHintType.ERROR_CORRECTION, qualityECL );		// 纠错级别
			
			// 生成二维码矩阵，参数分别是：1 字符串，2 格式，二维码（有很多格式，例如条形码…），3 宽度值，4 高度值，5 设置参数
			var bm : BitMatrix = writer.encode( strQRCode, BarcodeFormat.QR_CODE, widthHeight, widthHeight, ht ) as BitMatrix;
			
			return bm;
		}
		
		/**
		 * 传入二维码矩阵，生成二维码图像
		 * @param bm 二维码矩阵
		 * @return 生成二维码图像对象，BitmapData
		 */
		private static function generateBitmapData ( bm:BitMatrix ) : BitmapData
		{
			var i:int, j:int;
			var w : int = bm.width;
			var h : int = bm.height;
			var bd : BitmapData = new BitmapData( w, h );
			
			// 有LOGO图片
			if ( logo != null && logo.width < bd.width && logo.height < bd.height )
			{
				// 下面四个参数为了logo图片填充计数
				var countX : int = 0;
				var countY : int = 0;
				var wid : int = logo.width;
				var hei : int = logo.height;
				
				// 获取logo图片的图像位置，以便后面进行填充
				var leftX : int = int((bd.width - wid) / 2);
				var rightX : int = leftX + wid;
				var topY : int = int((bd.height - hei) / 2);
				var bottomY : int = topY + hei;
				
				for ( i = 0; i < w; i++ )
				{
					countX = i - leftX;
					for ( j = 0; j < h; j++ )
					{
						countY = j - topY;
						if ( leftX <= i && i < rightX && topY <= j && j < bottomY )
						{
							bd.setPixel( i, j, logo.getPixel(countX, countY) );
						}
						else
						{
							bd.setPixel( i, j, bm._get(i, j) ? foregroundColor : backgroundColor );
						}
					}
				}
			}
			// 没有LOGO图片
			else
			{
				for ( i = 0; i < w; i++ )
				{
					for ( j = 0; j < h; j++ )
					{
						bd.setPixel( i, j, bm._get(i, j) ? foregroundColor : backgroundColor );
					}
				}
			}
					
			return bd;
		}
		
		/**
		 * 根据接口参数（quality），设置真正的纠错级别参数
		 */
		private static function setErrorCorrectionLevel () : void
		{
			if ( quality == "L" ) qualityECL = ErrorCorrectionLevel.L;
			else if ( quality == "M" ) qualityECL = ErrorCorrectionLevel.M;
			else if ( quality == "Q" ) qualityECL = ErrorCorrectionLevel.Q;
			else qualityECL = ErrorCorrectionLevel.H;
		}
		
		
		//************************ ************************* 解析二维码 ******************** *********** *** **////
		/**
		 * 解析二维码
		 * @param bd 二维码图像
		 * @return 解析后二维码对应的字符串，如果为""，则代表解析失败
		 */
		public static function analyticQRCode ( bd:BitmapData ) : String
		{
			// 设置参数
			var ht : HashTable = new HashTable(1);
			ht.Add( DecodeHintType.CHARACTER_SET, characterSet );	// 字符集
			
			// 解码前的准备
			var binzer : Binarizer = new GlobalHistogramBinarizer( new BufferedImageLuminanceSource(bd, 0, 0, bd.width, bd.height) );
			var bb : BinaryBitmap = new BinaryBitmap( binzer );
			var result : Result;
			try
			{
				// 解码
				result = reader.decode( bb, ht );
			}
			catch ( err:NotFoundException )
			{
				return "";	// 解析二维码失败！会返回空字符串
			}
			return result.getText();
		}

		
	}
}