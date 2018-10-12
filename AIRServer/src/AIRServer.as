package
{
	import com.core.Keyboard;
	import com.worker.CryptWorker;
	import com.xyzdl.aircore.Log;
	import com.xyzdl.components.Image;
	import com.xyzdl.core.event.AddModuleListener;
	import com.xyzdl.core.event.DispatchEvent;
	import com.xyzdl.core.event.ModuleMessage;
	import com.xyzdl.core.loader.LoaderBean;
	import com.xyzdl.core.utils.AssetUtil;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.MessageChannelState;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.setTimeout;

	import test.dao.ChatInfoDaoTest;

	[SWF(width = 638, height = 425, frameRate = "30", backgroundColor = "#aabbcc")]
	public class AIRServer extends Sprite
	{
		private var _sSockets:XServerSocket;


		public function AIRServer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Keyboard.init(stage); //初始化键盘响应事件
			//先把配置文件加载进来
			var lb:LoaderBean = new LoaderBean();
			lb.loadCompleteHandler = initApp;
//			lb.loadCompleteHandler = forTest;
			lb.add(AssetUtil.CORE_CONFIG);
			lb.add(AssetUtil.COMMON_CONFIG);
			lb.start();
		}
		private function forTest():void
		{
			CoreConfig.initConf(); //第一:加载好核心配置文件后,初始化配置类
			Config.initConf();
			Log.initLog(Config.logFilePath);
			initView(); //第二:初始化基本界面
			new ChatInfoDaoTest;
		}
		private function initApp():void
		{
			CoreConfig.initConf(); //第一:加载好核心配置文件后,初始化配置类
			Config.initConf();
			Log.initLog(Config.logFilePath);
			initView(); //第二:初始化基本界面
			initWorker(); //第三:初始化子线程
			XServerSocket.singleton; //第四:初始化服务器通信接口
		}
		private function initView():void
		{
			App.init(stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeCom);
			this.addChild(new Image(AssetUtil.RES + "border.jpg"));
			Console.singleton.width = 638;
			Console.singleton.height = 425;
			Console.singleton.logger = Log.add;
			this.addChild(Console.singleton);

			Console.addMsg("Welcome to Server " + (new Date()).toLocaleString());
			Console.addMsg("Version " + Config.SERVER_VERSION);
		}

		private var _main:Worker;

		private var _cryptWorker:Worker;
		private var _toCryptWorker:MessageChannel;
		private var _cryptWorkerTo:MessageChannel;

		private var _dispatchWorker:Worker;
		private var _toDispatchWorker:MessageChannel;
		private var _dispatchWorkerTo:MessageChannel;
		private var _dispatchWorkerToMain:MessageChannel;
		private function initWorker():void
		{
			if(!Worker.current.isPrimordial)
				trace("Worker is not Primordial. App Init Failed");
			_main = Worker.current;
			_cryptWorker = WorkerDomain.current.createWorker(Workers.com_worker_CryptWorker);
			_dispatchWorker = WorkerDomain.current.createWorker(Workers.com_worker_DispatchWorker, true);

			_toCryptWorker = _main.createMessageChannel(_cryptWorker);
			_cryptWorkerTo = _cryptWorker.createMessageChannel(_main);
			_cryptWorker.setSharedProperty("toCryptWorker", _toCryptWorker);
			_cryptWorker.setSharedProperty("CryptWorkerto", _cryptWorkerTo);
			CryptWorker.toCryptWorkerMessageChannel = _toCryptWorker;

			_toDispatchWorker = _cryptWorker.createMessageChannel(_dispatchWorker);
			_dispatchWorkerTo = _dispatchWorker.createMessageChannel(_cryptWorker);
			_dispatchWorkerToMain = _dispatchWorker.createMessageChannel(_main);
			_cryptWorker.setSharedProperty("toDispatchWorker", _toDispatchWorker);
			_cryptWorker.setSharedProperty("DispatchWorkerto", _dispatchWorkerTo);
			_dispatchWorker.setSharedProperty("toDispatchWorker", _toDispatchWorker);
			_dispatchWorker.setSharedProperty("DispatchWorkerto", _dispatchWorkerTo);
			_dispatchWorker.setSharedProperty("toMain", _dispatchWorkerToMain);


			_cryptWorker.addEventListener(Event.WORKER_STATE, onWorkerState);
			_cryptWorkerTo.addEventListener(Event.CHANNEL_MESSAGE, onWorkerMsg);
			_dispatchWorkerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerMsg);

			_dispatchWorker.addEventListener(Event.WORKER_STATE, onWorkerState);

			AddModuleListener(ModuleMessage.SERVER_WORKER_CONSOLE_MESSAGE, onWorkerConsoleMsg);

			_cryptWorker.start();
			_dispatchWorker.start();
		}

		private function onWorkerState(e:Event):void
		{
			if(e.target == _cryptWorker)
				setTimeout(onInitConfig, 500);
			trace("Worker is Ready");
		}
		private function onInitConfig():void
		{
			CryptWorker.sendMsgToCryptWorker([ModuleMessage.SERVER_WORKER_INIT_CONFIG, [CoreConfig, Config]]);
		}
		private var msgCh:MessageChannel;
		private var msgArr:Array;
		private function onWorkerMsg(e:Event):void
		{
			msgCh = e.target as MessageChannel;
			if(msgCh.state != MessageChannelState.OPEN)
				return;
			msgArr = msgCh.receive();
			if(!msgArr || !msgArr.length)
				return;
			DispatchEvent(msgArr[0], msgArr.length > 1 ? [msgArr[1]] : null);
		}
		private function onWorkerConsoleMsg(str:String):void
		{
			if(!str)
				return;
			Console.addMsg(str);
		}
		private function resizeCom(e:Event):void
		{
			if(!stage)
				return;
			DispatchEvent(ModuleMessage.VIEW_STAGE_RESIZE);
		}
	}
}
