package com.xyzdl.aircore
{
	import com.xyzdl.core.modules.XSocket;

	import flash.net.Socket;
	import flash.utils.describeType;

	public class AirCoreUtil
	{
		public function AirCoreUtil()
		{
		}
		/**
		 *返回类似 127.0.0.1:8080 的套接字名字
		 */
		public static function getSocketId(socket:Socket):String
		{
			return socket.remoteAddress + ":" + socket.remotePort;
		}
		/**
		 * 返回类似 127.0.0.1:8080 的套接字名字
		 */
		public static function getSocketIdX(socket:XSocket):String
		{
			return socket.remoteAddress + ":" + socket.remotePort;
		}
		/**
		 * 将指定类的属性信息解析出来
		 */
		public static function parse4PropertyInfos(klass:Class):Array
		{
			var xml:XML = describeType(klass);
			var vars:XMLList = describeType(klass).factory[0].variable;
			var pis:Array = [];
			for each(var e:XML in vars)
				pis.push(new PropertyInfo(e.@name, e.@type));
			return pis;
		}
	}
}
