package vo
{
	import sr.modulo.MapObject;
	
	public class VOGrupo extends MapObject
	{
		public var grupoID:int;
		public var descripcion:String;
		public var nombre:String;
		public var renta:Number;
		public var inscripcion:Number;
				
		public function VOGrupo() {
			super();
		}
		
		public function toString():String {
			return nombre;
		}
		public function clientes():Vector.<VOCliente> {
			return GestionClientes.clientes.byGroup(grupoID);
		}
		
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.grupoID;
			return o;
		}
	}
}