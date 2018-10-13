package xyzdlcore.crypt
{
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.symmetric.AESKey;

	import flash.utils.ByteArray;

	public class AESCrypt
	{
		private static const BLOLEN:int = 16; //块大小

		private var aesKey:AESKey; //AES密钥
		private var block:ByteArray = new ByteArray(); //加解密二进制块，目前只支持16字节大小
		private var needNum:int = 0; //长度小于16字节的块填充到16字节的需要量

		public function AESCrypt()
		{
		}

		private var _key:ByteArray; //用来保存密钥的二进制数据
		public function set key(value:ByteArray):void
		{
			if(!value)
				return;
			if(value.length != 16 && value.length != 24 && value.length != 32)
				throw new Error("AES Key's Length is Wrong");
			_key = value;
			aesKey = new AESKey(value);
		}
		public function get key():ByteArray
		{
			return _key;
		}

		/**
		 * 随机生成一个AESKey
		 */
		public function generateRandomAESKey():void
		{
			var rand:Random = new Random();
			_key = new ByteArray();
			rand.nextBytes(_key, 16);
			key = _key;
		}


		/**
		 * 输入的bytes长度一定要大于0，否则加密就没有意义
		 */
		public function encryptBytes(bytes:ByteArray):void
		{
			if(!bytes.length)
				return;
			var round:int = (bytes.length - 1) / BLOLEN + 1;
			var mark:Boolean = bytes.length % BLOLEN == 0; //是否是块大小的整数倍
			padBlock(bytes);
			for(var i:int = 0; i < round; i++)
				encryptBlock(bytes, i);
			if(mark)
				bytes.writeByte(0xff);
		}

		private var iForPad:int = 0;
		/**
		 * 填充数据块
		 */
		private function padBlock(bytes:ByteArray):void
		{
			iForPad = needNum = (BLOLEN - bytes.length % BLOLEN) % BLOLEN;
			bytes.position = bytes.length;
			while(iForPad--)
			{
				bytes.writeByte(needNum);
			}
		}
		/**
		 * 加密数据块
		 */
		private function encryptBlock(bytes:ByteArray, blockIndex:int):void
		{
			block.position = 0;
			block.writeBytes(bytes, blockIndex * BLOLEN, BLOLEN);
			aesKey.encrypt(block);
			bytes.position = blockIndex * BLOLEN;
			bytes.writeBytes(block);
		}


		/**
		 * 解密，返回一组新数据
		 */
		public function decryptBytes(bytes:ByteArray):ByteArray
		{
			if(!bytes.length)
				return null;
			var decryptedBytes:ByteArray = new ByteArray();
			var round:int = (bytes.length - 2) / BLOLEN + 1;
			var i:int = 0;
			if(bytes.length % BLOLEN)
			{
				decryptedBytes.writeBytes(bytes, 0, round * BLOLEN);
				for(i = 0; i < round; i++)
				{
					decryptBlock(decryptedBytes, i);
				}
			}
			else
			{
				for(i = 0; i < round; i++)
				{
					decryptBlock(bytes, i);
				}
				needNum = bytes[bytes.length - 1];
				decryptedBytes.writeBytes(bytes, 0, bytes.length - needNum);
			}
			return decryptedBytes;
		}
		/**
		 * 解密数据块
		 */
		private function decryptBlock(bytes:ByteArray, blockIndex:int):void
		{
			block.position = 0;
			block.writeBytes(bytes, blockIndex * BLOLEN, BLOLEN);
			aesKey.decrypt(block);
			bytes.position = blockIndex * BLOLEN;
			bytes.writeBytes(block);
		}
	}
}
