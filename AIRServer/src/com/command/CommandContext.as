package com.command
{

	import com.message.MessageEnum.MessageId;
	import xyzdlcore.interfaces.ICommand;

	import flash.utils.ByteArray;

	/**
	 * @author xYzDl
	 * @date 创建时间：2018-1-19 14:44:28
	 * @description: 接收命令的统一入口
	 */
	public class CommandContext
	{
		private static var _singleton:CommandContext;
		public static function get singleton():CommandContext
		{
			_singleton ||= new CommandContext();
			return _singleton;
		}
		public function CommandContext()
		{
		}
		public static function addCMD(socketId:String, msgId:int, bytes:ByteArray):void
		{
			//此处可以将命令加到执行列表中,多线程异步执行
			var cmd:ICommand;
			switch(msgId)
			{
				case MessageId.C_Login:
					cmd = new LoginCMD(socketId, bytes);
					cmd.execute();
					break;
				case MessageId.C_LoginChat:
					cmd = new LoginChatCMD(socketId, bytes);
					cmd.execute();
					break;
				case MessageId.C_ChatMsg:
					cmd = new ChatMsgCMD(socketId, bytes);
					cmd.execute();
					break;
				default:
					trace("未定义msgId");
					break;
			}
		}
	}
}
