package vo
{
	import org.osflash.signals.Signal;
	
	import sr.modulo.MapObject;
	
	public class VOUsuario extends MapObject
	{
		public static const USER_ADMIN:int = 0;
		public static const USER_EMPLEADO:int = 1;
		
		public static const usuarioChange:Signal = new Signal(VOUsuario);
		
		private static var _USUARIO_ACTIVO:VOUsuario;
		public static function get USUARIO_ACTIVO():VOUsuario { return _USUARIO_ACTIVO; }
		public static function set USUARIO_ACTIVO(value:VOUsuario):void {
			if (_USUARIO_ACTIVO!=value) {
				_USUARIO_ACTIVO = value;
				usuarioChange.dispatch(value);
			}
		}		
		public static const ACCESOS:Array = [
			{label:"Administrador"},
			{label:"Empleado"}
		];
		
		public var usuarioID:int;
		public var usuario:String;
		public var pass:String;
		public var nombre:String;
				
		public var acceso:int;
		public function get accesoString ():String { return ACCESOS[acceso].label; }
		
		public function toString():String {
			return nombre;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.usuarioID;
			return o;
		}
	}
}