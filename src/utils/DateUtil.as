package utils
{
	public class DateUtil
	{
		static public function toggleDate (date:String):String {
			if (date.indexOf("/")>-1)
				return date.split("/").reverse().join("-");
			else
				return date.split("-").reverse().join("/");
		}
	}
}