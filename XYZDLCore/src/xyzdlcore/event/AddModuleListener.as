package xyzdlcore.event
{
	/**
	 * 添加全局模块消息监听
	 */
	public function AddModuleListener(eventType:String, listener:Function):void
	{
		App.moduleDispatcher.add(eventType, listener);
	}
}
