package utils
{
	import flash.utils.ByteArray;

	public class ObjectUtil
	{
		
		private static var b:ByteArray;
		private static var obj:Object;
		public function ObjectUtil()
		{
			
		}
		
		static public function toObject (o:*,exclude:Array=null):Object {
			b = new ByteArray;
			b.writeObject(o);
			b.position=0;
			obj = b.readObject();
			for each (var p:String in exclude) {
				delete obj[p];
			}
			return obj;
		}
	}
}
