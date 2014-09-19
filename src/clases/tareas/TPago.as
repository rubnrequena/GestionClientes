package clases.tareas
{
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOHorario;

	public class TPago
	{
		protected var grupoID:int;
		protected var descripcion:String;
		protected var fecha:String;
		protected var usuarioID:int;

		private var d:Date;

		private var grupo:VOGrupo;
		private var clientes:Vector.<VOCliente>;
		
		public function TPago(arguments:Array) {
			grupoID = arguments[0];
			descripcion = arguments[1];
			fecha = arguments[2];
			usuarioID = arguments[3];
						
			d = new Date;
			
			grupo = GestionClientes.grupos.byID(grupoID);
			clientes = GestionClientes.clientes.byGroup(grupoID);
			var pagos:Array = []; var pago:Object = {};
			var i:int;
			for (i = 0; i < clientes.length; i++) {
				pago = {};
				pago.clienteID = clientes[i].clienteID;
				pago.descripcion = replaceTags(descripcion);
				pago.monto = grupo.renta;
				pago.cantidad = 1;
				pago.usuarioID = usuarioID;
				pago.fecha = fecha;
				pago.pendiente = true;
				pagos.push(pago);
			}
			GestionClientes.sql.insertarUnion("pagos",pagos);
			grupo=null;	clientes=null; pagos=null; pago=null;
		}
		
		private function replaceTags(descripcion:String):String {
			descripcion = descripcion.split("{MES}").join(VOHorario.MESES[d.month]);
			descripcion = descripcion.split("{AÑO}").join(d.fullYear);
			descripcion = descripcion.split("{GRUPO}").join(grupo.nombre);
			return descripcion;
		}
	}
}