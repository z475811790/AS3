package com.adobe.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import game.core.utils.Tween;

	public class TweenUtil
	{
		private var dic:Dictionary;
		public function TweenUtil()
		{
			dic = new Dictionary;
		}
		
		public static function to(display:DisplayObject,time:int,obj:Object):void{
			if(!display)return;
			kill(display);
			
			var x0:int = display.x;
			var y0:int = display.y;
			var x1:int = obj.hasOwnProperty("x")?obj.x:x0;
			var y1:int = obj.hasOwnProperty("y")?obj.y:y0;
			
			Tween.add(display,time,{x:x1,y:y1},complete);
			
			function complete():void{
				if(display.x==x0&&display.y==y0){
					Tween.add(display,time,{x:x1,y:y1},complete);
				}else{
					Tween.add(display,time,{x:x0,y:y0},complete);
				}
			}
		}
		
		public static function kill(display:DisplayObject):void{
			Tween.del(display);
		}
	}
}