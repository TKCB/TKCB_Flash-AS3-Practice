package gyuque.effects
{
	public class Vec2
	{
		function Vec2(aX:Number = 0, aY:Number = 0)
		{
			x = aX;
			y = aY;
		}

		public var x:Number;
		public var y:Number;

		public function smul(k:Number):Vec2
		{
			x *= k;
			y *= k;

			return this;
		}

		public function add(v:Vec2):Vec2
		{
			x += v.x;
			y += v.y;

			return this;
		}

		public function norm():Number
		{
			return Math.sqrt(x*x + y*y);
		}

		public function normalize():Vec2
		{
			var nrm:Number = norm();
			if (nrm != 0)
			{
				x /= nrm;
				y /= nrm;
			}

			return this;
		}

		public function clone():Vec2
		{
			return new Vec2(x, y);
		}

		public function left():Vec2
		{
			var _y:Number = y;
			y = -x;
			x = _y;

			return this;
		}

		public function right():Vec2
		{
			var _y:Number = y;
			y = x;
			x = -_y;

			return this;
		}

		public function zero():Vec2
		{
			x = 0;
			y = 0;

			return this;
		}

		public function dp(v:Vec2):Number
		{
			return x * v.x  +  y * v.y;
		}

		public static function makeAtoB(a:Vec2, b:Vec2):Vec2
		{
			return new Vec2(b.x-a.x, b.y-a.y);
		}
	}
}