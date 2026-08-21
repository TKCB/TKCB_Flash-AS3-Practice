// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Nm（nm.tkcb.cc）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc




package
{
	import flash.display.Sprite;

	import flash.events.MouseEvent;

	import flash.utils.setTimeout;
	import flash.utils.getTimer;

	import maps.Map;
	import seekRoute.AStar;

	/**
	 * ...
	 */
	public class Main extends Sprite
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 地图对象 */
		private var map: Map;

		/** A*寻路对象 */
		private var aStar: AStar;

		/** 是否开启八方向寻路 */
		private var isEight: Boolean = true;

		/** 用于计算寻路时间 */
		private var aStarTime: int;


		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function Main()
		{
			newMap_btn.addEventListener(MouseEvent.CLICK, newMapMouse);
			newStartPoint_btn.addEventListener(MouseEvent.CLICK, newStartPointMouse);
			newEndPoint_btn.addEventListener(MouseEvent.CLICK, newEndPointMouse);
			newStartEndPoint_btn.addEventListener(MouseEvent.CLICK, newStartEndPointMouse);
			wayFinding_btn.addEventListener(MouseEvent.CLICK, wayFindingMouse);
			setEight_btn.addEventListener(MouseEvent.CLICK, setEightMouse);

			//// 创建地图，以及开始点和结束点
			setMap();
			map.newStartPoint();
			map.newEndPoint();

			// 地图点击检测
			map.addEventListener(MouseEvent.CLICK, mapClick);
			map.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mapClick);
		}


		//************************ ************************* 方　　法 ******************** *********** *** **////
		/** 设置地图 */
		private function setMap(): void
		{
			map = new Map(int(tf_1.text), int(tf_2.text), int(tf_3.text), Number(int(tf_4.text) / 100));
			map.x = 20;
			map.y = 40;
			this.addChild(map);
		}


		/** 创建新的地图 */
		private function newMapMouse(eve: MouseEvent): void
		{
			map.newMap(int(tf_1.text), int(tf_2.text), int(tf_3.text), Number(int(tf_4.text) / 100));
			map.newStartPoint();
			map.newEndPoint();
		}

		/** 创建新的寻路开始点 */
		private function newStartPointMouse(eve: MouseEvent): void
		{
			map.newStartPoint();
			wayFindingMouse(null);
		}

		/** 创建新的寻路结束点 */
		private function newEndPointMouse(eve: MouseEvent): void
		{
			map.newEndPoint();
			wayFindingMouse(null);
		}

		/** 创建新的寻路开始点和结束点 */
		private function newStartEndPointMouse(eve: MouseEvent): void
		{
			map.newStartPoint();
			map.newEndPoint();
			wayFindingMouse(null);
		}

		/** 设置四方向寻路或者八方向寻路 */
		private function setEightMouse(eve: MouseEvent): void
		{
			if (isEight)
			{
				isEight = false;
				tf_6.text = "当前为四方向寻路";
			}
			else
			{
				isEight = true;
				tf_6.text = "当前为八方向寻路";
			}
		}

		/** 开始寻路 */
		private function wayFindingMouse(eve: MouseEvent): void
		{
			// 新的寻路对象，传入地图可通行的数组，以及开始点、结束点的位置索引
			aStar = new AStar(map.mapPassableArr);
			aStar.isEight = isEight;

			// 获取寻路开始时间（毫秒）
			aStarTime = getTimer();
			aStar.seekRoute(map.startNum1, map.startNum2, map.endNum1, map.endNum2);

			// 判断是否寻找到路线
			if (aStar.isRoute)
			{
				//// 显示寻路时间（毫秒）（获取寻路结束时间并计算寻路时间）
				tf_5.text = "寻路时间：" + String(getTimer() - aStarTime) + " 毫秒";
				tf_7.text = "寻路步数：" + String(aStar.routeArr.length);
				// 绘制路线
				map.drawRoute(aStar.routeArr);
			}
			else
			{
				tf_5.text = "没有找到路线！";
				tf_7.text = "寻路步数：0";
			}
		}

		/** 开始寻路 */
		private function mapClick(eve: MouseEvent): void
		{
			setTimeout(function ()
			{
				wayFindingMouse(null);
			}, 200);
		}

	}
}