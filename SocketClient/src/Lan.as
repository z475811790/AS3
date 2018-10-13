package
{
	import xyzdlcore.constants.CommonConstant;
	import xyzdlcore.utils.AssetUtil;
	import xyzdlcore.utils.CoreUtil;

	import flash.utils.Dictionary;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-10 16:31:05
	 * @description: 语言包
	 */
	public class Lan
	{
		private var _lanDic:Dictionary = new Dictionary();

		private static var _singleton:Lan;
		public static function get singleton():Lan
		{
			_singleton ||= new Lan();
			return _singleton;
		}
		public function Lan()
		{
			init();
		}
		private function init():void
		{
			var obj:Object = CoreUtil.xml2Object(CoreUtil.getResXML(AssetUtil.LANGUAGE_PACKAGE));
			for(var str:String in obj)
				_lanDic[str] = obj[str];
		}
		public function getValueByGroupKey(group:String, key:String):String
		{
			if(!_lanDic[group])
				return group + ":" + key;
			if(_lanDic[group]["p"] == null)
				return key;
			for each(var o:Object in _lanDic[group]["p"])
				if(o["k"] == key)
					return o["v"];
			return key;
		}
		public static function getVal(group:String, key:String):String
		{
			return singleton.getValueByGroupKey(group, key);
		}
		public static function val(key:String):String
		{
			return singleton.getValueByGroupKey(CommonConstant.LANGUAGE_CONSTANT_GROUP, key);
		}
	}
}
