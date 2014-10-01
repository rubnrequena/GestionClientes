package views.organizacion
{
	import com.ListPickerSearch;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import utils.DateUtil;
	
	import vo.VOClase;
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOInstructor;
	import vo.VOSalon;

	public class ClaseNueva extends ClaseNuevaUI
	{
		
		private var _horarios:VectorList;
		public function ClaseNueva()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			_horarios = new VectorList;
		}
		override public function dispose():void {
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		protected function onRemoved(event:Event):void {
			btnAtras.removeEventListener(MouseEvent.CLICK,atras_click);
			btnInsertar.removeEventListener(MouseEvent.CLICK,insertar_click);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardar_click);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			
			salonInput.pickerClass = new ClassFactory(ListPickerSearch);
			instructorInput.pickerClass = new ClassFactory(ListPickerSearch);
			grupoInput.pickerClass = new ClassFactory(ListPickerSearch);
			tipoInput.onClose = function (tipo:int):void {
				diasInput.tipo = tipo;
			};
			diasGrid.dataProvider = _horarios;
		}
		override protected function childrenCreated():void {
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			btnGuardar.addEventListener(MouseEvent.CLICK,guardar_click);
			
			grupoInput.pickerClass = new ClassFactory(ListPickerSearch);
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);			
			instructorInput.pickerClass = new ClassFactory(ListPickerSearch);
			instructorInput.dataProvider = new VectorCollection(GestionClientes.instructores.data);			
			salonInput.pickerClass = new ClassFactory(ListPickerSearch);
			salonInput.dataProvider = new VectorCollection(GestionClientes.salones.data);
			super.childrenCreated();
		}	
		
		protected function remover_click(event:MouseEvent):void {
			if (diasGrid.selectedIndex>-1)
				_horarios.removeItemAt(diasGrid.selectedIndex);
		}
		
		protected function guardar_click(event:MouseEvent):void {
			if (formClase.validate) {
				var clase:VOClase = new VOClase;
				clase.grupoID = (grupoInput.selectedItem as VOGrupo).grupoID;
				clase.salonID = (salonInput.selectedItem as VOSalon).salonID;
				clase.instructorID = (instructorInput.selectedItem as VOInstructor).instructorID;
				
				GestionClientes.clasess.insertar(clase);
				
				for (var i:int = 0, horario:VOHorario; i < _horarios.length; i++) {
					horario = _horarios.getItemAt(i) as VOHorario; 
					horario.claseID = clase.claseID;
					horario.grupoID = clase.grupoID;
					GestionClientes.horarios.insertar(horario);
				}
				
				ModalAlert.showDelay("Clase guardada exitosamente","Clases",null,2000,function ():void {
					instructorInput.selectedIndex = grupoInput.selectedIndex = salonInput.selectedIndex = -1;
					_horarios.removeAll();
				},"well-info");
			}
		}
		protected function insertar_click(event:MouseEvent):void {
			if (formHorario.validate) {
				var h:VOHorario = new VOHorario;
				h.entrada = entradaInput.time;
				h.salida = salidaInput.time;
				h.dias = diasInput.dias;
				h.tipo = tipoInput.selectedIndex;
				
				_horarios.addItem(h);
				
				tipoInput.selectedIndex = -1;
				diasInput.tipo = -1;
			}
		}
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}