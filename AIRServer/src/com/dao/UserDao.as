package com.dao
{

	import com.po.User;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;

	public class UserDao extends BaseDao
	{
		private var _findUserByAccountSt:SQLStatement;
		public function UserDao(conn:SQLConnection)
		{
			super(conn);
			_findUserByAccountSt = new SQLStatement();
			_findUserByAccountSt.sqlConnection = conn;
			_findUserByAccountSt.text = "SELECT " + _fields4Select + " FROM " + _tableName + " WHERE account=@account";
			_findUserByAccountSt.itemClass = User;
		}
		public function findUserByAccount(account:String):User
		{
			_findUserByAccountSt.parameters["@account"] = account;
			_findUserByAccountSt.execute();
			_sqlResult = _findUserByAccountSt.getResult();
			if(!_sqlResult.data || !_sqlResult.data.length)
				return null;
			return _sqlResult.data[0];
		}
	}
}
