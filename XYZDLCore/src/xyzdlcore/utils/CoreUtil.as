package xyzdlcore.utils
{
	import xyzdlcore.loader.LoaderCore;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class CoreUtil
	{
		public function CoreUtil()
		{
		}

		public static function getResBytes(url:String):ByteArray
		{
			return LoaderCore.instance.resourceDic[url];
		}

		public static function getBitmapData(url:String):BitmapData
		{
			return LoaderCore.instance.bitmapDataDic[url];
		}

		public static function getResXML(url:String):XML
		{
			return getResBytes(url) ? XML(getResBytes(url)) : null;
		}

		public static function parseConf(staticInstance:Object, confUrl:String):void
		{
			var confxml:XML = getResXML(confUrl);
			var obj:Object = xml2Object(confxml);
			var vars:XMLList = describeType(staticInstance).variable;
			for each(var e:XML in vars)
				staticInstance[e.@name] = obj[e.@name].val;
		}
		
		public static function parseConfByObject(staticInstance:Object, obj:Object):void
		{
			var vars:XMLList = describeType(staticInstance).variable;
			for each(var e:XML in vars)
				staticInstance[e.@name] = obj[e.@name];
		}

		/**
		 * 将xml解析成一个动态object对象
		 * 注意:xml的第一级元素名字必须不相同,第二级以后元素名字可以重复
		 */
		public static function xml2Object(xml:XML):Object
		{
			var obj:Object = {};
			var nodes:XMLList = xml.children();
			for(var i:int = 0; i < nodes.length(); i++)
				obj[nodes[i].name().localName] = parseNode(nodes[i]);
			return obj;
		}
		private static function parseNode(xml:XML):Object
		{
			var obj:Object = nodes2Objcet(xml.children());
			var ao:Object = {};
			for each(var x:XML in xml.attributes())
				ao[x.name().localName] = typeFormat(x.valueOf());
			for(var str:String in ao)
				obj[str] = ao[str];
			return obj;
		}
		private static function nodes2Objcet(xmlList:XMLList):Object
		{
			var obj:Object = {};
			for each(var x:XML in xmlList)
			{
				if(!(x.name().localName in obj))
					obj[x.name().localName] = [];
				obj[x.name().localName].push(parseNode(x));
			}
			return obj;
		}
		private static function typeFormat(str:String):*
		{
			if(str.search(/^(\-|\+)?\d+$/) == 0)
				return int(str);
			else if(str.search(/^(\-|\+)?\d+(\.\d+)?$/) == 0)
				return Number(str);
			else if(str.search(/^0[xX][A-Fa-f0-9]+$/) == 0)
				return Number(str);
			else if(str == "true")
				return true;
			else if(str == "false")
				return false;
			else
				return str;
		}

		private static var sharedBytes:ByteArray;
		public static function getSharedBytes(src:ByteArray = null):ByteArray
		{
			sharedBytes = new ByteArray();
			sharedBytes.shareable = true;
			if(src)
			{
				src.position = 0;
				sharedBytes.writeBytes(src);
			}
			return sharedBytes;
		}

		public static function getClassShortName(obj:*):String
		{
			var name:String = getQualifiedClassName(obj);
			if(name.indexOf("::") > -1)
				return name.split("::")[1];
			else
				return name;
		}
	}
}
