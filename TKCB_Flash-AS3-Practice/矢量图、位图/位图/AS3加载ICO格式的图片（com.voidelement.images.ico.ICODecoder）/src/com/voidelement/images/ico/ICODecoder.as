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
 * v2.0.1 2025-6-22 TKCB-Gm，继续修改BUG，最终发现是因为原作者并没有解析ico内的png图片导致的问题，于是添加了PNGInfoHeader读取的类，用于进行png二进制的识别，然后转由
 */
package com.voidelement.images.ico
{
	import flash.display.BitmapData;

	import flash.utils.ByteArray;


	/**
	 * ICODecoder ICO格式解析类，用于解析ICO格式二进制数据，并且从中获取位图数据信息。
	 */
	public class ICODecoder
	{
		private static var _verbose: Boolean = false;

		private static function get verbose(): Boolean
		{
			return _verbose;
		}

		private static function set verbose(value: Boolean): void
		{
			_verbose = value;
		}


		private var _header: ICOFileHeader = null;

		public function get header(): ICOFileHeader
		{
			return _header;
		}



		private const image_arr: Array = [];

		/**
		 * コンストラクタ
		 */
		public function ICODecoder()
		{

		}


		/**
		 * デコード
		 *
		 * @param デコードしたいICOファイルのバイナリデータ
		 */
		public function decode(stream: ByteArray): Array
		{
			// 读取头部二进制（文件头6字节，固定的）
			_header = new ICOFileHeader(stream);

			// 读取图像信息二进制（图像信息块16字节，有几个图像就有几个信息块，每个信息块16字节） 
			var info_arr: Array = [];
			var len: int = header.num;
			for (var i: int = 0; i < len; ++i)
			{
				info_arr.push(new ICOInfoHeader(stream, i));
			}
			
			// 获取图像，ICOImageData对象是用于获取图像的
			// 但是ICOImageData内部，还要分为获取BMP类型图像，以及获取PNG类型图像
			var iid1: ICOImageData;
			for (var j: int = 0; j < len; ++j)
			{
				iid1 = new ICOImageData(stream, j, true);
				//iidoffset = iid1.offset;
				//stream.position = iidoffset;
				image_arr.push(iid1);
			}

			return image_arr;
		}


		public function getIcon(): BitmapData
		{
			var ic: ICOImageData;

			var bit: int = -1;
			var size: int = -1;
			var b: BitmapData = null;
			var i:int, len:int = image_arr.length;
			for(i = 0; i < len;i++)
			{
				if ((image_arr[i].width * image_arr[i].height) > size)
				{
					b = image_arr[i].image;
					size = image_arr[i].width * image_arr[i].height;
				}
			}
			return b;
		}


		/**
		 * ログ出力
		 */
		public static function log(message: String): void
		{
			if (verbose)
			{
				//trace(message);
			}
		}
	}
}