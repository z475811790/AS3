package test.dao
{
	import com.dao.ChatInfoDao;
	import com.po.ChatInfo;

	public class ChatInfoDaoTest extends BaseDaoTest
	{
		private var chatInfoDao:ChatInfoDao;
		public function ChatInfoDaoTest()
		{
			super();
//			testCaseInsert();
			testCaseQueryAll();
		}

		override public function after():void
		{
			super.after();
		}

		override public function before():void
		{
			super.before();
			chatInfoDao = dc.chatInfoDao;
		}

		override protected function testCaseDelete():void
		{
		}

		override protected function testCaseInsert():void
		{
			var ci:ChatInfo = new ChatInfo();
			ci.ip = "192.168.1.1:80";
			ci.content = "你好";
			ci.createDate = (new Date).getTime();
			chatInfoDao.insert(ci);
		}

		override protected function testCaseQueryAll():void
		{
			for each(var ci:ChatInfo in chatInfoDao.queryAll())
				trace(ci.toString());
		}

		override protected function testCaseUpdate():void
		{
		}
	}
}
