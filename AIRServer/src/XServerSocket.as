package
{
	import com.session.SessionContext;
	import com.session.XSession;
	import com.worker.CryptWorker;
	import com.xyzdl.aircore.AirCoreUtil;
	import com.xyzdl.core.crypt.AESCrypt;
	import com.xyzdl.core.event.AddModuleListener;
	import com.xyzdl.core.event.DispatchEvent;
	import com.xyzdl.core.event.ModuleMessage;
	import com.xyzdl.core.utils.CoreUtil;
	import com.xyzdl.core.utils.Hex;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class XServerSocket
	{
		private static const DETERMINE_VERSION:int = 0; //协议版本验证状态
		private static const SEND_CHALLENGE:int = 1; //发送验证状态
		private static const RECEIVE_CHALLENGE:int = 2; //接收码验证和客户端公钥状态
		private static const NORMAL:int = 4; //正常通信状态

		private static const HEAD_LEN:int = 4; //数据包头,用来表示实际数据的长度,数据包去掉包头才是实际数据长度

		private var _serverSocket:ServerSocket = new ServerSocket();
		private var _stateFunDic:Dictionary = new Dictionary(); //状态处理方法字典

		private static var _singleton:XServerSocket;
		public static function get singleton():XServerSocket
		{
			_singleton ||= new XServerSocket();
			return _singleton;
		}
		public function XServerSocket()
		{
			_stateFunDic[DETERMINE_VERSION] = sendVersion;
			_stateFunDic[SEND_CHALLENGE] = sendChallenge;
			_stateFunDic[RECEIVE_CHALLENGE] = receiveChallengeAndPublicKey;
			_stateFunDic[NORMAL] = read;

			AddModuleListener(ModuleMessage.SERVER_WORKER_CREATE_AES_COMPLETE, onCreateAESComplete);
			AddModuleListener(ModuleMessage.SERVER_WORKER_SEND_SOCKET_MESSAGE, onSendSocketMsg);

			_serverSocket.bind(Config.port, Config.host);
			_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			_serverSocket.addEventListener(Event.CLOSE, onClose);
			_serverSocket.listen();
			Console.addMsg("Bind to: " + _serverSocket.localAddress + ":" + _serverSocket.localPort);
		}
		//------START-事件注册区
		private var xSession:XSession;
		private function onCreateAESComplete(args:Array):void
		{
			if(!args || args.length < 2)
				return;
			xSession = SessionContext.getSessionBySocketId(args[0]);
			if(!xSession)
				return;
			xSession.sendDP(args[1]);
			xSession.state = NORMAL;
			DispatchEvent(ModuleMessage.SOCKET_STATE_TO_NORMAL, [SessionContext.numSession]);
		}
		private function onSendSocketMsg(args:Array):void
		{
			xSession = SessionContext.getSessionBySocketId(args[0]);
			if(xSession)
				xSession.sendDP(args[1]);
		}
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			var session:XSession = SessionContext.createSession(e.socket);
			session.addEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
			session.addEventListener(Event.CLOSE, onClientClose);
			_stateFunDic[DETERMINE_VERSION](session);
			DispatchEvent(ModuleMessage.SERVER_SOCKET_CONNECT, [AirCoreUtil.getSocketIdX(session)]);
			Console.addMsg("Start to Verify...");
		}
		private function onClose(e:Event):void
		{
			DispatchEvent(ModuleMessage.SERVER_SOCKET_CLOSE);
		}
		private function onClientSocketData(e:ProgressEvent):void
		{
			xSession = SessionContext.getSessionBySocket(e.currentTarget as Socket); //_sessionDic[AirCoreUtil.getSocketId(e.currentTarget as Socket)]
			if(!xSession)
				return;
			_stateFunDic[xSession.state](xSession);
		}
		private function onClientClose(e:Event):void
		{
			SessionContext.deleteSession(SessionContext.getSessionBySocket(e.target as Socket));
			CryptWorker.sendMsgToCryptWorker([ModuleMessage.SERVER_WORKER_DELETE_SOCKET, AirCoreUtil.getSocketId(e.target as Socket)]);
			DispatchEvent(ModuleMessage.SOCKET_CLOSE, [AirCoreUtil.getSocketId(e.target as Socket)]);
			Console.addMsg("The Left Client Num is " + SessionContext.numSession);
		}
		//------END---事件注册区
		//------START-公共方法区
		//------END---公共方法区
		//------START-私有方法区
		private var aesKey:AESCrypt;
		private var msgId:int;
		private var msgBuffer:ByteArray;
		private var sharedBytes:ByteArray;
		private function read(session:XSession):void
		{
			buffer = readBytes(session);
			if(!buffer || !buffer.length)
				return;
			sharedBytes = CoreUtil.getSharedBytes(buffer);
			//******多线程派发事件******------第一步-服务端在多线程的情况下,该步骤之后就可以多线程读取访问socket(用专门的IO处理线程的话可以更高效)
			//******多线程派发事件******------第二步-到这里表示客户端发来的一个完整的消息数据包已经接收到了,派发给解码线程(用可以调用硬件解码的线程解码消息可以更加高效)
			CryptWorker.sendMsgToCryptWorker([ModuleMessage.SERVER_WORKER_CRYPT_DECRYTP, [AirCoreUtil.getSocketIdX(session), sharedBytes]]);
			//******多线程派发事件******------第三步-向一个根据重要性分组的线程安全消息队列加入消息
			//******多线程派发事件******------第四步-一个线程专门从消息队列中循环取消息后派发消息
			//******多线程派发事件******------第五步-消息派发器用多线程的方式去处理每一条消息,每个方法用一个线程去执行
		}

		private var bufferLen:uint;
		private var buffer:ByteArray;
		private function readBytes(session:XSession):ByteArray
		{
			bufferLen = uint(session.len);
			if(!bufferLen)
			{
				bufferLen = session.readDPH();
				if(!bufferLen)
				{
					DispatchEvent(ModuleMessage.SOCKET_DATA_PACKAGE_EMPTY);
					return null;
				}
				session.len = bufferLen;
			}

			buffer = session.readDPB(bufferLen);
			if(!buffer)
				return null;
			session.len = 0;
			return buffer;
		}
		private function sendVersion(cs:XSession):void
		{
			cs.writeUnsignedInt(Config.COMMUNICATION_PROTOCOL_VERSION);
			cs.flush();
			cs.state = SEND_CHALLENGE;

			Console.addMsg("sendVersion");
		}
		private function sendChallenge(session:XSession):void
		{
			if(session.bytesAvailable < 4)
				return;
			var ver:int = session.readUnsignedInt();
			if(ver > Config.COMMUNICATION_PROTOCOL_VERSION)
			{
				Console.addMsg(AirCoreUtil.getSocketIdX(session) + "-" + "Client Version is " + ver + ". Newer than Server's.");
				SessionContext.deleteSession(session);
				return;
			}
			session.writeUnsignedInt(Config.challenge);
			session.flush();
			session.state = RECEIVE_CHALLENGE;

			Console.addMsg("sendChallenge");
		}
		private function receiveChallengeAndPublicKey(session:XSession):void
		{
			buffer = readBytes(session);
			if(!buffer)
				return;
			var challenge:int = buffer.readInt();
			//验证码算法
			if(challenge != Config.challenge * 2)
			{
				Console.addMsg(AirCoreUtil.getSocketIdX(session) + "-" + "Client Challenge is Wrong " + challenge + " Socket will be Closed.");
				SessionContext.deleteSession(session);
				return;
			}
			Console.addMsg("State Change to RECEIVE_PUB_KEY");
			var pk:ByteArray = CoreUtil.getSharedBytes();
			buffer.readBytes(pk, 0, buffer.length - 4);

			CryptWorker.sendMsgToCryptWorker([ModuleMessage.SERVER_WORKER_CRYPT_CREAT_AES, [AirCoreUtil.getSocketIdX(session), pk]]);
		}
		//------END---私有方法区
	}
}
