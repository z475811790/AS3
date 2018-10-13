package
{
	import xyzdlcore.utils.AssetUtil;
	import xyzdlcore.utils.CoreUtil;


	public class CoreConfig
	{
		public static const IS_DEBUG:Boolean = true; //调试模式否
		public static var appDomain:String = "";
		public static var dataCompress:Boolean = true; //消息数据压缩否

		public function CoreConfig()
		{
		}
		/**
		 * 通过反射机制读取核心配置,key大小一定要一致Config中定义的变量一定要在配置中能找到对应定义
		 */
		public static function initConf(obj:Object = null):void
		{
			if(obj == null)
				CoreUtil.parseConf(CoreConfig, AssetUtil.CORE_CONFIG);
			else
				CoreUtil.parseConfByObject(CoreConfig, obj);
		}
	}
}
