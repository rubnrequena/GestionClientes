package vo
{
	import sr.modulo.MapObject;

	public class VOHorario extends MapObject
	{
		public var horarioID:int;
		public var grupo:int;
		public var tipo:int;
		public var entrada:int;
		public var salida:int;
		public var dias:String;
		public var salonID:int;
		
		public static const TIPO:Array = ["Semanal","Mensual"];
		public static const MESES:Array = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Ocubre","Noviembre","Diciembre"];
		public static const DIAS_SEMANA:Array = ["Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"];
		
		public function VOHorario() {
			
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.horarioID;
			return o;
		}
		public function enRango (hora:int):int {
			if (hora<entrada)
				return -1;
			else if (hora>salida)
				return 1;
			else
				return 0;
		}
		public function get listDias():Array { return dias.split(","); }
		public function get diasString ():String {
			if (tipo==0) {
				var adias:Array = listDias;
				for (var i:int = 0; i < adias.length; i++) adias[i]=DIAS_SEMANA[i];
				return adias.join(",");
			} else {
				return dias;
			}
		}
		public function get tipoString():String {
			return TIPO[tipo];
		}
		public function get entradaString():String {
			var h:int = entrada/100;
			var m:int = entrada-(h*100);
			var a:String = "am";
			if (h>12) { h-=12; a="pm"; }
			return zero(h)+":"+zero(m)+" "+a;
		}
		public function get salidaString():String {
			var h:int = salida/100;
			var m:int = salida-(h*100);
			var a:String = "am";
			if (h>12) { h-=12; a="pm"; }
			return zero(h)+":"+zero(m)+" "+a;
		}
		private function zero (n:int):String {
			return n>9?n.toString():"0"+n;
		}
	}
}