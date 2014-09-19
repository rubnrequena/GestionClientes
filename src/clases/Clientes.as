package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOCliente;
	import vo.VOGrupo;

	public class Clientes
	{
		protected var updateFlag:Boolean=true;
		protected var _clientes:Vector.<VOCliente>;
		protected var _numClientes:uint;

		public function Clientes() {
			
		}
		
		public function get clientes():Vector.<VOCliente> {
			if (updateFlag) update();
			return _clientes;
		}
		public function byID (clienteID:int):VOCliente {
			if (updateFlag) update();
			var i:int;
			for (i = 0; i < _numClientes; i++) {
				if (_clientes[i].clienteID==clienteID) return _clientes[i];
			}
			return null;
		}
		public function byGroup (grupoID:int):Vector.<VOCliente> {
			if (updateFlag) update();
			var r:Vector.<VOCliente> = new Vector.<VOCliente>(_numClientes); var i:int;
			for (i = 0; i < _numClientes; i++) {
				if (_clientes[i].grupoID==grupoID) r.push(_clientes[i]);
			}
			return r;
		}
		public function update():void {
			_clientes = VectorUtil.toVector(GestionClientes.sql.seleccionar("clientes",null,VOCliente).data,Vector.<VOCliente>);
			_numClientes = _clientes.length;
			updateFlag=false;
		}
		
		public function cumpleaneros (mes:int):Array {
			var m:String = mes<10?"0"+mes:mes.toString();
			var clientes:Array = GestionClientes.sql.seleccionar("clientes",new <Value>[
				Value.fromPool("fechaNacimiento",'%-'+m+'-%',"AND","LIKE")
			],VOCliente).data; 
			return clientes;
		}
	}
}