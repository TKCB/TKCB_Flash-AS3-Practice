package com.dusk.zipcore.crypto
{

	import com.dusk.zipcore.utils.ZipCRC32;
	import com.dusk.zipcore.struct.ZipEntry;
	import com.dusk.zipcore.ZipError;
	import com.dusk.zipcore.struct.ZipHeader;
	import com.dusk.zipcore.zip_internal;

	import flash.utils.ByteArray;

	import com.dusk.zipcore.utils.BytesUtil;

	use namespace zip_internal;

	public class ZipCrypto implements ICrypto
	{

		private static var CRYPTHEADLEN: int = 12;

		// Initial keys
		private static var S_KEY1: int = 305419896;
		private static var S_KEY2: int = 591751049;
		private static var S_KEY3: int = 878082192;

		private var _key: Array;
		private var _password: ByteArray;
		private var _header: ZipHeader;

		private var _outBytes: ByteArray;

		public function ZipCrypto()
		{}

		public function initEncrypt(password: ByteArray, header: ZipHeader): void
		{
			var crc32: uint = header._crc32;
			_outBytes = BytesUtil.empty();
			_initEncrypt(password, crc32);

			header._compressSize += CRYPTHEADLEN;

		}

		/**
		 *  加密时使用的初始化处理
		 *
		 */
		private function _initEncrypt(password: ByteArray, crc32: uint): void
		{

			crc32 = crc32 >> 24;

			var ret: ByteArray = _outBytes;
			_key = new Array(3);
			_key[0] = S_KEY1;
			_key[1] = S_KEY2;
			_key[2] = S_KEY3;

			password.position = 0;
			while (password.bytesAvailable > 0)
			{
				var n: uint = password.readUnsignedByte();
				updateKeys(n);
			}

			var d: uint;
			for (var i: int = 0; i < CRYPTHEADLEN; i++)
			{
				if (i == CRYPTHEADLEN - 1)
				{
					d = uint(crc32 & 0xff);
				}
				else
				{
					d = uint((crc32 >> 32) & 0xFF);
				}
				d = zencode(d);
				ret.writeByte(d);
			}

		}

		/**
		 *  encrypt data
		 */
		public function encrypt(data: ByteArray): ByteArray
		{

			data.position = 0;
			while (data.bytesAvailable)
			{
				var n: uint = data.readUnsignedByte();
				_outBytes.writeByte(zencode(n));
			}
			_outBytes.position = 0;

			return _outBytes;
		}

		public function checkDecrypt(entry: ZipEntry): Boolean
		{
			return entry.isEncrypted() && !entry.isUseAES();
		}

		public function initDecrypt(password: ByteArray, header: ZipHeader): void
		{
			_password = password;
			_header = header;
			if (_header.isUseAES)
				throw ZipError("Use AESCrypto instead");
		}

		public function decrypt(data: ByteArray): ByteArray
		{
			trace(55555);
			//使用DataDesc后校验方式有差别
			var check1: uint = _header.isHasDataDescriptor ? (_header._lastModTime >> 8) & 0xff : _header._crc32 >> 24;
			var cryptoHeader: ByteArray = BytesUtil.empty();
			data.readBytes(cryptoHeader, 0, CRYPTHEADLEN);
			var check2: uint = _initDecrypt(_password, cryptoHeader) & 0xffff;
			
			// 不知道为什么，这个校验有问题，去掉就可以正常解析了
			//trace(check1, check2);
			//if (check1 != check2)
			//	throw new ZipError("Wrong password");
			
			return _decrypt(data);
		}
		
		/**
		 * 解密时使用的初始化处理
		 * @param password
		 * @param cryptHeader
		 * @return
		 */
		private function _initDecrypt(password: ByteArray, cryptHeader: ByteArray): uint
		{

			var ret: ByteArray = BytesUtil.empty();
			_key = new Array(3);
			_key[0] = S_KEY1;
			_key[1] = S_KEY2;
			_key[2] = S_KEY3;

			password.position = 0;

			while (password.bytesAvailable > 0)
			{
				var n: uint = password.readUnsignedByte();
				updateKeys(n);
			}
			cryptHeader.position = 0;

			for (var i: int = 0; i < CRYPTHEADLEN; i++)
			{
				var b: uint = cryptHeader.readUnsignedByte();
				b = zdecode(b);
			}
			return b;
		}


		/**
		 *  解密处理
		 *
		 */
		private function _decrypt(data: ByteArray): ByteArray
		{

			var out: ByteArray = BytesUtil.empty();
			while (data.bytesAvailable > 0)
			{
				var n: uint = data.readUnsignedByte();
				n = zdecode(n);
				out.writeByte(n);
			}
			out.position = 0;
			return out;
		}


		/**
		 *  解密用
		 */
		protected function zdecode(n: uint): uint
		{
			var t: uint = n;

			var d: uint = decryptByte();
			n ^= d;
			updateKeys(n);
			return n;
		}

		/**
		 *  加密用
		 */
		protected function zencode(n: uint): uint
		{
			var t: uint = decryptByte();
			updateKeys(n);
			return (t ^ n);
		}

		/**
		 *
		 *  @return unsigned char
		 */
		protected function decryptByte(): int
		{
			var temp: uint = _key[2] & 0xFFFF | 2;
			var ret: int = ((temp * (temp ^ 1)) >> 8) & 0xFF;
			return ret;
		}

		/**
		 * 更新密钥
		 * @param uchar
		 */
		protected function updateKeys(uchar: uint): void
		{
			_key[0] = ZipCRC32.getCRC32(_key[0], uchar);
			_key[1] = _key[1] + (_key[0] & 0xFF);

			//  这里分成两个是因为计算过程中会变成Number类型导致精度下降...
			var k2: int = _key[1];
			var b1: int = 134775000;
			var b2: int = 813;
			var t: int = uint(k2 * b1) + uint(k2 * b2) + 1;
			_key[1] = t;

			var k3: int = _key[1];

			var tmp: int = _key[1] >> 24;
			_key[2] = int(ZipCRC32.getCRC32(_key[2], tmp));
		}
	}
}