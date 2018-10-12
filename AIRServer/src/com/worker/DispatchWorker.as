package com.worker
{
	import com.command.CommandContext;
	import com.dao.DaoContext;
	import com.message.S_SYN_HEARTBEAT;
	import com.message.MessageEnum.MessageId;
	import com.netease.protobuf.Int64;
	import com.netease.protobuf.Message;
	import com.po.User;
	import com.service.ServiceContext;
	import com.service.SocketUserMap;
	import com.xyzdl.core.event.ModuleMessage;
	import com.xyzdl.core.loader.LoaderBean;
	import com.xyzdl.core.utils.AssetUtil;
	import com.xyzdl.core.utils.CoreUtil;

	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class DispatchWorker extends BaseWorker
	{
		private var _toMain:MessageChannel;

		private static var _singleton:DispatchWorker;
		public static function get singleton():DispatchWorker
		{
			_singleton ||= new DispatchWorker();
			return _singleton;
		}

		public function DispatchWorker()
		{
			super();
			_toMain = Worker.current.getSharedProperty("toMain");
			_dispatcher.add(ModuleMessage.SERVER_WORKER_DISPATCH_SOCKET_EVENT, onSocketEvent);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_DELETE_SOCKET, onDeleteSocket);
			var lb:LoaderBean = new LoaderBean();
			lb.loadCompleteHandler = initDb;
			lb.add(AssetUtil.CORE_CONFIG);
			lb.add(AssetUtil.COMMON_CONFIG);
			lb.start();

//			XTimer.add(onHeartbeat, 1000);
		}
		private function initDb():void
		{
			Config.initConf();
			DaoContext.singleton; //初始化数据库
		}
		private var socketId:String;
		private var msgId:int;
		private var msgBytes:ByteArray;
		private var dataBytes:ByteArray;
		private function onSocketEvent(args:Array):void
		{
			socketId = args[0];
			dataBytes = args[1];
			msgId = dataBytes.readInt();
			msgBytes = new ByteArray();
			dataBytes.readBytes(msgBytes);
			dataBytes.clear();
			dataBytes = null;
			CommandContext.addCMD(args[0], msgId, msgBytes);
		}

		private function onDeleteSocket(socketId:String):void
		{
			var user:User = SocketUserMap.getUser(socketId);
			if(user)
				ServiceContext.singleton.chatService.clearUser(user.account);
			SocketUserMap.removeSocket(socketId);
			trace("delete " + socketId);
		}
		
		private function onHeartbeat():void
		{
			var s:S_SYN_HEARTBEAT = new S_SYN_HEARTBEAT();
			s.serverTime = Int64.fromNumber(new Date().getTime());
			send2OppositeEventMsg(ModuleMessage.SERVER_WORKER_CRYPT_ENCRYTP, [-1, packMsg(s)]); //-1表示向所有客户端发送消息
		}

		public static function sendConsoleMsg(content:String):void
		{
			singleton._toMain.send([ModuleMessage.SERVER_WORKER_CONSOLE_MESSAGE, (new Date).toLocaleString() + "#" + content]);
		}
		public static function sendSocketMsg(args:Array):void
		{
			args[1] = packMsg(args[1] as Message);
			singleton.send2OppositeEventMsg(ModuleMessage.SERVER_WORKER_CRYPT_ENCRYTP, args);
		}


		private static var transitBytes:ByteArray = new ByteArray();
		private static var protoBytes:ByteArray = new ByteArray();
		private static function packMsg(msg:Message):ByteArray
		{
			protoBytes.clear();
			transitBytes = CoreUtil.getSharedBytes();
			msg.writeTo(protoBytes);

			var id:int = MessageId[CoreUtil.getClassShortName(msg)];

			transitBytes.writeInt(int(id));
			transitBytes.writeBytes(protoBytes);
			return transitBytes;
		}
	}
}
