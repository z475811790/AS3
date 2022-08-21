package com.module
{
	import com.netease.protobuf.Message;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-5 14:52:36
	 * @description: MVC控制器基类
	 */
	public class BaseController
	{
		public function BaseController()
		{
			initListeners();
		}
		protected function initListeners():void
		{

		}
		protected function sendSocketMessage(msg:Message):void
		{
			CSocket.singleton.sendProtoMessage(msg);
		}
		protected function addSocketListener(msgId:int, listener:Function):void
		{
			CSocket.singleton.addSocketMsgListener(msgId, listener);
		}
		protected function removeSocketListener(msgId:int, listener:Function):void
		{
			CSocket.singleton.removeSocketMsgListener(msgId, listener);
		}
	}
}
