package test.dao
{
	import com.dao.DaoContext;

	import test.BaseTest;

	public class BaseDaoTest extends BaseTest
	{
		protected var dc:DaoContext;
		public function BaseDaoTest()
		{
			dc = DaoContext.singleton;
			super();
		}
		protected function testCaseQueryAll():void
		{
		}
		protected function testCaseUpdate():void
		{
		}
		protected function testCaseInsert():void
		{
		}
		protected function testCaseDelete():void
		{
		}
	}
}
