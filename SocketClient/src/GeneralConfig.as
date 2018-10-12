package
{

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-10 13:26:09
	 * @description: 一般配置,根据应用具体情况所需要的配置
	 */
	public class GeneralConfig
	{
		private var _conf:Object;

		private static var _singleton:GeneralConfig;
		public static function get singleton():GeneralConfig
		{
			_singleton ||= new GeneralConfig();
			return _singleton;
		}
		public function GeneralConfig()
		{
		}
		public function init(conf:Object):void
		{
			_conf = conf;
		}
	}
}
