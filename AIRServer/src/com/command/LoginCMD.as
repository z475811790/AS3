package com.command
{
	import com.message.C_Login;
	import com.message.S_Login;
	import com.po.User;
	import com.service.ServiceContext;
	import com.service.SocketUserMap;
	import com.worker.DispatchWorker;

	import flash.utils.ByteArray;

	public class LoginCMD extends BaseCommand
	{
		private var c:C_Login;
		public function LoginCMD(socketId:String, bytes:ByteArray)
		{
			super(socketId, bytes);
			c = new C_Login();
			c.mergeFrom(bytes);
		}

		override public function dispose():void
		{
			super.dispose();
		}

		override public function execute():void
		{
			super.execute();

			var u:User = ServiceContext.singleton.loginService.login(c.account, c.password);
			SocketUserMap.addSocket(socketId, u);
			var s:S_Login = new S_Login();
			s.account = c.account;
			s.isSuccessful = true;
			s.msg = "登录成功";
			DispatchWorker.sendConsoleMsg(s.account + " 登录成功");
			DispatchWorker.sendSocketMsg([[socketId], s]);

			dispose();
		}
	}
}
