package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOFactura;

	public class Facturas
	{
		private var updateFlag:Boolean=true;
		
		private var dataLen:uint;
		private var _data:Vector.<VOFactura>;
		public function get data():Vector.<VOFactura> {
			loadIfNeeded();
			return _data; 
		}
		
		public function Facturas() {
			
		}
		
		private function loadIfNeeded():void {
			if (updateFlag) update();
		}		
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("facturas",null,VOFactura).data,Vector.<VOFactura>);
			dataLen = _data.length;
			updateFlag=false;
		}
		public function byCliente (clienteID:int):Vector.<VOFactura> {
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("facturas",new <Value>[
				Value.fromPool("clienteID",clienteID)
			],VOFactura).data,Vector.<VOFactura>);
		}
		public function byFechas (inicio:String,final:String):Vector.<VOFactura> {
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("facturas",new <Value>[
				Value.fromPool("fecha",inicio,"AND",">="),
				Value.fromPool("fecha",final,"AND","<=")
			],VOFactura).data,Vector.<VOFactura>);
		}
		public function instertar (factura:VOFactura):VOFactura {
			loadIfNeeded();
			factura.facturaID = GestionClientes.sql.insertar("facturas",factura.toObject).lastInsertRowID;
			_data.push(factura);
			dataLen++;
			return factura;
		}
	}
}