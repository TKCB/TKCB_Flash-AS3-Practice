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
 * v1.0.0 2026-4-23 由豆包AI生成（我做了多次调试和提示AI进行BUG修改和方案讨论）
 */
package cc.tkcb.crypto
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class BigFileCrypto
	{
		private static const HEADER_SIZE: int = 1024 * 1024 * 4; // 4MB 头部

		public function BigFileCrypto()
		{}

		// 同一个方法：执行1次=加密，执行2次=解密
		public function process(filePath: String, key: String): void
		{
			var file: File = new File(filePath);
			var fs: FileStream = new FileStream();

			// ✅ 修复 1119 错误：使用正确的 UPDATE 模式
			fs.open(file, FileMode.UPDATE);

			// ✅ 修复 2030 错误：只读文件实际存在的数据，不越界
			var readSize: int = Math.min(HEADER_SIZE, fs.bytesAvailable);
			var buf: ByteArray = new ByteArray();
			fs.readBytes(buf, 0, readSize);

			// 密钥二进制反转处理（加密/解密一体）
			reverseByKey(buf, key);

			// 写回头部
			fs.position = 0;
			fs.writeBytes(buf);



			// 内存释放开始
			fs.close();
			buf.clear(); // 清空字节数据
			buf = null; // 释放引用
			fs = null;
			file = null;
			//trace("处理完成：一次加密，两次解密");
		}

		// 核心：密钥驱动二进制位反转（自逆算法）
		private function reverseByKey(buf: ByteArray, key: String): void
		{
			var keyLen: int = key.length;
			var len: int = buf.length;

			// 安全读取所有字节
			var bytes: Array = [];
			buf.position = 0;
			for (var i: int = 0; i < len; i++)
			{
				bytes.push(buf.readByte());
			}

			// 根据密钥规则反转字节
			for (i = 0; i < len; i++)
			{
				var charCode: uint = key.charCodeAt(i % keyLen);
				if (charCode % 2 == 0)
				{
					bytes[i] = reverseBits(bytes[i]);
				}
			}

			// 写回字节数组
			buf.position = 0;
			for (i = 0; i < len; i++)
			{
				buf.writeByte(bytes[i]);
			}
			buf.position = 0;
		}

		// 单字节二进制位反转（反转两次 = 还原）
		private function reverseBits(b: int): int
		{
			b = b & 0xFF;
			b = ((b & 0xF0) >> 4) | ((b & 0x0F) << 4);
			b = ((b & 0xCC) >> 2) | ((b & 0x33) << 2);
			b = ((b & 0xAA) >> 1) | ((b & 0x55) << 1);
			return b;
		}
	}
}