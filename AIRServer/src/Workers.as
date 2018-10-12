/*******************************************************************************************************************************************
 * This is an automatically generated class. Please do not modify it since your changes may be lost in the following circumstances:
 *     - Members will be added to this class whenever an embedded worker is added.
 *     - Members in this class will be renamed when a worker is renamed or moved to a different package.
 *     - Members in this class will be removed when a worker is deleted.
 *******************************************************************************************************************************************/

package 
{
	
	import flash.utils.ByteArray;
	
	public class Workers
	{
		
		[Embed(source="../workerswfs/com/worker/CryptWorker.swf", mimeType="application/octet-stream")]
		private static var com_worker_CryptWorker_ByteClass:Class;
		
		[Embed(source="../workerswfs/com/worker/DispatchWorker.swf", mimeType="application/octet-stream")]
		private static var com_worker_DispatchWorker_ByteClass:Class;
		public static function get com_worker_CryptWorker():ByteArray
		{
			return new com_worker_CryptWorker_ByteClass();
		}
		
		public static function get com_worker_DispatchWorker():ByteArray
		{
			return new com_worker_DispatchWorker_ByteClass();
		}
		
		
	}
}
