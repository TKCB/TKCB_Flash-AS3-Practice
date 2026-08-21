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
 * 修    改：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 修者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
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
 * v1.0.0 2015-12-4
 * v1.1.0 2018-10-27 统一清理对象接口IDispose
 */

package cc.tkcb.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import cc.tkcb.interfaces.IDispose;
	

	/** 
	 * Rippler 类是一个用于创建水波纹效果。
	 * @author David Lenaerts（修改TKCB（www.tkcb.cc））
	 * @创建时间 未知
	 * @修改时间 2018-10-27
	 * @version 1.1.0
	 */
	public class Rippler implements IDispose
	{
		// The DisplayObject which the ripples will affect.
		private var _source: DisplayObject;

		// Two buffers on which the ripple displacement image will be created, and swapped.
		// Depending on the scale parameter, this will be smaller than the source
		private var _buffer1: BitmapData;
		private var _buffer2: BitmapData;

		// The final bitmapdata containing the upscaled ripple image, to match the source DisplayObject
		private var _defData: BitmapData;

		// Rectangle and Point objects created once and reused for performance
		private var _fullRect: Rectangle; // A buffer-sized Rectangle used to apply filters to the buffer
		private var _drawRect: Rectangle; // A Rectangle used when drawing a ripple
		private var _origin: Point = new Point(); // A Point object to (0, 0) used for the DisplacementMapFilter as well as for filters on the buffer

		// The DisplacementMapFilter applied to the source DisplayObject
		private var _filter: DisplacementMapFilter;
		// A filter causing the ripples to grow
		private var _expandFilter: ConvolutionFilter;

		// Creates a colour offset to 0x7f7f7f so there is no image offset due to the DisplacementMapFilter
		private var _colourTransform: ColorTransform;

		// Used to scale up the buffer to the final source DisplayObject's scale
		private var _matrix: Matrix;

		// We only need 1/scale, so we keep it here
		private var _scaleInv: Number;

		/**
		 * 构造函数，创建一个Rippler实例。
		 * @param source 水波对象，通常是位图，也可以是任何显示对象。
		 * @param strength 水波的强度，通常是50左右。
		 * @param scale 波纹大小，默认是2。波纹越大，水波速度越快。
		 */
		public function Rippler(source: DisplayObject, strength: Number, scale: Number = 2)
		{
			var correctedScaleX: Number;
			var correctedScaleY: Number;

			_source = source;
			_scaleInv = 1 / scale;

			// create the (downscaled) buffers and final (upscaled) image data, sizes depend on scale
			_buffer1 = new BitmapData(source.width * _scaleInv, source.height * _scaleInv, false, 0x000000);
			_buffer2 = new BitmapData(_buffer1.width, _buffer1.height, false, 0x000000);
			_defData = new BitmapData(source.width, source.height);

			// Recalculate scale between the buffers and the final upscaled image to prevent roundoff errors.
			correctedScaleX = _defData.width / _buffer1.width;
			correctedScaleY = _defData.height / _buffer1.height;

			// Create reusable objects
			_fullRect = new Rectangle(0, 0, _buffer1.width, _buffer1.height);
			_drawRect = new Rectangle();

			// Create the DisplacementMapFilter and assign it to the source
			_filter = new DisplacementMapFilter(_buffer1, _origin, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, strength, strength, "wrap");
			_source.filters = [_filter];

			// Create a frame-based loop to update the ripples
			_source.addEventListener(Event.ENTER_FRAME, handleEnterFrame);

			// Create the filter that causes the ripples to grow.
			// Depending on the colour of its neighbours, the pixel will be turned white
			_expandFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);

			// Create the colour transformation based on 
			_colourTransform = new ColorTransform(1, 1, 1, 1, 127, 127, 127);

			// Create the Matrix object
			_matrix = new Matrix(correctedScaleX, 0, 0, correctedScaleY);
		}

		/**
		 * 绘制波纹，设置绘制的一些参数。
		 * @param x 纹波原点的x坐标。
		 * @param y 纹波原点的y坐标。
		 * @param size 在第一次冲击的纹波直径的大小，通常为20以内。
		 * @param alpha 在第一次冲击的纹波alpha值，通常为0.85。
		 */
		public function drawRipple(x: int, y: int, size: int, alpha: Number): void
		{
			var half: int = size >> 1; // We need half the size of the ripple
			var intensity: int = (alpha * 0xff & 0xff) * alpha; // The colour which will be drawn in the currently active buffer

			// calculate and draw the rectangle, having (x, y) in its centre
			_drawRect.x = (-half + x) * _scaleInv;
			_drawRect.y = (-half + y) * _scaleInv;
			_drawRect.width = _drawRect.height = size * _scaleInv;
			_buffer1.fillRect(_drawRect, intensity);
		}

		/**
		 * 获取实际的波纹图像。
		 */
		public function getRippleImage(): BitmapData
		{
			return _defData;
		}
		
		/**
		 * 清除对象内部引用、侦听等（销毁对象前调用此方法）。
		 */
		public function dispose () : void
		{
			_source.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			_buffer1.dispose();
			_buffer2.dispose();
			_defData.dispose();
		}

		/** 实现水波动画效果 */
		private function handleEnterFrame(event: Event): void
		{
			// a temporary clone of buffer 2
			var temp: BitmapData = _buffer2.clone();
			// buffer2 will contain an expanded version of buffer1
			_buffer2.applyFilter(_buffer1, _fullRect, _origin, _expandFilter);
			// by substracting buffer2's old image, buffer2 will now be a ring
			_buffer2.draw(temp, null, null, BlendMode.SUBTRACT, null, false);
			// scale up and draw to the final displacement map, and apply it to the filter
			_defData.draw(_buffer2, _matrix, _colourTransform, null, null, true);
			_filter.mapBitmap = _defData;
			_source.filters = [_filter];
			temp.dispose();
			// switch buffers 1 and 2
			switchBuffers();
		}

		/** 切换缓冲器1和2 */
		private function switchBuffers(): void
		{
			var temp: BitmapData;
			temp = _buffer1;
			_buffer1 = _buffer2;
			_buffer2 = temp;
		}
	}
}