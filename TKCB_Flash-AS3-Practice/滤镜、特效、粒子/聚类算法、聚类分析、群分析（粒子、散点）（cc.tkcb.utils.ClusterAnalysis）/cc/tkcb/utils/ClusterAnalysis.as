/*
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
 * v1.0.0 2020-2-4
 */

package cc.tkcb.utils
{
	import flash.geom.Point;
	


	/**
	 * ClusterAnalysis 聚类分析 静态类，可以对一系列的坐标点，或一系列的对象（多为粒子或点对象）进行各种聚类行为的分析
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2020-2-4
	 * @修改时间 2020-2-4
	 * @version 1.0.0
	 */
	public class ClusterAnalysis
	{
		//************************ ************************* DBSCAN算法 ******************** *********** *** **////
		/**
		 * 对象的聚类分析，通常为粒子对象数组（DisplayObject），返回的数组中第一个为剔除的对象数组（也就是没有发生聚类行为的对象），第二个及之后都是找到的聚类对象的子数组
		 * @param arr 聚类的对象数组，必须是DisplayObject或Point一类的对象数组，因为需要用到x和y这两个参数
		 * @param distance 聚类距离，默认为30像素
		 * @param minNum 聚类最小的数量，默认为3个，最少为2个
		 * @return 已经分好类的新的聚类对象数组（二维数组）
		 */
		public static function clusterAnalysis ( arr:Array, distance:Number = 30, minNum:int = 3 ) : Array
		{
			if ( minNum < 2 ) minNum = 2;
			
			
			var i : int, len : int;
			var j : int, len2 : int;
			
			// 分析后的聚类数组，已经是二维数组了
			var clusterArr : Array = [];
			
			// 没有聚类的对象数组
			var noClusterArr : Array = [];
			
			
			// 重新创建一个数组，用于聚类分析，并且重置聚类对象连接的聚类对象的数组
			var newArr : Array = [];
			len = arr.length;
			for ( i = 0; i < len; i++ )
			{
				newArr[i] = arr[i];
				newArr[i][ "connectClusterArr" ] = [ newArr[i] ];
			}
			
			
			/// 梳理聚类对象周围相互连接的对象
			var pointA : Point;
			var pointB : Point;
			len = newArr.length;
			for ( i = 0; i < len; i++ )
			{
				pointA = new Point( newArr[i].x, newArr[i].y );
				len2 = newArr.length;
				for ( j = 0; j < len2; j++ )
				{
					if ( j != i &&  newArr[i]["connectClusterArr"].indexOf(newArr[j]) == -1 )
					{
						pointB = new Point( newArr[j].x, newArr[j].y );
						if ( Point.distance(pointA, pointB) < distance )
						{
							 newArr[i][ "connectClusterArr" ].push( newArr[j] );
						}
					}
				}
				//trace( newArr[i][ "connectClusterArr" ].length );
			}
			
			
			var tempIndex : int = 0;		// 当前遍历统计的索引值，由于连接是不定的，所以这个索引值也是任意的
			var tempTotal : int = 0;		// 计算相互连接的聚类对象的总数
			var tempArr : Array = [];		// 已经统计的数组
			var tempArr2 : Array = newArr[0][ "connectClusterArr" ];		// 当前要进行遍历的数组
			var isFor : Boolean = true;
			while ( isFor )
			{
				// 还有未统计的周围或串联的聚类
				if ( tempArr2.length >= 1 )
				{
					if ( tempArr.indexOf(newArr[tempIndex]) == -1 )
					{
						tempArr.push( newArr[tempIndex] );
						tempArr2.splice( tempArr2.indexOf(newArr[tempIndex]), 1 );
						tempTotal++;
						
						len2 = newArr[tempIndex][ "connectClusterArr" ].length;
						for ( j = 0; j < len2; j++ )
						{
							if ( tempArr.indexOf(newArr[tempIndex][ "connectClusterArr" ][j]) == -1 && tempArr2.indexOf(newArr[tempIndex][ "connectClusterArr" ][j]) == -1 )
							{
								tempArr2.push( newArr[tempIndex][ "connectClusterArr" ][j] );
							}
						}
						if ( tempArr2.length >= 1 )
						{
							tempIndex = newArr.indexOf( tempArr2[0] );
						}
					}
				}
				else
				{
					// 删除已经统计了的聚类对象
					len2 = tempArr.length;
					for ( j = 0; j < len2; j++ )
					{
						newArr.splice( newArr.indexOf(tempArr[j]), 1 );
					}
					
					// 有串联的聚类对象，则添加到最终的聚类数组中
					if ( tempTotal >= minNum )
					{
						clusterArr.push( tempArr );
					}
					// 没有则将添加到 没有聚类的对象数组
					else
					{
						noClusterArr = noClusterArr.concat( tempArr );
					}
					
					// 下一次循环的初始化
					tempIndex = 0;
					tempTotal = 0;
					tempArr = [];
					if ( newArr.length >= 1 )
					{
						tempArr2 = newArr[0][ "connectClusterArr" ];
					}
					// 已经排除所有的聚类对象，可以结束循环了
					else
					{
						isFor = false;
					}
				}
			}
			
			/*
			trace( noClusterArr.length );
			trace( clusterArr.length );
			trace( noClusterArr );
			trace( clusterArr );
			*/
			
			// 将没有聚类的对象数组 和 聚类了的对象数组进行合并
			clusterArr.unshift( noClusterArr );
			
			return clusterArr;
		}
		
		
	}
}