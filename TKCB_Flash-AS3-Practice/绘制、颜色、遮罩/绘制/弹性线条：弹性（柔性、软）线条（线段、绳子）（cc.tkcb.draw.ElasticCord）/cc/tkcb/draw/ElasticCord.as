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
 * v1.0.0 2018-10-23
 */
package cc.tkcb.draw
{
	import flash.display.Sprite;
	
	import flash.events.*;
	
	import flash.geom.Point;
	
	import cc.tkcb.interfaces.IDispose;
	
	
	/**
	 * ElasticCord 弹性线条类，用于生成带有弹性的线条
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-10-23
	 * @修改时间 2018-10-23
	 * @version 1.0.0
	 */
	public class ElasticCord extends Sprite implements IDispose
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		/** 开始坐标点对象，之所以不是Point是因为需要动态添加一些变量值 */
		private var _startPointObj : Object = new Object();
		
		/** 结束坐标点对象，之所以不是Point是因为需要动态添加一些变量值 */
		private var _endPointObj : Object = new Object();
		
		
		private var _thickness : Number;
		private var _color : Number;
		private var _alpha : Number;
		
		private var _segments : uint;
		private var _gravity : Number;
		private var _elasticity : Number;
		private var _friction : Number;
		
		private var _g : Number;
		
		
		//************************ ************************* get和set ******************** *********** *** **////
		public function set startPoint ( value:Point ) : void
		{
			_startPointObj.x = value.x;
			_startPointObj.y = value.y;
			this.addEventListener( Event.ENTER_FRAME, drawCord );
		}
		public function get startPoint () : Point
		{
			return new Point( _startPointObj.x, _startPointObj.y );
		}
		public function set endPoint ( value:Point ) : void
		{
			_endPointObj.x = value.x;
			_endPointObj.y = value.y;
			this.addEventListener( Event.ENTER_FRAME, drawCord );
		}
		public function get endPoint () : Point
		{
			return new Point( _endPointObj.x, _endPointObj.y );
		}
		public function set segments ( value:uint ) : void
		{
			_segments = value
		}
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数
		 * @param startPoint 开始坐标点，Point对象
		 * @param endPoint 结束坐标点，Point对象
		 * @param thickness 线条粗细，默认为2（像素）
		 * @param color 线条颜色，默认为0x000000（黑色）
		 * @param alpha 线条透明度，默认为1（0为不透明）
		 * @param segments 贝塞尔曲线次数，默认为8。最小1次，最大次数不限制，越多则需要更多计算，但多一些则会让线条更柔软
		 * @param gravity 重力，默认为10.没有重力则会是静止状态是直线，晃动时候有弹力，如果有重力则会像是“割绳子游戏”那样的效果
		 * @param elasticity 弹性，默认为0.5。弹性和摩擦参数是相对应调整的，需要根据实际情况进行设置值，但是都不建议超过1
		 * @param friction 摩擦，默认为0.75。弹性和摩擦参数是相对应调整的，需要根据实际情况进行设置值，但是都不建议超过1
		 */
		public function ElasticCord ( startPoint:Point, endPoint:Point, thickness:Number = 2, color:Number = 0x000000, alpha:Number = 1, 
									  segments:uint = 8, gravity:Number = 9.8, elasticity:Number = 0.2, friction:Number = 0.75 )
		{
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			
			_thickness = thickness;
			_color = color;
			_alpha = alpha;
			
			_segments = segments > 1 ? segments : 1;
			_gravity = gravity;
			_elasticity = elasticity;
			_friction = friction;
			
			_g = _gravity / (_segments * 2);
			
			this.addEventListener( Event.ENTER_FRAME, drawCord );
			
			// 初始化弹性线条
			initCord();
		}
		
		/**
		 * 清除对象内部引用、侦听等（销毁对象前调用此方法）。
		 */
		public function dispose() : void
		{
			this.removeEventListener( Event.ENTER_FRAME, drawCord );
		}
		
		/**
		 * 初始化弹性线条
		 */
		private function initCord () : void
		{
			var tempSegments : int = _segments;
			var dis : Number = Point.distance( startPoint, endPoint );
			var step : Number = dis / tempSegments;
			var tempPointObj : Object = _startPointObj;

			while ( tempSegments >= 0 )
			{
				var f : Number = step * tempSegments / dis;
				var pointObj = addPoint( tempPointObj, Point.interpolate(startPoint, endPoint, f) );
				tempPointObj.nextPoint = pointObj;
				tempPointObj = pointObj;
				tempSegments--;
			}
			tempPointObj.nextPoint = _endPointObj;
		}
		
		private function addPoint( prevPoint:Object, ownPoint:Point ) : Object
		{
			var pointObj : Object = new Object();
			pointObj.prevPoint = prevPoint;
			pointObj.x = ownPoint.x;
			pointObj.y = ownPoint.y;
			pointObj.vx = 0;
			pointObj.vy = 0;
			return pointObj;
		}
		
		private function drawCord ( e:Event ) : void
		{
			this.graphics.clear();
			this.graphics.lineStyle( _thickness, _color, _alpha );
			this.graphics.moveTo( _startPointObj.x, _startPointObj.y );
			
			for ( var tempPointObj = _startPointObj.nextPoint; tempPointObj.nextPoint; tempPointObj = tempPointObj.nextPoint )
			{
				var tempx : Number = (tempPointObj.prevPoint.x + tempPointObj.nextPoint.x) / 2;
				var tempy : Number = (tempPointObj.prevPoint.y + tempPointObj.nextPoint.y) / 2;
				tempPointObj.vx += (tempx - tempPointObj.x) * _elasticity;
				tempPointObj.vy += (tempy - tempPointObj.y) * _elasticity + _g;
				tempPointObj.vx *= _friction;
				tempPointObj.vy *= _friction;
				tempPointObj.x += tempPointObj.vx;
				tempPointObj.y += tempPointObj.vy;

				// 如果线条静止了，则停止监听，以此优化效率
				var vxBoo : Boolean = ( tempPointObj.vx >= 0 && tempPointObj.vx < 0.001 ) || ( tempPointObj.vx < 0 && tempPointObj.vx > -0.001 );
				var vyBoo : Boolean = ( tempPointObj.vy >= 0 && tempPointObj.vy < 0.001 ) || ( tempPointObj.vy < 0 && tempPointObj.vy > -0.001 );
				if ( vxBoo && vyBoo )
				{
					this.removeEventListener( Event.ENTER_FRAME, drawCord );
				}
			}

			for (tempPointObj = _startPointObj.nextPoint; tempPointObj.nextPoint; tempPointObj = tempPointObj.nextPoint)
			{
				this.graphics.curveTo( tempPointObj.x, tempPointObj.y, (tempPointObj.nextPoint.x + tempPointObj.x) / 2, (tempPointObj.nextPoint.y + tempPointObj.y) / 2);
			}
			this.graphics.lineTo( tempPointObj.x, tempPointObj.y );
		}
		
		
		
	}
}