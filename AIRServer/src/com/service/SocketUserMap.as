package com.service
{
	import com.po.User;

	import flash.utils.Dictionary;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-19 15:32:52
	 * @description: Socket与User的映射类
	 */
	public class SocketUserMap
	{
		private var user2SocketId:Dictionary = new Dictionary();
		private var socket2User:Dictionary = new Dictionary();

		private static var _singleton:SocketUserMap;
		public static function get singleton():SocketUserMap
		{
			_singleton ||= new SocketUserMap();
			return _singleton;
		}

		public static function getSocketId(account:String):String
		{
			return singleton.user2SocketId[account];
		}
		public static function getUser(socketId:String):User
		{
			return singleton.socket2User[socketId];
		}
		public static function addSocket(socketId:String, user:User):void
		{
			singleton.socket2User[socketId] = user;
			singleton.user2SocketId[user.account] = socketId;
		}
		public static function removeSocket(socketId:String):void
		{
			var u:User = singleton.socket2User[socketId];
			if(u)
				delete singleton.user2SocketId[u.account];
			delete singleton.socket2User[socketId];
		}
	}
}

