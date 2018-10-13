package com.worker
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.math.BigInteger;
	import xyzdlcore.crypt.AESCrypt;
	import xyzdlcore.event.ModuleMessage;
	import xyzdlcore.utils.CoreUtil;
	import xyzdlcore.utils.Hex;
	
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class CryptWorker extends BaseWorker
	{
		private var _keyDic:Dictionary = new Dictionary();
		private var _toDispatchWorker:MessageChannel;
		private var _dispatchWorkerTo:MessageChannel;

		public function CryptWorker()
		{
			super();
//			registerClassAlias("CoreConfig",CoreConfig);
//			registerClassAlias("Config",Config);
			
			_toDispatchWorker = Worker.current.getSharedProperty("toDispatchWorker");
			_dispatchWorkerTo = Worker.current.getSharedProperty("DispatchWorkerto");
			_dispatchWorkerTo.addEventListener(Event.CHANNEL_MESSAGE, onMsgEvent);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_INIT_CONFIG, onInitConfig);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_CRYPT_CREAT_AES, onCreateAES);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_CRYPT_DECRYTP, onDecrypt);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_CRYPT_ENCRYTP, onEncrypt);
			_dispatcher.add(ModuleMessage.SERVER_WORKER_DELETE_SOCKET, onDeleteSocket);
		}
		private function onInitConfig(args:Array):void
		{
			CoreConfig.initConf(args[0]);
			Config.initConf(args[1]);
		}
		private var socketId:String;
		private function onCreateAES(args:Array):void
		{
			socketId = args[0];
			var pk:ByteArray = args[1];
			var aes:AESCrypt = new AESCrypt();
//			aes.key = Hex.toArray("940600e35a3393eac3aa731090d49764");
			aes.generateRandomAESKey();
			_keyDic[socketId] = aes;
			send2ConsoleMsg("sn:" + Hex.fromArray(pk));
			var rsa:RSAKey = new RSAKey(new BigInteger(pk), 65537);
			var encrypted:ByteArray = CoreUtil.getSharedBytes();
			send2ConsoleMsg("s-sk:" + Hex.fromArray(aes.key));
			rsa.encrypt(aes.key, encrypted, aes.key.length);
			send2ConsoleMsg("afterEn:" + Hex.fromArray(encrypted));

			send2OppositeEventMsg(ModuleMessage.SERVER_WORKER_CREATE_AES_COMPLETE, [socketId, encrypted]);

			pk.clear();
			pk = null;
		}
		private var dataBytes:ByteArray;
		private var decryptedBytes:ByteArray;
		private function onDecrypt(args:Array):void
		{
			socketId = args[0];
			if(!_keyDic[socketId])
				return;
			dataBytes = args[1];
			trace("en:"+Hex.fromArray(dataBytes));
			dataBytes.position = 0;
			
			decryptedBytes = (_keyDic[socketId] as AESCrypt).decryptBytes(dataBytes);
			dataBytes.clear();
			if(CoreConfig.dataCompress)
				decryptedBytes.uncompress();
			dataBytes.clear();
			dataBytes.writeBytes(decryptedBytes);
			trace("de:"+Hex.fromArray(dataBytes));
			dataBytes.position = 0;
			
			decryptedBytes.clear();
			decryptedBytes = null;

			_toDispatchWorker.send([ModuleMessage.SERVER_WORKER_DISPATCH_SOCKET_EVENT, [socketId, dataBytes]]);
		}

		private function onEncrypt(args:Array):void
		{
			dataBytes = args[1];
			if(!dataBytes)
				return;
			if(CoreConfig.dataCompress)
				dataBytes.compress();
			if(args[0] && args[0] is Array)
			{
				for each(var socket:String in args[0])
					send(dataBytes, socket);
			}
			else
			{
				for(var k:String in _keyDic)
					send(dataBytes, k);
			}
		}
		private var midBytes:ByteArray;
		private function send(bytes:ByteArray, socketId:String):void
		{
			midBytes = CoreUtil.getSharedBytes(bytes);

			var aesKey:AESCrypt = _keyDic[socketId] as AESCrypt;
			if(!aesKey)
				return;
			aesKey.encryptBytes(midBytes);
			send2OppositeEventMsg(ModuleMessage.SERVER_WORKER_SEND_SOCKET_MESSAGE, [socketId, midBytes]);
		}
		private function onDeleteSocket(socketId:String):void
		{
			_toDispatchWorker.send([ModuleMessage.SERVER_WORKER_DELETE_SOCKET, socketId]);
			if(_keyDic[socketId])
				delete _keyDic[socketId];
		}
		//-------以下仅用于主进程里调用
		private static var _toCryptWorker:MessageChannel;
		public static function set toCryptWorkerMessageChannel(value:MessageChannel):void
		{
			_toCryptWorker = value;
		}
		public static function sendMsgToCryptWorker(args:*):void
		{
			if(!_toCryptWorker)
				return;
			_toCryptWorker.send(args);
		}
	}
}
