/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2017 TKCB, tkcb@qq.com
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
 * v1.0.0 2017-6-30
 */

package cc.tkcb.filter
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import cc.tkcb.interfaces.IDispose;
	
	
	/**
	 * TeraFire 火焰特效对象，用于纯代码生成火焰特效，仅支持竖向火焰生成（无法旋转）。
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-2-15
	 * @version 1.0.0
	 */
	public class TeraFire extends Sprite implements IDispose
	{
		/** 火焰横向速度，默认为0 */
		public var phaseRateX: Number;

		/** 火焰纵向速度，默认为5 */
		public var phaseRateY: Number;

		private var offsets: Array = [new Point(), new Point()];
		private var seed: Number = Math.random();
		private var fireW: Number;
		private var fireH: Number;
		
		// 火焰颜色，由于是生成的颜色，所以这里的颜色值不是实际看到的颜色值
		private var fireColerIn: uint = 0xFFCC00;
		private var fireColerOut: uint = 0xE22D09;

		private var ball: Sprite;
		private var gradientImage: BitmapData;
		private var displaceImage: BitmapData;
		//火の玉の中心の上下位置偏差（-1で上端、1で下端）
		private var focalPointRatio: Number = 0.6;
		//炎の揺らぎのせいで描画エリアをはみ出してしまうのを防ぐための余白幅
		private const margin: int = 10;
		private var rdm: Number;

		//コンストラクタ
		public function TeraFire ( xPos: Number = 0, yPos: Number = 0, fireWidth: Number = 30, fireHeight: Number = 90 )
		{
			fireW = fireWidth;
			fireH = fireHeight;
			phaseRateX = 0;
			phaseRateY = 5;
			var matrix: Matrix = new Matrix();
			matrix.createGradientBox(fireW, fireH, Math.PI / 2, -fireW / 2, -fireH * (focalPointRatio + 1) / 2);
			var colors: Array = [fireColerIn, fireColerOut, fireColerOut];
			var alphas: Array = [1, 1, 0];
			var ratios: Array = [30, 100, 220];

			var home: Sprite = new Sprite();
			ball = new Sprite();
			//炎本体
			ball.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix, "pad", "rgb", focalPointRatio);
			ball.graphics.drawEllipse(-fireW / 2, -fireH * (focalPointRatio + 1) / 2, fireW, fireH);
			ball.graphics.endFill();
			//余白確保用透明矩形
			ball.graphics.beginFill(0x000000, 0);
			ball.graphics.drawRect(-fireW / 2, 0, fireW + margin, 1);
			ball.graphics.endFill();
			addChild(home);
			home.addChild(ball);
			this.x = xPos;
			this.y = yPos;
			addEventListener(Event.ENTER_FRAME, loop);

			//ゆらぎ用のBitmap（ステージに貼付ける必要はないのでBitmapに貼る必要はない）
			displaceImage = new BitmapData(fireW + margin, fireH, false, 0xFFFFFFFF);
			//火の芯付近の揺らぎを抑える用のグラデーション
			var matrix2: Matrix = new Matrix();
			matrix2.createGradientBox(fireW + margin, fireH, Math.PI / 2, 0, 0);
			var gradient_mc: Sprite = new Sprite;
			gradient_mc.graphics.beginGradientFill(GradientType.LINEAR, [0x666666, 0x666666], [0, 1], [120, 220], matrix2);
			gradient_mc.graphics.drawRect(0, 0, fireW + margin, fireH); //drawのターゲットなので生成位置にこだわる必要はない。
			gradient_mc.graphics.endFill();
			gradientImage = new BitmapData(fireW + margin, fireH, true, 0x00FFFFFF);
			gradientImage.draw(gradient_mc); //gradient_mcを消す必要は？
			//同サイズの炎の揺らぎをランダム化
			rdm = Math.floor(Math.random() * 10);

			//確認検証用コード
			/*this.startDrag(true);//検証用マウス吸着
			import flash.display.Bitmap; 
			var bmp:Bitmap = new flash.display.Bitmap(displaceImage);
			bmp.x = -fireW/2;
			bmp.y = -fireH*(focalPointRatio+1)/2;
			home.addChild(bmp);
			bmp.alpha = 0.5;//揺らぎマップのコピーを半透明表示（擬似コピーなので揺らぎマップ本体ではない！）
			home.addChild(gradient_mc);//根元の揺らぎ抑えるグラデーションを表示。場所は適当
			*/
		}
		
		/**
		 * 对象每帧生成渲染
		 */
		private function loop ( e:Event ) : void
		{
			//もやもや画像を上スクロール移動させる
			for (var i: int = 0; i < 2; ++i)
			{
				offsets[i].x += phaseRateX;
				offsets[i].y += phaseRateY;
			}
			//もやもやした白黒画像を生成
			displaceImage.perlinNoise(30 + rdm, 60 + rdm, 2, seed, false, false, 7, true, offsets);
			//芯付近の揺らぎを抑える
			displaceImage.copyPixels(gradientImage, gradientImage.rect, new Point(), null, null, true);
			var dMap: DisplacementMapFilter = new DisplacementMapFilter(displaceImage, new Point(), 1, 1, 20, 10, DisplacementMapFilterMode.CLAMP);
			ball.filters = [dMap];
		}
		
		/**
		 * 清除对象内部引用、侦听等（销毁对象前调用此方法）。
		 */
		public function dispose () : void
		{
			removeEventListener( Event.ENTER_FRAME, loop );
			if ( gradientImage != null )
			{
				gradientImage.dispose();
			}
			if ( displaceImage != null )
			{
				displaceImage.dispose();
			}
		}
		
	}
}
/*
課題点：
・DisplacementMapFilterの元マップが原寸な必要ないかも。半分のサイズを拡大して使って負荷下げれたらいいかも。
・やや右寄りに揺らぐ分だけ余計にサイズ確保してる部分（margin）の処理が不細工。
*/