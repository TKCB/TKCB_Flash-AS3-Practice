/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2018 TKCB, tkcb@qq.com
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
 * v1.0.0 2018-7-9
 */
 
package cc.tkcb.filter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import cc.tkcb.filter.melt.*;
	
	/**
	 * Reflection 倒影生成 静态类，用于生成倒影
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-7-9
	 * @修改时间 2018-7-9
	 * @version 1.0.0
	 */
	public class Melt extends Sprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		/**
		 * this is margin around fluid target, if width or height are 0 at Constructor.
		 * change before doing addChild(new Melt(target)).
		 */
		static public var FLUID_DEFAULT_MARGIN:Number = 100;
		
		
		
		
		
		/**
		 * zeros
		 */
		private const ZERO_POINT:Point = new Point(0,0);
		
		
		
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		/**
		 * whether it gradually returns it to shape in the origin or not
		 */
		public function get fluidUseDecay():Boolean { return _fluidUseDecay; }
		public function set fluidUseDecay(value:Boolean):void { _fluidUseDecay = value; }
		private var _fluidUseDecay:Boolean = true;
		
		/**
		 * whether it accept mouse motion as external force.
		 * if it is false, you can add external force to fluid by fluid.addOrientedForce(x, y, forceX, forceY, fluidFlowSize).
		 */
		public function get fluidUseMouse():Boolean { return _fluidUseMouse; }
		public function set fluidUseMouse(value:Boolean):void { _fluidUseMouse = value; }
		private var _fluidUseMouse:Boolean = true;
		
		/**
		 * ColorMatrixFilter for erasing overflowing fluid gradually
		 */
		public function get fluidCanvasTone():ColorMatrixFilter { return _fluidCanvasTone; }
		public function set fluidCanvasTone(value:ColorMatrixFilter):void { _fluidCanvasTone = value; }
		private var _fluidCanvasTone:ColorMatrixFilter;
		
		/**
		 * magnitude of mouse influence
		 */
		public function get fluidFlowSize():Number { return _fluidFlowSize; }
		public function set fluidFlowSize(value:Number):void { _fluidFlowSize = value; }
		private var _fluidFlowSize:Number = 2;
		
		/**
		 * magnitude of flow
		 */
		public function get fluidMagnitude():Number { return _fluid.magnitude; }
		public function set fluidMagnitude(value:Number):void { _fluid.magnitude = value; }
		
		
		
		
		
		/**
		 * display BitmapData
		 */
		public function get canvas():BitmapData { return _canvas; }
		private var _canvas:BitmapData;
		
		/**
		 * fluid target
		 */
		public function get source():BitmapData { return _source; }
		private var _source:BitmapData;
		
		/**
		 * fluid core class
		 */
		public function get fluid():Fluid { return _fluid; }
		private var _fluid:Fluid;
		
		/**
		 * fluid width
		 */
		public function get fluidWidth():uint { return _fluid.width; }
		
		/**
		 * fluid height
		 */
		public function get fluidHeight():uint { return _fluid.height; }
		
		
		
		
		
		/**
		 * bitmap for add to stage
		 */
		private var _container:Bitmap;
		
		/**
		 * matrix for centering fluid target on container
		 */
		private var _centering:Matrix;
		
		/**
		 * fluid DisplacementMapFilter
		 */
		private var _mapFilter:DisplacementMapFilter;
		
		/**
		 * old mouse x
		 */
		private var _oldX:Number = 0;
		
		/**
		 * old mouse y
		 */
		private var _oldY:Number = 0;
		
		/**
		 * whether mouse is moving or not
		 */
		private var _isMouseMove:Boolean = false;
		
		
		
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	source
		 * @param	transparent
		 * @param	gridSize
		 * @param	fluidWidth
		 * @param	fluidHeight
		 * @param	edgeMode     "free" or "wrap"
		 */
		public function Melt(
			source:BitmapData,
			transparent:Boolean = false,
			gridSize:uint       = 20,
			fluidWidth:uint     = 0,
			fluidHeight:uint    = 0,
			edgeMode:String     = "free"
		):void
		{
			_source = source;
			
			fluidWidth  = (fluidWidth  != 0) ? fluidWidth  : (_source.width  + FLUID_DEFAULT_MARGIN * 2);
			fluidHeight = (fluidHeight != 0) ? fluidHeight : (_source.height + FLUID_DEFAULT_MARGIN * 2);
			
			//create fluid system
			_fluid = new Fluid(
				fluidWidth, 
				fluidHeight, 
				gridSize,
				150,
				edgeMode
			);
			
			//get DisplacementMapFilter applied to canvas
			_mapFilter = _fluid.mapFilter;
			
			//ColorMatrixFilter for erasing overflowing fluid gradually
			_fluidCanvasTone = (transparent) ?
				new ColorMatrixFilter([
					1, 0, 0, 0  , 5,
					0, 1, 0, 0  , 5,
					0, 0, 1, 0  , 5,
					0, 0, 0, .98, -1
				])
				:
				new ColorMatrixFilter([
					1, 0, 0, 0, 5,
					0, 1, 0, 0, 5,
					0, 0, 1, 0, 5,
					0, 0, 0, 0, 0
				]);
			
			//centering target in fluid field
			_centering = new Matrix();
			_centering.tx = uint((fluidWidth  - _source.width ) / 2);
			_centering.ty = uint((fluidHeight - _source.height) / 2);
			
			//bitmap for add to stage
			_container = new Bitmap();
			_container.x = -_centering.tx;
			_container.y = -_centering.ty;
			addChild(_container);
			
			/*
			var rect:Sprite = new Sprite();
			rect.graphics.lineStyle(1, 0x000000, 1);
			rect.graphics.drawRect(_clipRect.x, _clipRect.y, _clipRect.width, _clipRect.height);
			rect.x = -_centering.tx;
			rect.y = -_centering.ty;
			addChild(rect);
			*/
			
			//fluid bitmap data
			_canvas = new BitmapData(fluidWidth, fluidHeight, transparent, 0xffffff);
			_container.bitmapData = _canvas;
			
			//default flow size
			_fluidFlowSize = 2;
			
			//add event handler
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * kill events
		 */
		private function kill():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * update canvas
		 * @param	e
		 */
		private function _update(e:Event):void
		{
			var source:BitmapData = _source;
			var canvas:BitmapData = _canvas;
			
			//apply mouse velocity to force
			if (_fluidUseMouse && _isMouseMove)
			{
				var speedX:Number = _container.mouseX - _oldX;
				var speedY:Number = _container.mouseY - _oldY;
				
				_fluid.addOrientedForce(_container.mouseX, _container.mouseY, speedX, speedY, _fluidFlowSize);
				
				_isMouseMove = false;
			}
			
			//update flow
			_fluid.updateFlow(_fluidUseDecay);
			
			//update displacement map
			_fluid.updateMap();
			
			//draw
			_canvas.lock();
			_canvas.applyFilter(canvas, canvas.rect, ZERO_POINT, _fluidCanvasTone);
			_canvas.draw(source, _centering);
			_canvas.applyFilter(canvas, canvas.rect, ZERO_POINT, _mapFilter);
			_canvas.unlock();
			
			//save mouse position
			_oldX = _container.mouseX;
			_oldY = _container.mouseY;
		}
		
		/**
		 * event handler called when mouse move
		 * @param	e
		 */
		private function _mouseMoveHandler(e:MouseEvent):void
		{
			_isMouseMove = true;
		}
	}
}