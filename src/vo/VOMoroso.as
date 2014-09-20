package vo
{
	import utils.DateUtil;
	

	public class VOMoroso
	{
		public var clienteID:int;
		public var nombres:String;
		public var fecha:String;
		public var monto:Number;
		
		public function get fechaLocal():String {
			return DateUtil.toggleDate(fecha);
		}
		
		public function get cliente():VOCliente {
			return GestionClientes.clientes.byID(clienteID);
		}
		
		public function VOMoroso() {
			
		}
	}
}