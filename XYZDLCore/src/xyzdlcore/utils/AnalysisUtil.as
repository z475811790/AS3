package xyzdlcore.utils
{
	public class AnalysisUtil
	{
		public function AnalysisUtil()
		{
		}
		public static function convertFlowRate(value:uint):String
		{
			if(value < 1000)
			{
				return value + " B/s"
			}
			if(value < 1000000)
			{
				return (value / 1000).toFixed(1) + " KB/s";
			}
			else
			{
				return (value / 1000000).toFixed(1) + " MB/s";
			}
		}
	}
}