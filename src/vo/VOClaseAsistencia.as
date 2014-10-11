package vo
{
	import sr.modulo.MapObject;
	
	public class VOClaseAsistencia extends MapObject
	{
		public var ID:int;
		public var claseID:int;
		public var usuarioID:int;
		public var fecha:String;
		
		public function VOClaseAsistencia() {
			super();
		}
		
		public function get clase():VOClase {
			return GestionClientes.clasess.byID(claseID);
		}
	}
}