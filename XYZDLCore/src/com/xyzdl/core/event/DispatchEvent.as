package com.xyzdl.core.event
{
	/**
	 * 派发全局消息模块
	 */
	public function DispatchEvent(eventType:String, args:Array = null):void
	{
		App.moduleDispatcher.dispatch(eventType, args);
	}
}
