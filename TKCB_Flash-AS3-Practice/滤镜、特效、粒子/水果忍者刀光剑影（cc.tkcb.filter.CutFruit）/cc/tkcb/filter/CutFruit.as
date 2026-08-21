/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2013-2027 TKCB, www.tkcb.cc
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
 * v1.0.0 2018-9-6
 */

package cc.tkcb.filter
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	
	/**
	 * CutFruit 刀光特效类，水果忍者（切水果）中的刀光剑影特效。
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-9-6
	 * @修改时间 2018-9-6
	 * @version 1.0.0
	 */
	public class CutFruit extends Sprite
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		/** 线条对象数组 */
		private var setsArr:Vector.<CutFruitLine> = new Vector.<CutFruitLine>;
		
		/** 线条粗细，默认为8 */
		public var lineSize : Number;
		
		/** 线条颜色，默认为0xFFFFFF（白色） */
		public var lineColor : uint;
		
		//// 绘制刀光效果会用到的变量
		private var cacheX : int;
		private var cacheY : int;
		private var isDown : Boolean;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 */
		public function CutFruit ( $lineSize:Number = 8, $lineColor:uint = 0xFFFFFF, filterColor:uint = 0x00FF95, filtersArr:Array = null )
		{
			lineSize = $lineSize;
			lineColor = $lineColor;
			
			if ( filtersArr == null )
			{
				this.filters = [ new GlowFilter(filterColor, 1, 10, 10, 2, 1, false, false) ];
			}
			else
			{
				this.filters = filtersArr;
			}
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			this.addEventListener( Event.ADDED_TO_STAGE, addToStage );
		}
		
		
		//************************ ************************* 改变特效颜色和特效 ******************** *********** *** **////
		/**
		 * 设置发光特效颜色
		 * @param filterColor 颜色值，uint类型，例如：0xFF0000（红色）、0x00FF00（绿色）
		 * @param alpha 颜色的 Alpha 透明度值。有效值为 0 到 1。例如，0.25 设置透明度值为 25%。 
		 * @param blurX 水平模糊量。有效值为 0 到 255（浮点）。2 的乘方值（如 2、4、8、16 和 32）经过优化，呈示速度比其它值更快。 
		 * @param blurY 垂直模糊量。有效值为 0 到 255（浮点）。2 的乘方值（如 2、4、8、16 和 32）经过优化，呈示速度比其它值更快。 
		 * @param strength 印记或跨页的强度。该值越高，压印的颜色越深，而且发光与背景之间的对比度也越强。有效值为 0 到 255。 
		 * @param quality 应用滤镜的次数。使用 BitmapFilterQuality 常量： 
		 * @param inner 指定发光是否为内侧发光。值 true 指定发光是内侧发光。值 false 指定发光是外侧发光（对象外缘周围的发光）。 
		 * @param knockout 指定对象是否具有挖空效果。值为 true 将使对象的填充变为透明，并显示文档的背景颜色。 
		 */
		public function setFilterColor ( filterColor:uint, alpha:Number = 1.0, blurX:Number = 10, blurY:Number = 10, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false ) : void
		{
			this.filters = [ new GlowFilter(filterColor, alpha, blurX, blurY, strength, quality, inner, knockout) ];
		}
		
		/**
		 * 设置特效，可以是任意特效，但是传入的时候应该知道会是什么效果，不应该乱传特效参数
		 * @param filtersArr 特效数组，具体可参考 flash.filters 包里面的特效
		 */
		public function setFiltersArr ( filtersArr:Array ) : void
		{
			this.filters = filtersArr;
		}
		
		
		
		//************************ ************************* 对象加入或离开舞台的监听 ******************** *********** *** **////
		/**
		 * 对象加入舞台（显示列表）
		 */
		private function addToStage ( eve:Event ) : void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, addToStage );
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage );
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, stageUp );
			
			this.addEventListener( Event.ENTER_FRAME, enterFrame );
		}
		
		/**
		 * 对象离开舞台（显示列表）
		 */
		private function removeFromStage ( eve:Event ) : void
		{
			this.addEventListener( Event.ADDED_TO_STAGE, addToStage );
			this.removeEventListener( Event.REMOVED_FROM_STAGE, removeFromStage );
			
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageDown );
			stage.removeEventListener( MouseEvent.MOUSE_UP, stageUp );
			isDown = false;
			
			this.removeEventListener( Event.ENTER_FRAME, enterFrame );
			setsArr.length = 0;
		}
		
		
		//************************ ************************* 对象加入或离开舞台的监听 ******************** *********** *** **////
		/**
		 * 鼠标按下
		 */
		private function stageDown ( eve:MouseEvent ) : void
		{
			cacheX = stage.mouseX;
			cacheY = stage.mouseY;
			
			isDown = true;
			
			this.addEventListener( Event.ENTER_FRAME, enterFrame );
		}
		
		/**
		 * 鼠标弹起
		 */
		private function stageUp ( eve:MouseEvent ) : void
		{
			isDown = false;
		}
		
		/**
		 * 刷新帧频
		 */
		private function enterFrame ( eve:Event ) : void
		{
			if ( isDown == true )
			{
				if ( cacheX != stage.mouseX || cacheY != stage.mouseY )
				{
					setsArr[ setsArr.length ] = new CutFruitLine( cacheX, cacheY, stage.mouseX, stage.mouseY, lineSize );
					cacheX = stage.mouseX;
					cacheY = stage.mouseY;
				}
			}
			graphics.clear();
			var index : int = 0;
			var i:int, len:int = setsArr.length;
			var line : CutFruitLine;
			
			for ( i = 0; i < len; i++ )
			{
				line = setsArr[ index ];
				if ( line.lineSize <= 0 )
				{
					setsArr.splice( index, 1 );
				}
				else
				{
					graphics.lineStyle( line.lineSize, lineColor );
					graphics.moveTo( line.sX, line.sY );
					graphics.lineTo( line.eX, line.eY );
					
					line.lineSize -= 1;
					index++;
				}
			}
			if ( isDown == false && setsArr.length == 0 )
			{
				this.removeEventListener( Event.ENTER_FRAME, enterFrame );
			}
		}
		
		
	}
}

// 线条类
class CutFruitLine
{
	public var sX:int;
	public var sY:int;
	public var eX:int;
	public var eY:int;
	public var lineSize:Number;
	
	public function CutFruitLine ( $sX:int, $sY:int, $eX:int, $eY:int, $lineSize:Number )
	{
		sX = $sX;
		sY = $sY;
		eX = $eX;
		eY = $eY;
		lineSize = $lineSize;
	}
}