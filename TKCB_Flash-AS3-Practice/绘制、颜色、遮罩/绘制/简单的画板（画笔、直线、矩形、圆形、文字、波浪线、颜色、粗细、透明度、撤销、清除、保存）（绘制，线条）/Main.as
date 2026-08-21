// ************************ ************************* 作者 ******************** *********** *** ** ** //
// 作者：TKCB-Gm（TKCB乐队队长）
// QQ群：96759336（技术交流）
// Flash 闪侠：www.theflash.cc
// 11RIA 闪客社区：www.11ria.com


package
{
	// ************************ ************************* 类库 ******************** *********** *** ** ** //
	import flash.display.Sprite;
	import flash.display.BitmapData;

	import flash.events.MouseEvent;

	import flash.net.FileReference;

	import flash.utils.ByteArray;

	import com.tkcb.graphics.*;

	import adobe.JPGEncoder;

	/**
	 * ...
	 */
	public class Main extends Sprite
	{
		// ************************ ************************* 属性 ******************** *********** *** ** ** //
		/** 颜色 */
		public var lineColor: uint;

		/** 大小 */
		public var lineSize: int;

		/** 透明度 */
		public var lineAlpha: Number;

		/** 当前绘制工具 */
		private var currentTool: Graphic;

		/** 所有绘制图形的数组 */
		public var allShapeArr: Array;

		// 波浪线
		//private var iiii:int = 0;





		// ************************ ************************* 构造函数 ******************** *********** *** ** ** //
		/**
		 * 构造函数
		 */
		public function Main()
		{
			init();


			//// 绘制工具（画笔、直线、矩形、圆形）
			this.brush_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.straightLine_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.rectangle_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.circle_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.text_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.wave_btn.addEventListener(MouseEvent.CLICK, buttonMouse);

			//// 属性（颜色、粗细、透明度）
			this.color_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.size_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.alpha_btn.addEventListener(MouseEvent.CLICK, buttonMouse);


			//// 辅助（撤销、清除、保存）
			this.undo_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.clear_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
			this.save_btn.addEventListener(MouseEvent.CLICK, buttonMouse);
		}


		// ************************ ************************* 方　　法 ******************** *********** *** ** ** //
		/** 初始化 */
		private function init(): void
		{
			this.shapeArea.mask = this.shapeArea.shapeMask;

			lineColor = 0xFF0000;
			lineSize = 1;
			lineAlpha = 1;

			allShapeArr = [];

			currentTool = new Brush();
			currentTool.lineColor = lineColor;
			currentTool.lineSize = lineSize;
			currentTool.lineAlpha = lineAlpha;
			currentTool.allShapeArr = allShapeArr;
			currentTool.shapeSprite = shapeArea;
			addChild(currentTool);
		}

		/** 按钮被按下 */
		private function buttonMouse(eve: MouseEvent): void
		{
			switch (eve.currentTarget)
			{
				//// 绘制工具（画笔、直线、矩形、圆形）
				// 画笔
				case this.brush_btn:
					currentTool.stopDraw();
					currentTool = new Brush();
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					// 直线
				case this.straightLine_btn:
					currentTool.stopDraw();
					currentTool = new StraightLine();
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					// 矩形
				case this.rectangle_btn:
					currentTool.stopDraw();
					currentTool = new Rectangle();
					(currentTool as GraphicFill).isFill = false;
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					// 圆形
				case this.circle_btn:
					currentTool.stopDraw();
					currentTool = new Circle();
					(currentTool as GraphicFill).isFill = false;
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					// 文字
				case this.text_btn:
					currentTool.stopDraw();
					currentTool = new Text();
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					// 波浪
				case this.wave_btn:

					//iiii = 1;
					currentTool.stopDraw();
					currentTool = new WaveLine();
					currentTool.lineColor = lineColor;
					currentTool.lineSize = lineSize;
					currentTool.lineAlpha = lineAlpha;
					currentTool.shapeSprite = shapeArea;
					currentTool.allShapeArr = allShapeArr;
					addChild(currentTool);
					break;

					//// 属性（颜色、粗细、透明度）
					// 颜色
				case this.color_btn:
					if (this.color_btn.currentLabel == "state_1")
					{
						this.color_btn.gotoAndStop("state_2");
					}
					else
					{
						this.color_btn.gotoAndStop("state_1");
						//// 设置颜色
						switch (eve.target)
						{
							case this.color_btn.color_btn_1:
								lineColor = 0x000000;
								this.color_btn.color_btn_0.gotoAndStop("state_1");
								break;
							case this.color_btn.color_btn_2:
								lineColor = 0x999999;
								this.color_btn.color_btn_0.gotoAndStop("state_2");
								break;
							case this.color_btn.color_btn_3:
								lineColor = 0xFFFFFF;
								this.color_btn.color_btn_0.gotoAndStop("state_3");
								break;
							case this.color_btn.color_btn_4:
								lineColor = 0xFF0000;
								this.color_btn.color_btn_0.gotoAndStop("state_4");
								break;
							case this.color_btn.color_btn_5:
								lineColor = 0x00FF00;
								this.color_btn.color_btn_0.gotoAndStop("state_5");
								break;
							case this.color_btn.color_btn_6:
								lineColor = 0x0000FF;
								this.color_btn.color_btn_0.gotoAndStop("state_6");
								break;
							case this.color_btn.color_btn_7:
								lineColor = 0xFFFF00;
								this.color_btn.color_btn_0.gotoAndStop("state_7");
								break;
							case this.color_btn.color_btn_8:
								lineColor = 0x00FFFF;
								this.color_btn.color_btn_0.gotoAndStop("state_8");
								break;
							case this.color_btn.color_btn_9:
								lineColor = 0xFF00FF;
								this.color_btn.color_btn_0.gotoAndStop("state_9");
								break;

						}
						currentTool.lineColor = lineColor;
					}
					break;

					// 粗细
				case this.size_btn:
					if (this.size_btn.currentLabel == "state_1")
					{
						this.size_btn.gotoAndStop("state_2");
					}
					else
					{
						this.size_btn.gotoAndStop("state_1");
						//// 设置颜色
						switch (eve.target)
						{
							case this.size_btn.size_btn_1:
								lineSize = 2;
								this.size_btn.size_btn_0.gotoAndStop("state_1");
								break;
							case this.size_btn.size_btn_2:
								lineSize = 5;
								this.size_btn.size_btn_0.gotoAndStop("state_2");
								break;
							case this.size_btn.size_btn_3:
								lineSize = 10;
								this.size_btn.size_btn_0.gotoAndStop("state_3");
								break;
							case this.size_btn.size_btn_4:
								lineSize = 15;
								this.size_btn.size_btn_0.gotoAndStop("state_4");
								break;
							case this.size_btn.size_btn_5:
								lineSize = 25;
								this.size_btn.size_btn_0.gotoAndStop("state_5");
								break;

						}
						currentTool.lineSize = lineSize;
					}
					break;

					// 透明度
				case this.alpha_btn:
					if (this.alpha_btn.currentLabel == "state_1")
					{
						this.alpha_btn.gotoAndStop("state_2");
					}
					else
					{
						this.alpha_btn.gotoAndStop("state_1");
						//// 设置颜色
						switch (eve.target)
						{
							case this.alpha_btn.alpha_btn_1:
								lineAlpha = 1;
								this.alpha_btn.alpha_btn_0.gotoAndStop("state_1");
								break;
							case this.alpha_btn.alpha_btn_2:
								lineAlpha = 0.8;
								this.alpha_btn.alpha_btn_0.gotoAndStop("state_2");
								break;
							case this.alpha_btn.alpha_btn_3:
								lineAlpha = 0.6;
								this.alpha_btn.alpha_btn_0.gotoAndStop("state_3");
								break;
							case this.alpha_btn.alpha_btn_4:
								lineAlpha = 0.4;
								this.alpha_btn.alpha_btn_0.gotoAndStop("state_4");
								break;
							case this.alpha_btn.alpha_btn_5:
								lineAlpha = 0.2;
								this.alpha_btn.alpha_btn_0.gotoAndStop("state_5");
								break;

						}
						currentTool.lineAlpha = lineAlpha;
					}
					break;

					//// 辅助（撤销、清除、保存）
					// 撤销
				case this.undo_btn:
					if (allShapeArr.length > 0)
					{
						this.shapeArea.removeChild(allShapeArr[allShapeArr.length - 1]);
						allShapeArr.pop();
					}
					break;

					// 清除
				case this.clear_btn:
					var i: int;
					var len: int = allShapeArr.length;
					for (i = 0; i < len; i++)
					{
						this.shapeArea.removeChild(allShapeArr[allShapeArr.length - 1]);
						allShapeArr.pop();
					}
					break;

					// 保存
				case this.save_btn:
					//// 创建位图数据对象，并对绘制的图像进行截图
					var bitmapData: BitmapData = new BitmapData(this.shapeArea.shapeMask.width, this.shapeArea.shapeMask.height);
					bitmapData.draw(this.shapeArea);

					// 用于对JPG图片进行编码，可以设置图片编码质量，100为最高，0为最低
					var jpgEncoder: JPGEncoder = new JPGEncoder(80);
					var byteArray: ByteArray = jpgEncoder.encode(bitmapData);

					//// 将编码后的JPG图像数据保存为JPG文件
					var fileReference: FileReference = new FileReference();
					fileReference.save(byteArray, "绘制的图形截图.jpg");
					break;
			}
		}


	}
}