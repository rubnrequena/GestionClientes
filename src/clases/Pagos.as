package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOPago;

	public class Pagos
	{
		private var updateFlag:Boolean=true;
		private var _data:Vector.<VOPago>;
		private var _numPagos:int;

		public function get data():Vector.<VOPago> {
			loadIfNeeded()
			return _data;
		}
		public function loadIfNeeded():void {
			if (updateFlag) update();
		}
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("pagos",null,VOPago).data,Vector.<VOPago>);
			_numPagos = _data.length;	
			updateFlag=false;
		}		
		public function insertar (pago:VOPago):VOPago {
			loadIfNeeded();
			pago.pagoID = GestionClientes.sql.insertar("pagos",pago.toObject).lastInsertRowID;
			_data.push(pago);
			_numPagos++;
			return pago;
		}
		public function byCliente (clienteID:int):Vector.<VOPago> {
			loadIfNeeded();
			var i:int; var r:Vector.<VOPago> = new Vector.<VOPago>;
			for (i = 0; i < _numPagos; i++) {
				if (_data[i].clienteID==clienteID) r.push(_data[i]);
			}
			return r;
		}
		public function byFactura (facturaID:int):Vector.<VOPago> {
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("pagos",new <Value>[
				Value.fromPool("facturaID",facturaID)
			],VOPago).data,Vector.<VOPago>);
		}
		public function dispose():void {
			_data = null;
			_numPagos=0;
			updateFlag=true;
		}
	}
}