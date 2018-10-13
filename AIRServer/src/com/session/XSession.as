package com.session
{
	import xyzdlcore.crypt.AESCrypt;
	
	import flash.net.Socket;

	public class XSession extends XSocket
	{
		//服务器端的客户端模型增加一些特有属性
		public var len:uint = 0;
		public var state:int = 0;
		public var aes:AESCrypt;
		public function XSession(socket:Socket = null)
		{
			super(socket);
			aes = new AESCrypt();
		}
	}
}
