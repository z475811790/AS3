package com.po
{
	import com.dao.DaoContext;
	import com.xyzdl.aircore.PropertyInfo;
	import com.xyzdl.core.utils.XStringUtil;

	import flash.utils.getQualifiedClassName;

	public class BasePo
	{
		public function toString():String
		{
			var str:String = "";
			var pis:Array = DaoContext.poDic[getQualifiedClassName(this)];
			if(!pis)
				return getQualifiedClassName(this);
			for each(var pi:PropertyInfo in pis)
				str += pi.name + ":" + this[pi.name] + ",";
			return "{" + XStringUtil.trimEndChar(str) + "}";
		}
	}
}
