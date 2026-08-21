/*
 * 作　　者：TKCB
 * 作者信息：身高（167cm+）；体重（60kg±）；年龄（90后）；籍贯（陕西西安）；星座（双鱼座）；血型（O型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 */



package maps
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	/**
	 * ...
	 */
	public class Map extends Sprite
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		/** 地图可通行数组，用于存放地图的可通行信息。数组元素为 0 表示可通行，数组元素为 1 表示是障碍地形 */
		public var mapPassableArr : Array;
		
		/** 地图数组，用于存放地图每一个方块 */
		public var mapDisplayArr : Array;
		
		/** 寻路开始的点，以及它的竖向（1）、横向（2）索引值 */
		public var startPoint : Sprite;
		public var startNum1 : int;
		public var startNum2 : int;
		
		/** 寻路结束的点，以及它的竖向（1）、横向（2）索引值 */
		public var endPoint : Sprite;
		public var endNum1 : int;
		public var endNum2 : int;
		
		/** 方块大小 */
		private var rectSize : int = 10;
		
		/** 绘制的寻路路线容器 */
		private var routeSpr : Sprite;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function Map ( widthNum : int, heightNum : int, rectSize : int = 10, randomNum : Number = 0.5 )
		{
			newMap( widthNum, heightNum, rectSize, randomNum );
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		/**
		 * 创建地图，或设置新的地图
		 */
		public function newMap ( widthNum : int, heightNum : int, _rectSize : int = 10, randomNum : Number = 0.5 ) : void
		{
			if ( routeSpr != null )
			{
				this.removeChild( routeSpr );
				routeSpr = null;
			}
			
			rectSize = _rectSize;
			
			//// 用于循环的对象
			var i : int;
			var ilen : int;
			var j : int;
			var jlen : int;
			var rect : Sprite;
			
			//// 对地图数组（可通行数组）进行重置，如果地图数组已经有地图，则清除已有的地图
			mapPassableArr = [];
			if ( mapDisplayArr != null )
			{
				ilen = mapDisplayArr.length;
				jlen = mapDisplayArr[0].length;
				for ( i = 0; i < ilen; i++ )
				{
					for ( j = 0; j < jlen; j++ )
					{
						this.removeChild( mapDisplayArr[ i ][ j ] );
					}
				}
			}
			mapDisplayArr = [];
			
			
			//// 设置地图数组、地图可通行数组
			ilen = heightNum;
			jlen = widthNum;
			for ( i = 0; i < ilen; i++ )
			{
				for ( j = 0; j < jlen; j++ )
				{
					//// 判断地图的数组是否创建
					if ( mapPassableArr[ i ] == null )
					{
						mapPassableArr [ i ] = [];
						mapDisplayArr [ i ] = [];
					}
					
					//// 随机生成数组的障碍为，并设置地图数组、地图可通行数组
					if ( Math.random() > randomNum )
					{
						mapPassableArr[ i ][ j ] = 0;
						
						//// 生成浅灰色方块表示可通行
						rect = new Sprite();
						rect.graphics.beginFill( 0xD7D7D7 );
						if ( rectSize >= 5 ) rect.graphics.lineStyle( 0.1, 0x999999 );
						rect.graphics.drawRect( 0, 0, rectSize, rectSize );
						rect.graphics.endFill();
						rect.x = j * rectSize;
						rect.y = i * rectSize;
						rect.addEventListener( MouseEvent.CLICK, rectMouse );
						rect.addEventListener( MouseEvent.RIGHT_MOUSE_DOWN , rectMouse2 );
						this.addChild( rect );
						mapDisplayArr [ i ][ j ] = rect;
					}
					else
					{
						mapPassableArr[ i ][ j ] = 1;
						
						//// 生成黑色方块表示不可通行（障碍）
						rect = new Sprite();
						rect.graphics.beginFill( 0x000000 );
						if ( rectSize >= 5 ) rect.graphics.lineStyle( 0.1, 0x999999 );
						rect.graphics.drawRect( 0, 0, rectSize, rectSize );
						rect.graphics.endFill();
						rect.x = j * rectSize;
						rect.y = i * rectSize;
						rect.addEventListener( MouseEvent.CLICK, rectMouse );
						rect.addEventListener( MouseEvent.RIGHT_MOUSE_DOWN, rectMouse2 );
						this.addChild( rect );
						mapDisplayArr [ i ][ j ] = rect;
					}
				}
			}
		}
		
		/** 方块被点击，设置方块状态（反向） */
		private function rectMouse ( eve : MouseEvent ) : void
		{
			// 新的，创建开始点
			//// 用于存放被点击方块所在地图数组的索引位置
			var indexWidth : int;
			var indexHeight : int;
			
			//// 循环获取被点击方块所在地图数组的索引位置
			var i : int;
			var ilen : int = mapDisplayArr.length;
			var j : int;
			var jlen : int = mapDisplayArr[ 0 ].length;
			for ( i = 0; i < ilen; i++ )
			{
				for ( j = 0; j < jlen; j++ )
				{
					if ( mapDisplayArr[ i ][ j ] == eve.target )
					{
						indexHeight = i;
						indexWidth = j;
					}
				}
			}
			// 可通行
			if ( mapPassableArr[ indexHeight ][ indexWidth ] == 0 )
			{
				if ( routeSpr != null )
				{
					this.removeChild( routeSpr );
					routeSpr = null;
				}
				if ( mapPassableArr != null )
				{
					if ( startPoint != null )
					{
						this.removeChild( startPoint );
					}
				}
					
				startPoint = new Sprite();
				startPoint.graphics.beginFill( 0xFF0000 );
				startPoint.graphics.drawRect( 0, 0, rectSize, rectSize );
				startPoint.graphics.endFill();
				startPoint.x = indexWidth * rectSize;
				startPoint.y = indexHeight * rectSize;
				this.addChild( startPoint );
				
				//// 记录寻路开始点的竖向（1）、横向（2）索引值 
				startNum1 = indexHeight;
				startNum2 = indexWidth;
			}
			
			
			/* 旧的，用于切换方块状态
			
			//// 用于存放被点击方块所在地图数组的索引位置
			var indexWidth : int;
			var indexHeight : int;
			
			//// 循环获取被点击方块所在地图数组的索引位置
			var i : int;
			var ilen : int = mapDisplayArr.length;
			var j : int;
			var jlen : int = mapDisplayArr[ 0 ].length;
			for ( i = 0; i < ilen; i++ )
			{
				for ( j = 0; j < jlen; j++ )
				{
					if ( mapDisplayArr[ i ][ j ] == eve.target )
					{
						indexHeight = i;
						indexWidth = j;
					}
				}
			}
			
			//// 判断被点击方块是否可通行，设置方块状态
			var rect : Sprite = new Sprite();
			if ( mapPassableArr[ indexHeight ][ indexWidth ] == 0 )
			{
				//// 生成黑色方块表示不可通行（障碍）
				rect.graphics.beginFill( 0x000000 );
				rect.graphics.lineStyle( 0.1, 0x999999 );
				rect.graphics.drawRect( 0, 0, rectSize, rectSize );
				rect.graphics.endFill();
				rect.x = indexWidth * rectSize;
				rect.y = indexHeight * rectSize;
				rect.addEventListener( MouseEvent.CLICK, rectMouse );
				this.addChild( rect );
				this.removeChild( mapDisplayArr [ indexHeight ][ indexWidth ] );
				mapDisplayArr [ indexHeight ][ indexWidth ] = rect;
				mapPassableArr[ indexHeight ][ indexWidth ] = 1;
			}
			else
			{
				//// 生成浅灰色方块表示可通行
				rect.graphics.beginFill( 0xD7D7D7 );
				rect.graphics.lineStyle( 0.1, 0x999999 );
				rect.graphics.drawRect( 0, 0, rectSize, rectSize );
				rect.graphics.endFill();
				rect.x = indexWidth * rectSize;
				rect.y = indexHeight * rectSize;
				rect.addEventListener( MouseEvent.CLICK, rectMouse );
				this.addChild( rect );
				this.removeChild( mapDisplayArr [ indexHeight ][ indexWidth ] );
				mapDisplayArr [ indexHeight ][ indexWidth ] = rect;
				mapPassableArr[ indexHeight ][ indexWidth ] = 0;
			}*/
		}
		
		
		/** 右键点击方块，创建结束点 */
		private function rectMouse2 ( eve:MouseEvent ) : void
		{trace(12345)
			// 新的，创建开始点
			//// 用于存放被点击方块所在地图数组的索引位置
			var indexWidth : int;
			var indexHeight : int;
			
			//// 循环获取被点击方块所在地图数组的索引位置
			var i : int;
			var ilen : int = mapDisplayArr.length;
			var j : int;
			var jlen : int = mapDisplayArr[ 0 ].length;
			for ( i = 0; i < ilen; i++ )
			{
				for ( j = 0; j < jlen; j++ )
				{
					if ( mapDisplayArr[ i ][ j ] == eve.target )
					{
						indexHeight = i;
						indexWidth = j;
					}
				}
			}
			// 可通行
			if ( mapPassableArr[ indexHeight ][ indexWidth ] == 0 )
			{
				if ( routeSpr != null )
				{
					this.removeChild( routeSpr );
					routeSpr = null;
				}
				
				if ( mapPassableArr != null )
				{
					if ( endPoint != null )
					{
						this.removeChild( endPoint );
					}
					endPoint = new Sprite();
					endPoint.graphics.beginFill( 0x0000FF );
					endPoint.graphics.drawRect( 0, 0, rectSize, rectSize );
					endPoint.graphics.endFill();
					endPoint.x = indexWidth * rectSize;
					endPoint.y = indexHeight * rectSize;
					this.addChild( endPoint );
						
					//// 记录寻路结束点的竖向（1）、横向（2）索引值 
					endNum1 = indexHeight;
					endNum2 = indexWidth;
				}
			}
		}
		
		/**
		 * 创建一个开始点（随机的）
		 */
		public function newStartPoint () : void
		{
			if ( routeSpr != null )
			{
				this.removeChild( routeSpr );
				routeSpr = null;
			}
			
			if ( mapPassableArr != null )
			{
				var num1 : int = Math.random() * mapPassableArr[ 0 ].length;
				var num2 : int = Math.random() * mapPassableArr.length;
				if ( mapPassableArr[ num2 ][ num1 ] == 0 )
				{
					if ( startPoint != null )
					{
						this.removeChild( startPoint );
					}
					startPoint = new Sprite();
					startPoint.graphics.beginFill( 0xFF0000 );
					startPoint.graphics.drawRect( 0, 0, rectSize, rectSize );
					startPoint.graphics.endFill();
					startPoint.x = num1 * rectSize;
					startPoint.y = num2 * rectSize;
					this.addChild( startPoint );
					
					//// 记录寻路开始点的竖向（1）、横向（2）索引值 
					startNum1 = num2;
					startNum2 = num1;
				}
				else
				{
					newStartPoint();
				}
			}
		}
		
		/**
		 * 创建一个结束点（随机的）
		 */
		public function newEndPoint () : void
		{
			if ( routeSpr != null )
			{
				this.removeChild( routeSpr );
				routeSpr = null;
			}
			
			if ( mapPassableArr != null )
			{
				var num1 : int = Math.random() * mapPassableArr[ 0 ].length;
				var num2 : int = Math.random() * mapPassableArr.length;
				if ( mapPassableArr[ num2 ][ num1 ] == 0 )
				{
					if ( endPoint != null )
					{
						this.removeChild( endPoint );
					}
					endPoint = new Sprite();
					endPoint.graphics.beginFill( 0x0000FF );
					endPoint.graphics.drawRect( 0, 0, rectSize, rectSize );
					endPoint.graphics.endFill();
					endPoint.x = num1 * rectSize;
					endPoint.y = num2 * rectSize;
					this.addChild( endPoint );
					
					//// 记录寻路结束点的竖向（1）、横向（2）索引值 
					endNum1 = num2;
					endNum2 = num1;
				}
				else
				{
					newEndPoint();
				}
			}
		}
		
		/** 绘制寻找到的路线 */
		public function drawRoute ( arr : Array ) : void
		{
			if ( routeSpr != null )
			{
				this.removeChild( routeSpr );
			}
			routeSpr = new Sprite();
			this.addChild( routeSpr );
			
			var shape : Shape;
			var i : int;
			var len : int = arr.length;
			for ( i = 0; i < len; i++ )
			{
				shape = new Shape();
				shape.graphics.beginFill( 0x00FF00, 0.5 );
				shape.graphics.drawRect( 0, 0, rectSize, rectSize );
				shape.graphics.endFill();
				shape.x = arr[ i ].num2 * rectSize;
				shape.y = arr[ i ].num1 * rectSize;
				routeSpr.addChild( shape );
			}
		}
		
	}
}
