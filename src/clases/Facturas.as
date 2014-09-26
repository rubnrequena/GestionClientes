package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOFactura;

	public class Facturas
	{
		private var updateFlag:Boolean=true;
		
		private var _data:Vector.<VOFactura>;
		public function get data():Vector.<VOFactura> {
			if (updateFlag) update();
			return _data; 
		}
		
		public function Facturas() {
			
		}
				
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("facturas",null,VOFactura).data,Vector.<VOFactura>);
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
		public function byCorrelativo (correlativo:int):VOFactura {
			if (updateFlag) update();
			var i:int;
			for (i = 0; i < _data.length; i++)
				if (_data[i].correlativo==correlativo) return _data[i];
			return null;
		}
		public function instertar (factura:VOFactura):VOFactura {
			if (updateFlag) update();
			factura.facturaID = GestionClientes.sql.insertar("facturas",factura.toObject).lastInsertRowID;
			_data.push(factura);
			return factura;
		}
	}
}