package com.xyzdl.core.interfaces
{

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-19 14:31:59
	 * @description: 命令模式命令接口
	 */
	public interface ICommand
	{
		function execute():void;
		function dispose():void;
	}
}
