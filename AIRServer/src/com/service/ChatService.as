package com.service
{
	import com.dao.ChatInfoDao;
	import com.dao.DaoContext;
	import com.po.ChatInfo;
	import com.po.User;
	
	import flash.utils.Dictionary;

	public class ChatService
	{
		private var _chatInfoDao:ChatInfoDao;
		private var _chatRoomDic:Dictionary = new Dictionary();
		private var rooms:Dictionary = new Dictionary();
		private var _chatRoom:ChatRoom = new ChatRoom();
		public function ChatService()
		{
			_chatInfoDao = DaoContext.singleton.chatInfoDao;
		}
		public function recordMsg(name:String, content:String):void
		{
			var ci:ChatInfo = new ChatInfo();
			ci.ip = name;
			ci.content = content;
			ci.createDate = (new Date()).getTime();
			_chatInfoDao.insert(ci);
			trace(ci.toString());
		}
		public function loginChatRoom(roomNumber:int, user:User):void
		{
			var r:Dictionary;
			if(!_chatRoom.rooms[roomNumber])
			{
				_chatRoom.rooms[roomNumber] = new Dictionary();
			}
			r = _chatRoom.rooms[roomNumber];
			r[user.account] = user;
			_chatRoom.user2Room[user.account] = roomNumber;
		}
		public function getRoomByUser(account:String):Dictionary
		{
			var rn:int = _chatRoom.user2Room[account];
			if(rn > 0)
			{
				var room:Dictionary = _chatRoom.rooms[rn];
				if(room)
					return room;
			}
			return new Dictionary();
		}
		public function getRoomByRoomNumber(roomNumber:int):Dictionary
		{
			var r:Dictionary = _chatRoom.rooms[roomNumber];
			return r ? r : new Dictionary();
		}
		public function clearUser(account:String):void
		{
			var rn:int = _chatRoom.user2Room[account];
			if(rn > 0)
			{
				var room:Dictionary = _chatRoom.rooms[rn];
				if(room[account])
				{
					delete room[account];
				}
			}
			delete _chatRoom.user2Room[account];
		}
	}
}
import flash.utils.Dictionary;

class ChatRoom
{
	public var rooms:Dictionary = new Dictionary();
	public var user2Room:Dictionary = new Dictionary();
}
