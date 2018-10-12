package com.xyzdl.core.managers
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class RenderManager
	{
		private var _methods:Dictionary = new Dictionary();
		public function RenderManager()
		{
		}

		/**延时调用*/
		public function delayInvoke(method:Function, args:Array = null):void
		{
			if(!_methods[method])
			{
				_methods[method] = args || [];
				invalidate();
			}
		}
		private function invalidate():void
		{
			if(App.stage)
			{
				App.stage.addEventListener(Event.RENDER, onvalidate);
				App.stage.addEventListener(Event.ENTER_FRAME, onvalidate);
				App.stage.invalidate();
			}
		}
		private function onvalidate(e:Event):void
		{
			App.stage.removeEventListener(Event.ENTER_FRAME, onvalidate);
			App.stage.removeEventListener(Event.RENDER, onvalidate);
			invoke();
		}
		private function invoke():void
		{
			var args:Array;
			for(var fun:Function in _methods)
			{
				if(_methods[fun])
				{
					args = _methods[fun];
					delete _methods[fun];
					fun.apply(null, args);
				}
			}
		}
	}
}
