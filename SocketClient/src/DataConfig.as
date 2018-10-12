package
{
	import com.conf.ChatInfo;
	import com.conf.Item;
	import com.conf.User;
	import com.xyzdl.core.utils.AssetUtil;
	import com.xyzdl.core.utils.CoreUtil;

	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-17 13:38:52
	 * @description: 数据库配置数据类
	 */
	public class DataConfig
	{
		private static const PREFIX:String = "DataConf:";
		private var _dataConf:Dictionary;
		private static var _singleton:DataConfig;
		public static function get singleton():DataConfig
		{
			_singleton ||= new DataConfig();
			return _singleton;
		}
		public function DataConfig()
		{
			init();
		}
		private function init():void
		{
			registerClass();
			var xml:XML = CoreUtil.getResXML(AssetUtil.DATA_CONFIG);
			var map:Dictionary = new Dictionary();
			for each(var cell:XML in xml.children())
			{
				var className:String = cell.name();
				var klass:Class = getClassByAlias(PREFIX + className);
				var typeDic:Dictionary = genClassDef(new klass());
				var fName:String;
				var rows:Array = [];
				var i:int = 0;
				var index:int = 0;
				for(i = 0; i < cell.children().length(); i++)
				{
					rows.push(new klass());
				}
				for each(fName in cell.attributes())
				{
					switch(typeDic[fName])
					{
						case "int":
						{
							for(i = 0; i < cell.children().length(); i++)
								rows[i][fName] = int(cell.children()[i].children()[index].valueOf());
							break;
						}
						case "String":
						{
							for(i = 0; i < cell.children().length(); i++)
								rows[i][fName] = String(cell.children()[i].children()[index].valueOf());
							break;
						}
						case "Boolean":
						{
							for(i = 0; i < cell.children().length(); i++)
								rows[i][fName] = Boolean(cell.children()[i].children()[index].valueOf());
							break;
						}
						case "Number":
						{
							for(i = 0; i < cell.children().length(); i++)
								rows[i][fName] = Number(cell.children()[i].children()[index].valueOf());
							break;
						}
					}
					index++;
				}
				map[className] = rows;
			}
			_dataConf = map;
		}
		private function genClassDef(obj:Object):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var vars:XMLList = describeType(obj).variable;
			for each(var e:XML in vars)
				dic[String(e.@name)] = String(e.@type);
			return dic;
		}
		private function registerClass():void
		{
			registerClassAlias(PREFIX + CoreUtil.getClassShortName(Item), Item);
			registerClassAlias(PREFIX + CoreUtil.getClassShortName(ChatInfo), ChatInfo);
			registerClassAlias(PREFIX + CoreUtil.getClassShortName(User), User);
		}
	}
}
