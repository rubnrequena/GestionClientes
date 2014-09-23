package clases
{
	import clases.tareas.TPago;
	
	import flash.utils.getDefinitionByName;
	
	import mx.controls.DateField;
	
	import utils.VectorUtil;
	
	import vo.VOTarea;

	public class Tareas
	{
		private var tpago:TPago;
		
		protected var updateFlag:Boolean=true;

		protected var _data:Vector.<VOTarea>;
		public function get data():Vector.<VOTarea> {
			if (updateFlag) update();
			return _data;
		}		
		
		public function Tareas() {
			run();
		}
		private function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("tareas",null,VOTarea).data,Vector.<VOTarea>);
			updateFlag=false;
		}
		public function insertar (tarea:VOTarea):VOTarea {
			tarea.tareaID = GestionClientes.sql.insertar("tareas",tarea.toObject).lastInsertRowID;
			updateFlag=true;
			return tarea;
		}
		
		public function run():void {
			var d:Date = new Date; var i:int;
			var ds:String = DateField.dateToString(d,"YYYY-MM-DD");
			if (updateFlag) update(); 
			for (i = 0; i < _data.length; i++) {
				if (_data[i].tipo==0) {
					if (d.day==_data[i].dia) {
						runTask(_data[i],ds);
					}
				} else {
					if (d.date>=_data[i].dia) {
						runTask(_data[i],ds);
					}
				}
			}			
		}
		
		public function runTask(tarea:VOTarea,date:String):void {
			var type:Class = getDefinitionByName(tarea.type) as Class;
			var t:Object = new type(tarea.metaData.concat(date,1));
		}
	}
}