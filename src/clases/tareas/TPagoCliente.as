package clases.tareas
{
	import com.adobe.crypto.MD5;
	
	import vo.VOCliente;
	import vo.VOHorario;
	import vo.VOGrupo;

	public class TPagoCliente implements ITarea
	{
		protected var clienteID:int;
		protected var descripcion:String;
		protected var fecha:String;
		protected var usuarioID:int;
		
		private var d:Date;
		private var cliente:VOCliente;
		private var grupo:VOGrupo;
				
		public function TPagoCliente()
		{
		}
		
		public function meta(meta:String):String {
			var data:Array = meta.split(";");
			return [
				"Cliente: "+GestionClientes.clientes.byID(data[0]).nombres,
				"Descripción: "+data[1]
			].join("\n");
		}
		
		
		public function iniciar(arguments:Array):void {
			clienteID = arguments[0];
			descripcion = arguments[1];
			fecha = arguments[2];
			usuarioID = arguments[3];
			
			d = new Date;			
			var pagos:Array = [];
			
			cliente = GestionClientes.clientes.byID(clienteID);
			if (cliente) {
				grupo = cliente.grupo;
				var pago:Object = {};
				var hash:String; var descNoTags:String;
				if (cliente.exonerado==false) {
					descNoTags = replaceTags(descripcion); 
					hash = MD5.hash(descNoTags+cliente.clienteID);
					if (!GestionClientes.pagos.hasHash(hash)) {
						pago = {};
						pago.clienteID = cliente.clienteID;
						pago.descripcion = descNoTags;
						pago.monto = grupo.renta;
						pago.cantidad = 1;
						pago.usuarioID = usuarioID;
						pago.fecha = fecha;
						pago.pendiente = true;
						pago.hash = hash;
						pago.tipo = 0;
						pagos.push(pago);
					} else {
						trace(hash,"existe");
					}
				} else {
					trace(clienteID," cliente exonerado");
				}
			} else {
				trace(clienteID," cliente no existe");
			}
			if (pagos.length>0)
				GestionClientes.sql.insertarUnion("pagos",pagos);
			cliente=null; pagos=null; pago=null; grupo=null; d=null;
		}
		
		
		private function replaceTags(descripcion:String):String {
			descripcion = descripcion.split("{MES}").join(VOHorario.MESES[d.month].label);
			descripcion = descripcion.split("{AÑO}").join(d.fullYear);
			descripcion = descripcion.split("{GRUPO}").join(grupo.nombre);
			descripcion = descripcion.split("{DIA}").join(d.date);
			return descripcion.toUpperCase();
		}
	}
}