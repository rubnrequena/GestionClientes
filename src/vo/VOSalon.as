package vo
{	
	import sr.modulo.MapObject;

	public class VOSalon extends MapObject
	{
		public var salonID:int;
		public var nombre:String;
		
		public function VOSalon() {
			super();
		}
		
		public function toString():String { return nombre; }
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.salonID;
			return o;
		}
	}
}