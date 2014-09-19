package vo
{
	import sr.modulo.MapObject;
	
	public class VOTarea extends MapObject
	{
		public var tareaID:int;
		public var type:String;
		public var tipo:int;
		public var dia:int;
		public var meta:String;
		public var tarea:String;
		
		public function VOTarea() {
			super();
		}
		
		public function get metaData():Array {
			return meta.split(";");
		}
		public function toString():String {
			return tarea;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.tareaID;
			return o;
		}
	}
}