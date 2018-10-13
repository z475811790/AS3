package xyzdlcore.loader
{
	import flash.net.URLLoader;

	public class LoaderModel
	{
		public function LoaderModel(url:String, loader:URLLoader = null, state:Boolean = false, count:int = 1)
		{
			this.url = url;
			this.loader = loader;
			this.state = state;
			this.count = count;
		}
		public var url:String;
		public var loader:URLLoader;
		public var state:Boolean;
		public var count:int;
	}
}
