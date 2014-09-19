package views.finanzas
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.utils.StringUtil;
	
	import org.apache.flex.collections.VectorCollection;
	
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOTarea;

	public class Tareas extends TareasUI
	{	
		public function Tareas() {
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			insertarTarea.addEventListener(MouseEvent.CLICK,insertarTarea_click);
			removerTarea.addEventListener(MouseEvent.CLICK,removerTarea_click);
			
			tipoInput.onClose = tipoClose;
			
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
		}
		
		private function tipoClose(tipo:int):void {
			var i:int;
			var data:Array = tipo?VOHorario.DIAS_MES.slice():VOHorario.DIAS_SEMANA.slice();
			for (i = 0; i < data.length; i++) {
				data[i] = {label:data[i]};
			}
			diasInput.dataProvider = new ArrayList(data); 
		}
		protected function removerTarea_click(event:MouseEvent):void {
			
		}
		protected function insertarTarea_click(event:MouseEvent):void {
			var grupo:VOGrupo = grupoInput.selectedItem as VOGrupo;
			
			var tarea:VOTarea = new VOTarea;
			tarea.dia = diasInput.selectedIndex+tipoInput.selectedIndex;
			tarea.tipo = tipoInput.selectedIndex;
			tarea.meta = [grupo.grupoID,descInput.text].join(";");
			tarea.tarea = descTareaInput.text;
			tarea.type = tareaInput.selectedItem.type;
			
			GestionClientes.tareas.insertar(tarea);
		}
	}
}