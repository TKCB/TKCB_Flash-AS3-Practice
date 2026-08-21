/**
 * com.durej.PSDParser
 * 
 * @author       Copyright (c) 2010 Slavomir Durej
 * @version      0.1
 * 
 * @link         http://durej.com/
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
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
	 * PSDLayer PSD格式解析类，用于解析PSD格式二进制数据，并且从中获取位图数据信息。 
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-2-16
	 * @version 1.0.0
	 */
	public class PSDParser
	{
		//compression types
		private const COMP_RAW: int = 0; //Raw image data
		private const COMP_RLE: int = 1; //RLE compressed the image
		private const COMP_ZIP_W: int = 2; //ZIP without prediction
		private const COMP_ZIP_P: int = 3; //ZIP with prediction.

		private var fileData: ByteArray = null;
		public var numChannels: int = 0;
		public var canvas_height: int = 0;
		public var canvas_width: int = 0;
		public var colorChannelDepth: int = 0;
		public var colorMode: int = 0;
		public var colorModeStr: String = null;
		public var allLayers: Array = null; //array of all layer objects
		public var allBitmaps: Array = null; //array of all bitmap objects
		public var composite_bmp: BitmapData = null;

		internal static var createLayersBmd: Boolean = true;

		public function PSDParser()
		{
			
		}

		public function parse(fileData: ByteArray, layerBmd: Boolean = true): void
		{
			this.fileData = fileData;
			createLayersBmd = layerBmd;

			fileData.position = 0;
			readHeader();
			readImageResources();
			readLayerAndMaskInfo();
			readCompositeData();
		}

		public function dispose(): void
		{
			unpacked.length = 0;
			if (composite_bmp)
			{
				composite_bmp.dispose();
				composite_bmp = null;
			}

			if (allLayers)
			{
				for each(var l: PSDLayer in allLayers)
				{
					if (l)
					{
						l.dispose();
					}
				}
				allLayers.length = 0;
				allLayers = null;
			}
			if (allBitmaps)
			{
				for each(var b: PSDLayerBitmap in allBitmaps)
				{
					if (b)
					{
						b.dispose();
					}
				}
				allBitmaps.length = 0;
				allBitmaps = null;
			}
		}

		private function readHeader(): void
		{
			//check signatue
			/*
				Signature: always equal to '8BPS'. Do not try to read the file if the
				signature does not match this value.
			 */
			const sig: String = fileData.readUTFBytes(4);
			if (sig != "8BPS")
				throw new Error("invalid signature: " + sig);

			//version
			/*
			 * 	Version: always equal to 1. Do not try to read the file if the version does
				not match this value. (**PSB** version is 2.)
			 */
			const version: int = fileData.readUnsignedShort();
			if (version != 1)
				throw new Error("invalid version: " + version);

			//Reserved, must be zero
			fileData.position += 6;

			//chanels
			/*
				The number of channels in the image, including any alpha channels.
				Supported range is 1 to 56.
			 */
			numChannels = fileData.readUnsignedShort();

			//The height of the image in pixels. Supported range is 1 to 30,000.
			canvas_height = fileData.readUnsignedInt()

			//The width of the image in pixels. Supported range is 1 to 30,000.
			canvas_width = fileData.readUnsignedInt();

			//Depth: the number of bits per channel. Supported values are 1, 8, and 16.
			colorChannelDepth = fileData.readUnsignedShort();

			//document color mode
			/*
				The color mode of the file. Supported values are: Bitmap = 0; Grayscale =
				1; Indexed = 2; RGB = 3; CMYK = 4; Multichannel = 7; Duotone = 8; Lab = 9.
		*/
			colorMode = fileData.readUnsignedShort();

			switch (colorMode)
			{
				case 0:
					colorModeStr = "BITMAP";
					break;
				case 1:
					colorModeStr = "GRAYSCALE";
					break;
				case 2:
					colorModeStr = "INDEXED";
					break;
				case 3:
					colorModeStr = "RGB";
					break;
				case 4:
					colorModeStr = "CMYK";
					break;
				case 7:
					colorModeStr = "MULTICHANNEL";
					break;
				case 8:
					colorModeStr = "DUOTONE";
					break;
				case 9:
					colorModeStr = "LAB";
					break;
			}

			//color mode section
			/*
			 Only indexed color and duotone (see the mode field in Table 1.2) have color mode
			data. For all other modes, this section is just the 4-byte length field, which is set to zero.
			 */
			var size: int = fileData.readInt();
			fileData.position += size;

		}


		private function readImageResources(): void
		{
			//Length of image resource section.
			var size: uint = fileData.readUnsignedInt()
			// how much was read
			var read: uint = 0;

			while (read < size)
			{
				var sig: String = fileData.readUTFBytes(4);
				if (sig != "8BIM")
					throw new Error("Invalid signature: " + sig);
				read += 4;

				//Unique identifier for the resource.
				var resourceID: int = fileData.readUnsignedShort();
				read += 2;
				//Name: Pascal string, padded to make the size even (a null name consists of two bytes of 0)
				readPascalStringObj()
				var name: String = pas_str;
				read += pas_len;

				//Actual size of resource data that follows
				var resourceSize: uint = fileData.readUnsignedInt();
				read += 4;

				//readResourceBlock(resourceSize, resourceID);
				fileData.position += resourceSize;
				read += resourceSize;

				if (resourceSize % 2 == 1)
				{
					fileData.readByte();
					read++;
				}

			}
		}

		private function readLayerAndMaskInfo(): void
		{
			//Length of the layer and mask information section.
			var size: uint = fileData.readUnsignedInt();

			//current read position
			var pos: uint = fileData.position;

			if (size > 0)
			{
				parseLayerInfo();
				parseMaskInfo();
				//trace(size, fileData.position)
				fileData.position += pos + size - fileData.position;
			}
		}

		//loop throigh the layers and get all the layer info
		private function parseLayerInfo(): void
		{
			//Length of the layers info section, rounded up to a multiple of 2.
			const layerInfoSize: uint = fileData.readUnsignedInt();

			//current read position
			const pos: int = fileData.position;

			//all layers init
			allLayers = [];

			//all bitmaps init
			allBitmaps = [];

			if (layerInfoSize > 0)
			{
				//get total nu of layers
				const nLayers: int = fileData.readShort();

				/*
					Layer count. If it is a negative number, its absolute value is the number of
					layers and the first alpha channel contains the transparency data for the
					merged result.
				 */
				const numLayers: int = Math.abs(nLayers);

				//loop through all layers to retrieve layer object info and image data				
				for (var i: int = 0; i < numLayers; ++i)
				{
					allLayers[i] = new PSDLayer(fileData);
				}

				for (i = 0; i < numLayers; ++i)
				{
					var layer_psd: PSDLayer = allLayers[i];
					var layer_bmp: PSDLayerBitmap = new PSDLayerBitmap(layer_psd, fileData);
					allBitmaps[i] = layer_bmp;
					layer_psd.bmp = layer_bmp.image;
				}
			}
			fileData.position += pos + layerInfoSize - fileData.position;
		}


		private function parseMaskInfo(): void
		{
			//TODO implement proper mask parsing
			//			var size:uint=fileData.readUnsignedInt();
			//			var overlay:uint=fileData.readUnsignedShort();
			//			var color1:uint=fileData.readUnsignedInt();
			//			var color2:uint=fileData.readUnsignedInt();
			//			var opacity:uint=fileData.readUnsignedShort();
			//			var kind:uint=fileData.readUnsignedByte();

			fileData.position += 1 + 16; // padding
		}


		private function readCompositeData(): void
		{
			//identify the compression
			var compression: int = fileData.readUnsignedShort();
			var channelsData_arr: Array = [];

			switch (compression)
			{
				case COMP_RAW: //get raw data

					for (var channel: int = 0; channel < numChannels; ++channel)
					{
						var data: ByteArray = new ByteArray();
						fileData.readBytes(data, 0, canvas_width * canvas_height);
						channelsData_arr[channel] = data;
					}
					break;

				case COMP_RLE:
					var lines: Array = [];
					var i: int = 0;

					for (i = 0; i < canvas_height * numChannels; ++i)
					{
						lines[i] = fileData.readUnsignedShort();
					}

					for (channel = 0; channel < numChannels; ++channel)
					{
						data = new ByteArray();

						for (i = 0; i < canvas_height; ++i)
						{
							var line: ByteArray = new ByteArray();
							fileData.readBytes(line, 0, lines[channel * canvas_height + i]);
							unpack(line)
							data.writeBytes(unpacked, 0, unpack_len);
						}
						channelsData_arr[channel] = data;
					}
					break;

				default:
					throw new Error("invalid compression: " + compression);
					break;
			}

			//create composite bitmap out of byte array channels
			composite_bmp = new BitmapData(canvas_width, canvas_height, false, 0x000000);
			composite_bmp.lock();

			var r: ByteArray = channelsData_arr[0];
			var g: ByteArray = channelsData_arr[1];
			var b: ByteArray = channelsData_arr[2];
			var _ind: uint = 0;
			var iv: Vector.<uint> = composite_bmp.getVector(composite_bmp.rect);
			iv.fixed = true;
			for (var y: int = 0; y < canvas_height; ++y)
			{
				for (var x: int = 0; x < canvas_width; ++x)
				{
					var rgb: uint = r[_ind] << 16 | g[_ind] << 8 | b[_ind];
					iv[_ind] = rgb;
					_ind++;
				}
			}
			composite_bmp.setVector(composite_bmp.rect, iv);
			composite_bmp.unlock();
			iv.fixed = false;
			iv.length = 0;
			iv = null;
		}

		//unpack byte array data
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

		//returns the read value and its length in format {str:value, length:size}
		private var pas_str: String = null;
		private var pas_len: uint = 0;
		private function readPascalStringObj(): void
		{
			var size: uint = fileData.readUnsignedByte();
			size += 1 - size % 2;
			pas_str = fileData.readMultiByte(size, "shift-jis").toString();
			pas_len = size + 1;
			//			return {str: fileData.readMultiByte(size, "shift-jis").toString(), length: size + 1};
		}

	}
}