package com.xyzdl.core.interfaces
{
	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-7 14:47:35
	 * @description: 派发器接口
	 */
	public interface IDispatcher
	{
		function addListener(eventType:String, listener:Function):void;
		function removeListener(eventType:String, listener:Function):void;
		function dispatch(eventType:String, args:Array = null):void;
	}
}
