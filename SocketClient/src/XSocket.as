package 
{
	import xyzdlcore.event.DispatchEvent;
	import xyzdlcore.event.ModuleMessage;
	
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;

	public class XSocket
	{
		public static const HEAD_LEN:int = 4; //数据包头,用来表示实际数据的长度,数据包去掉包头才是实际数据长度

		private var _socket:Socket

		public function XSocket(socket:Socket = null)
		{
			_socket = socket ? socket : new Socket();
			_socket.timeout = 10000;
		}
		//------START-事件注册区
		//------END---事件注册区
		//------START-公共方法区

		public function get connected():Boolean
		{
			return _socket.connected;
		}

		public function get bytesAvailable():uint
		{
			return _socket.bytesAvailable;
		}

		public function connect(host:String, port:int):void
		{
			_socket.connect(host, port);
		}
		public function close():void
		{
			_socket.close();
		}
		public function flush():void
		{
			_socket.flush();
		}
		
		private var bytesLen:uint = 0;
		private var bytes:ByteArray = new ByteArray();
		public function readDP():ByteArray
		{
			bytesLen = readDPH();
			if(!bytesLen)
			{
				DispatchEvent(ModuleMessage.SOCKET_DATA_PACKAGE_EMPTY);
				return null;
			}
			return readDPB(bytesLen);
		}
		public function readDPH():uint
		{
			if (bytesLen == 0) {
				if (_socket.bytesAvailable < 4)
					return 0;
				else
					bytesLen = _socket.readUnsignedInt();	
				if (bytesLen < 0) {
					throw new Error("Fatal Error:Data Length Must >= 0!");
				}
				if (bytesLen == 0) {
					return 0;
				}
							
			}
			return bytesLen;
		}
		public function readDPB(len:uint):ByteArray
		{
			if(_socket.bytesAvailable < len)
			{
				DispatchEvent(ModuleMessage.SOCKET_DATA_PACKAGE_NOT_ENOUGH);
				return null;
			}
			bytes.clear();
			_socket.readBytes(bytes, 0, len);
			bytesLen = 0;
			return bytes;
		}
		public function readUnsignedInt():uint
		{
			return _socket.readUnsignedInt();
		}
		public function sendDP(bytes:ByteArray):void
		{
			if(!bytes)
				return;
			try
			{
				if(_socket != null && _socket.connected)
				{
					_socket.writeUnsignedInt(bytes.length);
					_socket.writeBytes(bytes, 0, bytes.length);
					_socket.flush();
				}
				else
				{
					trace("Socket is Disconnected");
				}
			}
			catch(error:Error)
			{
				trace(error.message);
			}
		}
		public function writeUnsignedInt(value:uint):void
		{
			_socket.writeUnsignedInt(value);
		}
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_socket.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function toString():String
		{
			return _socket.toString();
		}
		public function dispose():void
		{
			if(_socket.connected)
				_socket.close();
			_socket = null;
		}
		//------END---公共方法区
		//------START-私有方法区
		//------END---私有方法区
	}
}
