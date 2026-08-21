/**
 * com.voidelement.images.ico.ICODecoder  Class for ActionScript 3.0
 *
 * @author       Copyright (c) 2008 munegon
 * @version      1.0
 *
 * @link         http://www.voidelement.com/
 * @link         http://void.heteml.jp/blog/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */


/**
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
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */


/**
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-2-16 也不知道作者是哪一年创建的此类库，我（TKCB-Gm）作为修改者，于次日起修改此代码
 * v2.0.1 2025-6-22 TKCB-Gm，继续修改BUG
 */

package com.voidelement.images.ico
{
	import flash.errors.IOError;

	import flash.utils.ByteArray;
	import flash.utils.Endian;


	/**
	 * BitmapInfoHeader
	 */
	public class BitmapInfoHeader
	{
		private const BITMAP_INFO_HEADER_SIZE: uint = 40;
		
		
		// 这个是（TKCB-Gm）增加的，用来判断是否为ico的BMP格式图像（1-255像素宽高内的图像），如果是256的则应该判断为png格式
		public var isBMP: Boolean = false;


		// 这两个是我（TKCB-Gm）增加的
		public var sizeNum: uint = 40;


		public var width: int;

		public var height: int;

		private var _planes: uint;
		public function get planes(): uint
		{
			return _planes;
		}

		private var _bitsPerPixel: uint;
		public function get bitsPerPixel(): uint
		{
			return _bitsPerPixel;
		}

		private var _compression: uint;
		public function get compression(): uint
		{
			return _compression;
		}

		private var _sizeImage: uint;
		public function get sizeImage(): uint
		{
			return _sizeImage;
		}

		private var _xPixPerMeter: int;
		public function get xPixPerMeter(): int
		{
			return _xPixPerMeter;
		}

		private var _yPixPerMeter: int;
		public function get yPixPerMeter(): int
		{
			return _yPixPerMeter;
		}

		private var _colorUsed: uint;
		public function get colorUsed(): uint
		{
			return _colorUsed;
		}

		private var _colorImportant: uint;
		public function get colorImportant(): uint
		{
			return _colorImportant;
		}


		//imgesIndex  【方便测试的参数】：第几个图像的索引值，用于方便理解代码的次序，从0开始
		//isTrace  【方便测试的参数】：是否输出信息
		public function BitmapInfoHeader(stream: ByteArray, imgesIndex: int, isTrace: Boolean = false)
		{
			var bytes: ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;

			try
			{
				stream.readBytes(bytes, 0, BITMAP_INFO_HEADER_SIZE);

				//if (isTrace) trace("");
				//if (isTrace) trace("");
				//if (isTrace) trace("【BitmapInfoHeader " + imgesIndex + "】");
				//if (isTrace) trace("stream.position：" + stream.position);

				sizeNum = bytes.readUnsignedInt();
				//if (isTrace) trace(sizeNum);
				/*if (sizeNum != BITMAP_INFO_HEADER_SIZE)
				{
					if(isTrace) trace(123456)
					throw new VerifyError("invalid bitmap info header size");
				}*/

				/*
				查一下维基百科就能看到，一般来说ico支持的最大图片尺寸就是256，所以很多软件在把png转换成ico的时候，如果png的尺寸大于256，就会生成一个尺寸为256的图标，以及其他更小的图标。
				但是这里有个历史遗留问题：
				最早的时候，ico支持的最大图片尺寸其实是255，用1 byte存储这个尺寸，并且用bmp编码来存储图片。
				后来（Windows 95之后），微软允许ico支持尺寸为256的图片，用尺寸为0来表示尺寸为256。
				再后来（Windows Vista之后），ico还可以支持更大尺寸的图片，这时不用原来那个1 byte来决定尺寸，而是把图片用png编码存储，用png header来决定尺寸。
				*/
				
				
				
				var www:* = bytes.readUnsignedInt();
				width = www || 256;		// 如果是0，则为256
				var hhh:* = bytes.readUnsignedInt();
				height = (hhh / 2) || 256;
				

				//if (isTrace) trace("图像宽度：" + width + "（这里是准确的图像宽度值）");
				//if (isTrace) trace("图像高度：" + height + "（这里是准确的图像高度值）");

				_planes = bytes.readUnsignedShort();
				_bitsPerPixel = bytes.readUnsignedShort();
				//if (isTrace) trace("位面板数：" + _planes);
				//if (isTrace) trace("每像素所占位数：" + _bitsPerPixel); // 


				_compression = bytes.readUnsignedShort();
				_sizeImage = bytes.readUnsignedShort();
				//if (isTrace) trace("像素数据的压缩类型：" + _compression);  // 
				//if (isTrace) trace("图象数据的长度：" + _sizeImage);

				// 剩下16个字节的数据，网上说是空的预留数据位
				_xPixPerMeter = bytes.readInt();
				_yPixPerMeter = bytes.readInt();
				_colorUsed = bytes.readUnsignedInt();				// 
				_colorImportant = bytes.readUnsignedInt();
				//if (isTrace) trace(xPixPerMeter);
				//if (isTrace) trace(_yPixPerMeter);
				//if (isTrace) trace(_colorUsed);
				//if (isTrace) trace(_colorImportant);

				//if (isTrace) trace("stream.position：" + stream.position);
				
				
				// 判断是否为bmp
				if (sizeNum == 40 && width <= 256 && height <= 256)
				{
					isBMP = true;
				}

			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid bitmap info header");
			}
		}
	}
}