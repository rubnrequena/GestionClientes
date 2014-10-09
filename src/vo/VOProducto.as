package vo
{
	import sr.modulo.MapObject;
	
	public class VOProducto extends MapObject
	{
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