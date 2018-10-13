package
{
	import com.core.Keyboard;
	import com.module.ControllerRegister;
	import com.xyzdl.components.Image;
	import xyzdlcore.constants.CommonConstant;
	import xyzdlcore.event.DispatchEvent;
	import xyzdlcore.event.ModuleMessage;
	import xyzdlcore.loader.LoaderBean;
	import xyzdlcore.utils.AssetUtil;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;

	import test.Test4Client;

	[SWF(width = 638, height = 425, frameRate = "30", backgroundColor = "#eeeeee")] //272822
	public class Client extends Sprite
	{
		private static var _singleton:Client;
		public static function get singleton():Client
		{
			_singleton ||= new Client();
			return _singleton;
		}
		public function Client()
		{
			flash.system.Security.allowDomain("*");
			flash.system.Security.allowInsecureDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Keyboard.init(stage); //初始化键盘响应事件
			var lb:LoaderBean = new LoaderBean(); //顺序为先加载本地配置文件,再初始化配置类
			lb.loadCompleteHandler = initApp;
//			lb.loadCompleteHandler = testTemp;
			lb.add(AssetUtil.CORE_CONFIG);
			lb.add(AssetUtil.COMMON_CONFIG);
			lb.add(AssetUtil.GENERAL_CONFIG);
			lb.add(AssetUtil.LANGUAGE_PACKAGE);
			lb.add(AssetUtil.DATA_CONFIG);
			lb.start();
		}

		private function testTemp():void
		{
			new Test4Client();
		}

		private function initApp():void
		{
			//初始化的顺序十分重要,一定要注意
			CoreConfig.initConf(); //第一:加载好核心配置文件后,初始化配置类
			Config.initConf();
			Lan.singleton;
			DataConfig.singleton;
			initView(); //第二:初始化基本界面
			Security.loadPolicyFile("xmlsocket://" + Config.host + ":843");
			ControllerRegister.singleton; //第三:初始化控制器,所有模块事件,都在控制器初始化过后
			CSocket.singleton.connectToServer(); //第四:建立通信连接
		}
		private function initView():void
		{
			App.init(stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeCom);
			this.addChild(new Image(AssetUtil.RES + CommonConstant.IMG_BORDER));
			Console.singleton.width = 638;
			Console.singleton.height = 425;
			this.addChild(Console.singleton);

			Console.addMsg(Lan.val("1001") + (new Date()).toLocaleString());
			Console.addMsg(Lan.val("1002") + Config.CLIENT_VERSION);
		}

		public function resizeCom(e:Event):void
		{
			if(stage)
				DispatchEvent(ModuleMessage.VIEW_STAGE_RESIZE);
		}
	}
}
