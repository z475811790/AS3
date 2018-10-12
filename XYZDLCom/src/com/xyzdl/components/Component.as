package com.xyzdl.components
{
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Component extends Sprite
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		private var _areaShap:Shape;
		public function Component()
		{
			super();
			_areaShap = new Shape;
			this.addChild(_areaShap);
			_areaShap.graphics.lineStyle(0, 0x00ff00, 0.0, false, LineScaleMode.NONE, null, null);
			_areaShap.graphics.drawRect(0, 0, _width, _height);
			this.addEventListener(Event.RESIZE, onResize);
		}
		private function onResize(e:Event):void
		{
			resize();
		}
		public function showBorder(color:uint = 0xff0000):void
		{
			DisplayUtil.RemoveFromParent(getChildByName("BBOORRDDEERR"));
			var border:Shape = new Shape();
			border.name = "BBOORRDDEERR";
			border.graphics.lineStyle(1, color);
			border.graphics.drawRect(0, 0, this.width - 1, this.height - 1);
			this.addChild(border);
		}
		public function set scale(value:Number):void
		{
			this.scaleX = this.scaleY = value;
		}
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width = value;
			delayInvoke(resize);
		}
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height = value;
			delayInvoke(resize);
		}
		public function remove():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		public function delayInvoke(method:Function, args:Array = null):void
		{
			App.render.delayInvoke(method, args);
		}
		private var foreScaleX:Number, foreScaleY:Number;

		public function resize():void
		{
			if(getChildByName("BBOORRDDEERR"))
				showBorder();
			_areaShap.graphics.clear();
			_areaShap.graphics.drawRect(0, 0, _width, _height);
		}
	}
}
