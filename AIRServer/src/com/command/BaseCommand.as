package com.command
{
	import xyzdlcore.interfaces.ICommand;

	import flash.utils.ByteArray;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-19 15:40:10
	 * @description: 命令基类 命令模式命令具体实现类是以对应消息来命名LoginCMD对应消息为C_Login
	 * 这里不设置命令模式的接收者,接收者的调用方法全部在Service层实现
	 * 通过组合调用Service方法来实现具体业务逻辑
	 */
	public class BaseCommand implements ICommand
	{
		protected var socketId:String;
		protected var msgBytes:ByteArray;
		public function BaseCommand(socketId:String, bytes:ByteArray)
		{
			this.socketId = socketId;
			msgBytes = bytes;
		}

		public function execute():void
		{
		}
		public function dispose():void
		{
			if(msgBytes)
			{
				msgBytes.clear();
				msgBytes = null;
				socketId = null;
			}
		}
	}
}
