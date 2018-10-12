package com.xyzdl.core.modules
{
	import com.xyzdl.core.utils.AnalysisUtil;
	
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-11-30 19:22:55
	 * @description: 有流量分析功能的Socket的装饰器类
	 */
	public class XSocket4FlowAnalysis extends XSocket
	{
		private static const REFRESH_RATE:uint = 1000; //毫秒
		private static var _lastSecSum:uint = 0;
		private static var _currSecSum:uint = 0;
		private static var _timer:Timer;
		public static var _timerCount:uint = 0;

		public static function initTimer():void
		{
			_timer = new Timer(REFRESH_RATE);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			_timer.start();
		}

		public static var result:uint;
		private static function onTimerHandler(e:TimerEvent):void
		{
			result = calculateDataRate();
//			trace(_timerCount + ":" + AnalysisUtil.convertFlowRate(result));
		}
		


		private static var dataRate:Number;
		private static var midVar:Number;
		private static function calculateDataRate():uint
		{
			_timerCount++;
			dataRate = midVar = (_timerCount % (1000 / REFRESH_RATE)) * REFRESH_RATE / 1000;
			if(dataRate == 0)
			{
				dataRate = 1;
			}
			dataRate = (_currSecSum - _lastSecSum) / dataRate;
			if(midVar == 0)
			{
				_lastSecSum = _currSecSum;
			}
			return dataRate;
		}

		public function XSocket4FlowAnalysis(socket:Socket = null)
		{
			super(socket);
		}

		private var bytes:ByteArray = null;
		override public function readDPB(len:uint):ByteArray
		{
			bytes = super.readDPB(len);
			if(!bytes)
				return null;
			_currSecSum += (HEAD_LEN + bytes.length);
//			trace((new Date()).getTime()+":"+_currSecSum);
			return bytes;
		}

		override public function dispose():void
		{
			// TODO Auto Generated method stub
//			_timer.stop();
//			_timer = null;
			super.dispose();
		}

	}
}
