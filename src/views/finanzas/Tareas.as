package views.finanzas
{
	import com.ListPicker;
	import com.ModalAlert;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.utils.StringUtil;
	
	import org.apache.flex.collections.VectorCollection;
	
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOTarea;

	public class Tareas extends TareasUI
	{	
		
		private const tags:ArrayList = new ArrayList([
			{label:"DIA",data:"{DIA}"},
			{label:"SEMANA",data:"{SEMANA}"},
			{label:"MES",data:"{MES}"},
			{label:"AÑO",data:"{AÑO}"},
			{label:"CLIENTE",data:"{CLIENTE}"},
			{label:"INSTRUCTOR",data:"{INSTRUCTOR}"},
			{label:"GRUPO",data:"{GRUPO}"}
		]);
		public function Tareas() {
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			insertarTarea.addEventListener(MouseEvent.CLICK,insertarTarea_click);
			removerTarea.addEventListener(MouseEvent.CLICK,removerTarea_click);
			
			tipoInput.onClose = tipoClose;
			
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			btnEtiquetas.addEventListener(MouseEvent.CLICK,etiquetas_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnView.addEventListener(MouseEvent.CLICK,ocultar_click);
			
			tareasGrid.dataProvider = new VectorCollection(GestionClientes.tareas.data);
		}
		
		protected function ocultar_click(event:MouseEvent):void {
			form.visible = form.includeInLayout = !form.visible;
			btnView.label = form.visible?"Ocultar formulario":"Mostrar formulario";
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		protected function etiquetas_click(event:MouseEvent):void {
			var picker:ListPicker = new ListPicker;
			picker.dataProvider = tags;
			picker.onClose = function (i:int,item:Object):void {
				var pos:int = descInput.selectionActivePosition;
				if (pos != -1) {
					descInput.text = descInput.text.substr(0, pos) + item.data + descInput.text.substr(pos, descInput.text.length - pos);
				} else {
					descInput.appendText(item.data);
				}
			};
			picker.popUp();
		}
		
		private function tipoClose(tipo:int):void {
			if (tipo==VOTarea.TIPO_DIARIO || tipo==VOTarea.TIPO_INSCRIPCION) {
				diasInput.enabled=false;
				diasInput.dataProvider = null;
			} else {
				diasInput.enabled=true;
				var i:int;
				var data:Array = tipo?VOHorario.DIAS_MES.slice():VOHorario.DIAS_SEMANA.slice();
				for (i = 0; i < data.length; i++) {
					data[i] = {label:data[i]};
				}
				diasInput.dataProvider = new ArrayList(data);
			}
			diasInput.selectedIndex=-1;
		}
		protected function removerTarea_click(event:MouseEvent):void {
			if (tareasGrid.selectedIndex>-1) {
				ModalAlert.show("¿Seguro desea eliminar tarea?","Tareas",null,[ModalAlert.YES,ModalAlert.NO],function (detalle:int):void {
					if (detalle==0) {
						var tarea:VOTarea = tareasGrid.selectedItem as VOTarea;
						GestionClientes.tareas.remover(tarea.tareaID);
						tareasGrid.dataProvider = new VectorCollection(GestionClientes.tareas.data);
					}
				});
			}
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
			tareasGrid.dataProvider = new VectorCollection(GestionClientes.tareas.data);
		}
	}
}