package com.core
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class AirFileLoader
	{
		private static var appDir:File = File.applicationDirectory; //当前应用目录
		public function AirFileLoader()
		{
		}
		/**
		 * 加载指定xml文件
		 */
		public static function loadXML(path:String):XML
		{
			var xml:XML;
			var fileStream:FileStream = loadFile(path, FileMode.READ);
			xml = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			fileStream = null;
			return xml;
		}
		/**
		 * 获取日志文件
		 */
		public static function getLogFileStream(path:String):FileStream
		{
			return loadFile(path, FileMode.APPEND);
		}
		/**
		 * 以文件流方式加载文件
		 */
		private static function loadFile(path:String, fileMode:String):FileStream
		{
			var file:File = new File(appDir.resolvePath(path).nativePath);
			if(fileMode == FileMode.READ && !file.exists)
				throw new Error("FILE: " + path + " NOT EXISTS");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, fileMode);
			return fileStream;
		}
	}
}
