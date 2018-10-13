package com.xyzdl.components
{
	import xyzdlcore.loader.ImageLoaderBean;
	import xyzdlcore.utils.CoreUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-2 20:16:38
	 * @description: 图片类
	 */
	public class Image extends Component
	{
		private var _bitmap:Bitmap;
		private var _url:String;
		public var onCompleteHandler:Function;
		public function Image(url:String = null)
		{
			super();
			this.width = 100;
			this.height = 100;
			this.url = url;
		}
		public function set url(value:String):void
		{
			if(!value)
				return;
			_url = value;
			if(CoreUtil.getBitmapData(value))
				setBitmapData(CoreUtil.getBitmapData(value));
			else
				new ImageLoaderBean(value, setBitmapData);
		}

		private function setBitmapData(bitmapData:BitmapData):void
		{
			_bitmap = new Bitmap(bitmapData);
			_bitmap.smoothing = true;
			this.width = _bitmap.width;
			this.height = _bitmap.height;
			this.addChild(_bitmap);
			if(onCompleteHandler)
				onCompleteHandler();
		}
	}
}
