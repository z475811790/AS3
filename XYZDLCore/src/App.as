package
{

	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import xyzdlcore.managers.RenderManager;

	/**
	 * @author xYzDl
	 * @date 创建时间：2017-12-1 10:41:36
	 * @description: 全局引用入口
	 */
	public class App
	{
		public static var stage:Stage;
		public static var render:RenderManager = new RenderManager(); //渲染管理器
		public static var moduleDispatcher:Dispatcher = new Dispatcher(); //全局MVC共享事件派发器
		public static var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain); //加载图片数据用
		public function App()
		{
		}
		public static function init(main:Stage):void
		{
			stage = main;
		}
	}
}
