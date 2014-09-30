package vo
{
	import sr.modulo.MapObject;
	
	public class VOUsuario extends MapObject
	{
		public static var USUARIO_ACTIVO:VOUsuario;
		
		public static const ACCESOS:Array = [
			{label:"Administrador"},
			{label:"Empleado"}
		];
		
		public var usuarioID:int;
		public var usuario:String;
		public var pass:String;
		public var acceso:int;
		public var nombre:String;
		
		public function VOUsuario() {
			super();
		}
		
		
		public function get accesoString ():String {
			return ACCESOS[acceso].label;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.usuarioID;
			return o;
		}
	}
}