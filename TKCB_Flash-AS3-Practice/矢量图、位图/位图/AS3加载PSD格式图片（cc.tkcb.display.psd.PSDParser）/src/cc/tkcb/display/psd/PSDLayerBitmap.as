/**
 * @author Slavomir Durej
 */

/*
 * 修 改 者：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-2-16
 */

package cc.tkcb.display.psd
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	
	/**
	 * PSDLayer
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-2-16
	 * @version 1.0.0
	 */
	public class PSDLayerBitmap
	{

		private var layer: PSDLayer = null;
		private var fileData: ByteArray = null;
		private var lineLengths: Array = null;

		public var channels: Array = null;
		public var image: BitmapData = null;
		private var width: int = 0;
		private var height: int = 0;


		public function PSDLayerBitmap(layer: PSDLayer, fileData: ByteArray)
		{
			this.layer = layer;
			this.fileData = fileData;

			readChannels();
		}

		public function dispose(): void
		{
			if (channels)
			{
				channels.length = 0;
				channels = null;
			}
			if (lineLengths)
			{
				lineLengths.length = 0;
				lineLengths = null;
			}
			if (image)
			{
				image.dispose();
				image = null;
			}
		}

		private function readChannels(): void
		{
			//init image channels
			channels = [];
			channels["a"] = [];
			channels["r"] = [];
			channels["g"] = [];
			channels["b"] = [];

			const channelsLength: int = layer.channelsInfo_arr.length;
			const isTransparent: Boolean = (channelsLength > 3);

			if (layer.type != PSDLayer.LayerType_NORMAL)
			{
				var pixelDataSize: int = 0;

				for (var i: int = 0; i < channelsLength; ++i)
				{
					var channelLenghtInfo: PSDChannelInfoVO = layer.channelsInfo_arr[i];
					pixelDataSize += channelLenghtInfo.length;
				}
				//skip image data parsing for layer folders (for now)
				fileData.position += pixelDataSize;
				return;
			}

			for (i = 0; i < channelsLength; ++i)
			{
				channelLenghtInfo = layer.channelsInfo_arr[i];
				const channelID: int = channelLenghtInfo.id;
				const channelLength: uint = channelLenghtInfo.length;

				//determine the correct width and height
				if (channelID < -1)
				{
					//use the mask dimensions
					width = layer.maskBounds.width;
					height = layer.maskBounds.height;
				}
				else
				{
					//use the layer dimensions
					width = layer.bounds.width;
					height = layer.bounds.height;
				}


				if ((width * height) == 0) //TODO fix this later
				{
					const compression: int = fileData.readShort();
					return;
				}

				const channelData: ByteArray = readColorPlane(i, height, width, channelLength);

				if (channelData.length == 0)
					return; //TODO fix this later				

				if (channelID == -1)
				{
					channels["a"] = channelData;
					//TODO implement [int(ch * opacity_devider) for ch in channel] ; from pascal
				}
				else if (channelID == 0)
				{
					channels["r"] = channelData;
				}
				else if (channelID == 1)
				{
					channels["g"] = channelData;
				}
				else if (channelID == 2)
				{
					channels["b"] = channelData;
				}
				else if (channelID < -1)
				{
					channels["a"] = channelData;
					//TODO implement : [int(a * (c/255)) for a, c in zip(self.channels["a"], channel)] from pascal
				}
			}

			if (PSDParser.createLayersBmd)
			{
				renderImage(isTransparent);
			}
		}

		private function readColorPlane(planeNum: int, height: int, width: int, channelLength: int): ByteArray
		{
			const channelDataSize: int = width * height;
			var isRLEncoded: Boolean = false;
			var imageData: ByteArray = null;
			var i: int = 0;

			imageData = new ByteArray();

			const compression: int = fileData.readShort();
			isRLEncoded = (compression == 1);

			if (isRLEncoded)
			{
				lineLengths = new Array(height);

				for (i = 0; i < height; ++i)
				{
					lineLengths[i] = fileData.readUnsignedShort();
				}
				//read compressed chanel data 
				for (i = 0; i < height; ++i)
				{
					var line: ByteArray = new ByteArray();
					fileData.readBytes(line, 0, lineLengths[i]);
					unpack(line)
					imageData.writeBytes(unpacked, 0, unpack_len);
				}
			}
			else
			{
				if (compression == 0)
				{
					//read raw data
					fileData.readBytes(imageData, 0, channelDataSize);
				}
				else
				{
					//skip data
					fileData.position += channelLength;
				}
			}

			return imageData;
		}




		private function renderImage(transparent: Boolean = false): void
		{
			image = new BitmapData(width, height, transparent, 0x00000000);
			image.lock();

			//init alpha channel
			if (transparent)
			{
				var a: ByteArray = channels["a"];
			}

			var onlyTransparent: Boolean = (channels["r"].length == 0 && channels["g"].length == 0 && channels["b"].length == 0);

			if (!onlyTransparent)
			{
				//init channels
				var r: ByteArray = channels["r"];
				var g: ByteArray = channels["g"];
				var b: ByteArray = channels["b"];
			}

			var color: uint = 0;
			var _ind: uint = 0;
			var iv: Vector.<uint> = image.getVector(image.rect);
			iv.fixed = true;
			for (var y: int = 0; y < height; ++y)
			{
				for (var x: int = 0; x < width; ++x)
				{
					if (onlyTransparent)
					{
						color = a[_ind];
					}
					else
					{
						if (transparent)
						{
							color = a[_ind] << 24 | r[_ind] << 16 | g[_ind] << 8 | b[_ind];
						}
						else
						{
							color = r[_ind] << 16 | g[_ind] << 8 | b[_ind];
						}
					}
					iv[_ind++] = color;
				}
			}
			image.setVector(image.rect, iv);
			image.unlock();
			iv.fixed = false;
			iv.length = 0;
			iv = null;
		}


		private const unpacked: ByteArray = new ByteArray();
		private var unpack_len: int = 0;

		public function unpack(packed: ByteArray): void
		{
			var i: int = 0;
			var n: int = 0;
			var byte: int = 0;
			var count: int = 0;
			unpack_len = 0;
			unpacked.position = 0;
			packed.position = 0;

			while (packed.bytesAvailable)
			{
				n = packed.readByte();

				if (n >= 0)
				{
					count = n + 1;
					for (i = 0; i < count; ++i)
					{
						unpacked.writeByte(packed.readByte());
					}
					unpack_len += count;
				}
				else
				{
					byte = packed.readByte();

					count = 1 - n;
					for (i = 0; i < count; ++i)
					{
						unpacked.writeByte(byte);
					}
					unpack_len += count;
				}
			}

		}
	}
}