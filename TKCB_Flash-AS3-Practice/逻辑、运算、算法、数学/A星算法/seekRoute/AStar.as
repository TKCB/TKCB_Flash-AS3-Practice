/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */



package seekRoute
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	/**
	 * A*算法类
	 */
	public class AStar extends Sprite
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 地图可通行数组，用于存放地图的可通行信息。数组元素为 0 表示可通行，数组元素为 1 表示是障碍地形 */
		private var mapPassableArr : Array;
		
		/** 地图节点数组数组，用于存放所有节点（包括普通节点、开始节点、结束节点、障碍节点等等） */
		private var mapNodalPointArr : Array;
		
		/** 开放列表 */
		private var openList : Array;
		
		/** 开始节点 */
		private var startNodalPoint : NodalPoint;
		
		/** 结束节点 */
		private var endNodalPoint : NodalPoint;
		
		/** 是否结束寻路 */
		public var isEnd : Boolean = false;
		
		/** 是否寻找到路线（寻路结果），true为寻找到了，false为没有寻找到 */
		public var isRoute : Boolean = false;
		
		/** 找到的路线节点数组 */
		public var routeArr : Array;
		
		/** 是否开启八方向寻路 */
		public var isEight : Boolean = true;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function AStar ( arr : Array )
		{
			setSeekRouteMap ( arr );
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 
		 * 设置新的寻路地图
		 */
		public function setSeekRouteMap ( arr : Array ) : void
		{
			mapPassableArr = arr;
			mapNodalPointArr = [];
			
			var nodalPoint : NodalPoint;
			var i : int;
			var ilen : int = mapPassableArr.length;
			var j : int;
			var jlen : int = mapPassableArr[ 0 ].length;
			
			for ( i = 0; i < ilen; i++ )
			{
				for ( j = 0; j < jlen; j++ )
				{
					if ( mapNodalPointArr[ i ] == null )
					{
						mapNodalPointArr[ i ] = [];
					}
					// 判断是否可以通行，并创建相应的节点
					if ( mapPassableArr[ i ][ j ] == 0 )
					{
						nodalPoint = new NodalPoint();
						nodalPoint.num1 = i;
						nodalPoint.num2 = j;
						mapNodalPointArr[ i ][ j ] = nodalPoint;
					}
					else
					{
						nodalPoint = new NodalPoint();
						nodalPoint.isPassable = false;
						nodalPoint.num1 = i;
						nodalPoint.num2 = j;
						mapNodalPointArr[ i ][ j ] = nodalPoint;
					}
				}
			}
		}
		
		/**
		 * 寻找路线
		 * @param startNum1		开始节点，在地图中的竖向坐标（X轴）的索引值
		 * @param startNum2		开始节点，在地图中的横向坐标（Y轴）的索引值
		 * @param endNum1		结束节点，在地图中的竖向坐标（X轴）的索引值
		 * @param endNum2		结束节点，在地图中的横向坐标（Y轴）的索引值
		 */
		public function seekRoute ( startNum1 : int, startNum2 : int, endNum1 : int, endNum2 : int ) : void
		{
			trace( "寻找路线！！！" );
			isRoute = false;
			routeArr = null;
			openList = [];
			
			//// 将传入的开始点位置对应的节点设为开始节点，将传入的结束点位置对应的节点设为结束节点
			startNodalPoint = mapNodalPointArr[ startNum1 ][ startNum2 ];
			endNodalPoint = mapNodalPointArr[ endNum1 ][ endNum2 ];
			startNodalPoint.isStart = true;
			endNodalPoint.isEnd = true;
			
			
			//// 核心步骤【1】：将开始节点加入开放列表
			openList[ 0 ] = startNodalPoint;
			openList[ 0 ].inOpenList = true;
			
			//// 核心步骤【2】：不断的检测开放列表中的节点
			while ( isEnd == false )
			{
				//——trace( "循环探测中……" );
				
				var i : int;
				var ilen : int;
				var j : int;
				var jlen : int;
				var currentNP : NodalPoint;		// 当前节点
				var currentNum : int;			// 当前节点在开放列表中的索引位置
				
				//// 核心步骤【2.1】：在开放列表中查找具有最小 F 值的节点，并把查找到的节点作为当前节点
				ilen = openList.length;
				currentNP = openList[ 0 ];
				currentNum = 0;
				for ( i = 0; i < ilen; i++ )
				{
					if ( openList[ i ].F < currentNP.F )
					{
						currentNP = openList[ i ];
						currentNum = i;
					}	
				}
				
				//// 核心步骤【2.2】：把当前节点从开放列表删除, 加入到封闭列表
				currentNP.inOpenList = false;
				openList[ currentNum ] = openList[ openList.length - 1 ];
				openList.pop();
				
				//// 核心步骤【2.3】：对当前节点相邻的每一个节点依次执行以下步骤：
				//// 下面是一个九宫格循环，横向和竖向分别循环三次
				var currentDetectNP : NodalPoint;		// 当前要被探测的节点
				var num1 : int;		// 被探测节点的竖向坐标索引
				var num2 : int;		// 被探测节点的横向坐标索引
				var GNum : int;		// 用于计算 G 值
				var FNum : int;		// 用于计算 F 值
				ilen = 2;
				jlen = 2;
				for ( i = -1; i < ilen; i++ )
				{
					for ( j = -1; j < jlen; j++ )
					{
						//// 如果关闭了八方向寻路（即为四方向寻路），则忽略掉左上、左下、右上、右下的四个节点的探路
						if ( isEight == false )
						{
							// 左上角节点
							if ( i == -1 && j == -1 ) continue;
							// 右上角节点
							if ( i == -1 && j == 1 ) continue;
							// 左下角节点旁边障碍物判断
							if ( i == 1 && j == -1 ) continue;
							// 右下角节点旁边障碍物判断
							if ( i == 1 && j == 1 ) continue;
						}
						
						//// 核心步骤【2.3.1】：如果该相邻节点不可通行或者该相邻节点已经在封闭列表中,则什么操作也不执行,继续检验下一个节点
						GNum = 10;		// 设置 G 值
						num1 = currentNP.num1 + i;
						num2 = currentNP.num2 + j;
						//// 各种不需要检测的情况……
						if ( i == 0 && j == 0 )
						{
							//——trace( "探测的点为当前节点！！！" );
							continue;
						}
						if ( num1 < 0 )
						{
							//——trace( "探测的点超出上边！！！" );
							continue;
						}
						if ( num1 == mapNodalPointArr.length )
						{
							//——trace( "探测的点超出下边！！！" );
							continue;
						}
						if ( num2 < 0 )
						{
							//——trace( "探测的点超出左边！！！" );
							continue;
						}
						if ( num2 == mapNodalPointArr[ 0 ].length )
						{
							//——trace( "探测的点超出右边！！！" );
							continue;
						}
						//// 从节点数组中获取当前要探测的节点
						currentDetectNP = mapNodalPointArr[ num1 ][ num2 ];
						if ( currentDetectNP.isStart )
						{
							//——trace( "该节点为开始点！！！" );
							continue;
						}
						if ( currentDetectNP.isPassable == false )
						{
							//——trace( "该节点不可通行！！！" );
							continue;
						}
						if ( currentDetectNP.inCloseList )
						{
							//——trace( "该节点在封闭列表中！！！" );
							continue;
						}
						// 左上角节点旁边障碍物判断
						if ( i == -1 && j == -1 )
						{
							if ( mapNodalPointArr[ num1 + 1 ][ num2 ].isPassable == false )
							{
								//——trace( "【左上角】该节点的下边有障碍物！！！" );
								continue;
							}
							if ( mapNodalPointArr[ num1 ][ num2 + 1 ].isPassable == false )
							{
								//——trace( "【左上角】该节点的右边有障碍物！！！" );
								continue;
							}
							GNum = 14;		// 设置 G 值
						}
						// 右上角节点旁边障碍物判断
						if ( i == -1 && j == 1 )
						{
							if ( mapNodalPointArr[ num1 + 1 ][ num2 ].isPassable == false )
							{
								//——trace( "【右上角】该节点的下边有障碍物！！！" );
								continue;
							}
							if ( mapNodalPointArr[ num1 ][ num2 - 1 ].isPassable == false )
							{
								//——trace( "【右上角】该节点的左边有障碍物！！！" );
								continue;
							}
							GNum = 14;		// 设置 G 值
						}
						// 左下角节点旁边障碍物判断
						if ( i == 1 && j == -1 )
						{
							if ( mapNodalPointArr[ num1 - 1 ][ num2 ].isPassable == false )
							{
								//——trace( "【左下角】该节点的上边有障碍物！！！" );
								continue;
							}
							if ( mapNodalPointArr[ num1 ][ num2 + 1 ].isPassable == false )
							{
								//——trace( "【左下角】该节点的右边有障碍物！！！" );
								continue;
							}
							GNum = 14;		// 设置 G 值
						}
						// 右下角节点旁边障碍物判断
						if ( i == 1 && j == 1 )
						{
							if ( mapNodalPointArr[ num1 - 1 ][ num2 ].isPassable == false )
							{
								//——trace( "【右下角】该节点的上边有障碍物！！！" );
								continue;
							}
							if ( mapNodalPointArr[ num1 ][ num2 - 1 ].isPassable == false )
							{
								//——trace( "【右下角】该节点的左边有障碍物！！！" );
								continue;
							}
							GNum = 14;		// 设置 G 值
						}
						
						//// 核心步骤【2.3.2】：如果该相邻节点没有探测过，则将该节点添加到开放列表中, 并将该相邻节点的父节点设为当前节点,同时保存该相邻节点的G和F值
						if ( currentDetectNP.isDetect == false )
						{
							//——trace( "普通节点" );
							currentDetectNP.isDetect = true;		// 设置为被探测过
							currentDetectNP.inOpenList = true;		// 加入开放列表
							openList.push( currentDetectNP );		// 加入开放列表
							currentDetectNP.parentNodalPoint = currentNP;		// 设置父节点
							// 设置 G 值
							currentDetectNP.G = currentNP.G + GNum;
							// 设置 H 值
							currentDetectNP.H = ( Math.abs( currentDetectNP.num1 - endNodalPoint.num1 ) + Math.abs( currentDetectNP.num2 - endNodalPoint.num2 ) ) * 10;
							// 设置 F 值
							currentDetectNP.F = currentDetectNP.G + currentDetectNP.H;
						}
						
						//// 核心步骤【2.3.3】：如果该相邻节点在开放列表中, 则判断若经由当前节点到达该相邻节点的G值是否小于原来保存的G值,若小于,则将该相邻节点的父节点设为当前节点,并重新设置该相邻节点的G和F值
						if ( currentDetectNP.inOpenList )
						{
							//——trace( "开放列表中的节点！！！" );
							FNum = currentNP.G + GNum + ( ( Math.abs( currentDetectNP.num1 - endNodalPoint.num1 ) + Math.abs( currentDetectNP.num2 - endNodalPoint.num2 ) ) * 10 )
							if ( FNum < currentDetectNP.F )
							{
								currentDetectNP.parentNodalPoint = currentNP;		// 设置父节点
								// 设置 G 值
								currentDetectNP.G = currentNP.G + GNum;
								// 设置 F 值
								currentDetectNP.F = currentDetectNP.G + currentDetectNP.H;
							}	
						}
						//// 核心步骤【2.4.1】：循环结束条件：当结束节点被加入到开放列表作为待检验节点时，表示路径被找到，此时应终止循环
						if ( currentDetectNP.isEnd )
						{
							//——trace( "寻路结束，找到了路线！" );
							isEnd = true;		// 寻路结束
							isRoute = true;		// 找到了路线
							routeArr = [];
							routeArr.push( currentDetectNP );
							
							//// 核心步骤【3】：从终点节点开始沿父节点遍历, 并保存整个遍历到的节点坐标,遍历所得的节点就是最后得到的路径
							while ( true )
							{
								if ( currentDetectNP.parentNodalPoint.isStart == false )
								{
									routeArr.push( currentDetectNP.parentNodalPoint );
									currentDetectNP = currentDetectNP.parentNodalPoint;
								}
								else
								{
									break;
								}
							}
						}
					}
				}
				
				//// 核心步骤【2.4.2】：循环结束条件：开放列表为空，表明已无可以添加的新节点，而已检验的节点中没有终点节点则意味着路径无法被找到，此时也结束循环
				if ( openList.length == 0 )
				{
					//——trace( "寻路结束，没有找到路线！" );
					routeArr = [];
					isEnd = true;			// 寻路结束
					isRoute = false;		// 没有找到路线
				}
			}
		}
		
		
	}
}