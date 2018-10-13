package com.module.chat
{
	import com.message.C_ChatMsg;
	import com.message.C_Login;
	import com.message.C_LoginChat;
	import com.message.S_ChatMsg;
	import com.message.S_Login;
	import com.message.S_LoginChat;
	import com.message.MessageEnum.MessageId;
	import com.module.BaseController;
	import com.netease.protobuf.Message;
	import xyzdlcore.utils.TimeUtil;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	public class ChatController extends BaseController
	{
		private static var _singleton:ChatController;
		public static function get singleton():ChatController
		{
			_singleton ||= new ChatController;
			return _singleton;
		}
		public function ChatController()
		{
			super();
			Console.singleton.onInputHandler = onInput;
		}
		override protected function initListeners():void
		{
			// TODO Auto Generated method stub
			super.initListeners();
			addSocketListener(MessageId.S_ChatMsg, onChatMsgBack);
			addSocketListener(MessageId.S_Login, onLoginBack);
			addSocketListener(MessageId.S_LoginChat, onLoginChatRoomBack);
		}
		//------START-事件注册区
		private function onChatMsgBack(bytes:ByteArray):void
		{
			var s:S_ChatMsg = new S_ChatMsg();
			s.mergeFrom(bytes);

			Console.addMsg(s.name + "#" + TimeUtil.toShortTime(Number(s.date)) + "#" + s.content);
		}
		private function onLoginBack(bytes:ByteArray):void
		{
			var s:S_Login = new S_Login();
			s.mergeFrom(bytes);
			if(!s.isSuccessful)
			{
				Console.addMsg(Lan.val("1003") + s.msg);
				return;
			}
			Console.addMsg(Lan.val("1004"));
			userName = s.account;
			Console.addMsg(Lan.val("1005") + userName);
			Console.addMsg(Lan.val("1006"));
		}
		private function onLoginChatRoomBack(bytes:ByteArray):void
		{
			var s:S_LoginChat = new S_LoginChat();
			s.mergeFrom(bytes);
			roomNumber = s.roomNumber;
		}
		private var userName:String = "";
		private var roomNumber:int = 0;
		private function onInput(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				if(!e.currentTarget.text)
				{
					return;
				}
				if(!userName)
				{
					var l:C_Login = new C_Login();
					l.account = e.currentTarget.text;
					l.password = "123456";
					sendSocketMessage(l);
					e.currentTarget.text = "";
					return;
				}
				if(roomNumber == 0)
				{
					var rn:int = parseInt(e.currentTarget.text);
					if(!rn || rn <= 0)
					{
						Console.addMsg(Lan.val("1007"));
						return;
					}
					var cr:C_LoginChat = new C_LoginChat();
					cr.roomNumber = rn;
					sendMsg(cr);
					e.currentTarget.text = "";
					return;
				}
				var c:C_ChatMsg = new C_ChatMsg();
				c.name = userName;
				c.content = e.currentTarget.text;
				sendMsg(c);
				e.currentTarget.text = "";
				trace("C_Send_Time:"+TimeUtil.nowTimeNumber);
			}
		}
		//------END---事件注册区
		//------START-公共方法区
		//------END---公共方法区
		//------START-私有方法区
		private function sendMsg(msg:Message):void
		{
			if(!userName)
			{
				Console.addMsg(Lan.val("1008"));
				return;
			}
			sendSocketMessage(msg);
		}
		private function loginCheck():Boolean
		{

			return true;
		}
		//------END---私有方法区
	}
}
