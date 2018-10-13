package xyzdlcore.loader
{
	import xyzdlcore.utils.CoreUtil;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-3 9:53:02
	 * @description: Image类图片加载器
	 */

	public class ImageLoaderBean
	{
		private var _url:String;
		private var _loader:Loader;
		private var _loadCompleteHandler:Function;
		public function ImageLoaderBean(url:String, loadCompleteHandler:Function)
		{
			_url = url;
			_loadCompleteHandler = loadCompleteHandler;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadInfoComplete);
			if(CoreUtil.getResBytes(url))
			{
				_loader.loadBytes(CoreUtil.getResBytes(url), App.loaderContext);
			}
			else
			{
				LoaderCore.instance.addListener(LoaderCore.LOAD_ONE_COMPLETE_EVENT, onComplete);
				LoaderCore.instance.loadFile(new LoaderModel(url));
			}
		}
		private function onComplete(url:String):void
		{
			if(url != url)
				return;
			LoaderCore.instance.removeListener(LoaderCore.LOAD_ONE_COMPLETE_EVENT, onComplete);
			_loader.loadBytes(CoreUtil.getResBytes(url), App.loaderContext);
		}
		private function onLoadInfoComplete(e:Event):void
		{
			LoaderCore.instance.bitmapDataDic[_url] = Bitmap(_loader.content).bitmapData;
			if(_loadCompleteHandler)
				_loadCompleteHandler(LoaderCore.instance.bitmapDataDic[_url]);
		}
	}
}
