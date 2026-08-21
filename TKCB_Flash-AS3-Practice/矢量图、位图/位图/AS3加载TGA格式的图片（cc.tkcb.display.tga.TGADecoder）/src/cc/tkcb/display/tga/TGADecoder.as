/*
 * 修 改 者：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-11-26
 */

package cc.tkcb.display.tga
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * TGADecoder TGA格式解析类，用于解析TGA格式二进制数据，并且从中获取位图数据信息。 
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-11-26
	 * @version 1.0.0
	 */
	public class TGADecoder
	{
		//___________________________________________________________ const

		// constant value for _imageType
		private const TYPE_NONE:uint = 0x00;
		private const TYPE_INDEX_COLOR:uint = 0x01;
		private const TYPE_FULL_COLOR:uint = 0x02;
		private const TYPE_RLE_BIT:uint = 0x08;

		private const DIR_RIGHT_UP:int = 0;
		private const DIR_LEFT_UP:int = 1;
		private const DIR_RIGHT_DOWN:int = 2;
		private const DIR_LEFT_DOWN:int = 3;

		//___________________________________________________________ vars

		private var _bitmap:BitmapData;
		public function get bitmap():BitmapData
		{
			return _bitmap;
		}

		private var _idLength:int;// byte
		private var _colorMapType:int;// byte
		private var _imageType:int;// byte
		private var _colorMapIndex:int;// short
		private var _colorMapLength:int;// short
		private var _colorMapSize:int;// byte
		private var _originX:int;// short
		private var _originY:int;// short
		private var _width:int;// short
		public function get width():int
		{
			return _width;
		}
		private var _height:int;// short
		public function get height():int
		{
			return _height;
		}
		private var _bitDepth:int;// byte
		private var _descriptor:int;// byte
		public function get pixelDirection():int
		{
			// descriptor:
			//   4th bit: 0 = left to right, 1 = right to left
			//   5th bit: 0 = bottom up, 1 = top down
			return (_descriptor >> 4) & 3;
		}


		public function TGADecoder(bytes:ByteArray)
		{
			bytes.position = 0;
			bytes.endian = Endian.LITTLE_ENDIAN;

			_idLength = bytes.readByte();
			_colorMapType = bytes.readByte();
			_imageType = bytes.readByte();
			_colorMapIndex = bytes.readShort();
			_colorMapLength = bytes.readShort();
			_colorMapSize = bytes.readByte();
			_originX = bytes.readShort();
			_originY = bytes.readShort();
			_width = bytes.readShort();
			_height = bytes.readShort();
			_bitDepth = bytes.readByte();
			_descriptor = bytes.readByte();

			_bitmap = new BitmapData(_width,_height);

			// ignore unsupported formats.
			if ((_imageType & TYPE_FULL_COLOR) == 0
			                                         || (_imageType & TYPE_RLE_BIT) != 0)
			{
				throw new Error("Unsupported tga format.");
			}

			_bitmap.lock();
			try
			{
				if (_bitDepth == 32)
				{
					loadBitmap32(bytes);
				}
				else if (_bitDepth == 24)
				{
					loadBitmap24(bytes);
				}
			}
			finally
			{
				_bitmap.unlock();
			}
		}


		private function loadBitmap32(bytes:ByteArray):void
		{
			var x:int,y:int;
			switch (pixelDirection)
			{
				case DIR_RIGHT_UP :
					for (y = _bitmap.height - 1; y >= 0; --y)
					{
						for (x = 0; x < _bitmap.width; ++x)
						{
							_bitmap.setPixel32(x, y, bytes.readUnsignedInt());
						}
					}
					break;
				case DIR_LEFT_UP :
					for (y = _bitmap.height - 1; y >= 0; --y)
					{
						for (x = _bitmap.width - 1; x >= 0; --x)
						{
							_bitmap.setPixel32(x, y, bytes.readUnsignedInt());
						}
					}
					break;
				case DIR_RIGHT_DOWN :
					for (y = 0; y < _bitmap.height; ++y)
					{
						for (x = 0; x < _bitmap.width; ++x)
						{
							_bitmap.setPixel32(x, y, bytes.readUnsignedInt());
						}
					}
					break;
				case DIR_LEFT_DOWN :
					for (y = 0; y < _bitmap.height; ++y)
					{
						for (x = _bitmap.width - 1; x >= 0; --x)
						{
							_bitmap.setPixel32(x, y, bytes.readUnsignedInt());
						}
					}
					break;
			}
		}


		private function loadBitmap24(bytes:ByteArray):void
		{
			var x:int,y:int;
			var r:uint,g:uint,b:uint;
			switch (pixelDirection)
			{
				case DIR_RIGHT_UP :
					for (y = _bitmap.height - 1; y >= 0; --y)
					{
						for (x = 0; x < _bitmap.width; ++x)
						{
							b = bytes.readUnsignedByte();
							g = bytes.readUnsignedByte();
							r = bytes.readUnsignedByte();
							_bitmap.setPixel32(x, y, 0xFF000000 | (r << 16) | (g << 8) | b);
						}
					}
					break;
				case DIR_LEFT_UP :
					for (y = _bitmap.height - 1; y >= 0; --y)
					{
						for (x = _bitmap.width - 1; x >= 0; --x)
						{
							b = bytes.readUnsignedByte();
							g = bytes.readUnsignedByte();
							r = bytes.readUnsignedByte();
							_bitmap.setPixel32(x, y, 0xFF000000 | (r << 16) | (g << 8) | b);
						}
					}
					break;
				case DIR_RIGHT_DOWN :
					for (y = 0; y < _bitmap.height; ++y)
					{
						for (x = 0; x < _bitmap.width; ++x)
						{
							b = bytes.readUnsignedByte();
							g = bytes.readUnsignedByte();
							r = bytes.readUnsignedByte();
							_bitmap.setPixel32(x, y, 0xFF000000 | (r << 16) | (g << 8) | b);
						}
					}
					break;
				case DIR_LEFT_DOWN :
					for (y = 0; y < _bitmap.height; ++y)
					{
						for (x = _bitmap.width - 1; x >= 0; --x)
						{
							b = bytes.readUnsignedByte();
							g = bytes.readUnsignedByte();
							r = bytes.readUnsignedByte();
							_bitmap.setPixel32(x, y, 0xFF000000 | (r << 16) | (g << 8) | b);
						}
					}
					break;
			}
		}
	}
}