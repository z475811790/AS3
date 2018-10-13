package xyzdlcore.event
{

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-6 15:23:16
	 * @description: 模块消息
	 */
	public class ModuleMessage
	{
		/*----------共享的事件----------*/
		//----界面相关事件
		public static const VIEW_STAGE_RESIZE:String = "VIEW_STAGE_RESIZE"; //舞台改变事件
		//----Socket相关事件
		public static const SOCKET_STATE_TO_NORMAL:String = "SOCKET_STATE_TO_NORMAL"; //套接字通信状态改变为正常通信状态
		public static const SOCKET_CLOSE:String = "SOCKET_CLOSE"; //套接字关闭
		public static const SOCKET_DATA_PACKAGE_EMPTY:String = "SOCKET_DATAPACKAGE_EMPTY"; //数据包为空
		public static const SOCKET_DATA_PACKAGE_NOT_ENOUGH:String = "SOCKET_DATA_PACKAGE_NOT_ENOUGH"; //数据包未完全到达
		/*--------客户端模块消息--------*/

		/*--------服务器模块消息--------*/
		public static const SERVER_SOCKET_CONNECT:String = "SERVER_SOCKET_CONNECT"; //客户端连接服务器
		public static const SERVER_SOCKET_CLOSE:String = "SERVER_SOCKET_CLOSE"; //服务器通信接口关闭


		/*--------Worker消息--------*/
		public static const SERVER_WORKER_CRYPT_CREAT_AES:String = "SERVER_WORKER_CRYPT_CREAT_AES"; //AESWoker创建AESKey
		public static const SERVER_WORKER_CREATE_AES_COMPLETE:String = "SERVER_WORKER_CREATE_AES_COMPLETE"; //AESWoker创建AESKey完成
		public static const SERVER_WORKER_CONSOLE_MESSAGE:String = "SERVER_WORKER_CONSOLE_MESSAGE"; //Worker控制台消息
		public static const SERVER_WORKER_CRYPT_ENCRYTP:String = "SERVER_WORKER_CRYPT_ENCRYTP"; //AES加密消息
		public static const SERVER_WORKER_CRYPT_DECRYTP:String = "SERVER_WORKER_CRYPT_DECRYTP"; //AES解密消息
		public static const SERVER_WORKER_DISPATCH_SOCKET_EVENT:String = "SERVER_WORKER_DISPATCH_SOCKET_EVENT"; //解密后的SOCKET事件消息
		public static const SERVER_WORKER_SEND_SOCKET_MESSAGE:String = "SERVER_WORKER_SEND_SOCKET_MESSAGE"; //向客户端发送消息
		public static const SERVER_WORKER_DELETE_SOCKET:String = "SERVER_WORKER_DELETE_SOCKET"; //删除Socket Key
		public static const SERVER_WORKER_INIT_CONFIG:String = "SERVER_WORKER_INIT_CONFIG"; //由于Work与主程序实际上是不同的进程,所以配置其实并不共用,Work无法自己去读取本地文件,所以直接传配置类过去初始化
	}
}
