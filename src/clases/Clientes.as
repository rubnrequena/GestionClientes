package clases
{
	import utils.VectorUtil;
	
	import vo.VOClase;
	import vo.VOCliente;

	public class Clientes
	{
		protected var updateFlag:Boolean=true;
		protected var _data:Vector.<VOCliente>;

		public function Clientes() {
			
		}
		
		public function get data():Vector.<VOCliente> {
			if (updateFlag) update();
			return _data;
		}
		public function insertar (cliente:VOCliente):VOCliente {
			if (updateFlag) update();
			cliente.clienteID = GestionClientes.sql.insertar("clientes",cliente.toObject).lastInsertRowID;
			_data.push(cliente);
			return cliente;
		}
		public function byID (clienteID:int):VOCliente {
			if (updateFlag) update();
			var i:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].clienteID==clienteID) return _data[i];
			}
			return null;
		}
		public function byCedula (cedula:String):VOCliente {
			if (updateFlag) update();
			var i:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].cedula==cedula) return _data[i];
			}
			return null;
		}
		public function byGroup (grupoID:int):Vector.<VOCliente> {
			if (updateFlag) update();
			var r:Vector.<VOCliente> = new Vector.<VOCliente>; var i:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].grupoID==grupoID) r.push(_data[i]);
			}
			return r;
		}
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("clientes",null,VOCliente).data,Vector.<VOCliente>);
			updateFlag=false;
		}
		
		public function cumpleaneros (mes:int):Vector.<VOCliente> {
			if (updateFlag) update();
			var m:String = mes<10?"0"+mes:mes.toString();			
			var clientes:Vector.<VOCliente> = new Vector.<VOCliente>; 
			var i:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].fechaNacimiento.substr(5,2)==m) clientes.push(_data[i]);
			}
			return clientes;
		}
	}
}