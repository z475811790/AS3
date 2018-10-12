package test.dao
{
	import com.dao.UserDao;
	import com.po.User;


	public class UserDaoTest extends BaseDaoTest
	{
		private var userDao:UserDao;
		public function UserDaoTest()
		{
			super();
			testCaseQueryAll();
			testCaseUpdate();
			testCaseInsert();
			testCaseFindByAccount();
			after();
		}
		override public function before():void
		{
			super.before();
			userDao = dc.userDao;
		}
		override public function after():void
		{
			super.after();
		}

		override protected function testCaseDelete():void
		{
		}

		override protected function testCaseInsert():void
		{
			var u:User = new User();
			u.account = "mmm";
			u.createDate = 1246514546;
			u.id = 45;
			u.isAdmin = 1;
			u.password = "dsag";
			trace(u.toString());
			var id:int = userDao.insert(u);
			trace(id);
//			id = userDao.deleteById(id);
			trace(id);
		}

		override protected function testCaseQueryAll():void
		{
			for each(var u:User in userDao.queryAll())
				trace(u.toString());
		}

		override protected function testCaseUpdate():void
		{
		}
		private function testCaseFindByAccount():void
		{
			var u:User = userDao.findUserByAccount("mmm");
			if(u)
				trace(u.toString());
		}
	}
}
