package com.session
{
	import com.xyzdl.aircore.AirCoreUtil;

	import flash.net.Socket;
	import flash.utils.Dictionary;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-16 17:46:46
	 * @description: 会话容器
	 */
	public class SessionContext
	{
		private var _sessionDic:Dictionary = new Dictionary(); //客户端会话字典
		private var _numSession:int = 0; //会话数量

		private static var _singleton:SessionContext;
		public static function get singleton():SessionContext
		{
			_singleton ||= new SessionContext();
			return _singleton;
		}
		public function SessionContext()
		{
		}
		public static function getSessionBySocket(socket:Socket):XSession
		{
			return singleton._sessionDic[AirCoreUtil.getSocketId(socket)];
		}
		public static function getSessionBySocketId(socketId:String):XSession
		{
			return singleton._sessionDic[socketId];
		}
		public static function getAllSession():Dictionary
		{
			return singleton._sessionDic;
		}
		public static function createSession(socket:Socket):XSession
		{
			var s:XSession = new XSession(socket);
			singleton._sessionDic[AirCoreUtil.getSocketId(socket)] = s;
			singleton._numSession++;
			return s;
		}
		public static function deleteSession(session:XSession):void
		{
			if(!session)
				return;
			var key:String = AirCoreUtil.getSocketIdX(session);
			if(singleton._sessionDic[key])
			{
				session.dispose();
				delete _singleton._sessionDic[key];
				singleton._numSession--;
			}
		}

		public static function get numSession():int
		{
			return singleton._numSession;
		}

		public static function set numSession(value:int):void
		{
			singleton._numSession = value;
		}

	}
}
