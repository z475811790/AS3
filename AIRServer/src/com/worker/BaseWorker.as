package com.worker
{
	import xyzdlcore.event.ModuleMessage;
	import xyzdlcore.utils.CoreUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-20 19:28:54
	 * @description: 主要采用反射来注入MessageChannel
	 * 命名一定要符合约束规则,MessageChannel的在共享中的命名必须是 to子Worker类名 和 子Worker类名to
	 * 所有子Worker必须继承BaseWorker
	 * 且子Worker不能在默认包中
	 */
	public class BaseWorker extends Sprite
	{
		protected var _dispatcher:Dispatcher;
		protected var _thisName:String;
		protected var _toOpposite:MessageChannel;
		protected var _toOwn:MessageChannel;
		
		public function BaseWorker()
		{
			super();
			_dispatcher = new Dispatcher();
			_thisName = CoreUtil.getClassShortName(this);
			_toOpposite = Worker.current.getSharedProperty(_thisName + "to");
			_toOwn = Worker.current.getSharedProperty("to" + _thisName);
			_toOwn.addEventListener(Event.CHANNEL_MESSAGE, onMsgEvent);
		}
		//------START-事件注册区
		private var msgCh:MessageChannel;
		private var msgArr:Array;
		protected function onMsgEvent(e:Event):void
		{
			msgCh = e.target as MessageChannel;
			if(!msgCh)
				return;
			msgArr = msgCh.receive();
			if(!msgArr || !msgArr.length)
				return;
			
			_dispatcher.dispatch(msgArr[0], msgArr.length > 1 ? [msgArr[1]] : null);
		}
		//------END---事件注册区
		//------START-公共方法区
		//------END---公共方法区
		//------START-私有方法区
		protected function send2OppositeEventMsg(eventMsg:String, args:Array = null):void
		{
			_toOpposite.send([eventMsg, args]);
		}
		protected function send2ConsoleMsg(msg:String):void
		{
			_toOpposite.send([ModuleMessage.SERVER_WORKER_CONSOLE_MESSAGE, msg]);
		}
//		protected function addEventListener(eventType:String, listener:Function):void
//		{
//			_dispatcher.add(eventType, listener);
//		}
//		protected function removeEventListener(eventType:String, listener:Function):void
//		{
//			_dispatcher.remove(eventType, listener);
//		}
//		protected function dispatchEvent(eventType:String, args:Array = null):void
//		{
//			_dispatcher.dispatch(eventType, args);
//		}

		private function add(n:int):int
		{
			if(n == 1 || n == 2)
				return 1;
			else
				return add(n - 1) + add(n - 2);
		}
		//------END---私有方法区
	}
}

