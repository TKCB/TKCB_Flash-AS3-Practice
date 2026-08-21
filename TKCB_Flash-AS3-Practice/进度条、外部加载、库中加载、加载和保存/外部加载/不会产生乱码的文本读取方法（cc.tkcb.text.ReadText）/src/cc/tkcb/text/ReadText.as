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
 * v1.0.0 2017-11-26
 * v1.1.1 2018-8-13 对类做结构性调整，静态化，并且改变一些对外的API名称（功能上和以前保持一致）
 * v1.2.2 2025-6-2 添加了getStrFormat()静态方法，用于字符串格式的乱码处理
 * v1.3.3 2025-7-5 将网友夕眼（QQ508730568）同学的新方法read()融合到类库中，用于读取URLStream（数据流）
 */
package cc.tkcb.text
{
	import flash.net.*;
	import flash.utils.*;


	/**
	 * ReadText 不会产生乱码的读取文本的类，用于可能出现多种格式的情况，可用于某些情况下不能使用“System.useCodePage = true;”的情况
	 */
	public class ReadText
	{
		// ************************ ************************* 静态属性 ******************** *********** *** ** ** //
		// r\n转换为\n用到的正则表达式
		private static var reg: RegExp = /\r\n/g;

		// UTF-8编码，单字节的范围
		private static var utf8Min: uint = 0x00;
		private static var utf8Max: uint = 0x7F;


		// ************************ ************************* 读取任意文本，获取字符串对象 ******************** *********** *** ** ** //
		/**
		 * 读取任意二进制格式的文本，获取消除乱码后的字符串
		 * @param textByte 二进制格式的文本
		 * @param isRNSwitch 是否将\r\n转换为\n以便在Flash中使用和显示，默认是false，因为这样会破坏原有的格式
		 * @return 消除乱码后的字符串
		 */
		public static function getString(textByte: ByteArray, isRNSwitch: Boolean = false): String
		{
			var type: String = getFileType(textByte);
			var changdu: uint = textByte.length;
			var str: String = "";
			switch (type)
			{
				case "ANSI":
					textByte.position = 0;
					str = textByte.readMultiByte(changdu - textByte.position, "gb2312");
					//trace("ANSI", str);
					break;

				case "Unicode":
				case "Unicode big endian":
				case "UTF-8":
					//trace("UTF-8", str);
					str = textByte.toString();
					break;
			}
			if (isRNSwitch)
			{
				var reg: RegExp = /\r\n/g;
				str = str.replace(reg, "\n");
			}
			//trace(str);
			return str;
		}

		/**
		 * 读取任意字符串格式的文本，获取消除乱码后的字符串
		 * @param textStr 字符串格式的文本
		 * @param isStrong 是否使用更复杂的处理，强力消除乱码
		 * @return 消除乱码后的字符串
		 */
		public static function getStrFormat(textStr: String, isStrong: Boolean = false): String
		{
			//trace(textStr);
			if (textStr != null && textStr != "")
			{
				// 转换为二进制格式
				var oriByteArr: ByteArray = new ByteArray();
				oriByteArr.writeUTFBytes(textStr);
				oriByteArr.position = 0;

				// 消除乱码
				var newStr: String = ReadText.getString(oriByteArr);
				if (isStrong == false)
				{
					return newStr;
				}
				// 强力消除乱码
				else
				{
					// 第二种消除乱码的处理方式
					var newStr2: String = ReadText.encodeUTF8(newStr);

					return newStr.length < newStr2.length ? newStr : newStr2;

					/*
					百度了很多资料，尝试了好几个方式，最后发现这些办法都不太行，于是这些尝试都弃之！
					
					
					// 是否乱码
					var isMessyCode1: Boolean = false;
					var isMessyCode: Boolean = false;

					var newByteArr: ByteArray = new ByteArray();
					newByteArr.writeUTFBytes(newStr);
					newByteArr.position = 0;
					//trace(newStr, newByteArr.position, newByteArr.length);
					var pattern: RegExp = new RegExp("[^a-zA-Z0-9\u4e00-\u9fa5]");
					
					// 判断单字节是否超出UTF-8编码范围
					var num: uint;
					var i: int, len: int = newByteArr.length;
					for (i = 0; i < len; i++)
					{
						trace(textStr.charCodeAt(i));
						num = newByteArr.readUnsignedByte();
						//trace(num, utf8Max, newByteArr.position, newByteArr.length);
						if (num > utf8Max)
						{
							isMessyCode1 = true;
						}
						if ((newByteArr.position + 1) >= newByteArr.length)
						{
							break;
						}
					}
					len = textStr.length;
					for (i = 0; i < len; i++)
					{
						trace(textStr.charCodeAt(i));
					}

					//trace(isMessyCode, newStr);
					if (newStr.search(pattern) != -1)
					{
						isMessyCode = true;
					}

					//trace(textStr, newStr);
					//trace(isMessyCode, newStr.search(pattern));

					trace(textStr);
					// 有乱码，使用另一种消除方式
					if ( isMessyCode || newStr.length > textStr.length)
					{
						newStr = ReadText.encodeUTF8(newStr);
					}
					trace(textStr, textStr.length, newStr, newStr.length);

					//newByteArr.position = 0;
					//trace("isUTF8", textStr, isUTF8(newByteArr));
					*/
				}
			}
			else
			{
				return textStr;
			}

		}

		// 这个代码在win7系统适用，但在win10系统就会适得其反，所以弃之，使用我自己写的ReadText.getStrFormat()替代
		// 因为只支持UTF-8，此函数用于消除 ID3 内容的乱码
		private static function encodeUTF8(str: String): String
		{
			if (str != "" && str != null)
			{
				var oriByteArr: ByteArray = new ByteArray();
				oriByteArr.writeUTFBytes(str);
				var tempByteArr: ByteArray = new ByteArray();
				var i: int, len: int = oriByteArr.length;
				for (i = 0; i < len; i++)
				{
					if (oriByteArr[i] == 194)
					{
						tempByteArr.writeByte(oriByteArr[i + 1]);
						i++;
					}
					else if (oriByteArr[i] == 195)
					{
						tempByteArr.writeByte(oriByteArr[i + 1] + 64);
						i++;
					}
					else
					{
						tempByteArr.writeByte(oriByteArr[i]);
					}
				}
				tempByteArr.position = 0;
				return tempByteArr.readMultiByte(tempByteArr.bytesAvailable, "chinese");
			}
			else
			{
				return "";
			}
		}

		// 获取文件的字符集类型（UTF-8、ANSI、Unicode、Unicode big endian）
		// fileData 文本文档的字节数组
		// 返回字符集类型
		private static function getFileType(fileData: ByteArray): String
		{
			if (fileData.length < 2)
			{
				if (fileData.length == 1)
				{
					if (fileData[0] < (0x80))
					{
						return "UTF-8";
					}
					else
					{
						return "ANSI";
					}
				}
				if (fileData.length == 0)
				{
					return "ANSI";
				}
			}

			var b0: int = fileData.readUnsignedByte();
			var b1: int = fileData.readUnsignedByte();
			var fileType: String = "ANSI";
			if (b0 == 0xFF && b1 == 0xFE)
			{
				fileType = "Unicode";
			}
			else if (b0 == 0xFE && b1 == 0xFF)
			{
				fileType = "Unicode big endian";
			}
			else if (b0 == 0xEF && b1 == 0xBB)
			{
				fileType = "UTF-8";
			}
			if (fileType == "ANSI")
			{
				fileType = NO_bom_UTF(fileData) ? "UTF-8" : "ANSI";
			}
			return fileType;
		}

		/**
		 * 跟据格式标签来判断格式
		 * @param bit 文本文档的字节数组
		 * @return 是否UTF-8格式，如果是返回true，否则返回false
		 */
		private static function NO_bom_UTF(bit: ByteArray): Boolean
		{
			var result: Boolean = true;
			var bitPos: int = 0;
			while (bitPos < bit.length)
			{
				// (10000000): 值小于0x80的为ASCII字符
				if (bit[bitPos] < (0x80))
				{
					bitPos++;
				}
				// (11000000): 值介于0x80与0xC0之间的为无效UTF-8字符 
				else if (bit[bitPos] < (0xC0))
				{
					result = false;
					break;
				}
				// (11100000): 此范围内为2字节UTF-8字符
				else if (bit[bitPos] < (0xE0))
				{
					if (bitPos >= bit.length - 1)
					{
						break;
					}
					if ((bit[bitPos + 1] < (0x80)) || (bit[bitPos + 1] >= (0xC0)))
					{
						result = false;
						break;
					}
					bitPos += 2;
				}
				// (11110000): 此范围内为3字节UTF-8字符
				else if (bit[bitPos] < (0xF0))
				{
					if (bitPos >= bit.length - 2)
					{
						break;
					}
					if ((bit[bitPos + 1] < (0x80)) || (bit[bitPos + 1] >= (0xC0)))
					{
						result = false;
						break;
					}
					if ((bit[bitPos + 2] < (0x80)) || (bit[bitPos + 2] >= (0xC0)))
					{
						result = false;
						break;
					}
					bitPos += 3;
				}
				else
				{
					result = false;
					break;
				}
			}
			return result;
		}



		/*
		测试不太好用的代码
		private static function byteToUnsignedInt(byte: *): int
		{
			return byte & 0xff;
		}

		private static function isUTF8(pBuffer: ByteArray): Boolean
		{
			var value1:int;
			var value2:int;
			var value3:int;
			var IsUTF8: Boolean = true;
			var IsASCII: Boolean = true;
			var size:int = pBuffer.length;
			var i:int = 0;
			while (i < size)
			{
				var value: int = byteToUnsignedInt(pBuffer[i]);
				if (value < 0x80)
				{
					// (10000000): 值小于 0x80 的为 ASCII 字符
					if (i >= size - 1)
					{
						if (IsASCII)
						{
							// 假设纯 ASCII 字符不是 UTF 格式
							IsUTF8 = false;
						}
						break;
					}
					i++;
				}
				else if (value < 0xC0)
				{
					// (11000000): 值介于 0x80 与 0xC0 之间的为无效 UTF-8 字符
					IsASCII = false;
					IsUTF8 = false;
					break;
				}
				else if (value < 0xE0)
				{
					// (11100000): 此范围内为 2 字节 UTF-8 字符
					IsASCII = false;
					if (i >= size - 1)
					{
						break;
					}

					value1 = byteToUnsignedInt(pBuffer[i + 1]);
					if ((value1 & (0xC0)) != 0x80)
					{
						IsUTF8 = false;
						break;
					}

					i += 2;
				}
				else if (value < 0xF0)
				{
					IsASCII = false;
					// (11110000): 此范围内为 3 字节 UTF-8 字符
					if (i >= size - 2)
					{
						break;
					}

					value1 = byteToUnsignedInt(pBuffer[i + 1]);
					value2 = byteToUnsignedInt(pBuffer[i + 2]);
					if ((value1 & (0xC0)) != 0x80 || (value2 & (0xC0)) != 0x80)
					{
						IsUTF8 = false;
						break;
					}

					i += 3;
				}
				else if (value < 0xF8)
				{
					IsASCII = false;
					// (11111000): 此范围内为 4 字节 UTF-8 字符
					if (i >= size - 3)
					{
						break;
					}

					value1 = byteToUnsignedInt(pBuffer[i + 1]);
					value2 = byteToUnsignedInt(pBuffer[i + 2]);
					value3 = byteToUnsignedInt(pBuffer[i + 3]);
					if ((value1 & (0xC0)) != 0x80 || (value2 & (0xC0)) != 0x80 || (value3 & (0xC0)) != 0x80)
					{
						IsUTF8 = false;
						break;
					}

					i += 3;
				}
				else
				{
					IsUTF8 = false;
					IsASCII = false;
					break;
				}
			}

			return IsUTF8;
		}*/




		// ************************ ************************* 将网友夕眼（508730568）同学的新方法read()融合到类库中，用于读取URLStream（数据流） ******************** *********** *** ** ** //
		public static const UTF_8: String = "utf-8";
		public static const UTF_16: String = "utf-16";
		public static const GB2312: String = "gb2312";

		/**
		 * 读取文本
		 * @param	ioStream ByteArray或URLStream
		 * @param	toUnixNewlines 是否转换\r\n为\n
		 * @param	length 读取长度如果为URLStream则必须指定长度
		 * @return
		 */
		public static function read(ioStream: IDataInput, toUnixNewlines: Boolean = false, length: Number = NaN): String
		{
			if (!isNaN(length) && length < 0)
				throw new ArgumentError("Length must be greater than 0");
			if (ioStream is URLStream && isNaN(length))
				throw new ArgumentError("Length must be specified while reading a URLStream");

			var bytes: ByteArray;
			var charset: String;
			var textRaw: String;

			bytes = new ByteArray();
			ioStream.readBytes(bytes, 0, isNaN(length) ? ioStream.bytesAvailable : length);
			bytes.position = 0;
			charset = getCharset(bytes);
			bytes.position = 0;
			textRaw = bytes.readMultiByte(bytes.bytesAvailable, charset);

			if (bytes) bytes.clear(); //清除临时变量
			return toUnixNewlines ? textRaw.replace(/\r\n/g, "\n") : textRaw;
		}

		/**
		 * 获取文件的字符集类型（UTF-8、ANSI、Unicode、Unicode big endian）
		 * @param fileData 文本文档的字节数组
		 * @return 字符集类型
		 */
		private static function getCharset(data: ByteArray): String
		{
			if (data.length < 2)
			{
				if (data.length == 1)
				{
					if (data[0] < (0x80))
					{
						return UTF_8;
					}
					else
					{
						return GB2312;
					}
				}
				if (data.length == 0)
				{
					return GB2312;
				}
			}

			var b0: int = data.readUnsignedByte();
			var b1: int = data.readUnsignedByte();
			var codec: String = GB2312;
			if (b0 == 0xFF && b1 == 0xFE)
			{
				codec = UTF_8;
			}
			else if (b0 == 0xFE && b1 == 0xFF)
			{
				codec = UTF_16;
			}
			else if (b0 == 0xEF && b1 == 0xBB)
			{
				codec = UTF_8;
			}
			if (codec == GB2312)
			{
				codec = NO_bom_UTF(data) ? UTF_8 : GB2312;
			}
			return codec;
		}











	}

}