package vo
{
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	

	public class VOAsistencia extends MapObject
	{
		public var asistenciaID:int;
		public var clienteID:int;
		public var grupoID:int;
		public var fechaIngreso:String;
		public var horaIngreso:int;
		public var usuario:int;
		
		public function get cliente ():VOCliente {
			return GestionClientes.clientes.byID(clienteID);
		}
		public function get grupo ():VOGrupo {
			return GestionClientes.grupos.byID(grupoID);
		}
		public function get fechaIngresoLocal():String {
			return DateUtil.toggleDate(fechaIngreso);
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.asistenciaID;
			return o;
		}
	}
}