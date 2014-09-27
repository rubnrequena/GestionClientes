package clases
{
	import org.osflash.signals.Signal;
	
	import sr.helpers.Value;
	
	import vo.VOConfig;

	public class Config
	{
		public static var sql_set:Vector.<Value>;
		public static var sql_where:Vector.<Value>;
		public static function resetPool():void {
			sql_set.length = sql_where.length = 0;
		}
		public var correlativo:int;
		public var razon_social:String="SALSA CASINO";
		public var rif:String="J-00000000-0";
		public var anchoPapel:Number=300;

		public var change:Signal = new Signal();
		
		public function Config() {
			reload();
		}
		
		private var initialized:Boolean;
		public function init():void {
			if (!initialized) {
				sql_set = new Vector.<Value>;
				sql_where = new Vector.<Value>;
				change = new Signal;
				initialized=true;
			} else {
				resetPool();
			}
		}
		public function reload():void {
			var data:Array = GestionClientes.sql.seleccionar("config",null,VOConfig).data;
			for each (var c:VOConfig in data) {
				if (c.key in this) {
					this[c.key]=c.value;
				}
			}
		}
		public function update (campo:String,valor:*):void {
			init(); 
			
			sql_set.push(Value.fromPool("value",valor));
			sql_where.push(Value.fromPool("key",campo));
			
			GestionClientes.sql.actualizar("config",sql_set,sql_where);
			this[campo]=valor;
			change.dispatch(campo,valor);
			
			resetPool();
		}
	}
}