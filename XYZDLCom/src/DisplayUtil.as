package
{
	import flash.display.DisplayObject;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		public static function RemoveFromParent(disObj:DisplayObject):void
		{
			if(disObj == null)
				return;
			if(disObj.parent == null)
				return;
			disObj.parent.removeChild(disObj);
		}
	}
}
