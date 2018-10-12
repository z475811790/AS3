package com.module.main
{
	import com.message.C_HEARTBEAT;
	import com.message.S_SYN_HEARTBEAT;
	import com.message.S_SynHeartbeat;
	import com.message.MessageEnum.MessageId;
	import com.module.BaseController;
	import com.xyzdl.core.event.AddModuleListener;
	import com.xyzdl.core.event.ModuleMessage;
	import com.xyzdl.core.utils.XTimer;
	
	import flash.utils.ByteArray;

	public class MainController extends BaseController
	{
		private static var _singleton:MainController;
		public static function get singleton():MainController
		{
			_singleton ||= new MainController;
			return _singleton;
		}
		public function MainController()
		{
			super();
		}
		override protected function initListeners():void
		{
			// TODO Auto Generated method stub
			super.initListeners();
			AddModuleListener(ModuleMessage.SOCKET_STATE_TO_NORMAL, onSocketStateToNormal); //通信连接验证成功变为正常通信状态后引发的事件
			AddModuleListener(ModuleMessage.SOCKET_CLOSE, onSocketClose); //通信接口关闭事件,包括由IO错误,服务主动断开,安全策略错误等导致接口关闭事件
			AddModuleListener(ModuleMessage.SOCKET_DATA_PACKAGE_EMPTY, onDataPackageEmpty); //数据包为空事件
			AddModuleListener(ModuleMessage.SOCKET_DATA_PACKAGE_NOT_ENOUGH, onDataPackageNotEnough); //数据包未完全到达

			addSocketListener(MessageId.S_SynHeartbeat, onSynHeartbeat);
		}
		//------START-事件注册区
		private function onSocketStateToNormal():void
		{
			Console.addMsg(Lan.val("1008"));
		}
		private function onSocketClose(msg:String):void
		{
			Console.addMsg(msg);
		}
		private function onDataPackageEmpty():void
		{
			trace("DataPackage Length is 0, It Can't be Empty!");
		}
		private function onDataPackageNotEnough():void
		{
			trace("DataPackage Has not Arrived All!");
		}
		private function onSynHeartbeat(bytes:ByteArray):void
		{
			var s:S_SynHeartbeat = new S_SynHeartbeat;
			s.mergeFrom(bytes);
			XTimer.singleton.synServerTime(Number(s.serverTime));
			trace("SYS:"+s.serverTime);
		}
		//------END---事件注册区
		//------START-公共方法区
		//------END---公共方法区
		//------START-私有方法区
		//------END---私有方法区
	}
}
