package
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.math.BigInteger;
	import com.message.MessageEnum.MessageId;
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import xyzdlcore.crypt.AESCrypt;
	import xyzdlcore.event.DispatchEvent;
	import xyzdlcore.event.ModuleMessage;
	import xyzdlcore.utils.Hex;

	public class CSocket
	{
		private static const DETERMINE_VERSION:int = 0; //协议版本验证状态
		private static const RECEIVE_CHALLENGE:int = 2; //接收验证码状态
		private static const RECEIVE_SEC_KEY:int = 3; //接收密钥状态
		private static const NORMAL:int = 4; //正常通信状态


//		private var _xSocket:XSocket = new XSocket(); //XSocket4FlowAnalysis; //套接字实例
		private var _socket:Socket;
		private var _currState:int = DETERMINE_VERSION; //初始状态
		private var _aesKey:AESCrypt = new AESCrypt(); //AES加密对象
		private var _rsaKey:RSAKey; //RSA加密对象
		private var _stateFunDic:Dictionary = new Dictionary(); //状态处理方法字典
		private var _dispatcher:Dispatcher = new Dispatcher(); //服务器消息事件派发器

		private static var _singleton:CSocket;
		public static function get singleton():CSocket
		{
			_singleton ||= new CSocket();
			return _singleton;
		}

		public function CSocket()
		{
			_socket = new Socket();
			_socket.timeout = 10000;
			var bign:BigInteger = new BigInteger("d65e6d75aeda689cfab5efa15e134a7fa416765c568940ec93ab51c88be3581561ed258824fb1f366324cb6b412416452972f23737a816933fd3f156c00a0d9d",16);
			var bigd:BigInteger = new BigInteger("b38a28b11cbe2e49f3acf74336907f9fc1e5524269f3d09d93dc33c5fc6b6f7407b141a12d1c2c6169d1fcb090a63072ad742d6eba45b326dffdd32b6e361281",16);
			var e:int = 65537;
			
			
//			_rsaKey = new RSAKey(bign,e,bigd);
			_rsaKey =RSAKey.generate(512, "10001");
			
			trace(_rsaKey.n.toString());
			trace(_rsaKey.d.toString());

			_stateFunDic[DETERMINE_VERSION] = receiveVersion;
			_stateFunDic[RECEIVE_CHALLENGE] = receiveChallenge;
			_stateFunDic[RECEIVE_SEC_KEY] = receiveSecretKey;
			_stateFunDic[NORMAL] = read;

			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onServerSocketData);
			_socket.addEventListener(Event.CLOSE, onSocketClose);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
//------START-事件注册区
		private function onConnect(e:Event):void
		{
			clearTimeout(timeoutId);
			Console.addMsg("Connect to " + Config.host + ":" + Config.port);
		}
		private function onServerSocketData(e:ProgressEvent):void
		{
			_stateFunDic[_currState]();
		}
		private function onSocketClose(e:Event):void
		{
			if(_currState == DETERMINE_VERSION)
			{
				DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["Server Socket is Closed"]);
				return;
			}
			if(_currState == RECEIVE_CHALLENGE)
			{
				DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["Communication Protocol Version is Newer. Socket is Closed"]);
				return;
			}
			if(_currState == RECEIVE_SEC_KEY)
			{
				DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["Challenge Verifying is failed"]);
				return;
			}
			DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["Server Socket is Closed"]);
		}
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["Security Error:" + e.text]);
		}
		private function onIOError(e:IOErrorEvent):void
		{
			DispatchEvent(ModuleMessage.SOCKET_CLOSE, ["IO Error:" + e.text]);
		}
//------END---事件注册区
//------START-公共方法区
		private var protoBytes:ByteArray = new ByteArray();
		private var transitBytes:ByteArray = new ByteArray();
		public function sendProtoMessage(msg:Message):void
		{
			protoBytes.clear();
			transitBytes.clear();
			msg.writeTo(protoBytes);
			protoBytes.position = 0;
			transitBytes.writeInt(int(MessageId[getQualifiedClassName(msg).split("::")[1]]));
			transitBytes.writeBytes(protoBytes);

			send(transitBytes);
		}
		private function send(msg:ByteArray):void
		{
			if(!msg || !msg.length || _currState != NORMAL)
				return;
			if(CoreConfig.dataCompress)
				msg.compress();
			_aesKey.encryptBytes(msg);
			sendDP(msg);
		}
		
		
		private var timeoutId:int = 0;
		public function connectToServer():void
		{
			if(Config.autoTimeoutReconnect)
				timeoutId = setTimeout(connectToServer, 5000);
			Console.addMsg("Start to Connect...");
			_socket.connect(Config.host, Config.port);
		}
		public function disconnect():void
		{
			Console.addMsg("Disconnected");
			_socket.close();
		}
		public function addSocketEventListener(eventType:int, listener:Function):void
		{
			_dispatcher.add(eventType + "", listener);
		}
		public function removeSocketEventListener(eventType:int, listener:Function):void
		{
			_dispatcher.remove(eventType + "", listener);
		}
//------END---公共方法区
//------START-私有方法区
		private function receiveVersion():void
		{
			if(_socket.bytesAvailable < 4)
				return;
			var ver:uint = _socket.readUnsignedInt();
			Console.addMsg("Server Communication Protocol Version is " + ver);
			if(Config.COMMUNICATION_PROTOCOL_VERSION > ver)
			{
				Console.addMsg("Client Communication Protocol Version is Newer than Server's!");
			}
			_socket.writeUnsignedInt(Config.COMMUNICATION_PROTOCOL_VERSION);
			_socket.flush();

			_currState = RECEIVE_CHALLENGE;
		}
		private function receiveChallenge():void
		{
			if(_socket.bytesAvailable < 4)
				return;
			var challenge:uint = _socket.readUnsignedInt();
			var cAndn:ByteArray = new ByteArray();
			var n:ByteArray = _rsaKey.n.toByteArray();
			Console.addMsg("Server Challenge is " + challenge);
			Console.addMsg("c-n:" + _rsaKey.n);
			cAndn.writeUnsignedInt(challenge * 2); //验证算法,后期可以修改为复杂一些的
			cAndn.writeBytes(n);
			sendDP(cAndn);

			_currState = RECEIVE_SEC_KEY;
		}
		private var buffer:ByteArray;
		private function receiveSecretKey():void
		{
			buffer = readDP();
			if(!buffer || !buffer.length)
				return;
			var aesKeyBytes:ByteArray = new ByteArray();
			Console.addMsg("beforeDe:" + Hex.fromArray(buffer));
			_rsaKey.decrypt(buffer, aesKeyBytes, buffer.length);
			_aesKey = new AESCrypt();
			_aesKey.key = aesKeyBytes;
			Console.addMsg("c-sk:" + Hex.fromArray(aesKeyBytes));

			_currState = NORMAL;

			DispatchEvent(ModuleMessage.SOCKET_STATE_TO_NORMAL);
		}
		private var msgId:String;
		private var msgBuffer:ByteArray = new ByteArray;
		private function read():void
		{
			buffer = readDP();
			if(!buffer || !buffer.length)
				return;
			buffer.position = 0;
			trace(Hex.fromArray(buffer));
			buffer.position = 0;
			buffer = _aesKey.decryptBytes(buffer);
			if(CoreConfig.dataCompress)
				buffer.uncompress();
			buffer.position = 0;
			msgId = buffer.readInt() + "";
			msgBuffer.clear();
			buffer.readBytes(msgBuffer);
//			trace("msgId:"+msgId);
			_dispatcher.dispatch(msgId, [msgBuffer]);
		}
		
		
		private var bytesLen:uint = 0;
		private var bytes:ByteArray = new ByteArray();
		private function readDP():ByteArray
		{
			if (bytesLen == 0) {
				if (_socket.bytesAvailable < 4)
					return null;
				else
					bytesLen = _socket.readUnsignedInt();	
				if (bytesLen < 0) {
					throw new Error("Fatal Error:Data Length Must >= 0!");
				}
				if (bytesLen == 0) {
					DispatchEvent(ModuleMessage.SOCKET_DATA_PACKAGE_EMPTY);
					return null;
				}
			}
			
			if(_socket.bytesAvailable < bytesLen)
			{
				DispatchEvent(ModuleMessage.SOCKET_DATA_PACKAGE_NOT_ENOUGH);
				return null;
			}
			bytes.clear();
			_socket.readBytes(bytes, 0, bytesLen);
			bytesLen = 0;
			return bytes;
		}
		
		private function sendDP(bytes:ByteArray):void
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
		
//------END---私有方法区
	}
}
