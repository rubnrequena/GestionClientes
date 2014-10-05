package clases.tareas
{
	import com.adobe.crypto.MD5;
	
	import flash.filesystem.File;
	
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOHorario;

	public class TPago implements ITarea
	{
		protected var grupoID:int;
		protected var descripcion:String;
		protected var fecha:String;
		protected var usuarioID:int;

		private var d:Date;

		private var grupo:VOGrupo;
		private var clientes:Vector.<VOCliente>;
		
		public function TPago() {
			
		}
		
		public function meta(meta:String):String {
			var data:Array = meta.split(";");
			return [
				"Grupo: "+GestionClientes.grupos.byID(data[0]).nombre,
				"Descripción: "+data[1]
			].join("\n");
		}
		
		
		public function iniciar(arguments:Array):void {
			grupoID = arguments[0];
			descripcion = arguments[1];
			fecha = arguments[2];
			usuarioID = arguments[3];
			
			d = new Date;
			
			clientes = GestionClientes.clientes.byGroup(grupoID);
			if (clientes.length>0) {
				grupo = GestionClientes.grupos.byID(grupoID);
				var pagos:Array = []; var pago:Object = {};
				var i:int; var hash:String; var descNoTags:String;
				for (i = 0; i < clientes.length; i++) {
					descNoTags = replaceTags(descripcion); 
					hash = MD5.hash(descNoTags+clientes[i].clienteID);
					if (!GestionClientes.pagos.hasHash(hash)) {
						pago = {};
						pago.clienteID = clientes[i].clienteID;
						pago.descripcion = descNoTags;
						pago.monto = grupo.renta;
						pago.cantidad = 1;
						pago.usuarioID = usuarioID;
						pago.fecha = fecha;
						pago.pendiente = true;
						pago.hash = hash;
						pagos.push(pago);
					}
				}
			}
			if (pagos.length>0)
				GestionClientes.sql.insertarUnion("pagos",pagos);
			grupo=null;	clientes=null; pagos=null; pago=null;
		}
		
		
		private function replaceTags(descripcion:String):String {
			descripcion = descripcion.split("{MES}").join(VOHorario.MESES[d.month].label);
			descripcion = descripcion.split("{AÑO}").join(d.fullYear);
			descripcion = descripcion.split("{GRUPO}").join(grupo.nombre);
			return descripcion.toUpperCase();
		}
	}
}