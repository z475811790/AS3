package com.xyzdl.core.utils
{
	import flash.net.SharedObject;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-17 19:04:19
	 * @description: 缓存对象工具
	 */
	public class SharedObjectUtil
	{
		private static const CACHE_MARK:String = "xYzDlAS3";
		public function SharedObjectUtil()
		{
		}
		public static function setKeyValue(key:String, value:*):void
		{
			var so:SharedObject = SharedObject.getLocal(CACHE_MARK);
			so.data[key] = value;
			try
			{
				so.flush();
			}
			catch(error:Error)
			{
				trace(error.message);
			}
		}
		public static function getKeyValue(key:String):*
		{
			var so:SharedObject = SharedObject.getLocal(CACHE_MARK);
			if(so.data[key] != null)
				return so.data[key];
			return null;
		}
	}
}
