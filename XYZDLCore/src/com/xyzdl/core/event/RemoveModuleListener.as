package com.xyzdl.core.event
{
	/**
	 * 删除全局模块消息监听
	 */
	public function RemoveModuleListener(eventType:String, listener:Function):void
	{
		App.moduleDispatcher.remove(eventType, listener);
	}
}
