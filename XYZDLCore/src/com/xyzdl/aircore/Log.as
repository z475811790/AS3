package com.xyzdl.aircore
{
	import com.xyzdl.core.utils.TimeUtil;

	import flash.filesystem.FileStream;

	public class Log
	{
		private static var logFileStream:FileStream;
		public function Log()
		{
		}
		/**
		 * 初始化日志文件流
		 */
		public static function initLog(logUrl:String):void
		{
			logFileStream = AirFileLoader.getLogFileStream(logUrl);
		}
		/**
		 * 添加日志
		 */
		public static function add(msg:String):void
		{
			logFileStream.writeUTFBytes(TimeUtil.nowFullTimeString + "##" + msg + "\r\n");
		}
	}
}
