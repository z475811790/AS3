package com.xyzdl.components
{
	public class Box extends Component
	{
		public function Box()
		{
			super();
			initCom();
		}
		private function initCom():void
		{
			this._width = 100;
			this._height = 100;
		}
		private var childComp:Component;
		public override function resize():void
		{
			super.resize();
			for(var i:int = 0; i < this.numChildren; i++)
			{
				childComp = this.getChildAt(i) as Component;
				if(childComp)
					childComp.resize();
			}
		}
	}
}
