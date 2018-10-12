package com.xyzdl.core.modules
{
	import flash.utils.Dictionary;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-5 17:48:26
	 * @description: 事件派发核心类
	 */
	public class Dispatcher
	{
		private var _listenersSet:Dictionary = new Dictionary();
		public function Dispatcher()
		{
		}

		private var listeners:Array = null;
		public function add(eventType:String, listener:Function):void
		{
			listeners = _listenersSet[eventType];
			if(!listeners)
			{
				listeners = [];
				_listenersSet[eventType] = listeners;
			}
			if(listeners.indexOf(listener) != -1)
				return;
			listeners.push(listener);
		}
		private var index:int = -1;
		public function remove(eventType:String, listener:Function):void
		{
			listeners = _listenersSet[eventType];
			index = listeners.indexOf(listener);
			if(index != -1)
				listeners.splice(index, 1);
		}
		private var fun:Function = null;
		public function dispatch(eventType:String, args:Array = null):void
		{
			listeners = _listenersSet[eventType];
			if(!listeners)
				return;
			for(var i:int = listeners.length - 1; i >= 0; i--)
			{
				fun = listeners[i];
//				try
//				{
					fun.apply(null, args);
//				}
//				catch(error:Error)
//				{
//					trace("Wrong Executing. EventType is " + eventType + ". ErrorMessage:" + error.message);
//				}
			}
		}
	}
}
