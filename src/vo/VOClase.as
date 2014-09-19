package vo
{
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	
	public class VOClase extends MapObject
	{
		public var claseID:int;
		public var usuarioID:int;
		public var instructorID:int;
		public var grupoID:int;
		public var salonID:int;
		public var fecha:String;
		public var entrada:int;
		public var salida:int;
		
		public function VOClase()
		{
			super();
		}
		
		public function get salon():VOSalon {
			return GestionClientes.salones.byID(salonID);
		}
		public function get instructor():VOInstructor {
			return GestionClientes.instructores.byID(instructorID);
		}
		public function get grupo():VOGrupo {
			return GestionClientes.grupos.byID(grupoID);
		}
		public function get fechaLocal():String {
			return DateUtil.toggleDate(fecha);
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.claseID;
			return o;
		}
	}
}