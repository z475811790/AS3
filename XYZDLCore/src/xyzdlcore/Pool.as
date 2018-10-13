package xyzdlcore
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-10-20 13:42:47
	 * @description: 全局对象池
	 */
	public class Pool
	{
		private static var _singleton:Pool = new Pool();
		private var _poolDictionary:Dictionary = new Dictionary();

		public function Pool()
		{
		}

		public static function get singleton():Pool
		{
			return _singleton;
		}

		private var _className:String;
		/**
		 * @description: 取出对象
		 * @param
		 * @return 返回对象
		 */
		public function pop(klass:Class):Object
		{
			_className = getQualifiedClassName(klass);
			if(_singleton._poolDictionary[_className] && _singleton._poolDictionary[_className].length > 0)
			{
				return _poolDictionary[_className].pop();
			}
			return new klass();
		}

		/**
		 * @description: 放入对象
		 * @param
		 * @return 操作成功与否
		 */
		public function push(obj:Object):Boolean
		{
			if(!obj)
				return false;
			if((obj is DisplayObject) && obj.parent)
			{
				(obj as DisplayObject).parent.removeChild((obj as DisplayObject));
			}
			_className = getQualifiedClassName(obj);
			if(!_poolDictionary[_className])
				_poolDictionary[_className] = [];
			
			if(isExists(obj))
			{
				trace(obj + " Already Exists In Pool. Can't Be Pushed");
				return false;
			}

			_poolDictionary[_className].push(obj);
			return true;
		}

		/**
		 * @description: 对象是否已存在于对象池中
		 * @param 对象
		 * @return 存在与否
		 */
		private function isExists(obj:Object):Boolean
		{
			for each(var oo:Object in _poolDictionary[_className])
			{
				if(oo == obj)
				{
					return true;
				}
			}
			return false;
		}
	}
}
