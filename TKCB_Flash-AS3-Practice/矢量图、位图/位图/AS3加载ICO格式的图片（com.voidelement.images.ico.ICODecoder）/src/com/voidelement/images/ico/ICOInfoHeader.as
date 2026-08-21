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
	 * ICOInfoHeader
	 */
	public class ICOInfoHeader
	{
		private const INFO_HEADER_SIZE: uint = 16;


		private var _width: uint;
		public function get width(): uint
		{
			return _width;
		}

		private var _height: uint;
		public function get height(): uint
		{
			return _height;
		}

		private var _count: uint;
		public function get count(): uint
		{
			return _count;
		}

		private var _xHotSpot: uint;
		public function get xHotSpot(): uint
		{
			return _xHotSpot;
		}

		private var _yHotSpot: uint;
		public function get yHotSpot(): uint
		{
			return _yHotSpot;
		}

		private var _size: uint;
		public function get size(): uint
		{
			return _size;
		}

		private var _offset: uint;
		public function get offset(): uint
		{
			return _offset;
		}


		// imgesIndex  【方便测试的参数】：第几个图像的索引值，用于方便理解代码的次序，从0开始
		public function ICOInfoHeader(stream: ByteArray, imgesIndex: int)
		{
			var bytes: ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;


			try
			{
				stream.readBytes(bytes, 0, INFO_HEADER_SIZE);

				// 图标宽度
				var www:* = bytes.readUnsignedByte();
				//trace(www);
				_width = www || 256;
				//trace(_width);

				// 图标高度
				var hhh:* = bytes.readUnsignedByte();
				//trace(hhh);
				_height = hhh || 256;
				//trace(_height);

				// 颜色计数
				var ccc:* = bytes.readUnsignedByte();
				//trace(ccc);
				_count = ccc || 256;
				//trace(_count);

				//trace("");
				//trace("【ICOInfoHeader " + imgesIndex + "】");
				//trace("图标宽度：" + _width + "（最大值256，故而这个值对于超过256的ICO图像，就不准确）");
				//trace("图标高度：" + _height + "（最大值256，同上）");
				//trace("颜色计数：" + _count);

				bytes.position += 1; // reserved

				_xHotSpot = bytes.readUnsignedShort();
				_yHotSpot = bytes.readUnsignedShort();
				_size = bytes.readUnsignedInt();
				_offset = bytes.readUnsignedInt();
				
				//trace("stream.position：" + stream.position);
			}
			catch (e: IOError)
			{
				//trace("error: icon info header");
				throw new VerifyError("invalid icon info header");
			}
		}
	}
}