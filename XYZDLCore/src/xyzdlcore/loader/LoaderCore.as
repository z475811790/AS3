package xyzdlcore.loader
{
	import xyzdlcore.interfaces.IDispatcher;
	import xyzdlcore.modules.Dispatcher;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-11-01 15:11:42
	 * @description: 文件加载
	 */
	public class LoaderCore implements IDispatcher
	{
		//----资源加载相关事件----START
		public static const LOAD_ONE_COMPLETE_EVENT:String = "LOAD_ONE_COMPLETE_EVENT"; //单个资源加载完成(一次加载操作可以加载多个资源)
		public static const LOAD_ONE_MAXTIME_EVENT:String = "LOAD_ONE_MAXTIME_EVENT"; //单个资源加载失败次数已达最大值
		//----资源加载相关事件----END
		public static const RELOAD_MAX_COUNT:int = 3; //加载失败重载最大次数

		private var loaderModels:Vector.<LoaderModel> = new Vector.<LoaderModel>(); // 设置一个数组，用来描述正在加载中的外部文件
		private var numLoaderError:int = 0; // 设置一个计数器，描述加载出错的文件数量
		public var resourceDic:Dictionary = new Dictionary(); //资源字典
		public var bitmapDataDic:Dictionary = new Dictionary(); //图片bitmapData资源字典
		private var _dispatcher:Dispatcher = new Dispatcher(); //加载核心内部事件派发器

		private static var _instance:LoaderCore;
		public static function get instance():LoaderCore
		{
			_instance ||= new LoaderCore();
			return _instance;
		}

		public function LoaderCore()
		{
		}
		//------START-事件注册区
		//------END---事件注册区
		//------START-公共方法区
		public function loadFile(loaderModel:LoaderModel):void
		{
			if(resourceDic[loaderModel.url])
			{
				dispatch(LOAD_ONE_COMPLETE_EVENT, [loaderModel.url]);
				return;
			}
			reloadFile(loaderModel);
		}
		public function addListener(eventType:String, listener:Function):void
		{
			_dispatcher.add(eventType, listener);
		}
		public function removeListener(eventType:String, listener:Function):void
		{
			_dispatcher.remove(eventType, listener);
		}
		public function dispatch(eventType:String, args:Array = null):void
		{
			_dispatcher.dispatch(eventType, args);
		}
		//------END---公共方法区
		//------START-私有方法区
		private function reloadFile(loaderModel:LoaderModel):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var urlReq:URLRequest = new URLRequest(loaderModel.url);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.OPEN, onOpen);
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderModel.loader = urlLoader;
			loaderModels.push(loaderModel);
			urlLoader.load(urlReq);
		}
		private function onOpen(e:Event):void
		{
			trace("start to load");
		}
		private function onComplete(e:Event):void
		{
			// 引用事件触发的 URLLoader 对象  
			var urlLoader:URLLoader = e.target as URLLoader;
			// 遍历数组中的对象  

			var model:LoaderModel = getLoaderModel(urlLoader);
			if(!model)
				return;
			model.state = true;

			resourceDic[model.url] = urlLoader.data;

			trace("Load Completed##URL: " + model.url);

			// 按加载状态 stats 排序  
			loaderModels.sort(compareFunction4LoaderModelOnState);
			// 删除数组中最后一个元素，即加载成功的信息  
			loaderModels.pop();
			dispatch(LOAD_ONE_COMPLETE_EVENT, [model.url]);
			// 校验是否需要进行重加载  
			if((numLoaderError == loaderModels.length) && (numLoaderError > 0))
				reload();
		}
		private function onLoadError(e:IOErrorEvent):void
		{
			numLoaderError++;
			// 校验是否需要进行重加载  
			if((numLoaderError == loaderModels.length) && (numLoaderError > 0))
				reload();
		}
		private function onProgress(e:ProgressEvent):void
		{
			trace("File Loaded by:" + (e.bytesLoaded / e.bytesTotal * 100).toFixed(2) + "%");
		}
		private function reload():void
		{
			trace("Failed Resource Number is " + numLoaderError + ". Start Reload");
			// 清空 xmlLoaderErr 的数据  
			numLoaderError = 0;
			// 设置一个临时数组，保存 xmlLoaderList 的数据 
			var vec:Vector.<LoaderModel> = loaderModels;
			loaderModels = new Vector.<LoaderModel>();
			// 重新加载出错的外部文件, 超过最大次数后则不再重新加载
			for each(var model:LoaderModel in vec)
			{
				if(model.count < RELOAD_MAX_COUNT)
				{
					model.count++;
					reloadFile(model);
				}
				else
				{
					dispatch(LOAD_ONE_MAXTIME_EVENT, [model]);
					trace("Reload Count is More Than the Max Count. " + model.url);
				}
			}
		}
		private function getLoaderModel(urlLoader:URLLoader):LoaderModel
		{
			for each(var model:LoaderModel in loaderModels)
			{
				if(model.loader == urlLoader)
					return model;
			}
			return null;
		}
		private function compareFunction4LoaderModelOnState(x:LoaderModel, y:LoaderModel):int
		{
			if(x.state == y.state)
				return 0;
			if(x.state > y.state)
				return 1;
			else
				return -1;
		}
		//------END---私有方法区
	}
}
