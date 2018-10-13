package
{
	import xyzdlcore.utils.AssetUtil;
	import xyzdlcore.utils.CoreUtil;

	public class Config
	{
		public static const CLIENT_VERSION:String = "1.2"; //客户端版本
		public static const COMMUNICATION_PROTOCOL_VERSION:int = 1;

		public static var appDomain:String = "";
		public static var host:String = "";
		public static var port:int = 0;
		public static var autoTimeoutReconnect:Boolean = true;
		public function Config()
		{
		}
		public static function initConf():void
		{
			CoreUtil.parseConf(Config, AssetUtil.COMMON_CONFIG);
		}
	}
}
