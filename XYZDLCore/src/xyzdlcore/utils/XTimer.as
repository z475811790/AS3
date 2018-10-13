package xyzdlcore.utils
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-6 10:05:45
	 * @description: 核心时钟工具
	 */
	public class XTimer
	{
		/**
		 * 驱动时钟,也用来限制最小执行间隔时间,系统Timer最长可运行 24.86 天
		 * 所以这里设计为每10天重置一下计时器
		 */
		private static const FREQUENCE:int = 100; //基本频率毫秒值
		private static const REFRESH_INTERVAL:int = 10 * 24 * 60 * 60 * 1000; //重置间隔
		private var _internalTimer:Timer = new Timer(FREQUENCE); //官方建议值不要低于20,实际测试有相当大的延迟,且每次延迟不一样
		private var _nowTime:uint;
		private var _timeOffset:uint;
		private var _num:int = 0;
		private var _nodes:Vector.<Node> = new Vector.<Node>();
		private var _handlerDic:Dictionary = new Dictionary();

		private static var _singleton:XTimer;
		public static function get singleton():XTimer
		{
			_singleton ||= new XTimer;
			return _singleton;
		}
		public function XTimer()
		{
			_internalTimer.addEventListener(TimerEvent.TIMER, onTimer);
			_internalTimer.start();
			setInterval(function():void
			{
				_internalTimer.stop();
				_internalTimer.reset();
				_internalTimer.start();
			}, REFRESH_INTERVAL);
		}
		//------START-事件注册区
		private function onTimer(e:Event):void
		{
			_nowTime = getTimer();
			_nowTime += _timeOffset;

			var pos:int = _num - 1;
			var n:Node;
			while(pos >= 0)
			{
				n = _nodes[pos];
				pos--;
				if(n.setTime + n.interval > _nowTime)
					continue;
				n.setTime = _nowTime;
				if(n.isOnce)
					removeHandler(n.handler);

				if(CoreConfig.IS_DEBUG)
				{
					n.invoke(_nowTime);
				}
				else
				{
					try
					{
						n.invoke(_nowTime);
					}
					catch(error:Error)
					{
						trace(error.message);
					}
				}
			}
		}
		//------END---事件注册区
		//------START-公共方法区
		/**
		 * handler:回调方法,如果为一个参数则必须为int类型
		 * 将传入调用时间值,两个参数时第二参数才是自定义参数
		 * 也可以不传入参数
		 * interval:回调间隔
		 * isOnce:执行一次否
		 * arg:回调参数
		 */
		private function addHandler(handler:Function, interval:int = 0, isOnce:Boolean = false, arg:* = null):void
		{
			if(!handler || _handlerDic[handler] != null)
				return;
			var node:Node = (_num == _nodes.length) ? (_nodes[_num] = new Node()) : _nodes[_num];
			_handlerDic[handler] = _num; //保存其索引
			node.setTime = _nowTime;
			node.interval = interval <= FREQUENCE ? FREQUENCE : interval;
			node.handler = handler;
			node.isOnce = isOnce;
			node.arg = arg;
			_num++;
		}
		private function removeHandler(handler:Function):void
		{
			if(!handler || _handlerDic[handler] == null || _num < 1 || _handlerDic[handler] >= _num - 1)
				return;
			var n:Node = _nodes[_handlerDic[handler]];
			_nodes[_handlerDic[handler]] = _nodes[_num - 1];
			_nodes[_num - 1] = n;
			_num--;
			delete _handlerDic[handler];
		}
		public static function add(handler:Function, interval:int = 0, isOnce:Boolean = false, arg:* = null):void
		{
			singleton.addHandler(handler, interval, isOnce, arg);
		}
		public static function remove(handler:Function):void
		{
			singleton.removeHandler(handler);
		}

		private var _synTime:Number = -1;
		private var _setTime:int = 0;
		public function synServerTime(time:Number):void
		{
			_synTime = time;
			_setTime = getTimer();
		}
		/**
		 * 获取服务器时间
		 */
		public static function serverTime():Number
		{
			if(singleton._synTime <= 0)
				return (new Date()).getTime();
			else
				return getTimer() - singleton._setTime + singleton._synTime;
		}
		/**
		 * 获取相对即时时间
		 */
		public static function get now():uint
		{
			return singleton._nowTime;
		}
		//------END---公共方法区
		//------START-私有方法区
		//------END---私有方法区
	}
}

class Node
{
	public var setTime:int; //设置时间
	public var interval:int; //回调间隔
	public var handler:Function; //回调方法
	public var isOnce:Boolean; //执行一次否
	public var arg:*; //回调参数
	public function invoke(nowTime:int):void
	{
		if(!handler)
			return;
		if(handler.length == 2)
			handler(nowTime, arg);
		else if(handler.length == 1)
			handler(nowTime);
		else
			handler();
	}
}
