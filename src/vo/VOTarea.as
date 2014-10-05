package vo
{
	import clases.tareas.ITarea;
	
	import flash.utils.getDefinitionByName;
	
	import sr.modulo.MapObject;
	
	public class VOTarea extends MapObject
	{
		public var tareaID:int;
		public var type:String;
		public var tipo:int;
		public var dia:int;
		public var meta:String;
		public var tarea:String;
		
		public function VOTarea() {
			super();
		}
		
		public function get metaData():Array {
			return meta.split(";");
		}
		public function get tipoString():String {
			return type.split("::").pop();
		}
		public function get repetirString():String {
			return VOHorario.TIPO[tipo];
		}
		public function get diaString():String {
			if (tipo==0)
				return VOHorario.DIAS_SEMANA[dia];
			else
				return dia.toString();
		}
		public function get metaString():String {
			var type:Class = getDefinitionByName(type) as Class;
			var t:ITarea = new type();
			return t.meta(meta);
		}
		public function toString():String {
			return tarea;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.tareaID;
			return o;
		}
	}
}