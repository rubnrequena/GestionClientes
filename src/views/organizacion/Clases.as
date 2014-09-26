package views.organizacion
{
	import com.ListPickerSearch;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import utils.DateUtil;
	
	import vo.VOClase;
	import vo.VOGrupo;
	import vo.VOInstructor;
	import vo.VOSalon;
	

	public class Clases extends ClasesUI
	{
		public function Clases()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			
			grupoInput.pickerClass = new ClassFactory(ListPickerSearch);
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			
			instructorInput.pickerClass = new ClassFactory(ListPickerSearch);
			instructorInput.dataProvider = new VectorCollection(GestionClientes.instructores.data);
			
			salonInput.pickerClass = new ClassFactory(ListPickerSearch);
			salonInput.dataProvider = new VectorCollection(GestionClientes.salones.data);
			
			btnView.addEventListener(MouseEvent.CLICK,changeView_click);
			
			btnBuscar.addEventListener(MouseEvent.CLICK,buscar_click);
			updateData();
		}		
		
		protected function buscar_click(event:MouseEvent):void {
			clasesGrid.dataProvider = new VectorCollection(GestionClientes.clasess.byFecha(DateUtil.toggleDate(dateInput2.text)));
		}
		
		protected function changeView_click(event:MouseEvent):void {
			addform.visible = addform.includeInLayout = !addform.visible;
			btnView.label = addform.visible?"Ocultar formulario":"Mostrar formulario";
			
			busqForm.visible = busqForm.includeInLayout = !busqForm.visible
		}
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		protected function remover_click(event:MouseEvent):void {
			
		}		
		protected function insertar_click(event:MouseEvent):void {
			var clase:VOClase = new VOClase;
			clase.entrada = entradaInput.time;
			clase.salida = salidaInput.time;
			clase.fecha = DateUtil.toggleDate(dateInput.text);
			clase.grupoID = (grupoInput.selectedItem as VOGrupo).grupoID;
			clase.salonID = (salonInput.selectedItem as VOSalon).salonID;
			clase.instructorID = (instructorInput.selectedItem as VOInstructor).instructorID;
			
			GestionClientes.clasess.insertar(clase);
			updateData();
		}
		
		private function updateData():void {
			clasesGrid.dataProvider = new VectorCollection(GestionClientes.clasess.data);
		}
	}
}