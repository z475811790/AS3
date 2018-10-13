package
{
	import com.xyzdl.components.Box;
	import com.xyzdl.components.ConsoleInput;
	import com.xyzdl.components.ConsolePanel;
	import xyzdlcore.event.AddModuleListener;
	import xyzdlcore.event.ModuleMessage;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;

	public class Console extends Box
	{
		private var _panel:ConsolePanel;
		private var _input:ConsoleInput;
		private static var _singleton:Console;

		public var onInputHandler:Function;

		public static function get singleton():Console
		{
			_singleton ||= new Console;
			return _singleton;
		}
		public function Console()
		{
			_panel = new ConsolePanel;
			_input = new ConsoleInput;
			_panel.width = 100;
			_panel.height = 100 - _input.height;
			_input.width = 100;
			_input.y = _panel.height;

			AddModuleListener(ModuleMessage.VIEW_STAGE_RESIZE, onResize);
			
			_input.addEventListener(KeyboardEvent.KEY_DOWN, onInput);
			_input.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);

			this.addChild(_panel);
			this.addChild(_input);
		}
		private function onResize():void
		{
			width = App.stage.stageWidth;
			height = App.stage.stageHeight;
		}
		private function onInput(e:KeyboardEvent):void
		{
			if(!onInputHandler)
				return;
			onInputHandler(e);
		}
		private function onFocusIn(e:FocusEvent):void
		{
		}
		private function onFocusOut(e:FocusEvent):void
		{
		}


		public function set logger(value:Function):void
		{
			_panel.logger = value;
		}

		public static function addMsg(msg:String):void
		{
			_singleton._panel.addMsg(msg);
		}

		override public function resize():void
		{
			// TODO Auto Generated method stub
			super.resize();

			_panel.width = this.width;
			_panel.height = this.height - _input.height;
			_input.width = this.width;
			_input.y = _panel.height - 2;
		}
	}
}
