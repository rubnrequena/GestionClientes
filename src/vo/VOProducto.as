package vo
{
	import sr.modulo.MapObject;
	
	public class VOProducto extends MapObject
	{
		public static const RENTA:int = 0;
		public static const SERVICIO:int = 1;
		public static const PRODUCTO:int = 2;
		public static const MISCELANEO:int = 3;
		public static const INSCRIPCION:int = 4;
		
		public var productoID:int;
		public var descripcion:String;
		public var cantidad:Number;
		public var monto:Number;
		public var tipo:int;
		
		public function VOProducto() {
			super();
		}
		
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.productoID;
			return o;
		}
		
		public function toString():String {
			return descripcion;
		}
	}
}