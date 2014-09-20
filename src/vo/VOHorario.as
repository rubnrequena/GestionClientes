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
		public static const MESES:Array = [
			{label:"Enero"},
			{label:"Febrero"},
			{label:"Marzo"},
			{label:"Abril"},
			{label:"Mayo"},
			{label:"Junio"},
			{label:"Julio"},
			{label:"Agosto"},
			{label:"Septiembre"},
			{label:"Octubre"},
			{label:"Noviembre"},
			{label:"Diciembre"},
		];
		public static const DIAS_SEMANA:Array = ["Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"];
		public static const DIAS_MES:Array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
		
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