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
 * v1.0.0 2025-6-23 这个是我（TKCB-Gm）创建的类，用于修复原作者的ico类库在读取ico 256宽高图像的BUG问题，这个类专门用于识别在ico文件中二进制中隐藏的png二进制
 */

package com.voidelement.images.ico
{
	import flash.errors.IOError;

	import flash.utils.ByteArray;
	import flash.utils.Endian;


	/**
	 * PNGInfoHeader
	 */
	public class PNGInfoHeader
	{
		// 是否为PNG格式图片的二进制数据
		public var isPNG: Boolean = false;


		// PNG 二进制部分数据长度，用于后面的pngLoader.loadBytes(ByteArray)
		public var pngLength: int = 8;

		// PNG 图像宽度
		public var width: int;

		// PNG 图像高度
		public var height: int;


		//imgesIndex  【方便测试的参数】：第几个图像的索引值，用于方便理解代码的次序，从0开始
		//isTrace  【方便测试的参数】：是否输出信息
		public function PNGInfoHeader(stream: ByteArray, imgesIndex: int, isTrace: Boolean = false)
		{
			var bytes: ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;

			// 累计的position的使用长度
			var positionLen: int = 0;

			// 二进制头部的8个字节，里面有类型，含有PNG
			var pngStr: String = stream.readUTFBytes(8); // 8
			positionLen += 8;
			isPNG = pngStr.indexOf("PNG") != -1;

			// 是PNG才做分析，不然直接跳过
			if (isPNG)
			{
				// 数据长度
				var lenNum: int; // 4

				// 数据类型
				var typeStr: String; // 4

				// 遍历PNG 数据块（Chunk）
				var i: int, len: int = (stream.length - stream.position) / 8;
				for (i = 0; i < len; i++)
				{
					// 数据长度
					lenNum = stream.readUnsignedInt(); // 4
					//trace("数据长度" + lenNum);

					// 数据类型
					typeStr = stream.readUTFBytes(4); // 4
					//trace("数据类型" + typeStr);

					// 四种关键数据块，还有其他的数据块但不重要，也就这里不做介绍了
					// 文件头数据块 IHDR（header chunk）：包含有图像基本信息，作为第一个数据块出现并只出现一次。
					// 调色板数据块 PLTE（palette chunk）：必须放在图像数据块之前。
					// 图像数据块 IDAT（image data chunk）：存储实际图像数据。PNG 数据允许包含多个连续的图像数据块。
					// 图像结束数据 IEND（image trailer chunk）：放在文件尾部，表示 PNG 数据流结束。

					// 其他数据块
					if (typeStr == "IHDR")
					{
						// Width	4 bytes	图像宽度，以像素为单位
						// Height	4 bytes	图像高度，以像素为单位
						width = stream.readUnsignedInt(); // 4
						height = stream.readUnsignedInt(); // 4
						
						
						// Bit depth	1 byte	图像深度：索引彩色图像：1，2，4或8 ;灰度图像：1，2，4，8或16 ;真彩色图像：8或16
						// ColorType	1 byte	颜色类型：0：灰度图像, 1，2，4，8或16;2：真彩色图像，8或16;3：索引彩色图像，1，2，4或84：带α通道数据的灰度图像，8或16;6：带α通道数据的真彩色图像，8或16
						// Compression method	1 byte	压缩方法(LZ77派生算法)
						// Filter method	1 byte	滤波器方法
						// Interlace method	1 byte	隔行扫描方法：0：非隔行扫描;1： Adam7(由Adam M. Costello开发的7遍隔行扫描方法)
						
						
						// 跳过数据块的内容
						stream.position += (lenNum - 8 + 4);

						// 数据块的累计长度（数据长度本身的4个字节 + 数据类型4个字节 + 数据长度 + 数据校验的4个字节）
						positionLen += (4 + 4 + lenNum + 4);
					}
					// 其他数据块
					else if (typeStr != "IEND")
					{
						// 跳过数据块的内容
						stream.position += (lenNum + 4);

						// 数据块的累计长度（数据长度本身的4个字节 + 数据类型4个字节 + 数据长度 + 数据校验的4个字节）
						positionLen += (4 + 4 + lenNum + 4);
					}
					// 结束数据块：图像结束数据 IEND（image trailer chunk）
					else
					{
						// 跳过数据块的内容
						stream.position += (lenNum + 4);

						// 数据块的累计长度（数据长度本身的4个字节 + 数据类型4个字节）
						positionLen += (4 + 4 + lenNum + 4);
						break;
					}
				}
			}

			// 回退读取位置
			stream.position -= positionLen;

			// 图片二进制的长度
			pngLength = positionLen;
		}
	}
}