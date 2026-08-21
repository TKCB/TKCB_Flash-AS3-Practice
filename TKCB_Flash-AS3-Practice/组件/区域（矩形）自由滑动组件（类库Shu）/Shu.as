package {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextFormat;
	public class Shu extends MovieClip {
		var mc: * ;
		var gundong_bl = false;
		var zz: Sprite = new Sprite;
		var bg: Sprite = new Sprite;
		var gdz = false;
		var inix=0;
		var iniy=0;
		var dd3=0;
		var dd=0;
		var dd2=0;
		var mcx=0;
		var mcy=0;
		var cc=0;
		var mclsy=0;
		var ysx:Number;
		var ysy:Number;
		function Shu(e , w: int, h: int,reize:Boolean=false) {
			mc = e;
			zz.graphics.beginFill(0xffffff)
			zz.graphics.drawRect(0,0, w, h)
			zz.graphics.endFill()
			//bg.graphics.beginFill(0x000000)
			//bg.graphics.drawRect(0,0, w, h)
			//bg.graphics.endFill()
			mc.parent.addChild(zz)
			//bg.alpha=0.01;
			//mc.addChildAt(bg,0)
			mc.scaleX=1;
			mc.scaleY=1;
			zz.x=ysx=inix = e.x;
			zz.y=ysy=iniy = e.y;
			mc.mask = zz;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, cl)
		}
		public function top(){
			mc.y=zz.y;
		}
		public function rec(h_:Number){
			zz.x=inix=ysx= mc.x;
			zz.y=ysy=iniy =mc.y;
			zz.height=h_;
			//bg.height=h_;
			zz.width=bg.width=mc.width
		}
		public function set active(e:Boolean){
			if(e){
				mc.addEventListener(MouseEvent.MOUSE_DOWN, cl)
			}else{
				mc.removeEventListener(MouseEvent.MOUSE_DOWN, cl)
				mc.stage.removeEventListener(Event.ENTER_FRAME, fr2)
				mc.stage.removeEventListener(Event.ENTER_FRAME, fr)
			}
		}
		function cl(e) {
			if(mc.height>zz.height){
			/*if(mc.height>zz.height){
				bg.height=mc.height;
				bg.width=mc.width
			}else{
				bg.height=zz.height;
				bg.width=zz.width
			}*/
			if (gdz) {
				gdz = false;
				this["dd3"] = 0;
				mc.mouseChildren = mc.mouseEnabled = false
				mc.stage.removeEventListener(Event.ENTER_FRAME, fr2)
				if ((int(this["dd3"]) > 0 ? int(this["dd3"]) : -int(this["dd3"])) == 0) {
					if (mc.y < -(mc.height - zz.height - this["iniy"])) {
						mc.y = this["iniy"] - (mc.height - zz.height)
					}
					if (mc.y > this["iniy"]) {
						mc.y = this["iniy"]
					}
				}
			}
			mc.stage.addEventListener(MouseEvent.MOUSE_UP, up)
			mc.stage.addEventListener(Event.ENTER_FRAME, fr)
			this["dd3"] = 0;
			this["dd"] = mc.parent.mouseY;
			this["cc"] = mc.parent.mouseY;
			this["mcx"] = mc.mouseY;
			this["mcy"] = mc.mouseY;
			mclsy=mc.y;
		}
		
		}
		function fr(e) {
			if(mclsy+2>mc.y&&mclsy-2<mc.y){
				//mc.mouseChildren = mc.mouseEnabled = true
			}else{
				mc.mouseChildren = mc.mouseEnabled = false
			}
			lidu();
			tuodong();
		}
		function up(e) {
			if (mc.y < -(mc.height - zz.height - this["iniy"])) {
				mc.y = this["iniy"] - (mc.height - zz.height)
			}
			if (mc.y > this["iniy"]) {
				mc.y = this["iniy"]
			}
			if (this["dd3"] != 0) {
				gdz = true;
				mc.stage.addEventListener(Event.ENTER_FRAME, fr2)
			}
			mc.mouseChildren = mc.mouseEnabled = true;
			mc.stage.removeEventListener(Event.ENTER_FRAME, fr)
			mc.stage.removeEventListener(MouseEvent.MOUSE_UP, up)
		}
		function lidu() {
			if (this["dd"]) {
				this["dd2"] = mc.parent.mouseY

				this["dd3"] = this["dd2"] - this["dd"];

				this["dd"] = this["dd2"]

			} else {
				this["dd"] = mc.parent.mouseY
				this["dd2"] = 0
			}
		}
		function tuodong() {

			if (mc.y <= this["iniy"] && mc.y >= -(mc.height - zz.height - this["iniy"])) {
				mc.y = mc.parent.mouseY - this["mcy"];

			} else {
				if (mc.y >= this["iniy"]) {

					mc.y = this["iniy"] + (mc.parent.mouseY - this["cc"]) * 0.2
				}
				if (mc.y <= -(mc.height - zz.height - this["iniy"])) {

					mc.y = -(mc.height - zz.height - this["iniy"]) + (mc.parent.mouseY - this["cc"]) * 0.2
				}

			}

		}
		function fr2(e) {
			this["dd3"] *= 0.98;
			if (mc.y == this["iniy"] || mc.y == this["iniy"] - (mc.height - zz.height)) {
				mc.stage.removeEventListener(Event.ENTER_FRAME, fr2)
			} else {
				if ((int(this["dd3"]) > 0 ? int(this["dd3"]) : -int(this["dd3"])) == 0) {
					if (mc.y <= -(mc.height - zz.height - this["iniy"])) {

						mc.y = this["iniy"] - (mc.height - zz.height)

					}
					if (mc.y >= this["iniy"]) {
						mc.y = this["iniy"]
					}
					gdz = false;
					mc.stage.removeEventListener(Event.ENTER_FRAME, fr2)
				}
				if (mc.y > this["iniy"] || mc.y < -(mc.height - zz.height - this["iniy"])) {
					mc.y += this["dd3"] *= 0.5
				} else {
					mc.y += this["dd3"]
				}

			}
		}

	}

}