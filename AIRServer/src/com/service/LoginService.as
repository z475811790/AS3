package com.service
{
	import com.dao.DaoContext;
	import com.dao.UserDao;
	import com.po.User;

	public class LoginService
	{
		private var userDao:UserDao;
		public function LoginService()
		{
			userDao = DaoContext.singleton.userDao;
		}
		public function login(account:String, password:String):User
		{
			var u:User = userDao.findUserByAccount(account);
			if(!u)
			{
				u = new User();
				u.account = account;
				u.password = "123456";
				u.isAdmin = 0;
				u.createDate = (new Date).getTime();
				userDao.insert(u);
			}
			return u;
		}
	}
}
