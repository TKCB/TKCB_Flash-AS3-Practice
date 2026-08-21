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
 * v1.0.0 2017-10-16
 * v1.1.1 2017-10-18 增加对64进制的支持，采用【0-9 a-z A-Z _ $】这64个字符作为64进制的组成，这样有利于更短的数字压缩、存储、传输、显示等等
 * v1.2.2 2017-10-18 升级机制，添加对94进制的支持，更加强大
 * v1.3.3 2019-4-13 修改类库的分类，由 utils 改为 math 包
 * v2.0.3 2025-6-25 添加二进制、八进制、十进制、十六进制的相互转换函数，以及数字和汉字的转换，以及数字转人民币大小写（简体和繁体）
 * v2.1.4 2025-7-7 给strUTF8ConvertNum16()增加是否加零的参数
 * v2.2.5 2025-7-9 增加convertBase()方法用于数字进制转换，这个是AI豆包帮我写的，我改了改里面的代码，变成可以AS3使用的版本
 * v2.3.6 2025-7-15 将hex94提出来，单独写，并且对外可访问，便于随时设置自定义的94进制字符
 */
package cc.tkcb.math
{
	import flash.utils.ByteArray;

	/**
	 * NumberTool 数字扩展工具 静态类，包括一些常用的扩展功能，任意进制的转换等等
	 */
	public class NumberTool
	{
		// ************************ ************************* 数字任意进制（2、8、10、16、32、64、94）之间的转换 ******************** *********** *** ** ** //
		// 94进制字符串，可随时设置
		public static var hex94: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
		
		/**
		 * 数字进制转换，支持2-94位，任意转换（这是我用豆包AI生成的函数，蛮不错的）
		 * @param number 当前要转换的数字，字符串形式
		 * @param fromBase 当前数字的进制，2-94位
		 * @param toBase 当前数字要转换的进制，2-94位
		 * @return 转换后的数字
		 */
		public static function convertBase(number: String, fromBase: int, toBase: int): String
		{
			// 输入验证
			if (fromBase < 2 || fromBase > 94 || toBase < 2 || toBase > 94)
			{
				throw new Error('进制必须在2到94之间');
			}

			// 处理特殊情况
			if (number === '0') return '0';

			// 因为94个字符中包含-了，所以这里不能这样做
			// 去除前导零和符号处理
			var isNegative = false;
			var stripped = number;
			/*if (stripped.charAt(0) === '-')
			{
				isNegative = true;
				stripped = stripped.substring(1);
			}*/

			stripped = stripped.replace(/^0+/, '');
			if (stripped === '') return '0';

			// 任意进制转十进制（高精度实现）
			function toDecimal(numStr, base)
			{
				//trace("toDecimal ()");
				var result = [0]; // 使用数组存储高精度数值，低位在前

				for (var i = 0; i < numStr.length; i++)
				{
					var char = numStr.charAt(i);
					var digit = NumberTool.hex94.indexOf(char);
					//trace(char, digit, hex94)

					// 由于可以自定义94个字符，所以就不存在无效字符了
					/*if (digit === -1 || digit >= base)
					{
						throw new Error('无效字符 \'' + numStr.charAt(i) + '\' 对于进制 ' + base);
					}*/

					// 乘以基数并加上当前位
					result = multiply(result, base);
					result = add(result, [digit]);
				}

				return result;
			}

			// 十进制转任意进制（高精度实现）
			function fromDecimal(decimalArray, base)
			{
				//trace("fromDecimal ()");
				var result = '';
				var current = decimalArray.slice();

				while (!isZero(current))
				{
					var quotientRemainder = divide(current, base);
					var quotient = quotientRemainder[0];
					var remainder = quotientRemainder[1];
					result = NumberTool.hex94.charAt(remainder) + result;
					current = quotient;
				}

				return isNegative ? '-' + result : result;
			}

			// 辅助函数：高精度加法
			function add(a, b)
			{
				//trace("add ()");
				var result = [];
				var carry = 0;
				var i = 0;

				//trace(a, b);
				//trace(a.length, b.length);
				while (i < a.length || i < b.length || carry)
				{
					var sum = (a[i] || 0) + (b[i] || 0) + carry;
					result.push(sum % 10);
					carry = Math.floor(sum / 10);
					i++;
				}

				return result;
			}

			// 辅助函数：高精度乘法（乘以小整数）
			function multiply(a, b)
			{
				//trace("multiply ()");
				if (b === 0) return [0];

				var result = [];
				var carry = 0;

				for (var i = 0; i < a.length || carry; i++)
				{
					var product = (a[i] || 0) * b + carry;
					result.push(product % 10);
					carry = Math.floor(product / 10);
				}

				return result;
			}

			// 辅助函数：高精度除法（除以小整数）
			function divide(a, b)
			{
				//trace("divide ()");
				var quotient = [];
				var remainder = 0;

				for (var i = a.length - 1; i >= 0; i--)
				{
					remainder = remainder * 10 + a[i];
					quotient.unshift(Math.floor(remainder / b));
					remainder = remainder % b;
				}

				// 去除前导零
				while (quotient.length > 0 && quotient[quotient.length - 1] === 0)
				{
					quotient.pop();
				}

				return [quotient.length === 0 ? [0] : quotient, remainder];
			}

			// 辅助函数：检查是否为零
			function isZero(a)
			{
				//trace("isZero ()");
				return a.length === 1 && a[0] === 0;
			}

			// 执行转换
			var decimalArray = toDecimal(stripped, fromBase);
			return fromDecimal(decimalArray, toBase);
		}

		/**
		 * 数字的进制转换，可以将（2/8/10/16/32/64/94）等进制之间进行任意转换，因为牵扯到32进制转换，所以转换后的返回值为String类型
		 * 因为AS3虽然没有现成的转换，不过我们可以结合使用parseInt和toString处完成各种进制的转换..
		 * 其中parseInt是把2/8/10/16/32/64/94进制转换成10进制，然后再使用toString把10进制转换成2/8/10/16/32/64/94进制
		 * @param num 要转换的数字，可以是String形式，也可以是数字（Number、int、uint）
		 * @param radix 当前要转换的数字的基进制数，例如，传入的数字是0xFF6600，则此基进制数为16；如果传入的数字是123456789，则此基进制数为10
		 * @param target 目标进制数，要将当前数字转换为的目标进制数（2/8/10/16/32/64/94）
		 * @return 转换后的数字（字符串形式）
		 */
		public static function numberHexSwitch(num: * , radix: uint, target: uint): String
		{
			var newNum: Number;

			// 2/8/10/16/32进制之间的任意转换
			if (radix <= 32 && target <= 32)
			{
				// 如果是文本
				if (num is String)
				{
					newNum = parseInt(num, radix); // 把2~32进制转换为10进制
				}
				else if (isNaN(num) == false)
				{
					newNum = num; // 因为本身已经是数字了
				}
				return newNum.toString(target); // 把10进制转换为2~32进制
			}
			// 大于32进制转换（64、94）
			else
			{
				// 0-9 为10进制，a-f 为16进制，g-v 为32进制，w-$ 为64进制，!-,为94进制
				var i: int, len: int;
				var tempStr: String;
				var tempNum: Number;
				var tempNum2: Number;
				var tempNum3: Number;
				var newStr: String;

				// radix 基进制数为大于32进制
				if (radix > 32 && target <= 32)
				{
					// 先将大的进制转换为10进制
					newNum = 0;
					len = num.length;
					for (i = 0; i < len; i++)
					{
						tempStr = num.charAt(num.length - i - 1);
						tempNum = NumberTool.hex94.indexOf(tempStr);
						newNum += tempNum * Math.pow(radix, i);
					}
					return newNum.toString(target); // 把10进制转换为2~32进制
				}
				// target 目标进制数为大于32进制
				else if (radix <= 32 && target > 32)
				{
					tempNum = parseInt(num, radix); // 把2~32进制转换为10进制

					// 将10进制的数字不断除以64/94，获得每次的余数作为当前位数的值，商如果大于等于64/94继续循环，如果小于64/94停止循环，返回64/94进制值
					newStr = "";
					for (i = 0; i < 1; i--)
					{
						tempNum2 = tempNum % target; // 余数
						tempNum3 = int(tempNum / target); // 商
						tempStr = NumberTool.hex94.charAt(tempNum2);
						newStr = tempStr + newStr;
						if (tempNum3 >= target)
						{
							tempNum = tempNum3;
						}
						else
						{
							tempStr = NumberTool.hex94.charAt(tempNum3);
							newStr = tempStr + newStr;
							break;
						}
					}
					return newStr;
				}
				// 两个都是大于32进制
				else
				{
					// 先将大的进制转换为10进制
					newNum = 0;
					len = num.length;
					for (i = 0; i < len; i++)
					{
						tempStr = num.charAt(num.length - i - 1);
						tempNum = NumberTool.hex94.indexOf(tempStr);
						newNum += tempNum * Math.pow(radix, i);
					}

					tempNum = newNum;

					// 将10进制的数字不断除以64/94，获得每次的余数作为当前位数的值，商如果大于等于64/94继续循环，如果小于64/94停止循环，返回64/94进制值
					newStr = "";
					for (i = 0; i < 1; i--)
					{
						tempNum2 = tempNum % target; // 余数
						tempNum3 = int(tempNum / target); // 商
						tempStr = NumberTool.hex94.charAt(tempNum2);
						newStr = tempStr + newStr;
						if (tempNum3 >= target)
						{
							tempNum = tempNum3;
						}
						else
						{
							tempStr = NumberTool.hex94.charAt(tempNum3);
							newStr = tempStr + newStr;
							break;
						}
					}
					return newStr;
				}
			}
		}



		// ************************ ************************* 数字和中文转换 ******************** *********** *** ** ** //
		/**
		 * 阿拉伯数字转换人民币数字金额（简体或繁体），包含十百千万亿单位
		 * @param num 阿拉伯数字，也就是普通的十进制的数字
		 * @param isTraditional 是否转换为繁体，默认为true，转换繁体，因为一般来说，人民币大写时候都要求用繁体的数字
		 * @return 转换后的数字
		 */
		public static function numberToChineseRMB(num: Number, isTraditional: Boolean = true): String
		{
			if (num == 0)
			{　　
				return "零";　　
			}

			var numStr: String = num.toString();
			var regExp: RegExp = /^(0|[1-9]\d*)(\.\d+)?$/;
			if (regExp.test(numStr) == false)
			{
				return "数据非法";
			}

			var unitStr: String = isTraditional ? "仟佰拾亿仟佰拾万仟佰拾元角分" : "千百十亿千百十万千百十元角分";
			var num09Str: String = isTraditional ? "零壹贰叁肆伍陆柒捌玖" : "零一二三四五六七八九";
			var strCN: String = "";
			numStr += "00";　　
			var pointIndex: int = numStr.indexOf(".");　　
			if (pointIndex >= 0)
			{
				numStr = numStr.substring(0, pointIndex) + numStr.substr(pointIndex + 1, 2);
			}

			unitStr = unitStr.substr(unitStr.length - numStr.length);
			var i: int, len: int = numStr.length;
			for (i = 0; i < len; i++)
			{　　　　
				strCN += num09Str.charAt(Number(numStr.charAt(i))) + unitStr.charAt(i);　　
			}

			regExp = isTraditional ? /零(仟|佰|拾|角)/g : /零(千|百|十|角)/g;
			strCN = strCN.replace(regExp, "零");

			regExp = /(零)+/g;
			strCN = strCN.replace(regExp, "零");

			regExp = /零(万|亿|元)/g;
			strCN = strCN.replace(regExp, "$1");

			regExp = isTraditional ? /(亿)万|壹(拾)/g : /(亿)万|一(十)/g;
			strCN = strCN.replace(regExp, "$1$2");

			regExp = /^元零?|零分/g;
			strCN = strCN.replace(regExp, "");

			regExp = /元$/g;
			strCN = strCN.replace(regExp, "元整");

			return strCN;
		}

		/**
		 * 阿拉伯数字转换中文数字（简体或繁体）
		 * @param num 阿拉伯数字，也就是普通的十进制的数字
		 * @param isTraditional 是否转换为繁体，默认为true，转换繁体，因为一般来说，人民币大写时候都要求用繁体的数字
		 * @return 转换后的数字
		 */
		public static function numberToChineseNum(num: Number, isTraditional: Boolean = true): String
		{
			if (num == 0)
			{　　
				return "零";　　
			}

			var numStr: String = num.toString();
			var regExp: RegExp = /^(0|[1-9]\d*)(\.\d+)?$/;
			if (regExp.test(numStr) == false)
			{
				return "数据非法";
			}

			var numStr1: String = "0123456789.";
			var numStr2: String = isTraditional ? "零壹贰叁肆伍陆柒捌玖点" : "零一二三四五六七八九点";

			var newNumStr: String = "";
			var index: int;
			var i: int, len: int = numStr.length;
			for (i = 0; i < len; i++)
			{
				index = numStr1.indexOf(numStr.charAt(i));
				newNumStr += numStr2.charAt(index);
			}

			return newNumStr;
		}



		// ************************ ************************* 2/8/10/16进制和字符串的相互转换 ******************** *********** *** ** ** //
		/**
		 * 2进制，转字符串（UTF8编码）
		 * @param num2 2进制
		 * @retutn 转换后的字符串（UTF8编码）
		 */
		public static function num2ConvertStrUTF8(num2: String): String
		{
			// 清除首尾的空字符
			var reg1: RegExp = /^\s+|\s+$/g;
			num2 = num2.replace(reg1, "");
			//trace(num2);


			// 否处理中间的空白字符
			// 包括 \f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
			var reg2: RegExp = /[\f\n\r\t\v]/g;
			num2 = num2.replace(reg2, "");


			// 将连续的多个空格转换为一个空格
			var reg3: RegExp = / +?/g;
			num2 = num2.replace(reg3, " ");
			//trace(num2);


			// 判断是否有空格作为分隔符，判断空格数量
			var isNullBoo: Boolean = false;
			var reg4: RegExp = / /g;
			var nullNum: int = num2.match(reg4).length; // 中间的空格分隔符的数量
			var nullProportion: Number = (num2.length - 8) / nullNum; // 整个数字串的长度 - 8 再 / 空格数量，就等于或者小于9，也就是8个二进制字符 + 1个空格，之所以会小于是因为有可能二进制的字符是少于8位的
			if (nullNum >= 1 && nullProportion <= 9)
			{
				isNullBoo = true;
			}


			// 有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换
			var str2: int;
			var str2Arr: Array;
			var i: int, len: int;
			if (isNullBoo)
			{
				//trace("有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换");

				str2Arr = num2.split(" ");

				// 一个字节一个数字串，转换为十进制数字
				len = str2Arr.length;
				for (i = 0; i < len; i++)
				{
					str2Arr[i] = parseInt(str2Arr[i], 2);
				}
			}
			// 没有空格作为分隔符，则判断为连续的8位的二进制数字串，进行转换
			else
			{
				//trace("没有空格作为分隔符，则判断为连续的8位的二进制数字串，进行转换");

				// 清除多余空格
				var reg5: RegExp = / /g;
				num2 = num2.replace(reg5, "");

				// 以8个数字为固定数量，转换为十进制数字，和上面if里面的执行结果是一样的
				str2Arr = [];
				len = num2.length;
				for (i = 0; i < len; i++)
				{
					str2 = parseInt(num2.charAt(i) + num2.charAt(i + 1) + num2.charAt(i + 2) + num2.charAt(i + 3) + num2.charAt(i + 4) + num2.charAt(i + 5) + num2.charAt(i + 6) + num2.charAt(i + 7), 2);
					str2Arr.push(str2);

					// 由于一次读取了8个数字，故而+7
					i += 7;
				}
			}
			//trace(str2Arr.toString());


			// 将数字数组写入二进制字节对象
			var byteArray: ByteArray = new ByteArray();
			len = str2Arr.length;
			for (i = 0; i < len; i++)
			{
				byteArray.writeByte(str2Arr[i]);
			}


			// 然后再将写入的数据，用utf-8字符集解码的方式，读取成字符串
			byteArray.position = 0;
			var newStr: String = byteArray.readUTFBytes(byteArray.length);


			// 返回 转换后的字符串（UTF8编码）
			return newStr;
		}

		/**
		 * 8进制，转字符串（UTF8编码）
		 * @param str8 8进制
		 * @retutn 转换后的字符串（UTF8编码）
		 */
		public static function num8ConvertStrUTF8(num8: String): String
		{
			// 清除首尾的空字符
			var reg1: RegExp = /^\s+|\s+$/g;
			num8 = num8.replace(reg1, "");
			//trace(num8);


			// 否处理中间的空白字符
			// 包括 \f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
			var reg2: RegExp = /[\f\n\r\t\v]/g;
			num8 = num8.replace(reg2, "");


			// 将连续的多个空格转换为一个空格
			var reg3: RegExp = / +?/g;
			num8 = num8.replace(reg3, " ");
			//trace(num8);


			// 判断是否有空格作为分隔符，判断空格数量
			var isNullBoo: Boolean = false;
			var reg4: RegExp = / /g;
			var nullNum: int = num8.match(reg4).length; // 中间的空格分隔符的数量
			var nullProportion: Number = (num8.length - 3) / nullNum; // 整个数字串的长度 - 3 再 / 空格数量，就等于或者小于4，也就是3个八进制字符 + 1个空格，之所以会小于是因为有可能八进制的字符是少于3位的
			if (nullNum >= 1 && nullProportion <= 4)
			{
				isNullBoo = true;
			}


			// 有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换
			var str8: int;
			var str8Arr: Array;
			var i: int, len: int;
			if (isNullBoo)
			{
				//trace("有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换");

				str8Arr = num8.split(" ");

				// 一个字节一个数字串，转换为十进制数字
				len = str8Arr.length;
				for (i = 0; i < len; i++)
				{
					str8Arr[i] = parseInt(str8Arr[i], 8);
				}
			}
			// 没有空格作为分隔符，则判断为连续的3位的八进制数字串，进行转换
			else
			{
				//trace("没有空格作为分隔符，则判断为连续的3位的八进制数字串，进行转换");

				// 清除多余空格
				var reg5: RegExp = / /g;
				num8 = num8.replace(reg5, "");

				// 以3个数字为固定数量，转换为十进制数字，和上面if里面的执行结果是一样的
				str8Arr = [];
				len = num8.length;
				for (i = 0; i < len; i++)
				{
					str8 = parseInt(num8.charAt(i) + num8.charAt(i + 1) + num8.charAt(i + 2), 8);
					str8Arr.push(str8);

					// 由于一次读取了3个数字，故而+2
					i += 2;
				}
			}
			//trace(str8Arr.toString());


			// 将数字数组写入八进制字节对象
			var byteArray: ByteArray = new ByteArray();
			len = str8Arr.length;
			for (i = 0; i < len; i++)
			{
				byteArray.writeByte(str8Arr[i]);
			}


			// 然后再将写入的数据，用utf-8字符集解码的方式，读取成字符串
			byteArray.position = 0;
			var newStr: String = byteArray.readUTFBytes(byteArray.length);


			// 返回 转换后的字符串（UTF8编码）
			return newStr;
		}

		/**
		 * 10进制，转字符串（UTF8编码）
		 * @param str10 10进制
		 * @retutn 转换后的字符串（UTF8编码）
		 */
		public static function num10ConvertStrUTF8(num10: String): String
		{
			// 清除首尾的空字符
			var reg1: RegExp = /^\s+|\s+$/g;
			num10 = num10.replace(reg1, "");
			//trace(num10);


			// 否处理中间的空白字符
			// 包括 \f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
			var reg2: RegExp = /[\f\n\r\t\v]/g;
			num10 = num10.replace(reg2, "");


			// 将连续的多个空格转换为一个空格
			var reg3: RegExp = / +?/g;
			num10 = num10.replace(reg3, " ");
			//trace(num10);


			// 判断是否有空格作为分隔符，判断空格数量
			var isNullBoo: Boolean = false;
			var reg4: RegExp = / /g;
			var nullNum: int = num10.match(reg4).length; // 中间的空格分隔符的数量
			var nullProportion: Number = (num10.length - 3) / nullNum; // 整个数字串的长度 - 3 再 / 空格数量，就等于或者小于4，也就是3个十进制字符 + 1个空格，之所以会小于是因为有可能十进制的字符是少于3位的
			if (nullNum >= 1 && nullProportion <= 4)
			{
				isNullBoo = true;
			}


			// 有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换
			var str10: int;
			var str10Arr: Array;
			var i: int, len: int;
			if (isNullBoo)
			{
				//trace("有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换");

				str10Arr = num10.split(" ");

				// 一个字节一个数字串，转换为十进制数字
				len = str10Arr.length;
				for (i = 0; i < len; i++)
				{
					str10Arr[i] = parseInt(str10Arr[i], 10);
				}
			}
			// 没有空格作为分隔符，则判断为连续的3位的十进制数字串，进行转换
			else
			{
				//trace("没有空格作为分隔符，则判断为连续的3位的十进制数字串，进行转换");

				// 清除多余空格
				var reg5: RegExp = / /g;
				num10 = num10.replace(reg5, "");

				// 以3个数字为固定数量，转换为十进制数字，和上面if里面的执行结果是一样的
				str10Arr = [];
				len = num10.length;
				for (i = 0; i < len; i++)
				{
					str10 = parseInt(num10.charAt(i) + num10.charAt(i + 1) + num10.charAt(i + 2), 10);
					str10Arr.push(str10);

					// 由于一次读取了3个数字，故而+2
					i += 2;
				}
			}
			//trace(str10Arr.toString());


			// 将数字数组写入十进制字节对象
			var byteArray: ByteArray = new ByteArray();
			len = str10Arr.length;
			for (i = 0; i < len; i++)
			{
				byteArray.writeByte(str10Arr[i]);
			}


			// 然后再将写入的数据，用utf-8字符集解码的方式，读取成字符串
			byteArray.position = 0;
			var newStr: String = byteArray.readUTFBytes(byteArray.length);


			// 返回 转换后的字符串（UTF8编码）
			return newStr;
		}

		/**
		 * 16进制，转字符串（UTF8编码）
		 * @param num16 16进制
		 * @retutn 转换后的字符串（UTF8编码）
		 */
		public static function num16ConvertStrUTF8(num16: String): String
		{
			// 清除首尾的空字符
			var reg1: RegExp = /^\s+|\s+$/g;
			num16 = num16.replace(reg1, "");
			//trace(num16);


			// 否处理中间的空白字符
			// 包括 \f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
			var reg2: RegExp = /[\f\n\r\t\v]/g;
			num16 = num16.replace(reg2, "");


			// 将连续的多个空格转换为一个空格
			var reg3: RegExp = / +?/g;
			num16 = num16.replace(reg3, " ");
			//trace(num16);


			// 判断是否有空格作为分隔符，判断空格数量
			var isNullBoo: Boolean = false;
			var reg4: RegExp = / /g;
			var nullNum: int = num16.match(reg4).length; // 中间的空格分隔符的数量
			var nullProportion: Number = (num16.length - 2) / nullNum; // 整个数字串的长度 - 2 再 / 空格数量，就等于或者小于3，也就是2个十六进制字符 + 1个空格，之所以会小于是因为有可能十六进制的字符是一位的，而非两位
			if (nullNum >= 1 && nullProportion <= 3)
			{
				isNullBoo = true;
			}


			// 有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换
			var str16: int;
			var str16Arr: Array;
			var i: int, len: int;
			if (isNullBoo)
			{
				//trace("有空格作为分隔符，则按照分隔符拆分数字，然后逐个转换");

				str16Arr = num16.split(" ");

				// 一个字节一个数字串，转换为十进制数字
				len = str16Arr.length;
				for (i = 0; i < len; i++)
				{
					str16Arr[i] = parseInt("0x" + str16Arr[i], 16);
					//trace(str16Arr[i]);
				}
			}
			// 没有空格作为分隔符，则判断为连续的2位的十六进制数字串，进行转换
			else
			{
				//trace("没有空格作为分隔符，则判断为连续的两位的十六进制数字串，进行转换");

				// 清除多余空格
				var reg5: RegExp = / /g;
				num16 = num16.replace(reg5, "");

				// 以2个数字为固定数量，转换为十进制数字，和上面if里面的执行结果是一样的
				str16Arr = [];
				len = num16.length;
				for (i = 0; i < len; i++)
				{
					str16 = parseInt("0x" + num16.charAt(i) + num16.charAt(i + 1), 16);
					str16Arr.push(str16);
					//trace(str16);

					// 由于一次读取了两个数字，故而再次+1
					i++;
				}
			}
			//trace(str16Arr.toString());


			// 将数字数组写入二进制字节对象
			var byteArray: ByteArray = new ByteArray();
			len = str16Arr.length;
			for (i = 0; i < len; i++)
			{
				byteArray.writeByte(str16Arr[i]);
			}


			// 然后再将写入的数据，用utf-8字符集解码的方式，读取成字符串
			byteArray.position = 0;
			var newStr: String = byteArray.readUTFBytes(byteArray.length);


			// 返回 转换后的字符串（UTF8编码）
			return newStr;
		}

		/**
		 * 字符串（UTF8编码），转二进制
		 * @param strUTF 要转换的字符串（UTF8编码）
		 * @param delimiter 分隔单字节的分隔符，默认为空格，可以传递其他，比如传递空字符串则转化后是连续的十六进制字符串了
		 * @param isStartEndSS 是否处理首尾空白字符，默认为true进行处理
		 * @param isBlankSS 是否处理中间的空白字符，包括\f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
		 * @param isAddZero 是否给长度不足8位的单字节的转换数字前面加0
		 * @return 转换后的二进制
		 */
		public static function strUTF8ConvertNum2(strUTF: String, delimiter: String = " ", isStartEndSS: Boolean = true, isBlankSS: Boolean = true, isAddZero: Boolean = false): String
		{
			// 清除字符串首尾的空字符
			var reg1: RegExp;
			if (isStartEndSS)
			{
				reg1 = /^\s+|\s+$/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 否处理中间的空白字符
			if (isBlankSS)
			{
				reg1 = /[\f\n\r\t\v]/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 字符写入二进制对象
			var byteArray: ByteArray = new ByteArray();
			byteArray.writeUTFBytes(strUTF);

			// 设置读取头
			byteArray.position = 0;

			// 从二进制对象中读取单个字节，然后转换为2进制（字符串形式）
			var newStr: String = "";
			var tempStr: String = "";
			var i: int, len: int = byteArray.length;

			// 给单字节转换后长度小于8的，加0前缀
			if (isAddZero)
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(2);
					//trace(tempStr);

					// 是否给单字节转换后长度小于8的，加0前缀
					if (tempStr.length < 8)
					{
						if (tempStr.length == 7) tempStr = "0" + tempStr;
						else if (tempStr.length == 6) tempStr = "00" + tempStr;
						else if (tempStr.length == 5) tempStr = "000" + tempStr;
						else if (tempStr.length == 4) tempStr = "0000" + tempStr;
						else if (tempStr.length == 3) tempStr = "00000" + tempStr;
						else if (tempStr.length == 2) tempStr = "000000" + tempStr;
						else tempStr = "0000000" + tempStr;
					}
					newStr += tempStr + delimiter;
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(2);
					newStr += tempStr + delimiter;
				}
			}


			// 删除最后一个空格
			if (delimiter != "")
			{
				newStr = newStr.substr(0, newStr.length - 1);
			}

			return newStr;
		}

		/**
		 * 字符串（UTF8编码），转八进制
		 * @param strUTF 要转换的字符串（UTF8编码）
		 * @param delimiter 分隔单字节的分隔符，默认为空格，可以传递其他，比如传递空字符串则转化后是连续的八进制字符串了
		 * @param isStartEndSS 是否处理首尾空白字符，默认为true进行处理
		 * @param isBlankSS 是否处理中间的空白字符，包括\f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
		 * @param isAddZero 是否给长度不足3位的单字节的转换数字前面加0
		 * @return 转换后的八进制
		 */
		public static function strUTF8ConvertNum8(strUTF: String, delimiter: String = " ", isStartEndSS: Boolean = true, isBlankSS: Boolean = true, isAddZero: Boolean = false): String
		{
			// 清除字符串首尾的空字符
			var reg1: RegExp;
			if (isStartEndSS)
			{
				reg1 = /^\s+|\s+$/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 否处理中间的空白字符
			if (isBlankSS)
			{
				reg1 = /[\f\n\r\t\v]/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 字符写入二进制对象
			var byteArray: ByteArray = new ByteArray();
			byteArray.writeUTFBytes(strUTF);

			// 设置读取头
			byteArray.position = 0;

			// 从二进制对象中读取单个字节，然后转换为8进制（字符串形式）
			var newStr: String = "";
			var tempStr: String = "";
			var i: int, len: int = byteArray.length;

			// 给单字节转换后长度小于8的，加0前缀
			if (isAddZero)
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(8);

					// 是否给单字节转换后长度小于8的，加0前缀
					if (tempStr.length < 3)
					{
						if (tempStr.length == 2) tempStr = "0" + tempStr;
						else tempStr = "00" + tempStr;
					}
					newStr += tempStr + delimiter;
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(8);
					newStr += tempStr + delimiter;
				}
			}


			// 删除最后一个空格
			if (delimiter != "")
			{
				newStr = newStr.substr(0, newStr.length - 1);
			}


			return newStr;
		}

		/**
		 * 字符串（UTF8编码），转十进制
		 * @param strUTF 要转换的字符串（UTF8编码）
		 * @param delimiter 分隔单字节的分隔符，默认为空格，可以传递其他，比如传递空字符串则转化后是连续的十进制字符串了
		 * @param isStartEndSS 是否处理首尾空白字符，默认为true进行处理
		 * @param isBlankSS 是否处理中间的空白字符，包括\f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
		 * @param isAddZero 是否给长度不足3位的单字节的转换数字前面加0
		 * @return 转换后的十进制
		 */
		public static function strUTF8ConvertNum10(strUTF: String, delimiter: String = " ", isStartEndSS: Boolean = true, isBlankSS: Boolean = true, isAddZero: Boolean = false): String
		{
			// 清除字符串首尾的空字符
			var reg1: RegExp;
			if (isStartEndSS)
			{
				reg1 = /^\s+|\s+$/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 否处理中间的空白字符
			if (isBlankSS)
			{
				reg1 = /[\f\n\r\t\v]/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 字符写入二进制对象
			var byteArray: ByteArray = new ByteArray();
			byteArray.writeUTFBytes(strUTF);

			// 设置读取头
			byteArray.position = 0;

			// 从二进制对象中读取单个字节，然后转换为8进制（字符串形式）
			var newStr: String = "";
			var tempStr: String = "";
			var i: int, len: int = byteArray.length;

			// 给单字节转换后长度小于10的，加0前缀
			if (isAddZero)
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(10);

					// 是否给单字节转换后长度小于10的，加0前缀
					if (tempStr.length < 3)
					{
						if (tempStr.length == 2) tempStr = "0" + tempStr;
						else tempStr = "00" + tempStr;
					}
					newStr += tempStr + delimiter;
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(10);
					newStr += tempStr + delimiter;
				}
			}


			// 删除最后一个空格
			if (delimiter != "")
			{
				newStr = newStr.substr(0, newStr.length - 1);
			}


			return newStr;
		}

		/**
		 * 字符串（UTF8编码），转十六进制
		 * @param strUTF 要转换的字符串（UTF8编码）
		 * @param delimiter 分隔单字节的分隔符，默认为空格，可以传递其他，比如传递空字符串则转化后是连续的十六进制字符串了
		 * @param isStartEndSS 是否处理首尾空白字符，默认为true进行处理
		 * @param isBlankSS 是否处理中间的空白字符，包括\f换页符 \n换行符 \r回车符 \t制表符 \v垂直制表符
		 * @param isAddZero 是否给长度不足2位的单字节的转换数字前面加0
		 * @return 转换后的十六进制
		 */
		public static function strUTF8ConvertNum16(strUTF: String, delimiter: String = " ", isStartEndSS: Boolean = true, isBlankSS: Boolean = true, isAddZero: Boolean = false): String
		{
			// 清除字符串首尾的空字符
			var reg1: RegExp;
			if (isStartEndSS)
			{
				reg1 = /^\s+|\s+$/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 否处理中间的空白字符
			if (isBlankSS)
			{
				reg1 = /[\f\n\r\t\v]/g;
				strUTF = strUTF.replace(reg1, "");
			}

			// 字符写入二进制对象
			var byteArray: ByteArray = new ByteArray();
			byteArray.writeUTFBytes(strUTF);

			// 设置读取头
			byteArray.position = 0;

			// 从二进制对象中读取单个字节，然后转换为16进制（字符串形式）
			var newStr: String = "";
			var tempStr: String = "";
			var i: int, len: int = byteArray.length;
			if (isAddZero)
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(16);

					// 小于等于16的一个字节字符，前面加0处理
					if (tempStr.length == 1)
					{
						tempStr = "0" + tempStr;
					}
					newStr += tempStr + delimiter;
				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{
					tempStr = byteArray.readUnsignedByte().toString(16);
					newStr += tempStr + delimiter;
				}
			}

			// 删除最后一个空格
			if (delimiter != "")
			{
				newStr = newStr.substr(0, newStr.length - 1);
			}

			return newStr;
		}


	}
}