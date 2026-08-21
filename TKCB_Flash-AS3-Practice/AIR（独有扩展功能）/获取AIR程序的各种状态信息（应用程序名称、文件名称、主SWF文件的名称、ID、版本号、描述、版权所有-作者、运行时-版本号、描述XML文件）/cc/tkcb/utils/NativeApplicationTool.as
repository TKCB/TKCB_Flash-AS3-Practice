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
 * v1.0.0 2018-1-19
 * v1.1.1 2018-2-19 修改代码说明，之前是错误的说明
 * v1.2.2 2025-6-17 代码基本没动，只是稍微调整了下注释说明，以及个别代码的大小写
 */
package cc.tkcb.utils
{
	import flash.desktop.NativeApplication;


	/**
	 * NativeApplicationTool 获取和设置AIR应用程序的状态信息 静态类，功能包括：getAIRInfo（获取AIR程序的状态信息）
	 */
	public class NativeApplicationTool
	{
		// ************************ ************************* 获取AIR程序的信息 ******************** *********** *** ** ** //
		/**
		 * 获取当前AIR程序的状态信息
		 * 包括：name（应用程序名称）、fileName（应用程序文件名称）、swfName（AIR对应的主SWF文件的名称）、applicationID（应用程序 ID）、
		 * versionNumber（版本号）、description（描述）、copyright（版权所有-作者）、runtimeVersion（AIR运行时 版本号）、
		 * applicationDescriptor（应用程序的描述XML文件）
		 * @return 当前AIR程序的部分信息
		 */
		public static function getAIRInfo(): Object
		{
			var nativeApplication: NativeApplication = NativeApplication.nativeApplication;

			// 必须使用String的方式获取字符串，然后找到对应的信息，不然不知道为什么，就是无法获取到对应的XML信息
			var airXMLStr: String = nativeApplication.applicationDescriptor.toString();
			var tempStr: String;
			var tempArr: Array;
			var pattern: RegExp;

			var obj: Object = {};


			// 1 应用程序名称
			pattern = /<name>.+?<\/name>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(6, tempStr.length - 13);
			}
			else
			{
				tempStr = "";
			}
			obj.name = tempStr;


			// 2 应用程序文件名称
			pattern = /<filename>.+?<\/filename>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(10, tempStr.length - 21);
			}
			else
			{
				tempStr = "";
			}
			obj.fileName = tempStr;


			// 3 AIR对应的主SWF文件的名称
			pattern = /<content>.+?<\/content>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(9, tempStr.length - 23);
			}
			else
			{
				tempStr = "";
			}
			obj.swfName = tempStr;


			// 4 应用程序 ID（我的AIR程序ID通常为cc.tkcb.XXXX）
			obj.applicationID = nativeApplication.applicationID;


			// 5 版本号
			pattern = /<versionNumber>.+?<\/versionNumber>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(15, tempStr.length - 31);
			}
			else
			{
				tempStr = "";
			}
			obj.versionNumber = tempStr;


			// 6 描述
			pattern = /<description>.+?<\/description>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(13, tempStr.length - 27);
			}
			else
			{
				tempStr = "";
			}
			obj.description = tempStr;


			// 7 版权所有-作者
			pattern = /<copyright>.+?<\/copyright>/g;
			tempArr = airXMLStr.match(pattern);
			if (tempArr.length > 0)
			{
				tempStr = tempArr[0];
				tempStr = tempStr.substr(11, tempStr.length - 23);
			}
			else
			{
				tempStr = "";
			}
			obj.copyright = tempStr;


			// 8 AIR运行时-版本号
			obj.runtimeVersion = nativeApplication.runtimeVersion;

			// 9 应用程序的描述XML文件
			obj.applicationDescriptor = nativeApplication.applicationDescriptor;

			return obj;
		}

	}
}