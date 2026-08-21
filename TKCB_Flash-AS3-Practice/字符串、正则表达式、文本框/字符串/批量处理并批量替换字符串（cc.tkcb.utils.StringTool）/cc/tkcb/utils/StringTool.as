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
 * v1.0.0 2017-10-20
 * v1.1.0 2017-10-21 修改排序算法，整数和字符分开处理判断
 * v1.2.0 2017-11-2 修改排序会部分排序错误的BUG，这是由于之前出现造成的；顺便把之前的插入字符串的方法修改为删除字符串和添加字符串，对应的是Array类中的splice方法
 * v1.3.0 2017-11-3 将 fileNameSort() 方法从 StringTool 类中，迁移到 FileNameSort 类中（因为对于中文排序需要使用 ChineseSwitchPinyin 类，这个类比较大，这么做也是为了效率考虑）。
 * v2.0.0 2018-2-18 添加删除行注释和块注释的方法deleteNotes()，本来想要写单独的行注释方法和块注释方法，但由于代码的复杂性，暂时先实现最主要的
 * v3.0.0 2018-7-24 添加了新的 forReplace() 方法，专门针对复杂的批量替换的情况。
 */
 
package cc.tkcb.utils
{
	
	 /**
	 * StringTool 字符串扩展工具 静态类，添加一些实用的扩展字符串的方法，删除并插入字符串、删除注释（行注释+块注释）、循环替换文本
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2017-10-20
	 * @修改时间 2018-7-24
	 * @version 3.0.0
	 */
	public class StringTool
	{
		//************************ ************************* 实用功能扩展 ******************** *********** *** **////
		/**
		 * 删除并插入字符串。在传入的字符串任意处，插入另一个字符串，然后返回新的字符串，原有字符串不会被改变
		 * @param srcStr 原始字符串
		 * @param index 开始（删除或者插入）的位置索引值
		 * @param deleteCount 删除的指定长度的字符串
		 * @param insertStr 插入的字符串
		 * @return 新的字符串
		 */
		public static function splice ( srcStr:String, index:int, deleteCount:uint, insertStr:String = "" ) : String
		{
			var newStr : String = srcStr.slice(0, index) + insertStr + srcStr.slice(index + deleteCount);
			return newStr;
		}
		
		/**
		 * 删除注释（行注释+块注释）。行注释和块注释的标志字符串可任意替换，但不保证对于其他代码的注释也完美试用，因为代码都是针对AS写的
		 * @param srcStr 原始字符串
		 * @param lineStr 行注释的标志字符串，在AS中为“//”
		 * @param blockStartStr 块注释的开始标志字符串，在AS中为“/*”
		 * @param blockEndStr 块注释的开始标志字符串，在AS中为“* /”（实际上*和/之间没有空格，由于代码注释的交叉性，必须要有空格）
		 * @return 删除注释后的新字符串
		 */
		public static function deleteNotes ( srcStr:String, lineStr:String = "//", blockStartStr:String = "/*", blockEndStr:String = "*/" ) : String
		{
			// 行注释和块注释本身很好匹配，但是有其他代码交叉会产生各种变化，比如行注释和块注释相互注释交叉，还有就是文本字符串中的行注释和块注释
			
			// 所以之前网友问我能不能用正则表达式匹配行注释和块注释，当时我的回答就是不能
			// 但今天写了发现，比我想的复杂很多（当然或许有高手可以用正则完美匹配，但是几率小到0，因为正则并不难，可以想到几乎所有可能性）
			
			// 超级复杂的情况
			// 对于“/*1213 */trace( 123456 );/*1213 */trace( 123456 );//trace( 123456 )”这种复杂的注释
			// 我的代码无能为力，因为这种形式还可以更加复杂，那就是加上引号，引号内再加上//和/**/
			
			
			//// 第1步：先将所有字符串文本分为一行一个数组元素
			// 优化处理，之前简单的使用split()方法将文本分为一行一行的，但是后面在实践中发现有的行是单独使用\r或者\n的
			// 所以需要使用正则表达式替换的方法，进行优化处理
			var pattern : RegExp = /\r\n/g;
			srcStr = srcStr.replace( pattern, "\n" );
			pattern = /\r/g;
			srcStr = srcStr.replace( pattern, "\n" );
			var strArr : Array = srcStr.split( "\n" );
			
			
			//// 第2步：逐行分析，行注释和块注释，然后删除注释
			var i : int, len : int;
			var j : int, len2 : int;
			var k : int, len3 : int;
			
			var tempStr : String;
			var tempStr2 : String;
			var tempStr3 : String;
			
			var simpleStr : String;		// 用于复杂情况下的，临时字符串
			
			var strIndex : int;
			var strIndex2 : int;
			var strIndex3 : int;
			var strIndex4 : int;
			var isNullLine : int;
			
			var patternNullLine : RegExp = /[^ 　\f\n\r\t\v]/g;		// 用来匹配空行的正则表达式
			
			var isBlockComments : Boolean = false;		// 是否已经匹配到一个开始的/*，需要优先匹配末尾的*/
			
			var deleteLine : String = "TKCB****XY**QWERTYUIOPASDFGHJKLZXCVBNM20180215";		// 用于标记删除行的字符串
			
			len = strArr.length;
			for ( i = 0; i < len; i++ )
			{
				tempStr = strArr[i];
				
				// 【注意】：下面的情况可能是多个叠加所以，不是每一个情况完毕后就break循环，没有break说明后续还会有更复杂的情况
				
				// 情况1：优先匹配末尾的*/符号，也就是说明之前已经匹配到一个块注释/*
				if ( isBlockComments )
				{
					strIndex = tempStr.indexOf( blockEndStr );
					if ( strIndex != -1 )
					{
						tempStr = tempStr.substring( strIndex + blockEndStr.length );
						
						// 空行，后续会删除，所以将它设置为特定字符串
						isNullLine = tempStr.match( patternNullLine ).length;
						if ( isNullLine == 0 )
						{
							tempStr = deleteLine;
						}
						strArr[i] = tempStr;
						
						// 块注释结束
						isBlockComments = false;
					}
					else
					{
						strArr[i] = deleteLine;		// 空行，后续会删除，所以将它设置为特定字符串
						
						// 如果没有找到*/，说明本行全部是注释，则继续查找下一行，跳过本次循环
						continue;
					}
				}
				
				// 【提示】：之所以优先处理情况2和情况3，一是让逻辑简单一些，二是为了让最常见的情况优先处理提高程序效率
				
				// 情况2：之后再匹配行注释，最简单的行注释
				strIndex = tempStr.indexOf( lineStr );
				if ( strIndex != -1 )
				{
					// 注释有效：本行//的前面，没有""、''、/*，这三个会导致逻辑混乱的因素
					if ( tempStr.lastIndexOf('"', strIndex) == -1 && tempStr.lastIndexOf("'", strIndex) == -1 && tempStr.lastIndexOf(blockStartStr, strIndex) == -1 )
					{
						tempStr = tempStr.substring( 0, strIndex );
						
						// 空行，后续会删除，所以将它设置为特定字符串
						isNullLine = tempStr.match( patternNullLine ).length;
						if ( isNullLine == 0 )
						{
							tempStr = deleteLine;
						}
						strArr[i] = tempStr;
						
						// 如果是行注释的情况，可以跳过本次循环了，因为已经后面的字符串都被注释掉了
						continue;
					}
				}
				
				// 情况3：匹配最简单的块注释
				strIndex = tempStr.indexOf( blockStartStr );
				if ( strIndex != -1 )
				{
					// 注释有效：本行/*的前面，没有""、''、//，这三个会导致逻辑混乱的因素
					if ( tempStr.lastIndexOf('"', strIndex) == -1 && tempStr.lastIndexOf("'", strIndex) == -1 && tempStr.lastIndexOf(lineStr, strIndex) == -1 )
					{
						// 在本行找到末尾注释符
						strIndex2 = tempStr.indexOf( blockEndStr, strIndex + blockStartStr.length );
						if ( strIndex2 != -1 )
						{
							tempStr = tempStr.substring( 0, strIndex ) + tempStr.substring( strIndex2 + blockEndStr.length );
							
							// 空行，后续会删除，所以将它设置为特定字符串
							isNullLine = tempStr.match( patternNullLine ).length;
							if ( isNullLine == 0 )
							{
								tempStr = deleteLine;
							}
							strArr[i] = tempStr;
						}
						// 本行没有/*对应的*/结束符
						else
						{
							isBlockComments = true;
							
							tempStr = tempStr.substring( 0, strIndex );
							
							// 空行，后续会删除，所以将它设置为特定字符串
							isNullLine = tempStr.match( patternNullLine ).length;
							if ( isNullLine == 0 )
							{
								tempStr = deleteLine;
							}
							strArr[i] = tempStr;
							
							// 块注释的结束符没有在本行，说明本行之后的都是注释内容，所以可以跳过本次循环了
							continue;
						}
					}
				}
				
				// 【提示】：再接一个简单的行注释，因为如果出现了 /* xxxx */ trace(xx) //xxxx 这种情况的代码
				// 【提示】：情况2和情况4是一摸一样的代码
				
				// 情况4：之后再匹配行注释，最简单的行注释
				strIndex = tempStr.indexOf( lineStr );
				if ( strIndex != -1 )
				{
					// 注释有效：本行//的前面，没有""、''、/*，这三个会导致逻辑混乱的因素
					if ( tempStr.lastIndexOf('"', strIndex) == -1 && tempStr.lastIndexOf("'", strIndex) == -1 && tempStr.lastIndexOf(blockStartStr, strIndex) == -1 )
					{
						tempStr = tempStr.substring( 0, strIndex );
						
						// 空行，后续会删除，所以将它设置为特定字符串
						isNullLine = tempStr.match( patternNullLine ).length;
						if ( isNullLine == 0 )
						{
							tempStr = deleteLine;
						}
						strArr[i] = tempStr;
						
						// 如果是行注释的情况，可以跳过本次循环了，因为已经后面的字符串都被注释掉了
						continue;
					}
				}
				
				// 如果出现""和''内有//或/*的情况，就会导致判断特别复杂
				// 所以需要临时用一个字符串将""和''内的部分全部替换为其他不影响的字符，然后再进行判断
				if ( tempStr.indexOf(lineStr) != -1 || tempStr.indexOf(blockStartStr) != -1 )
				{
					// 临时的字符串，用于将原有字符串中""和''部分替换掉，用于后续判断的
					simpleStr = tempStr;
					
					// 循环将所有的""内的文字都替换为“X”，以便后面搜索真正的搜索的时候进行排除法的索引定位
					pattern = /".+?[^\\]"/g;
					if ( simpleStr.match( pattern ).length > 0 )
					{
						pattern = /".+?[^\\]"/;
						len2 = 9999999;
						for ( j = 0; j < len2; j++ )
						{
							strIndex = simpleStr.search( pattern );
							if ( strIndex != -1 )
							{
								tempStr2 = simpleStr.match( pattern )[0];
								tempStr3 = "";
								len3 = tempStr2.length;
								for ( k = 0; k < len3; k++ )
								{
									tempStr3 += "X";
								}
									
								simpleStr = simpleStr.replace( pattern, tempStr3 );
							}
							else
							{
								len2 = 0;
							}
						}
					}
					
					// 循环将所有的''内的文字都替换为“Y”，以便后面搜索真正的搜索的时候进行排除法的索引定位
					pattern = /'.+?[^\\]'/g;
					if ( simpleStr.match( pattern ).length > 0 )
					{
						pattern = /'.+?[^\\]'/;
						len2 = 9999999;
						for ( j = 0; j < len2; j++ )
						{
							strIndex = simpleStr.search( pattern );
							if ( strIndex != -1 )
							{
								tempStr2 = simpleStr.match( pattern )[0];
								tempStr3 = "";
								len3 = tempStr2.length;
								for ( k = 0; k < len3; k++ )
								{
									tempStr3 += "Y";
								}
									
								simpleStr = simpleStr.replace( pattern, tempStr3 );
							}
							else
							{
								len2 = 0;
							}
						}
					}
					
					// 【注意】：仔细观察可以知道，下面的复杂情况1、2、3，其实和之前的简单情况是一样的，只不过个别地方有差别，还要就是tempStr换成了simpleStr
					
					// 复杂情况1：再次查找是否有//，因为之前可能是""和''内的//导致的混淆，所以需要重新查找
					strIndex = simpleStr.indexOf( lineStr );
					if ( strIndex != -1 )
					{
						// 注释有效：本行//的前面，没有/*
						if ( simpleStr.lastIndexOf(blockStartStr, strIndex) == -1 )
						{
							tempStr = tempStr.substring( 0, strIndex );
							
							// 空行，后续会删除，所以将它设置为特定字符串
							isNullLine = tempStr.match( patternNullLine ).length;
							if ( isNullLine == 0 )
							{
								tempStr = deleteLine;
							}
							strArr[i] = tempStr;
							
							// 如果是行注释的情况，可以跳过本次循环了，因为已经后面的字符串都被注释掉了
							continue;
						}
					}
					
					// 复杂情况2：匹配最简单的块注释
					strIndex = simpleStr.indexOf( blockStartStr );
					if ( strIndex != -1 )
					{
						// 注释有效：本行/*的前面，没有//
						if ( simpleStr.lastIndexOf(lineStr, strIndex) == -1 )
						{
							// 在本行找到末尾注释符
							strIndex2 = tempStr.indexOf( blockEndStr, strIndex + blockStartStr.length );
							if ( strIndex2 != -1 )
							{
								tempStr = tempStr.substring( 0, strIndex ) + tempStr.substring( strIndex2 + blockEndStr.length );
								simpleStr = simpleStr.substring( 0, strIndex ) + simpleStr.substring( strIndex2 + blockEndStr.length );
								
								// 空行，后续会删除，所以将它设置为特定字符串
								isNullLine = tempStr.match( patternNullLine ).length;
								if ( isNullLine == 0 )
								{
									tempStr = deleteLine;
									simpleStr = deleteLine;
								}
								strArr[i] = tempStr;
							}
							// 本行没有/*对应的*/结束符
							else
							{
								isBlockComments = true;
								
								tempStr = tempStr.substring( 0, strIndex );
								
								// 空行，后续会删除，所以将它设置为特定字符串
								isNullLine = tempStr.match( patternNullLine ).length;
								if ( isNullLine == 0 )
								{
									tempStr = deleteLine;
								}
								strArr[i] = tempStr;
								
								// 块注释的结束符没有在本行，说明本行之后的都是注释内容，所以可以跳过本次循环了
								continue;
							}
						}
					}
					
					// 复杂情况3：重复之前的复杂情况1
					strIndex = simpleStr.indexOf( lineStr );
					if ( strIndex != -1 )
					{
						// 注释有效：本行//的前面，没有/*
						if ( simpleStr.lastIndexOf(blockStartStr, strIndex) == -1 )
						{
							tempStr = tempStr.substring( 0, strIndex );
							
							// 空行，后续会删除，所以将它设置为特定字符串
							isNullLine = tempStr.match( patternNullLine ).length;
							if ( isNullLine == 0 )
							{
								tempStr = deleteLine;
							}
							strArr[i] = tempStr;
							
							// 如果是行注释的情况，可以跳过本次循环了，因为已经后面的字符串都被注释掉了
							continue;
						}
					}
				}
			}
			
			
			//// 第3步：合并所有行，剔除空行
			// 为了防止剔除原有的空行，我给删除的空行设置了“TKCB****XY**QWERTYUIOPASDFGHJKLZXCVBNM20180215”这个绝对不会出现的字符串
			var newStr : String = "";
			len = strArr.length;
			for ( i = 0; i < len; i++ )
			{
				if ( strArr[i] != deleteLine )
				{
					newStr += strArr[i] + "\n";
				}
			}
			
			// 如果直接使用下面代码（把上面代码都删掉），然后输出字符串会出错，可能由于我删除的是AS文档的注释，所以格式相对复杂很多，代码内部会有一些交叉错误
			//var newStr : String = srcStr;
			return newStr;
		}
		
		/**
		 * 循环替换文本。
		 * 根据正则表达式和传入的要替换的字符串数组，对字符串进行查找替换（replArr的元素数量应该和pattern所能匹配的数量一致）。
		 * 本方法解决的是要替换多处文本，但是多处文本要替换的内容也都不尽相同，很难批量替换的问题。
		 * @param srcStr 原始字符串
		 * @param replArr 要替换的字符串数组，这个数组应该是提前以准备好的，通常是pattern匹配出来的字符串进行了很多次操作之后的数组。
		 * @param pattern 要进行批量替换的正则表达式，不应该使用g模式，因为本方法使用的是for循环单个匹配，使用g会浪费效率。
		 * @return 新的字符串
		 */
		public static function forReplace ( srcStr:String, replArr:Array, pattern:RegExp ) : String
		{
			var newStr : String = "";
			var oldStr : String = srcStr;
			var tempStr : String;
			
			var searchIndex : int;
			var matchStr : String;
			
			// 这个算法很简单，因为替换方法只能是一次替换一个，所以就把字符串不断进行单个替换
			// 每次替换完成，就获取剩余没有替换部分的字符串再次循环进行替换
			// 直到找不到替换的字符串
			var i:int, len:int = replArr.length * 2;	// 这里 *2 只是为了得到一个足够大的值，防止漏循环的情况出现
			for ( i = 0; i < len; i++ )
			{
				searchIndex = oldStr.search( pattern );
				if ( searchIndex != -1 )
				{
					matchStr = oldStr.match( pattern )[0];
					tempStr = oldStr.slice( 0, searchIndex + matchStr.length );
					oldStr = oldStr.slice( tempStr.length );
					newStr += tempStr.replace( pattern, replArr[i] );
				}
				else
				{
					newStr += oldStr;
					break;
				}
			}
			
			return newStr;
		}
		
		
		
	}
}


