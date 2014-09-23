package views.asistencias
{
	import clases.Horarios;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeStyle;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import spark.events.TextOperationEvent;
	import spark.formatters.DateTimeFormatter;
	
	import vo.VOAsistencia;
	import vo.VOCliente;

	public class AsistenciaRegistro extends AsistenciaRegistroUI
	{
		private var horarios:Horarios;
		public function AsistenciaRegistro()
		{
			horarios = GestionClientes.horarios;
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		
		protected function onRemoved(event:Event):void {
			btnRegistrar.removeEventListener(MouseEvent.CLICK,registrarClick);
		}
		
		override protected function childrenCreated():void {
			btnRegistrar.addEventListener(MouseEvent.CLICK,registrarClick);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			cedulaInput.addEventListener(FlexEvent.ENTER,registrarClick);
			cedulaInput.addEventListener(TextOperationEvent.CHANGE,cedulaChange);
			cedulaInput.setFocus();
		}		
		
		protected function cedulaChange(event:TextOperationEvent):void {
			resultGroup.visible = false;
			currentState="registrar";
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		protected function registrarClick(event:Event):void {
			resultGroup.visible=true;
			
			var cliente:VOCliente = GestionClientes.clientes.byCedula(cedulaInput.text);
			if (cliente) {
				currentState="resultado";
				var ahora:Date = new Date;
				clienteCard.cliente = cliente;
				clienteAsistencias.dataProvider = new VectorList(cliente.asistencias(10));
				clienteHorarios.dataProvider = new VectorCollection(cliente.horarios);
				if (horarios.entradaPermitida(ahora,cliente)) {
					resultGroup.styleName = "well-success text-size-lg";
					resultLabel.text = "ASISTENCIA REGISTRADA";
					
					var s:DateTimeFormatter = new DateTimeFormatter;
					s.setStyle("locale","es_VE");
					s.dateStyle = DateTimeStyle.NONE;
					s.timeStyle = DateTimeStyle.SHORT;
					
					var a:VOAsistencia = new VOAsistencia;
					a.clienteID = cliente.clienteID;
					a.grupoID = cliente.grupoID;
					a.fechaIngreso = DateField.dateToString(ahora,"YYYY-MM-DD");
					a.horaIngreso = s.format(ahora);
					a.usuario = 0;
					
					GestionClientes.sql.insertar("asistencias",a.toObject);					
				} else {
					resultLabel.text = "ASISTENCIA RECHAZADA: HORARIO NO PERMITIDO";
					resultGroup.styleName = "well-danger text-size-lg";
				}
			} else {
				resultLabel.text = "ASISTENCIA RECHAZADA: CLIENTE NO EXISTE";
				resultGroup.styleName = "well-danger text-size-lg";
			}
		}
	}
}