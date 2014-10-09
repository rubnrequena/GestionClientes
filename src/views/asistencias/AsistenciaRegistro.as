package views.asistencias
{
	import clases.Asistencias;
	import clases.Clases;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeStyle;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import spark.events.TextOperationEvent;
	import spark.formatters.DateTimeFormatter;
	
	import utils.DateUtil;
	
	import vo.VOAsistencia;
	import vo.VOCliente;
	import vo.VOHorario;
	import vo.VOUsuario;

	public class AsistenciaRegistro extends AsistenciaRegistroUI
	{
		public var back:Boolean=true;
		
		public function AsistenciaRegistro() {
			
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized)
				childrenCreated();
		}
		
		override protected function onRemoved(event:Event):void {
			super.onRemoved(event);
			btnRegistrar.removeEventListener(MouseEvent.CLICK,registrarClick);
		}
		
		override protected function childrenCreated():void {
			if (back)
				btnAtras.addEventListener(MouseEvent.CLICK,cancelarClick);
			else
				controlBarContent.pop();
			
			btnRegistrar.addEventListener(MouseEvent.CLICK,registrarClick);
			cedulaInput.addEventListener(FlexEvent.ENTER,registrarClick);
			cedulaInput.addEventListener(TextOperationEvent.CHANGE,cedulaChange);
			cedulaInput.setFocus();
			
		}		
		
		protected function cedulaChange(event:TextOperationEvent):void {
			resultGroup.visible = false;
			currentState="registrar";
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		protected function registrarClick(event:Event):void {
			resultGroup.visible=true;
			
			var cliente:VOCliente = GestionClientes.clientes.byCedula(cedulaInput.text);
			if (cliente) {
				currentState="resultado";
				var ahora:Date = new Date;
				clienteCard.cliente = cliente;
				
				var asistenciaIndice:int = GestionClientes.asistencias.registrarAsistencia(cliente.clienteID,DateUtil.dateToString(ahora,"YYYY-MM-DD"),int(DateUtil.dateToString(ahora,"HHnn")));
				if (asistenciaIndice>-1) {
					resultGroup.styleName = "well-success text-size-lg";
					resultLabel.text = "ASISTENCIA REGISTRADA";
					
					if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_registrada.play(0,1);
					
				} else if (asistenciaIndice==-1) {
					resultLabel.text = "ASISTENCIA RECHAZADA: HORARIO NO PERMITIDO";
					resultGroup.styleName = "well-danger text-size-lg";
					if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_rechazada.play(0,1);
				} else if (asistenciaIndice==-2) {
					resultLabel.text = "ASISTENCIA RECHAZADA: ASISTENCIA PREVIA REGISTRADA";
					resultGroup.styleName = "well-danger text-size-lg";
					if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_rechazada.play(0,1);
				}
				clienteAsistencias.dataProvider = new VectorList(cliente.asistencias());
				clienteHorarios.dataProvider = new VectorCollection(cliente.horarios);
			} else {
				resultLabel.text = "ASISTENCIA RECHAZADA: CLIENTE NO EXISTE";
				resultGroup.styleName = "well-danger text-size-lg";
				if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_rechazada.play(0,1);
			}
		}
	}
}