package com.command
{

	import com.message.C_LoginChat;
	import com.message.S_ChatMsg;
	import com.message.S_LoginChat;
	import com.po.User;
	import com.service.ServiceContext;
	import com.service.SocketUserMap;
	import com.worker.DispatchWorker;
	import xyzdlcore.event.ModuleMessage;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class LoginChatCMD extends BaseCommand
	{
		private var c:C_LoginChat;
		public function LoginChatCMD(socketId:String, bytes:ByteArray)
		{
			super(socketId, bytes);
			c = new C_LoginChat();
			c.mergeFrom(bytes);
		}

		override public function dispose():void
		{
			super.dispose();
		}

		override public function execute():void
		{
			super.execute();

			ServiceContext.singleton.chatService.loginChatRoom(c.roomNumber, SocketUserMap.getUser(socketId));

			var sl:S_LoginChat = new S_LoginChat();
			sl.roomNumber = c.roomNumber;
			DispatchWorker.sendSocketMsg([[socketId], sl]);

			var room:Dictionary = ServiceContext.singleton.chatService.getRoomByRoomNumber(c.roomNumber);
			var socketIds:Array = [];
			for each(var u:User in room)
				socketIds.push(SocketUserMap.getSocketId(u.account));
			var s:S_ChatMsg = new S_ChatMsg();
			s.content = SocketUserMap.getUser(socketId).account + " 进入房间 " + c.roomNumber;
			s.name = "系统";
			s.date = (new Date).getTime().toString();
			DispatchWorker.sendSocketMsg([socketIds, s]);

			dispose();
		}

	}
}
