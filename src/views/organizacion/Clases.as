package views.organizacion
{
	import bootstrap.controls.FormItem;
	
	import com.ListPickerSearch;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import spark.events.GridSelectionEvent;
	
	import utils.DateUtil;
	
	import vo.VOClase;
	import vo.VOGrupo;
	import vo.VOInstructor;
	import vo.VOSalon;
	

	public class Clases extends ClasesUI
	{
		private var clazes:VectorCollection;
		public function Clases()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		override public function dispose():void {
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		protected function onRemoved(event:Event):void {
			btnAtras.removeEventListener(MouseEvent.CLICK,atras_click);
			btnNuevo.removeEventListener(MouseEvent.CLICK,nuevo_click);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnNuevo.addEventListener(MouseEvent.CLICK,nuevo_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			clasesGrid.addEventListener(GridSelectionEvent.SELECTION_CHANGE,clases_selectionChange);
									
			instructorInput.dataProvider = new VectorCollection(GestionClientes.instructores.data);
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			salonInput.dataProvider = new VectorList(GestionClientes.salones.data);
			updateData();
		}		
		
		protected function remover_click(event:MouseEvent):void {
			if (clasesGrid.selectedIndex==-1) return;
			ModalAlert.show("¿Seguro desea remover clase?","Remover clase",null,[ModalAlert.YES,ModalAlert.NO],function (detalle:int):void {
				if (detalle==0) {
					GestionClientes.clasess.remover(clasesGrid.selectedItem.claseID);
				}
			},0,"well-danger");
		}
		
		protected function clases_selectionChange(event:GridSelectionEvent):void {
			horarioGrid.dataProvider = new VectorList((clasesGrid.selectedItem as VOClase).horarios);
		}
		override protected function createChildren():void {
			super.createChildren();
			
			instructorInput.pickerClass = new ClassFactory(ListPickerSearch);
			instructorInput.onClose = filtrarInstructor;
			grupoInput.pickerClass = new ClassFactory(ListPickerSearch);
			grupoInput.onClose = filtrarGrupo;
			salonInput.onClose = filtrarSalon;
		}
		
		private function resaltar(name:String):void {
			for (var i:int = 0, item:FormItem; i < formClase.numElements; i++) {
				item = formClase.getElementAt(i) as FormItem;
				item.styleName = item.name==name?"well-success":"well-default";
			}			
		}
		
		private function filtrarSalon(index:int,salon:VOSalon):void {
			clazes.filterFunction = function (item:VOClase):Boolean {
				return item.salonID==salon.salonID;
			};
			clazes.refresh();
			resaltar("salon");
		}
		
		
		private function filtrarGrupo(index:int,grupo:VOGrupo):void {
			clazes.filterFunction = function (item:VOClase):Boolean {
				return item.grupoID==grupo.grupoID;
			};
			clazes.refresh();
			resaltar("grupo");
		}
		
		private function filtrarInstructor(index:int,instructor:VOInstructor):void {
			clazes.filterFunction = function (item:VOClase):Boolean {
				return item.instructorID==instructor.instructorID;
			};
			clazes.refresh();
			resaltar("instructor");
		}
		protected function nuevo_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).addView("clase_nueva",ClaseNueva,null,true);
		}	
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}	
		
		private function updateData():void {
			clazes = new VectorCollection(GestionClientes.clasess.data);
			clasesGrid.dataProvider = clazes;
		}
	}
}