package com.dao
{
	import com.core.PropertyInfo;
	import xyzdlcore.utils.CoreUtil;
	import xyzdlcore.utils.XStringUtil;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-27 20:51:39
	 * @description: dao类必须放在dao包之内,且必须以'po类名+Dao'的格式命名
	 * 数据表命名以配置中的前缀加po类名小写命名
	 */
	public class BaseDao
	{
		protected var _conn:SQLConnection; //数据库连接
		protected var _poName:String; //对应po类名
		protected var _tableName:String; //表名
		protected var _poClass:Class; //对应po类
		protected var _fields4Select:String = ""; //查询语句对应po的所有字段
		protected var _fields4Update:String = ""; //更新语句对应po的所有字段
		protected var _fields4Insert:String = "("; //插入语句对应po的所有字段
		protected var _pis:Array = []; //属性信息
		protected var _sqlResult:SQLResult;

		protected var _queryAllSt:SQLStatement = new SQLStatement(); //查询所有
		protected var _updateByIdSt:SQLStatement = new SQLStatement(); //更新
		protected var _deleteByIdSt:SQLStatement = new SQLStatement(); //删除
		protected var _insertSt:SQLStatement = new SQLStatement(); //插入
		public function BaseDao(conn:SQLConnection)
		{
			_conn = conn;
			var str:String = CoreUtil.getClassShortName(this);
			_poName = str.substr(0, str.length - 3);
			_tableName = Config.dataTablePrefix + XStringUtil.camel2Underline(_poName).substring(1);
			_poClass = getDefinitionByName(Config.poPackagePrefix + _poName) as Class;
			_pis = DaoContext.poDic[getQualifiedClassName(_poClass)];

			var valueStr:String = " VALUES(";
			for each(var pi:PropertyInfo in _pis)
			{
				_fields4Select += pi.name + ",";
				if(pi.name != "id")
				{
					_fields4Update += pi.name + "=@" + pi.name + ",";
					_fields4Insert += pi.name + ",";
					valueStr += "@" + pi.name + ",";
				}
			}
			_fields4Select = XStringUtil.trimEndChar(_fields4Select);
			_fields4Update = XStringUtil.trimEndChar(_fields4Update);
			_fields4Insert = XStringUtil.trimEndChar(_fields4Insert);
			_fields4Insert += ")";
			valueStr = valueStr.substr(0, valueStr.length - 1);
			valueStr += ")";
			_fields4Insert += valueStr;
			iniBaseSts();
		}


		//------START-事件注册区
		protected function onError(e:Event):void
		{
			trace(e);
		}
		//------END---事件注册区
		//------START-公共方法区
		protected var sre:SQLResult;
		public function queryAll():Array
		{
			_queryAllSt.execute();
			_sqlResult = _queryAllSt.getResult();
			return _sqlResult.data ? _sqlResult.data : [];
		}
		public function update(obj:Object):int
		{
			for each(var pi:PropertyInfo in _pis)
				_updateByIdSt.parameters["@" + pi.name] = obj[pi.name];
			_updateByIdSt.execute();
			_sqlResult = _updateByIdSt.getResult();
			return _sqlResult.rowsAffected;
		}
		public function insert(obj:Object):int
		{
			for each(var pi:PropertyInfo in _pis)
				if(pi.name != "id")
					_insertSt.parameters["@" + pi.name] = obj[pi.name];
			_insertSt.execute();
			_sqlResult = _insertSt.getResult();
			return _sqlResult.lastInsertRowID;
		}
		public function deleteById(id:int):int
		{
			_deleteByIdSt.parameters["@id"] = id;
			_deleteByIdSt.execute();
			_sqlResult = _deleteByIdSt.getResult();
			return _sqlResult.rowsAffected;
		}
		//------END---公共方法区
		//------START-私有方法区
		private function iniBaseSts():void
		{
			_queryAllSt.sqlConnection = _conn;
			_queryAllSt.text = "SELECT " + _fields4Select + " FROM " + _tableName;
			_queryAllSt.itemClass = _poClass;

			_updateByIdSt.sqlConnection = _conn;
			_updateByIdSt.text = "UPDATE " + _tableName + " SET " + _fields4Update + " WHERE id=@id";

			_insertSt.sqlConnection = _conn;
			_insertSt.text = "INSERT INTO " + _tableName + _fields4Insert;

			_deleteByIdSt.sqlConnection = _conn;
			_deleteByIdSt.text = "DELETE FROM " + _tableName + " WHERE id=@id";
		}
		//------END---私有方法区
	}
}
