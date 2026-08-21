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
	import flash.display.*;
	import flash.events.*;
	
	import flash.errors.IOError;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Point;
	
	
	/**
	 * ICOImageData 
	 */
	public class ICOImageData
	{
		private const COMP_RGB: int = 0;
		private const COMP_RLE8: int = 1;
		private const COMP_RLE4: int = 2;
		private const COMP_BITFIELDS: int = 3;

		private const BIT1: int = 1;
		private const BIT4: int = 4;
		private const BIT8: int = 8;
		private const BIT16: int = 16;
		private const BIT24: int = 24;
		private const BIT32: int = 32;

		// TKCB-Gm 新加偏移值，用于修正读取图像信息头之后就去读取图像数据导致的读取位置（stream.position）偏差
		public var offset: int;

		// 图像的宽高
		public var width: int = 0;
		public var height: int = 0;

		private var _image: BitmapData;

		public function get image(): BitmapData
		{
			return _image;
		}

		//		private var _mask:BitmapData;
		//
		//		public function get mask():BitmapData {
		//			return _mask;
		//		}

		private var _info: BitmapInfoHeader;

		public function get info(): BitmapInfoHeader
		{
			return _info;
		}

		private var _palette: Array;

		public function get palette(): Array
		{
			return _palette;
		}


		private var nRMask: uint;
		private var nGMask: uint;
		private var nBMask: uint;
		private var nRPos: uint = 0;
		private var nGPos: uint = 0;
		private var nBPos: uint = 0;
		private var nRMax: uint;
		private var nGMax: uint;
		private var nBMax: uint;


		// imgesIndex  【方便测试的参数】：第几个图像的索引值，用于方便理解代码的次序，从0开始
		// isTrace  【方便测试的参数】：是否输出信息
		public function ICOImageData(stream: ByteArray, imgesIndex: int, isTrace: Boolean = false)
		{
			
			// 检测是否PNG图片二进制数据
			var pih:PNGInfoHeader = new PNGInfoHeader(stream, imgesIndex, isTrace);
			
			// PNG格式图片
			if (pih.isPNG)
			{
				_image = new BitmapData(pih.width, pih.height);
				width = pih.width;
				height = pih.height;
			
				// PNG图片二进制数据
				var pngBytes: ByteArray = new ByteArray();
				stream.readBytes(pngBytes, 0, pih.pngLength);

				// 二进制加载
				var pngLoader:Loader = new Loader();
				pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(eve:Event){
					var bitmap:Bitmap = eve.target.loader.content as Bitmap;
					
					_image.copyPixels(bitmap.bitmapData, bitmap.bitmapData.rect, new Point(0, 0));
				});
				pngLoader.loadBytes(pngBytes);
				
				offset = stream.position;
			}
			// BMP格式图片
			else
			{
				// 读取BMP信息头（40字节）
				//trace("stream.position：" + stream.position);
				_info = new BitmapInfoHeader(stream, imgesIndex, isTrace);
				width = _info.width;
				height = _info.height;
				_image = new BitmapData(_info.width, _info.height, true);
				_image.lock();

				//trace("position " + stream.position);
				//trace("BMP：w " + width + "  h " + height);
				
				stream.endian = Endian.LITTLE_ENDIAN;

				//ICODecoder.log("bpp: " + _info.bitsPerPixel);
				//ICODecoder.log("comp: " + _info.compression);
				//ICODecoder.log("used: " + _info.colorUsed);
				//ICODecoder.log("impo: " + _info.colorImportant);

				switch (_info.bitsPerPixel)
				{
					case BIT1:
						readColorPalette(stream);
						decode1BitBMP(stream);
						decodeMaskData(stream);
						break;
					case BIT4:
						readColorPalette(stream);
						if (_info.compression == COMP_RLE4)
						{
							decode4bitRLE(stream);
						}
						else
						{
							decode4BitBMP(stream);
						}
						decodeMaskData(stream);
						break;
					case BIT8:
						readColorPalette(stream);
						if (_info.compression == COMP_RLE8)
						{
							decode8BitRLE(stream);
						}
						else
						{
							decode8BitBMP(stream);
						}
						decodeMaskData(stream);
						break;
					case BIT16:
						readBitFields(stream);
						checkColorMask();
						decode16BitBMP(stream);
						decodeMaskData(stream);
						break;
					case BIT24:
						decode24BitBMP(stream);
						decodeMaskData(stream);
						break;
					case BIT32:
						//readBitFields(stream);
						//					checkColorMask();
						decode32BitBMP(stream);
						decodeMaskData(stream);
						break;
					default:
						throw new VerifyError("invalid bits per pixel : " + _info.bitsPerPixel);
				}

				_image.unlock();
				
				
				offset = stream.position;
				//trace("stream.position：" + stream.position);
				//trace("_image    end");
			}
		}

		/**
		 * ビットフィールド読み込み
		 */
		private function readBitFields(stream: ByteArray): void
		{
			if (_info.compression == COMP_RGB)
			{
				if (_info.bitsPerPixel == BIT16)
				{
					// RGB555
					nRMask = 0x00007c00;
					nGMask = 0x000003e0;
					nBMask = 0x0000001f;
				}
				else
				{
					//RGB888;
					nRMask = 0x00ff0000;
					nGMask = 0x0000ff00;
					nBMask = 0x000000ff;
				}
			}
			else if (_info.compression == COMP_BITFIELDS)
			{
				try
				{
					nRMask = stream.readUnsignedInt();
					nGMask = stream.readUnsignedInt();
					nBMask = stream.readUnsignedInt();
				}
				catch (e: IOError)
				{
					throw new VerifyError("invalid bit fields");
				}
			}
		}


		/**
		 * カラーパレット読み込み
		 */
		private function readColorPalette(stream: ByteArray): void
		{
			var i: int;
			var len: int = (_info.colorUsed > 0) ? _info.colorUsed : Math.pow(2, _info.bitsPerPixel);

			_palette = [];

			for (i = 0; i < len; ++i)
			{
				_palette[i] = stream.readUnsignedInt();
			}
		}


		/**
		 * 1bitのBMPデコード
		 */
		private function decode1BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var i: int;
			var col: int;
			var buf: ByteArray = new ByteArray();
			var line: int = _info.width / 8;

			if (line % 4 > 0)
			{
				line = ((line / 4 | 0) + 1) * 4;
			}

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;
					stream.readBytes(buf, 0, line);

					for (x = 0; x < _info.width; x += 8)
					{
						col = buf.readUnsignedByte();

						for (i = 0; i < 8; ++i)
						{
							_image.setPixel(x + i, y, _palette[col >> (7 - i) & 0x01]);
						}
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}


		/**
		 * 4bitのRLE圧縮BMPデコード
		 */
		private function decode4bitRLE(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var i: int;
			var n: int;
			var col: int;
			var data: uint;
			var buf: ByteArray = new ByteArray();

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;

					while (stream.bytesAvailable > 0)
					{
						n = stream.readUnsignedByte();

						if (n > 0)
						{
							// エンコードデータ
							data = stream.readUnsignedByte();
							for (i = 0; i < n / 2; ++i)
							{
								buf.writeByte(data);
							}
						}
						else
						{
							n = stream.readUnsignedByte();

							if (n > 0)
							{
								// 絶対モードデータ
								stream.readBytes(buf, buf.length, n / 2);
								buf.position += n / 2;

								if (n / 2 + 1 >> 1 << 1 != n / 2)
								{
									stream.readUnsignedByte();
								}
							}
							else
							{
								// EOL
								break;
							}
						}
					}

					buf.position = 0;

					for (x = 0; x < _info.width; x += 2)
					{
						col = buf.readUnsignedByte();

						_image.setPixel(x, y, _palette[col >> 4]);
						_image.setPixel(x + 1, y, _palette[col & 0x0f]);
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}


		/**
		 * 4bitの非圧縮BMPデコード
		 */
		private function decode4BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var i: int;
			var col: int;
			var buf: ByteArray = new ByteArray();
			var line: int = _info.width / 2;

			if (line % 4 > 0)
			{
				line = ((line / 4 | 0) + 1) * 4;
			}

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;
					stream.readBytes(buf, 0, line);

					for (x = 0; x < _info.width; x += 2)
					{
						col = buf.readUnsignedByte();

						_image.setPixel(x, y, _palette[col >> 4]);
						_image.setPixel(x + 1, y, _palette[col & 0x0f]);
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}


		/**
		 * 8bitのRLE圧縮BMPデコード
		 */
		private function decode8BitRLE(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var i: int;
			var n: int;
			var col: int;
			var data: uint;
			var buf: ByteArray = new ByteArray();

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;

					while (stream.bytesAvailable > 0)
					{
						n = stream.readUnsignedByte();

						if (n > 0)
						{
							// エンコードデータ
							data = stream.readUnsignedByte();
							for (i = 0; i < n; ++i)
							{
								buf.writeByte(data);
							}
						}
						else
						{
							n = stream.readUnsignedByte();

							if (n > 0)
							{
								// 絶対モードデータ
								stream.readBytes(buf, buf.length, n);
								buf.position += n;
								if (n + 1 >> 1 << 1 != n)
								{
									stream.readUnsignedByte();
								}
							}
							else
							{
								// EOL
								break;
							}
						}
					}

					buf.position = 0;

					for (x = 0; x < _info.width; ++x)
					{
						_image.setPixel(x, y, _palette[buf.readUnsignedByte()]);
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}

		/**
		 * 8bitの非圧縮BMPデコード
		 */
		private function decode8BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var i: int;
			var col: int;
			var buf: ByteArray = new ByteArray();
			var line: int = _info.width;

			if (line % 4 > 0)
			{
				line = ((line / 4 | 0) + 1) * 4;
			}

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;
					stream.readBytes(buf, 0, line);

					for (x = 0; x < _info.width; ++x)
					{
						_image.setPixel(x, y, _palette[buf.readUnsignedByte()]);
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}

		/**
		 * 16bitのBMPデコード
		 */
		private function decode16BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var col: int;

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					for (x = 0; x < _info.width; ++x)
					{
						col = stream.readUnsignedShort();
						_image.setPixel(x, y, (((col & nRMask) >> nRPos) * 0xff / nRMax << 16) + (((col & nGMask) >> nGPos) * 0xff / nGMax << 8) + (((col & nBMask) >> nBPos) * 0xff / nBMax << 0));
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}

		/**
		 * 24bitのBMPデコード
		 */
		private function decode24BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var col: int;
			var buf: ByteArray = new ByteArray();
			var line: int = _info.width * 3;

			if (line % 4 > 0)
			{
				line = ((line / 4 | 0) + 1) * 4;
			}

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					buf.length = 0;
					stream.readBytes(buf, 0, line);

					for (x = 0; x < _info.width; ++x)
					{
						_image.setPixel(x, y, buf.readUnsignedByte() + (buf.readUnsignedByte() << 8) + (buf.readUnsignedByte() << 16));
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}

		/**
		 * 32bitのBMPデコード
		 */
		private function decode32BitBMP(stream: ByteArray): void
		{
			var x: int;
			var y: int;
			var col: uint;

			try
			{
				for (y = _info.height - 1; y >= 0; --y)
				{
					for (x = 0; x < _info.width; ++x)
					{
						col = stream.readUnsignedInt();
						_image.setPixel32(x, y, col);
						//						_image.setPixel(x, y, (((col & nRMask) >> nRPos) * 0xff / nRMax << 16) | (((col & nGMask) >> nGPos) * 0xff / nGMax << 8) | (((col & nBMask) >> nBPos) * 0xff / nBMax << 0));
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid image data");
			}
		}


		/**
		 * 设置图像透明度
		 */
		private function decodeMaskData(stream: ByteArray): void
		{
			
			//trace("22222222stream.position：" + stream.position);
			//trace(_info.width, _info.height);
			//			_mask=new BitmapData(_info.width, _info.height, false, 0xffffff);

			stream.endian = Endian.BIG_ENDIAN;

			try
			{

				var x: int = 0;
				var _w: int = _info.width;
				var _h: int = _info.height;

				const n: int = int((_w - 1) / BIT32) + 1;
				var alphas: Array = [];
				var alpha: Number = 0;

				for (var y: int = _h - 1; y >= 0; --y)
				{

					for (var a: int = 0; a < n; a++)
					{
						alphas[a] = stream.readUnsignedInt();
					}
					for (x = 0; x < _w; ++x)
					{
						alpha = alphas[int(x / BIT32)];
						if ((alpha >>> (BIT32 - 1 - (x % _w))) & 1)
						{
							_image.setPixel32(x, y, 0);
						}
					}
				}
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid mask data");
			}
			//trace("222222222stream.position：" + stream.position);

		}


		/**
		 * カラーマスクチェック
		 */
		private function checkColorMask(): void
		{
			if ((nRMask & nGMask) | (nGMask & nBMask) | (nBMask & nRMask))
			{
				throw new VerifyError("invalid bit fields");
			}

			while (((nRMask >> nRPos) & 0x00000001) == 0)
			{
				nRPos++;
			}
			while (((nGMask >> nGPos) & 0x00000001) == 0)
			{
				nGPos++;
			}
			while (((nBMask >> nBPos) & 0x00000001) == 0)
			{
				nBPos++;
			}

			nRMax = nRMask >> nRPos;
			nGMax = nGMask >> nGPos;
			nBMax = nBMask >> nBPos;
		}
	}
}