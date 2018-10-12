package com.core
{
	import com.xyzdl.core.utils.SharedObjectUtil;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-17 14:41:02
	 * @description: 键盘事件响应
	 */
	public class Keyboard
	{
		public function Keyboard()
		{
		}
		private static var _keyDic:Dictionary = new Dictionary();
		public static function init(main:Stage):void
		{
			var funs:XMLList = describeType(Keyboard).method;
			for each(var funDes:XML in funs)
				if(Key[String(funDes.@name)])
					_keyDic[Key[String(funDes.@name)]] = Keyboard[String(funDes.@name)];

			main.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		private static function onKeyDown(e:KeyboardEvent):void
		{
			if(App.stage.focus is TextField)
				return;
			if(_keyDic[e.keyCode])
				_keyDic[e.keyCode]();
		}
		public static function F1():void
		{
			trace("F1");
		}
		public static function A():void
		{
			SharedObjectUtil.setKeyValue("xyz",12);
		}
		public static function B():void
		{
			trace(SharedObjectUtil.getKeyValue("xyz")?SharedObjectUtil.getKeyValue("xyz"):"NO");
		}
	}
}

class Key
{

	public static const SPACE:int = 32;
	public static const ESCAPE:int = 27;
	public static const ENTER:int = 13;
	public static const BACKSPACE:int = 8;
	public static const TAB:int = 9;
	public static const TILDE:int = 192;
	public static const CONTROL:int = 17;

	public static const NUMBER1:int = 49;
	public static const NUMBER2:int = 50;
	public static const NUMBER3:int = 51;
	public static const NUMBER4:int = 52;
	public static const NUMBER5:int = 53;
	public static const NUMBER6:int = 54;
	public static const NUMBER7:int = 55;
	public static const NUMBER8:int = 56;
	public static const NUMBER9:int = 57;
	public static const NUMBER0:int = 48;

	public static const NUMPAD1:int = 97;
	public static const NUMPAD2:int = 98;
	public static const NUMPAD3:int = 99;
	public static const NUMPAD4:int = 100;
	public static const NUMPAD5:int = 101;
	public static const NUMPAD6:int = 102;

	public static const A:int = 65;
	public static const B:int = 66;
	public static const C:int = 67;
	public static const D:int = 68;
	public static const E:int = 69;
	public static const F:int = 70;
	public static const G:int = 71;
	public static const H:int = 72;
	public static const I:int = 73;
	public static const J:int = 74;
	public static const K:int = 75;
	public static const L:int = 76;
	public static const M:int = 77;
	public static const N:int = 78;
	public static const O:int = 79;
	public static const P:int = 80;
	public static const Q:int = 81;
	public static const R:int = 82;
	public static const S:int = 83;
	public static const T:int = 84;
	public static const U:int = 85;
	public static const V:int = 86;
	public static const W:int = 87;
	public static const X:int = 88;
	public static const Y:int = 89;
	public static const Z:int = 90;

	public static const F1:int = 112;
	public static const F2:int = 113;
	public static const F3:int = 114;
	public static const F4:int = 115;
	public static const F5:int = 116;
	public static const F6:int = 117;
	public static const F7:int = 118;
	public static const F8:int = 119;
	public static const F9:int = 120;
	public static const F10:int = 121;
	public static const F11:int = 122;
	public static const F12:int = 123;

	public static const NUMPAD_ADD:int = 187;
	public static const NUMPAD_SUB:int = 189;
}
