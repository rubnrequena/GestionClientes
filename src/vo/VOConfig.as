package vo
{
	import sr.modulo.MapObject;
	
	public class VOConfig extends MapObject
	{
		public var configID:int;
		public var key:String;
		public var value:*;
		public function VOConfig()
		{
			super();
		}
	}
}