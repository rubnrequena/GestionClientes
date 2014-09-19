package vo
{
	import clases.Config;
	
	import sr.helpers.Value;
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	
	public class VOPago extends MapObject
	{
		public var pagoID:int;
		public var facturaID:int;
		public var clienteID:int;
		public var descripcion:String;
		public var monto:Number=0;
		public var fecha:String;
		public var cantidad:Number=0;
		public var usuarioID:int;
		public var pendiente:Boolean;
		
		public function get total():Number {
			return cantidad*monto;
		}
		public function get fechaLocal():String {
			return DateUtil.toggleDate(fecha);
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.pagoID;
			return o;
		}
	}
}