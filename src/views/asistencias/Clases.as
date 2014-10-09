package views.asistencias
{
	import clases.Horarios;
	
	import com.ListPickerSearch;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ListCollectionView;
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	
	import utils.DateUtil;
	
	import vo.VOAsistencia;
	import vo.VOClase;
	import vo.VOCliente;
	import vo.VOHorario;
	import vo.VOUsuario;

	public class Clases extends ClasesUI
	{
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
		override protected function createChildren():void {
			super.createChildren();
			claseInput.pickerClass = new ClassFactory(ListPickerSearch);
			claseInput.onClose = claseInput_close;
		}
		override protected function onRemoved(event:Event):void {
			super.onRemoved(event);
		}		
		override protected function childrenCreated():void {
			super.childrenCreated();
			
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnGuardar.addEventListener(MouseEvent.CLICK,registrar_click);
			
			claseInput.dataProvider = new VectorCollection(GestionClientes.clasess.data);
		}
		
		protected function registrar_click(event:MouseEvent):void {
			var clientes:Vector.<VOCliente> = (claseInput.selectedItem as VOClase).clientes;
			var asistencias:Array = new Array(clientes.length);
			var asistencia:VOAsistencia;
			var ahora:Date = new Date;
			for (var i:int = 0; i < clientes.length; i++) {
				asistencia = new VOAsistencia;
				asistencia.clienteID = clientes[i].clienteID;
				asistencia.grupoID = clientes[i].grupoID;
				asistencia.claseID = (claseInput.selectedItem as VOClase).claseID;
				asistencia.salonID = (claseInput.selectedItem as VOClase).salonID;
				asistencia.usuarioID = VOUsuario.USUARIO_ACTIVO.usuarioID;
				if (horariosGrid.dataProviderLength==1) {
					asistencia.entrada = (horariosGrid.dataProvider.getItemAt(0) as VOHorario).entrada;  
					asistencia.salida = (horariosGrid.dataProvider.getItemAt(0) as VOHorario).salida;
				} else {
					asistencia.entrada = (horariosGrid.selectedItem as VOHorario).entrada;  
					asistencia.salida = (horariosGrid.selectedItem as VOHorario).salida;
				}
				asistencia.asistio = false;
				asistencia.horaIngreso = int(DateUtil.dateToString(ahora,"HHnn"));
				asistencia.fechaIngreso = DateUtil.dateToString(ahora,"YYYY-MM-DD");
				asistencias[i] = asistencia.toObject;
			}
			GestionClientes.asistencias.insertar_lote(asistencias);
			ModalAlert.showDelay("Clase registrada exitosamente","Registrar clase",null,1000,function ():void {
				claseInput.selectedIndex=-1;
				clientesGrid.dataProvider = horariosGrid.dataProvider = null;
			});
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack(true);
		}
		
		private function claseInput_close(index:int,clase:VOClase):void {
			clientesGrid.dataProvider = new VectorCollection(clase.clientes);
			var horariosDia:VectorCollection = new VectorCollection(clase.horarios);
			var hoy:Date = new Date;
			horariosDia.filterFunction = function (item:VOHorario):Boolean {
				if (item.tipo==0) {
					return item.listDias.indexOf(hoy.day)>-1?true:false;
				} else {
					return item.listDias.indexOf(hoy.date)>-1?true:false;
				}
			};
			horariosDia.refresh();
			horariosGrid.dataProvider = horariosDia;
		}
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) childrenCreated();
		}
	}
}