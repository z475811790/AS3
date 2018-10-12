package com.command
{
	import com.message.C_ChatMsg;
	import com.message.S_ChatMsg;
	import com.po.User;
	import com.service.ServiceContext;
	import com.service.SocketUserMap;
	import com.worker.DispatchWorker;
	import com.xyzdl.core.utils.TimeUtil;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ChatMsgCMD extends BaseCommand
	{
		private var c:C_ChatMsg;
		public function ChatMsgCMD(socketId:String, bytes:ByteArray)
		{
			super(socketId, bytes);
			c = new C_ChatMsg();
			c.mergeFrom(bytes);
		}

		override public function dispose():void
		{
			super.dispose();
		}

		override public function execute():void
		{
			super.execute();

			ServiceContext.singleton.chatService.recordMsg(c.name, c.content);
			DispatchWorker.sendConsoleMsg(c.name + ":" + c.content);

			var room:Dictionary = ServiceContext.singleton.chatService.getRoomByUser(SocketUserMap.getUser(socketId).account);
			var socketIds:Array = [];
			for each(var u:User in room)
				socketIds.push(SocketUserMap.getSocketId(u.account));
			var s:S_ChatMsg = new S_ChatMsg();
			s.content = c.content;
			s.name = c.name;
			s.date = (new Date).getTime().toString();
			DispatchWorker.sendSocketMsg([socketIds, s]);

			dispose();
		}
	}
}
