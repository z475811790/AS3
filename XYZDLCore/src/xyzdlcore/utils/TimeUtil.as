package xyzdlcore.utils
{

	public class TimeUtil
	{
		public function TimeUtil()
		{
		}

		private static var date:Date;
		private static function addZero(src:int):String
		{
			return src < 10 ? "0" + src : src + "";
		}
		/**
		 * 时间戳
		 */
		public static function get nowTimeNumber():Number
		{
			return (new Date()).getTime();
		}
		/**
		 * 例如2018-01-12 12:05:30
		 */
		public static function get nowFullTimeString():String
		{
			date = new Date();
			return date.fullYear + "-" + addZero(date.month + 1) + "-" + addZero(date.date) + " " + addZero(date.hours) + ":" + addZero(date.minutes) + ":" + addZero(date.seconds);
		}
		/**
		 * 例如2018-01-12 12:05:30
		 */
		public static function toFullTime(number:Number):String
		{
			date = new Date(number);
			return date.fullYear + "-" + addZero(date.month + 1) + "-" + addZero(date.date) + " " + addZero(date.hours) + ":" + addZero(date.minutes) + ":" + addZero(date.seconds);
		}
		/**
		 * 例如12:05:30
		 */
		public static function toShortTime(number:Number):String
		{
			date = new Date(number);
			return addZero(date.hours) + ":" + addZero(date.minutes) + ":" + addZero(date.seconds);
		}
	}
}
