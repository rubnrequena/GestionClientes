package vo
{
	import com.adobe.utils.StringUtil;
	
	import mx.utils.ObjectUtil;
	
	import sr.modulo.MapObject;
	
	import utils.VectorUtil;

	public class VOHorario extends MapObject
	{
		public static const TIPO_SEMANAL:int=0;
		public static const TIPO_MENSUAL:int=1;
		
		public var horarioID:int;
		public var claseID:int;
		public var grupoID:int;
		public var tipo:int;
		public var entrada:int;
		public var salida:int;
		public var dias:String;
		
		
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
		public function get clase():VOClase {
			return GestionClientes.clasess.byID(claseID);
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.horarioID;
			return o;
		}
		public function enRango (hora:int):Boolean {
			if (hora>=entrada && hora<=salida )
				return true
			else
				return false;
		}
		public function get listDias():Vector.<int> { 
			return VectorUtil.toVector(dias.split(","),Vector.<int>);; 
		}
		public function get diasString ():String {
			if (tipo==0) {
				var adias:Array = dias.split(",");
				for (var i:int = 0; i < adias.length; i++) adias[i] = DIAS_SEMANA[adias[i]];
				return adias.join(",");
			} else {
				return dias;
			}
		}
		public function get tipoString():String {
			return TIPO[tipo];
		}
		public function get entradaString():String {
			return timeString(entrada);
		}
		public function get salidaString():String {
			return timeString(salida);
		}
		public static function timeString (time:int):String {
			var h:int = time/100;
			var m:int = time-(h*100);
			var a:String = "am";
			if (h>12) { h-=12; a="pm"; }
			return zero(h)+":"+zero(m)+" "+a;
		}
				
		private static function zero (n:int):String {
			return n>9?n.toString():"0"+n;
		}
		
		public static function asistir (now:Date,horarios:Vector.<VOHorario>):int {
			var time:int = int([now.hours,zero(now.minutes)].join(""));
			var hoy:String; var h:int;
			for (var i:int = 0; i < horarios.length; i++) {
				hoy = horarios[i].tipo?now.date.toString():now.day.toString();
				h = horarios[i].listDias.indexOf(hoy);
				if (h>-1 && horarios[i].enRango(time))
					return i;
			}
			return -1;
		}
	}
}