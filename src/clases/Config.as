package clases
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	
	import sr.helpers.Value;
	
	import vo.VOConfig;

	public class Config
	{		
		public static const IMPRESION_FUENTES:Array = [
			{label:"Arial"},
			{label:"Courier New"},
			{label:"Times New Roman"},
			{label:"Verdana"}
		];
		
		public static var sql_set:Vector.<Value>;
		public static var sql_where:Vector.<Value>;
		public static function resetPool():void {
			sql_set.length = sql_where.length = 0;
		}
		
		//AUDIO
		public var asistencia_rechazada:Sound;
		public var asistencia_registrada:Sound;
		
		public var correlativo:int;
		public var razon_social:String;
		public var rif:String;
		public var impresion_anchoPapel:Number;
		public var impresion_fuente:int;
		public var sonidos:Boolean;

		public var inasistencias_alerta:int=2;
		public var inasisencias_maximas:int=10;

		public var change:Signal = new Signal();
		
		public function Config() {
			reload();
		}
		
		private var initialized:Boolean;
		public function init():void {
			if (!initialized) {
				sql_set = new Vector.<Value>;
				sql_where = new Vector.<Value>;
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
			};
			asistencia_rechazada = new Sound(new URLRequest("assets/asistencia_rechazada.mp3"));
			asistencia_registrada = new Sound(new URLRequest("assets/asistencia_registrada.mp3"));
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