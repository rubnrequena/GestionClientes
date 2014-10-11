package vo
{
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	

	public class VOAsistencia extends MapObject
	{
		public static const RECHAZADA_HORARIO_INVALIDO:int=-1;
		public static const RECHAZADA_ASISTENCIA_PREVIA:int=-2;
		
		public var asistenciaID:int;
		public var clienteID:int;
		public var grupoID:int;
		public var fechaIngreso:String;
		public var horaIngreso:int;
		public var usuarioID:int;
		public var claseID:int;
		public var asistio:Boolean;
		public var entrada:int;
		public var salida:int;
		public var salonID:int;
		
		public function get clase():VOClase {
			return GestionClientes.clasess.byID(claseID);
		}
		public function get asistioString():String {
			return asistio?"Si":"No";
		}
		public function get usuario():VOUsuario {
			return GestionClientes.usuarios.byID(usuarioID);
		}		
		public function get cliente ():VOCliente {
			return GestionClientes.clientes.byID(clienteID);
		}
		public function get grupo ():VOGrupo {
			return GestionClientes.grupos.byID(grupoID);
		}
		public function get fechaIngresoLocal():String {
			return DateUtil.toggleDate(fechaIngreso);
		}
		public function get horaLocal():String {
			return VOHorario.timeString(horaIngreso);
		}
		public function enRango (hora:int):Boolean {
			trace(entrada,hora,salida);
			return hora>=entrada&&hora<=salida?true:false;
		}
		
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.asistenciaID;
			return o;
		}
	}
}