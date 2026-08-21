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
	 * ICOFileHeader
	 */
	public class ICOFileHeader
	{
		private const FILE_HEADER_SIZE: uint = 6;


		private var _type: uint = 0;

		public function get type(): uint
		{
			return _type;
		}

		private var _num: uint = 0;

		public function get num(): uint
		{
			return _num;
		}


		public function ICOFileHeader(stream: ByteArray)
		{
			var bytes: ByteArray = new ByteArray();

			// ICO文件至少头部这里使用的是这种写法
			// 多字节数字的最低有效字节位于字节序列的最前面
			bytes.endian = Endian.LITTLE_ENDIAN;

			// 多字节数字的最高有效字节位于字节序列的最前面
			//bytes.endian = Endian.BIG_ENDIAN;

			try
			{
				stream.readBytes(bytes, 0, FILE_HEADER_SIZE);

				// ico文件头部有6个字节，分别是保留的字节（00 00）、资源类型（01 00 ，01为图标，02为光标））、图象个数（01 00，）
				// 保留的字节
				//if (bytes.readUnsignedInt() != 0x00)		// 原作者这里代码不对，我改为了下面的readUnsignedShort
				if (bytes.readUnsignedShort() != 0x00)
				{
					throw new VerifyError("invalid icon file header signature");
				}

				// 资源类型
				_type = bytes.readUnsignedShort();

				// 图象个数
				_num = bytes.readUnsignedShort();

				//trace("【ICOFileHeader】");
				//trace("图标类型：" + _type);
				//trace("图标数量：" + _num);
				//trace("stream.position：" + stream.position);
			}
			catch (e: IOError)
			{
				throw new VerifyError("invalid file icon header size");
			}
		}
	}
}