package vo
{
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	
	public class VOClase extends MapObject
	{
		public var claseID:int;
		public var descripcion:String;
		public var instructorID:int;
		public var grupoID:int;
		public var salonID:int;
		public var auto_registro:Boolean;
		
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
		public function get horarios():Vector.<VOHorario> {
			return GestionClientes.horarios.byClase(claseID);
		}
		public function get clientes():Vector.<VOCliente> {
			return GestionClientes.clientes.byGroup(grupoID);
		}
		public function toString():String {
			return descripcion;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.claseID;
			return o;
		}
	}
}