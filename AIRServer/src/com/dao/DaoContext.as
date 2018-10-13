package com.dao
{

	import com.hurlant.util.Base64;
	import com.po.ChatInfo;
	import com.po.User;
	import com.core.AirCoreUtil;
	
	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-27 16:36:58
	 * @description: 数据库上下文
	 */
	public class DaoContext
	{
		private var _conn:SQLConnection;
		public static var poDic:Dictionary = new Dictionary();
		
		private static var _singleton:DaoContext;
		public static function get singleton():DaoContext
		{
			_singleton ||= new DaoContext();
			return _singleton;
		}
		public function DaoContext()
		{
			var dbFile:File = new File(File.applicationDirectory.resolvePath(Config.dbFile).nativePath);
			_conn = new SQLConnection();
			_conn.addEventListener(SQLErrorEvent.ERROR, onError);
			_conn.open(dbFile);
			trace("Database[" + Config.dbFile + "] is Open.");
			registerPos();
			initDao();
		}
		//------START-事件注册区
		private function onError(e:Event):void
		{
			Console.addMsg(e.toString());
		}
		//------END---事件注册区
		//------START-公共方法区
		private var _userDao:UserDao;
		public function get userDao():UserDao
		{
			return _userDao;
		}
		private var _chatInfoDao:ChatInfoDao;
		public function get chatInfoDao():ChatInfoDao
		{
			return _chatInfoDao;
		}
		//------END---公共方法区
		//------START-私有方法区
		/**
		 * 所有po必须在这里注册
		 */
		private function registerPos():void
		{
			poDic[getQualifiedClassName(User)] = AirCoreUtil.parse4PropertyInfos(User);
			poDic[getQualifiedClassName(ChatInfo)] = AirCoreUtil.parse4PropertyInfos(ChatInfo);
		}
		private function initDao():void
		{
			_userDao = new UserDao(_conn);
			_chatInfoDao = new ChatInfoDao(_conn);
		}
		//------END---私有方法区
	}
}
