package vo
{
	import clases.Config;
	
	import mx.utils.StringUtil;
	
	import sr.helpers.Value;
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	
	public class VOFactura extends MapObject
	{
		public var facturaID:int;
		public var clienteID:int;
		public var fecha:String;
		public var usuarioID:int;
		public var correlativo:int;
		public var monto:Number;
		
		public function VOFactura() {
			
		}
		public function get fechaLocal():String {
			return DateUtil.toggleDate(fecha);
		}
		public function get correlativoString():String {
			var len:int = correlativo.toString().length;
			return StringUtil.repeat("0",6-len)+correlativo.toString(); 
		}
		public function get cliente():VOCliente {
			return GestionClientes.clientes.byID(clienteID);
		}
		public function get pagos():Vector.<VOPago> {
			return GestionClientes.pagos.byFactura(facturaID);
		}
		public function cancelarPagos():void {
			GestionClientes.config.init();
			Config.sql_set.push(Value.fromPool("pendiente",false));
			Config.sql_where.push(Value.fromPool("facturaID",facturaID));
			GestionClientes.sql.actualizar("pagos",Config.sql_set,Config.sql_where);
			Config.resetPool();
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.facturaID;
			return o;
		}
	}
}