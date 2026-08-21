package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	public class Main extends MovieClip
	{
		/* 容器对象数组，洗衣机，冰箱，书包 */
		private var containerArr : Array = [ "xyjMC", "sbMC", "bxMC" ];
		
		/* 每个容器对应的子对象数组 */
		private var subObjectArr : Array = [ ["xyj0", "xyj1", "xyj2", "xyj3"], ["sb0", "sb1", "sb2"], ["bx0", "bx1", "bx2"] ];
		
		
		/* 当前容器的索引值 */
		private var containerIndex : int = -1;
		
		/* 当前子对象的索引值 */
		private var subObjectIndexI : int = -1;
		private var subObjectIndexJ : int = -1;
		
		/* 当前容器 */
		private var currentContainer : MovieClip;
		
		/* 当前子对象 */
		private var currentSubObject : MovieClip;
		
		/* 当前对象 */
		private var ts : MovieClip;
		
		
		public function Main ()
		{
			init();
		}
		
		private function init () : void
		{
			ts = this;
			
			var j:int, len2:int;
			var i:int, len:int;
			
			len = containerArr.length;
			for ( i = 0; i < len; i++ )
			{
				// 容器点击函数
				containerMouseFun( this[ containerArr[i] ], i );
				
				len2 = subObjectArr[i].length;
				for ( j = 0; j < len2; j++ )
				{
					// 容器点击函数
					subObjectMouseFun( this[ subObjectArr[i][j] ], i, j );
				}
			}
			
			
			// 重置按钮
			resetBtn.addEventListener( MouseEvent.CLICK, resetBtnMouse );

		}
		
		/**
		 * 容器点击函数
		 */
		private function containerMouseFun ( container:MovieClip, index:int ) : void
		{
			container.buttonMode = true;
			container.addEventListener( MouseEvent.CLICK, function ( eve:MouseEvent ) : void
			{
				var i:int, len:int;
				len = containerArr.length;
				for ( i = 0; i < len; i++ )
				{
					if ( container != ts[ containerArr[i] ] && ts[ containerArr[i] ].currentFrame == 2 )
					{
						ts[ containerArr[i] ].gotoAndStop( 1 );
					}
				}
				
				if ( container.currentFrame == 1 )
				{
					containerIndex = index;
					container.gotoAndStop( 2 );
					
					currentContainer = container;
					
					if ( subObjectIndexI != -1 && subObjectIndexJ != -1 && containerIndex == subObjectIndexI )
					{
						currentContainer.gotoAndStop( 1 );
						currentSubObject.gotoAndStop( 3 );
						containerIndex = -1;
						subObjectIndexI = -1;
						subObjectIndexJ = -1;
					}
				}
				else if ( container.currentFrame == 2 )
				{
					containerIndex = -1;
					container.gotoAndStop( 1 );
				}
				
				if ( containerIndex != subObjectIndexI && containerIndex != -1 && subObjectIndexI != -1 )
				{
					currentContainer.gotoAndStop( 1 );
					currentSubObject.gotoAndStop( 1 );
					containerIndex = -1;
					subObjectIndexI = -1;
					subObjectIndexJ = -1;
				}
			});
		}
		
		/**
		 * 子对象点击函数
		 */
		private function subObjectMouseFun ( subObject:MovieClip, indexI:int, indexJ:int ) : void
		{
			subObject.buttonMode = true;
			subObject.addEventListener( MouseEvent.CLICK, function ( eve:MouseEvent ) : void
			{
				var j:int, len2:int;
				var i:int, len:int;
				len = containerArr.length;
				for ( i = 0; i < len; i++ )
				{
					len2 = subObjectArr[i].length;
					for ( j = 0; j < len2; j++ )
					{
						if ( subObject != ts[ subObjectArr[i][j] ] && ts[ subObjectArr[i][j] ].currentFrame == 2 )
						{
							ts[ subObjectArr[i][j] ].gotoAndStop( 1 );
						}
					}
				}
				
				if ( subObject.currentFrame == 1 )
				{
					subObjectIndexI = indexI;
					subObjectIndexJ = indexJ;
					subObject.gotoAndStop( 2 );
					
					currentSubObject = subObject;
					
					if ( containerIndex != -1 && containerIndex == subObjectIndexI )
					{
						currentContainer.gotoAndStop( 1 );
						currentSubObject.gotoAndStop( 3 );
						containerIndex = -1;
						subObjectIndexI = -1;
						subObjectIndexJ = -1;
					}
				}
				else if ( subObject.currentFrame == 2 )
				{
					subObjectIndexI = -1;
					subObjectIndexJ = -1;
					subObject.gotoAndStop( 1 );
				}
				if ( containerIndex != subObjectIndexI && containerIndex != -1 && subObjectIndexI != -1 )
				{
					currentContainer.gotoAndStop( 1 );
					currentSubObject.gotoAndStop( 1 );
					containerIndex = -1;
					subObjectIndexI = -1;
					subObjectIndexJ = -1;
				}
			});
		}
		
		
		
		
		/**
		 * 重置按钮
		 */
		private function resetBtnMouse ( eve:MouseEvent ) : void
		{
			currentContainer = null;
			currentSubObject = null;
			
			containerIndex = -1;
			subObjectIndexI = -1;
			subObjectIndexJ = -1;
			
			var j:int, len2:int;
			var i:int, len:int;
			len = containerArr.length;
			for ( i = 0; i < len; i++ )
			{
				ts[ containerArr[i] ].gotoAndStop( 1 );
				
				len2 = subObjectArr[i].length;
				for ( j = 0; j < len2; j++ )
				{
					ts[ subObjectArr[i][j] ].gotoAndStop( 1 );
				}
			}
		}

	}
}