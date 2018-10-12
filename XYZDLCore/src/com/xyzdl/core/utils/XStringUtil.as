package com.xyzdl.core.utils
{

	public class XStringUtil
	{
		/**
		 * 去掉最后一个字符
		 */
		public static function trimEndChar(str:String):String
		{
			return str.substr(0, str.length - 1);
		}
		/**
		 * {0},{1},{2}替换成相应参数
		 */
		public static function format(str:String, ... args):String
		{
			var len:int = args.length;
			for(var i:int = 0; i < len; i++)
			{
				str = str.replace("{" + i + "}", args[i]);
			}
			return str;
		}
		/**
		 * 驼峰格式字符串转换为下划线格式字符串,结果为全小写字母
		 */
		public static function camel2Underline(str:String):String
		{
			if(!str)
				return "";
			var dis:String = "";
			for(var i:int = 0; i < str.length; i++)
			{
				if(isUpperCase(str.charAt(i)))
				{
					dis += "_";
					dis += str.charAt(i).toLowerCase();
				}
				else
				{
					dis += str.charAt(i);
				}
			}
			return dis;
		}
		/**
		 * 下划线格式字符串转换为驼峰格式字符串
		 */
		public static function underline2Camel(str:String):String
		{
			if(!str)
				return "";
			var dis:String = "";
			for(var i:int = 0; i < str.length; i++)
			{
				if(str.charAt(i) == "-")
				{
					if(++i < str.length)
						dis += str.charAt(i).toUpperCase();
				}
				else
				{
					dis += str.charAt(i).toLowerCase();
				}
			}
			return dis;
		}
		public static function isUpperCase(char:String):Boolean
		{
			if(char.length == 1 && char >= 'A' && char <= "Z")
				return true;
			return false;
		}
		public static function isLowerCase(char:String):Boolean
		{
			if(char.length == 1 && char >= 'a' && char <= "z")
				return true;
			return false;
		}
	}
}
