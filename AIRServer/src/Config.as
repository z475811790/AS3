package
{
	import xyzdlcore.utils.AssetUtil;
	import xyzdlcore.utils.CoreUtil;

	public class Config
	{
		public static const SERVER_VERSION:String = "1.2"; //服务器版本
		public static const COMMUNICATION_PROTOCOL_VERSION:int = 1;
		public static var challenge:int = 0;
		public static var logFilePath:String = "";
		public static var host:String = "";
		public static var port:int = 0;
		public static var dbFile:String = "";
		public static var dataTablePrefix:String = "";
		public static var poPackagePrefix:String = "";
		public function Config()
		{
		}
		public static function initConf(obj:Object = null):void
		{
			if(obj == null)
				CoreUtil.parseConf(Config, AssetUtil.COMMON_CONFIG);
			else
				CoreUtil.parseConfByObject(Config, obj);
		}
	}
}
