package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import luaAlchemy.LuaAlchemy;

	public class LuaTest extends Sprite
	{
		public function LuaTest()
		{
			var luaStr:String = "this.run();";
			var lua:LuaAlchemy = new LuaAlchemy();
			lua.setGlobal("this",this);
			lua.doString(luaStr);
		}
		public function run():void
		{
			var border:Shape = new Shape;
			border.graphics.lineStyle(1, 0x00ff00);
			border.graphics.drawRect(0, 0, 100, 100);
			this.addChild(border);
		}
	}
}
