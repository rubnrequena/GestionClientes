package views.asistencias
{
	import com.ListPicker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CalendarLayoutChangeEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import sr.helpers.Value;
	
	import utils.DateUtil;
	
	import vo.VOAsistencia;
	import vo.VOGrupo;

	public class Asistencias extends AsistenciasUI
	{
		private var grupo:VOGrupo;
		private var grupoIndice:int;
		
		public function Asistencias()
		{
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
			grupoInput.addEventListener(MouseEvent.CLICK,seleccionarGrupo);
			inicioInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,fechaChange);
			finInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,fechaChange);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnBuscar.addEventListener(MouseEvent.CLICK,buscarClick);
		}
		
		protected function buscarClick(event:MouseEvent):void {
			updateData();
		}
		
		protected function cancelarClick(event:MouseEvent):void {
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
		}
		
		protected function seleccionarGrupo(event:MouseEvent):void {
			var sg:ListPicker = new ListPicker();
			sg.title = "Seleccionar Grupo";
			sg.onClose = function (indice:int,data:VOGrupo):void {
				fechas.enabled=true;
				grupo = data;
				grupoInput.label = data.nombre;
				grupoIndice = indice;				
				updateData();
			};
			sg.labelField = "nombre";
			sg.dataProvider = new VectorList(GestionClientes.grupos.data);
			sg.selectedIndex = grupoIndice;
			sg.popUp();
		}
		protected function updateData():void {
			var asist:Array = GestionClientes.sql.seleccionar("asistencias",new <Value>[
				Value.fromPool("grupoID",grupo.grupoID),
				Value.fromPool("fechaIngreso",DateUtil.toggleDate(inicioInput.text),"AND",">="),
				Value.fromPool("fechaIngreso",DateUtil.toggleDate(finInput.text),"AND","<=")
			],VOAsistencia).data;
			gridAsistencias.dataProvider = new ArrayCollection(asist);
		}
	}
}