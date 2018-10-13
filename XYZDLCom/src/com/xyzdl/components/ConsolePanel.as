package com.xyzdl.components
{
	import xyzdlcore.Pool;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-10-20 14:48:55
	 * @description: 控制台
	 */
	public class ConsolePanel extends Component
	{
		public static const MAX_TEXT_NUM:int = 72; //最大保留文本数量
		public static const FONT_SIZE:int = 14; //字体大小

		private var _tfList:Vector.<TextField>;
		private var _tfBox:Box;
		public var textFormat:TextFormat;
		private var addLog:Function;
		public function ConsolePanel()
		{
			super();
			initCom();
		}
		public function initCom():void
		{
			_tfList = new Vector.<TextField>();
			_tfBox = new Box;
			this.addChild(_tfBox);
			textFormat = new TextFormat("微软雅黑", FONT_SIZE, 0x000000, true, false, false, null, null, null, null, null, null, 3);

			tf = (Pool.singleton.pop(TextField) as TextField);
			tf.text = "";
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;
			tf.text = "Console Created By xYzDl";

			_tfList.push(tf);
			_tfBox.addChild(tf);
		}
		private var ltf:TextField; //前一个文本
		private var tf:TextField; //当前文本
		private var totalHeight:int; //可见文本的总高度
		private function refresh():void
		{
			ltf = _tfList[0];
			ltf.width = this.width;
			ltf.y = 0;
			totalHeight = ltf.textHeight;
			for(var i:int = 1; i < _tfList.length; i++)
			{
				tf = _tfList[i];
				tf.width = this.width;
				tf.y = ltf.y + ltf.textHeight;
				totalHeight += tf.textHeight;
				ltf = tf;
			}
			_tfBox.width = this.width;
			_tfBox.height = totalHeight + textFormat.leading;

			if(_tfBox.height <= this.height)
			{
				_tfBox.y = 0;
			}
			else
			{
				_tfBox.y = this.height - _tfBox.height;
			}
		}
		public function addMsg(msg:String):void
		{
			if(addLog)
				addLog(msg);
			if(_tfList.length >= MAX_TEXT_NUM)
			{
				tf = _tfList.shift();
			}
			else
			{
				tf = Pool.singleton.pop(TextField) as TextField;
				tf.defaultTextFormat = textFormat;
				tf.wordWrap = true;
				_tfBox.addChild(tf);
			}
			tf.text = msg;
			_tfList.push(tf);
			delayInvoke(refresh);
		}
		public function set logger(logger:Function):void
		{
			addLog = logger;
		}
		override public function resize():void
		{
			super.resize();
			delayInvoke(refresh);
		}
	}
}
