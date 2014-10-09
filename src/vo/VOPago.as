package vo
{
	import clases.Config;
	
	import sr.helpers.Value;
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	
	public class VOPago extends MapObject
	{
		public static const PAGO_RENTA:int = 0;
		public static const PAGO_SERVICIO:int = 1;
		public static const PAGO_PRODUCTO:int = 2;
		public static const PAGO_MISCELANEO:int = 3;
		
		public var pagoID:int;
		public var facturaID:int;
		public var clienteID:int;
		public var descripcion:String;
		public var monto:Number=0;
		public var fecha:String;
		public var cantidad:Number=0;
		public var usuarioID:int;
		public var pendiente:Boolean;
		public var tipo:int;
		public var hash:String;
		
		public function get total():Number {
			return cantidad*monto;
		}
		public function get fechaLocal():String {
			return DateUtil.toggleDate(fecha);
		}
		public function asignarFactura (factura:int):void {
			GestionClientes.config.init();
			Config.sql_set.push(Value.fromPool("facturaID",factura));
			Config.sql_where.push(Value.fromPool("pagoID",pagoID));
			GestionClientes.sql.actualizar("pagos",Config.sql_set,Config.sql_where);
			facturaID=factura;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.pagoID;
			return o;
		}
	}
}