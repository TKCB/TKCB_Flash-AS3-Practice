/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */



package seekRoute
{
	/**
	 * 节点类，如果 isStart 为 true 表示该节点为开始节点，如果 isEnd 为 true 表示该节点为结束节点，，如果 isPassable 为 true 表示该节点为障碍节点，否则为普通节点
	 */
	public class NodalPoint
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 节点的 F 值，F 值是起点到目标节点的预估距离值（计算公式 F = G + H ）*/
		public var F : int = 0;
		
		/** 节点的 G 值，G 值是从起点到该节点的移动值 */
		public var G : int = 0;
		
		/** 节点的 H 值，H 值是该节点到目标节点的预估距离值*/
		public var H : int = 0;
		
		
		/** 是否是开始节点，true表示是开始节点，false表示不是开始节点（如果 isStart 和 isEnd 都是 false 表示该节点是普通节点） */
		public var isStart : Boolean = false;
		
		/** 是否是结束节点，true表示是结束节点，false表示不是结束节点（如果 isStart 和 isEnd 都是 false 表示该节点是普通节点） */
		public var isEnd : Boolean = false;
		
		/** 是否是可以通行，true表示可以通行，false表示不能通行（障碍） */
		public var isPassable : Boolean = true;
		
		/** 是否被探测，treu表示被探测过，false表示没有被探测 */
		public var isDetect : Boolean = false;
		
		/** 是否在开放列表中，true表示在开放列表中，false表示没有在开放列表中 */
		public var inOpenList : Boolean = false;
		
		/** 是否在封闭列表中，true表示在封闭列表中，false表示没有在封闭列表中 */
		public var inCloseList : Boolean = false;
		
		
		/** 节点在地图中的竖向位置（二维数组索引） */
		public var num1 : int;
		
		/** 节点在地图中的横向位置（二维数组索引） */
		public var num2 : int;
		
		
		/** 父节点 */
		public var parentNodalPoint : NodalPoint;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function NodalPoint ()
		{
			
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		
		
		
	}
}



