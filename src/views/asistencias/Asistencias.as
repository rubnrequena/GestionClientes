package views.asistencias
{
	import com.ListPicker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CalendarLayoutChangeEvent;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import sr.helpers.Value;
	
	import utils.DateUtil;
	
	import vo.VOAsistencia;
	import vo.VOCliente;
	import vo.VOGrupo;

	public class Asistencias extends AsistenciasUI
	{		
		private var busquedaActual:int=-1;
		public function Asistencias() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			var d:Date = new Date;
			inicioInput.selectedDate = d;
			finInput.selectedDate = d;
		}
		
		override protected function childrenCreated():void {
			inicioInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,fechaChange);
			finInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,fechaChange);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelar_click);
			
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			grupoInput.onClose = grupoInput_close;
			clienteInput.dataProvider = new VectorCollection(GestionClientes.clientes.data);
			clienteInput.onClose = clienteInput_close;
		}
		
		private function clienteInput_close():void {
			busquedaActual=0;
			clienteItem.styleName = "well-success";
			grupoItem.styleName = "well-default";
			grupoInput.selectedIndex=-1;
			updateData();
			fechas.enabled=true;
		}		
		private function grupoInput_close(indice:int,grupo:VOGrupo):void {
			busquedaActual=1;
			grupoItem.styleName = "well-success";
			clienteItem.styleName = "well-default";
			clienteInput.selectedIndex=-1;
			updateData();
			fechas.enabled=true;
		}
			
		protected function cancelar_click(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		protected function fechaChange(event:CalendarLayoutChangeEvent):void {
			if (event.target.id=="inicioInput") {
				if (inicioInput.selectedDate>finInput.selectedDate) {
					finInput.selectedDate = inicioInput.selectedDate;
					finInput.validateNow();
				}
			}
			
			if (event.target.id=="finInput") {
				if (finInput.selectedDate<inicioInput.selectedDate) { 
					inicioInput.selectedDate = finInput.selectedDate;
					inicioInput.validateNow();
				}
			}
			invalidateProperties();
			updateData();
		}
		
		protected function updateData():void {
			var asist:Array;
			if (busquedaActual) {
				asist = GestionClientes.sql.seleccionar("asistencias",new <Value>[
					Value.fromPool("grupoID",(grupoInput.selectedItem as VOGrupo).grupoID),
					Value.fromPool("fechaIngreso",DateUtil.toggleDate(inicioInput.text),"AND",">="),
					Value.fromPool("fechaIngreso",DateUtil.toggleDate(finInput.text),"AND","<=")
				],VOAsistencia).data;
			} else {
				asist = GestionClientes.sql.seleccionar("asistencias",new <Value>[
					Value.fromPool("clienteID",(clienteInput.selectedItem as VOCliente).clienteID),
					Value.fromPool("fechaIngreso",DateUtil.toggleDate(inicioInput.text),"AND",">="),
					Value.fromPool("fechaIngreso",DateUtil.toggleDate(finInput.text),"AND","<=")
				],VOAsistencia).data;
			}
			gridAsistencias.dataProvider = new ArrayCollection(asist);
		}
	}
}