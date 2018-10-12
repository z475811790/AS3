package com.xyzdl.components
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class ConsoleInput extends Component
	{
		private var _textField:TextField;
		public function ConsoleInput()
		{
			super();
			initCom();
		}
		private function initCom():void
		{
			_textField = new TextField;
			_textField.borderColor = 0xff5513;
			_textField.border = true;
			_textField.type = TextFieldType.INPUT;
			_textField.defaultTextFormat = new TextFormat("微软雅黑", 14, 0x000000, true, false, false, null, null, null, null, 5, null, 4);
			this.height = _textField.height + _textField.defaultTextFormat.leading;
			this.addChild(_textField);
		}

		public function get text():String
		{
			return _textField.text;
		}

		public function set text(value:String):void
		{
			_textField.text = value;
		}
		override public function resize():void
		{
			_textField.width = this._width - 1;
			_textField.height = 24;
			this._height = _textField.textHeight;
			super.resize();
		}
	}
}
