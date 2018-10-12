package com.xyzdl.core.utils
{
	import flash.utils.ByteArray;

	public class Hex
	{
		public function Hex()
		{
		}
		public static function toArray(hex:String):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			if(!hex)
				return bytes;
			if((int(hex.length) & 1) == 1)
			{
				if(hex.charAt(0) == "0")
					hex = hex.substr(1);
				else
					hex = "0" + hex;
			}

			for(var i:int = 0; i < hex.length; i += 2)
				bytes.writeByte(parseInt(hex.substr(i, 2), 16));
			bytes.position = 0;
			return bytes;
		}
		public static function fromArray(bytes:ByteArray):String
		{
			var str:String = "";
			var b:uint = 0;
			if(!bytes || !bytes.length)
				return str;
			bytes.position = 0;
			for(var j:int = 0; j < bytes.length; j++)
			{
				b = bytes.readUnsignedByte();
				if(b < 0x10)
					str += "0" + b.toString(16);
				else
					str += b.toString(16);
			}
			bytes.position = 0;
			return str;
		}
	}
}
