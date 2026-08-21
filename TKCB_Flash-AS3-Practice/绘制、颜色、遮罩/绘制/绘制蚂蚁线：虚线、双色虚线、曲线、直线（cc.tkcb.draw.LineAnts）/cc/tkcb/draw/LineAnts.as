/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2017 TKCB, tkcb@qq.com
 *
 *
 * This is free software/program/code :  you can redistribute it and/or modify
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
 * 修 改 者：TKCB
 * 改者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 改者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
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
 * v1.0.0 2014-8-21 原作者jempty创建蚂蚁线类
 * v2.0.0 2017-7-28 TKCB重构蚂蚁线类，修改优化部分代码，重命名属性、方法、类名，删除部分属性、方法等等
 */

package cc.tkcb.draw
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GraphicsPath;
	import flash.display.SpreadMethod;
	
	import flash.display.LineScaleMode;
	import flash.display.GradientType;
	import flash.display.CapsStyle;
	
	import flash.events.TimerEvent;
	
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	import flash.utils.Timer;
	
	
	/**
	 * lineShape 蚂蚁线（流动的虚线），可用于生成任意蚂蚁线段，以及追加蚂蚁线
	 * @author jempty（修改者：TKCB（www.tkcb.cc））
	 * @创建时间 2014-8-21
	 * @修改时间 2017-7-28
	 * @version 2.0.0
	 */
	public class LineAnts extends Sprite
	{
		//************************ ************************* 属性 ******************** *********** *** **////
		//// 可外部设置更改的参数
		/** 虚线长度影响值，越大虚线越长，越小虚线越短，但设置的长度未必和绘制出来的虚线长度一致（实际对应的是宽度和高度） */
		private var _wh : Number;
		
		/** 线条宽度值 */
		private var _thickness : Number;
		
		/** 虚线颜色1，默认白色，虚线其实由两条线段组成，只是“虚线2”通常是透明的而已 */
		public var color1 : uint;
		
		/** 虚线颜色2，默认黑色，虚线其实由两条线段组成，只是“虚线2”通常是透明的而已 */
		public var color2 : uint;
		
		/** 虚线颜色透明度1，默认不透明，虚线其实由两条线段组成，只是“虚线2”通常是透明的而已 */
		public var colorAlpha1 : Number;
		
		/** 虚线颜色透明度2，默认透明，虚线其实由两条线段组成，只是“虚线2”通常是透明的而已 */
		public var colorAlpha2 : Number;
		
		/** 是否允许动画（也就是蚂蚁线流动），如果不允许则可生成虚线（或双色虚线） */
		private var _isAn : Boolean;
		
		/** 蚂蚁线动画间隔时间，单位毫秒（由1000毫秒除以传入的帧频计算出来） */
		private var _intervalTime;
		
		/** 蚂蚁线流动速度，默认为1 */
		public var speed : Number;
		
		/** 线条的缩放模式，默认为随对象缩放，由 LineScaleMode 类定义四种缩放模式 */
		public var lineScaleMode : String;
		
		/** 线条的端点样式，默认为圆头，由 CapsStyle 类定义三种样式 */
		public var capsStyle : String;
		
		
		//// 内部用到的变量
		/** 主要的绘图对象 */
		private var lineShape : Shape;
		
		/** 绘图命令对象 */
		private var antsPath : GraphicsPath;
		
		/** 开始点，默认第一次会自动设置开始点，后续需要连续使用同一对象绘制不同位置才需要设置开始点，开始点由setStartPoint()方法设置 */
		private var startPoint : Point;
		
		/** 上一个绘制点 */
		private var prevPoint : Point;
		
		/** 是否是第一个绘制点 */
		private var isFristPoint : Boolean;
		
		/** 用于蚂蚁线流动动画，不断更新线条 */
		private var timer : Timer;
		
		/** 绘图命令数组 */
		private var pathList : Vector.<GraphicsPath>;
		
		/** 转换矩阵数组，用于绘制蚂蚁线 */
		private var matrixList : Vector.<Matrix>;
		
		/** 速度位置数组，用于绘制蚂蚁线流动 */
		private var speedList : Vector.<Array>;
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 创建蚂蚁线对象，构造函数的参数是最主要的几个，还有很多参数可以通过属性和方法进行设置
		 * @param length 虚线长度影响值，越大虚线越长，越小虚线越短，但设置的长度未必和绘制出来的虚线长度一致
		 * @param thickness 线条宽度值，单位像素，默认为3
		 * @param color 线条颜色值（color1值），默认为0xFFFF00
		 * @param isAn 是否允许动画（也就是蚂蚁线流动），如果不允许则可生成虚线（或双色虚线）
		 * @param frameRate 蚂蚁线帧频（也就是动画间隔），单位帧频，默认应传入和舞台帧频一直的帧频（1000毫秒除以帧频数就是刷新间隔的时间）
		 */
		public function LineAnts ( length:Number = 30, thickness:Number = 3, color:uint = 0xFFFF00, isAn:Boolean = true, frameRate:uint = 30 )
		{
			// 对象初始化
			init();
			
			// 获取外部的参数
			_wh = length;
			_thickness = thickness;
			color1 = color;
			_isAn = isAn;
			_intervalTime = 1000 / frameRate;
			
			// 添加新的绘图命令
			addPath();
			
			// 是否允许蚂蚁线流动，如果不允许流动，则为虚线（或双色虚线）
			if ( _isAn )
			{
				timer = new Timer( _intervalTime );
				timer.addEventListener( TimerEvent.TIMER, timerEvent );
			}
		}
		
		
		//************************ ************************* 初始化 ******************** *********** *** **////
		/**
		 * 对象初始化
		 */
		private function init () : void
		{
			_thickness = 3;
			color1 = 0x000000;
			color2 = 0xFFFFFF;
			colorAlpha1 = 1;
			colorAlpha2 = 0;
			speed = 1;
			lineScaleMode = LineScaleMode.NORMAL;
			capsStyle = CapsStyle.ROUND;
			
			
			lineShape = new Shape();
			isFristPoint = true;
			pathList = new Vector.<GraphicsPath>();
			matrixList = new Vector.<Matrix>();
			speedList = new Vector.<Array>();
			addChild( lineShape );
		}
		
		/**
		 * 添加新的绘图命令
		 */
		private function addPath () : void
		{
			antsPath = new GraphicsPath();
			pathList.push(antsPath);
		}
		
		
		//************************ ************************* 添加蚂蚁线开始点和连接点 ******************** *********** *** **////
		/**
		 * 设置开始点，之所以有这个方法，是为了同一个蚂蚁线多次连续绘制可以有不同的开始点（第一次绘制一般不需要刻意调用此方法）
		 */
		public function setStartPoint ( point:Point ) : void
		{
			startPoint = point;
			antsPath.moveTo( point.x, point.y );
			prevPoint = point;
		}
		
		/**
		 * 添加直线连接点
		 * @param px 连接点的X轴坐标值
		 * @param py 连接点的Y轴坐标值
		 */
		public function addPoint ( px:Number, py:Number ) : void
		{
			setParams( px, py );
		}
		
		/**
		 * 添加曲线连接点，如果控制点弧度过大会导致蚂蚁线扭曲变形，一般情况建议使用addPoint()方法
		 * @param px 连接点的X轴坐标值
		 * @param py 连接点的Y轴坐标值
		 * @param controlX 曲线控制点的X轴坐标值（应使用算法提前计算好曲线控制点坐标值）
		 * @param controlY 曲线控制点的Y轴坐标值（应使用算法提前计算好曲线控制点坐标值）
		 */
		public function addCurvePoint ( px:Number, py:Number, controlX:Number, controlY:Number ) : void
		{
			setParams( px, py, controlX, controlY, true );
		}
		
		/**
		 * 设置蚂蚁线参数，因为直线和曲线共同使用同样的代码，所以需要单独分出一个方法来设置参数
		 * @param px 连接点的X轴坐标值
		 * @param py 连接点的Y轴坐标值
		 * @param controlX 曲线控制点的X轴坐标值
		 * @param controlY 曲线控制点的Y轴坐标值
		 * @param isCurve 是否曲线绘制，默认为false
		 */
		private function setParams ( px:Number, py:Number, controlX:Number = 0, controlY:Number = 0, isCurve:Boolean = false ) : void
		{
			// 第一个绘制点
			if ( prevPoint == null )
			{
				setStartPoint( new Point( px, py ) );
			}
			// 之后的绘制点
			else
			{
				var dx : Number = px - prevPoint.x;
				var dy : Number = py - prevPoint.y;
				var angle : Number = Math.atan2( dy, dx );
				//angle *= 180 / Math.PI;	// 随机曲线测试
				var matix : Matrix = new Matrix(); 
				matix.createGradientBox( _wh, _wh, angle, 0, 0 );
				
				// 方向判断
				var tx:Number, ty:Number; 
				
				if ( dx == 0 )
				{
					tx = 0;
				}
				else
				{
					tx = dx / Math.abs(dx) * speed;
				}
				
				if ( dy == 0 )
				{
					ty = 0;
				}
				else
				{
					ty = dy / Math.abs(dy) * speed;
				}
				
				if ( isFristPoint )
				{
					isFristPoint = false;
				}
				else
				{
					addPath();
					var path : GraphicsPath = pathList[pathList.length - 2];
					var len : int = path.data.length;
					var point = new Point(path.data[len - 2], path.data[len - 1]);
					setStartPoint( point );
				}
				
				if ( isCurve )
				{
					antsPath.curveTo( controlX, controlY, px, py );
				}
				else
				{
					antsPath.lineTo( px, py );
				}
				
				matrixList.push( matix );
				speedList.push( [tx, ty] );
				
				prevPoint.x = px;
				prevPoint.y = py;
				
				// 绘制蚂蚁线（或虚线、双色虚线）
				drawAntsLine();
				
				// 如果允许蚂蚁线流动，则启动蚂蚁线流动计时器
				if ( _isAn )
				{
					// 开始蚂蚁线流动
					startTimer();
				}
				
			}
		}
		
		/**
		 * 绘制蚂蚁线（或虚线、双色虚线）
		 */
		public function drawAntsLine () : void
		{
			lineShape.graphics.clear();
			lineShape.graphics.lineStyle( _thickness, 0x000000, 1, false, lineScaleMode, capsStyle );
			var i : int;
			var len : int = pathList.length; 
			var tx : Number;
			var ty : Number;
			for (i = 0; i < len; i++)
			{
				lineShape.graphics.lineGradientStyle( GradientType.LINEAR, [color1, color2], [colorAlpha1, colorAlpha2], [0xFF/2, 0xFF/2], matrixList[i], SpreadMethod.REPEAT );
				lineShape.graphics.drawPath(pathList[i].commands, pathList[i].data);
				if ( _isAn && timer )
				{
					matrixList[i].tx +=  speedList[i][0];
					matrixList[i].ty +=  speedList[i][1]; 
					tx = matrixList[i].tx;
					ty = matrixList[i].ty;
					if (Math.abs(tx) > 5000)
					{
						matrixList[i].tx = 0;
					}
					if (Math.abs(ty) > 5000)
					{
						matrixList[i].ty = 0;
					}
				}
					
			}
		}
			
		//************************ ************************* 开始和停止蚂蚁线流动（动画） ******************** *********** *** **////
		/**
		 * 开始蚂蚁线流动
		 */
		public function startTimer () : void
		{
			_isAn = true;
			if ( timer == null )
			{
				timer = new Timer( _intervalTime );
				timer.addEventListener( TimerEvent.TIMER, timerEvent );
			}
			if ( timer && timer.running == false )
			{
				timer.start();
			}
		}
		
		/**
		 * 停止蚂蚁线流动
		 */
		public function stopTimer () : void
		{
			_isAn = false;
			if ( timer && timer.running )
			{
				timer.stop();
			}
		}
		
		/**
		 * 计时器间隔性到期，蚂蚁线流动
		 */
		private function timerEvent ( eve:TimerEvent ) : void
		{
			// 绘制蚂蚁线（或虚线、双色虚线）
			drawAntsLine();
		}
		
		
		//************************ ************************* 清除对象 ******************** *********** *** **////
		/**
		 * 清除对象内部引用、侦听等（销毁对象前调用此方法）。
		 */
		public function dispose () : void
		{
			this.graphics.clear();
			
			lineShape.graphics.clear();
			
			pathList.length = 0;
			matrixList.length = 0;
			speedList.length = 0;
			prevPoint = null;
			
			if ( timer )
			{
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER, timerEvent );
			}
			
			pathList = null;
			matrixList = null;
			speedList = null;
			
			removeChild( lineShape );
		}
		
		
	}
}