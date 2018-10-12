package com.service
{

	public class ServiceContext
	{
		private static var _singleton:ServiceContext;
		public static function get singleton():ServiceContext
		{
			_singleton ||= new ServiceContext();
			return _singleton;
		}
		public function ServiceContext()
		{
			chatService = new ChatService();
			loginService = new LoginService();
		}
		public var chatService:ChatService;
		public var loginService:LoginService;
	}
}
