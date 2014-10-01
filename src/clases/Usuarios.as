package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOUsuario;

	public class Usuarios
	{
		private var updateFlag:Boolean=true;
		
		private var _data:Vector.<VOUsuario>;
		public function get data():Vector.<VOUsuario> {
			if (updateFlag) update();
			return _data;
		}
		
		public function Usuarios() {
			
		}
		private function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("usuarios",null,VOUsuario).data,Vector.<VOUsuario>);
			updateFlag=false;
		}
		public function insertar (usuario:VOUsuario):VOUsuario {
			usuario.usuarioID = GestionClientes.sql.insertar("usuarios",usuario.toObject).lastInsertRowID;
			_data.push(usuario);
			return usuario;
		}
		public function remover (usuarioID:int):void {
			GestionClientes.sql.remover("usuarios",new <Value>[
				Value.fromPool("usuarioID",usuarioID)
			]);
			updateFlag=true;
		}
		public function byID (usuarioID:int):VOUsuario {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++)
				if (_data[i].usuarioID==usuarioID) return _data[i];
			return null;
		}
		public function byUsuario(usuario:String):VOUsuario {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++)
				if (_data[i].usuario==usuario) return _data[i];
			return null;
		}
		public function byLogin (usuario:String,pass:String):VOUsuario {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++)
				if (_data[i].usuario==usuario && _data[i].pass==pass) return _data[i];
			return null;
		}
		public function byAcceso (acceso:int):Vector.<VOUsuario> {
			if (updateFlag) update();
			return _data.filter(function (usuario:VOUsuario,indice:int,data:*):Boolean {
				return usuario.acceso==this;
			},acceso);
		}
	}
}