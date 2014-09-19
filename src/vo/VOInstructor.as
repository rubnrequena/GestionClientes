package vo
{
	import sr.modulo.MapObject;
	
	public class VOInstructor extends MapObject
	{
		public var instructorID:int;
		public var nombres:String;
		public var cedula:String;
		public var telefonos:String;
		
		public function VOInstructor()
		{
			super();
		}
		public function toString():String {
			return nombres;
		}
		override public function get toObject():Object {
			var i:Object = super.toObject;
			delete i.instructorID;
			return i;
		}
	}
}