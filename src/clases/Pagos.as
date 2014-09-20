package clases
{
	import com.adobe.crypto.MD5;
	
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOMoroso;
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
			pago.hash = MD5.hash(pago.descripcion+pago.clienteID);
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
		public function hasHash (hash:String):Boolean {
			loadIfNeeded();
			for (var i:int = 0; i < _numPagos; i++) {
				if (_data[i].hash==hash) return true;	
			}
			return false;
		}
		public function byFactura (facturaID:int):Vector.<VOPago> {
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("pagos",new <Value>[
				Value.fromPool("facturaID",facturaID)
			],VOPago).data,Vector.<VOPago>);
		}
		public function pagosPendientes (clienteID:int):Vector.<VOPago> {
			GestionClientes.config.init();
			Config.sql_where.push(Value.fromPool("clienteID",clienteID));
			Config.sql_where.push(Value.fromPool("pendiente",true));
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("pagos",Config.sql_where,VOPago).data,Vector.<VOPago>);
			Config.resetPool();
		}
		public function get morosos():Vector.<VOMoroso> {
			var data:Array = GestionClientes.sql.sql('SELECT clientes.clienteID, clientes.nombres, pagos.fecha, SUM(pagos.monto) monto ' +
				'FROM pagos JOIN clientes ON clientes.clienteID = pagos.clienteID WHERE pendiente = true ' +
				'GROUP BY clientes.clienteID ORDER BY monto DESC, fecha ASC',VOMoroso).data;
			return VectorUtil.toVector(data,Vector.<VOMoroso>);
		}
		public function dispose():void {
			_data = null;
			_numPagos=0;
			updateFlag=true;
		}
	}
}