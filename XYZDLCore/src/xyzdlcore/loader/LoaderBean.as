package xyzdlcore.loader
{

	public class LoaderBean
	{
		private var _loadQueue:Vector.<LoaderModel> = new Vector.<LoaderModel>();
		public var loadCompleteHandler:Function
		public function LoaderBean()
		{
		}
		public function add(url:String):void
		{
			if(!hasUrl(url))
				_loadQueue.push(new LoaderModel(url));
		}
		public function start():void
		{
			LoaderCore.instance.addListener(LoaderCore.LOAD_ONE_COMPLETE_EVENT, onComplete);
			for each(var model:LoaderModel in _loadQueue)
			{
				LoaderCore.instance.loadFile(model);
			}
		}
		/**
		 * 核心加载器每加载完成一个资源会调用该事件
		 */
		private function onComplete(url:String):void
		{
			for each(var model:LoaderModel in _loadQueue)
			{
				if(model.url == url && loadCompleteHandler && isLoadFinished())
				{
					LoaderCore.instance.removeListener(LoaderCore.LOAD_ONE_COMPLETE_EVENT, onComplete);
					loadCompleteHandler();
					break;
				}
			}
		}
		private function isLoadFinished():Boolean
		{
			var mark:Boolean = true;
			for each(var model:LoaderModel in _loadQueue)
			{
				if(!model.state)
				{
					mark = false;
					break;
				}
			}
			return mark;
		}
		private function hasUrl(url:String):Boolean
		{
			var mark:Boolean = false;
			for each(var model:LoaderModel in _loadQueue)
			{
				if(model.url == url)
				{
					mark = true;
					break;
				}
			}
			return mark;
		}
	}
}
