package views.asistencias
{
	import clases.Asistencias;
	import clases.Clases;
	
	import com.ModalAdmin;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeStyle;
	
	import mx.controls.DateField;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import spark.events.TextOperationEvent;
	import spark.formatters.DateTimeFormatter;
	
	import sr.helpers.Value;
	
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
				var asistenciasPrevias:Vector.<VOAsistencia> = cliente.asistencias(10);
				currentState="resultado";
				var ahora:Date = new Date;
				var entrada:int = int(DateUtil.dateToString(ahora,"HHnn"));
				clienteCard.cliente = cliente;
				
				var asistenciaID:int = GestionClientes.asistencias.registrarAsistencia(cliente.clienteID,DateUtil.dateToString(ahora,"YYYY-MM-DD"),entrada);
				if (asistenciaID>0) {
					if (validarInasistenciasPrevias(asistenciasPrevias)) {
						registrarAsistencia(asistenciaID,entrada);
					} else {
						rechazarAsistencia("DEMASIADAS INASISTENCIAS CONSECUTIVAS");
						var modal:ModalAdmin = new ModalAdmin("Este usuario ha exedido el máximo de inasistencias consecutivas, se requiere permiso del administrador","Inasistencias Exedidas");
						modal.onClose = function (detalle:int):void {
							registrarAsistencia(asistenciaID,entrada);	
							cedulaInput.selectAll();
						};
						modal.popUp();
					}
				} else if (asistenciaID==-1) {
					rechazarAsistencia("HORARIO NO PERMITIDO");
				} else if (asistenciaID==-2) {
					rechazarAsistencia("ASISTENCIA PREVIA REGISTRADA");
				}
				clienteAsistencias.dataProvider = new VectorList(asistenciasPrevias);
				clienteHorarios.dataProvider = new VectorCollection(cliente.horarios);
			} else {
				rechazarAsistencia("CLIENTE NO EXISTE");
			}
			cedulaInput.selectAll();
		}
		
		private function rechazarAsistencia(label:String):void {
			resultLabel.text = "ASISTENCIA RECHAZADA: "+label;
			resultGroup.styleName = "well-danger text-size-lg";
			if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_rechazada.play(0,1);
		}
		
		private function validarInasistenciasPrevias(asistenciasPrevias:Vector.<VOAsistencia>):Boolean {
			var maxInasistencias:int = GestionClientes.config.inasistencias_alerta;
			if (maxInasistencias>asistenciasPrevias.length) {
				return false;
			} else {
				var inasistencias:int=0;
				for (var i:int = 0; i < maxInasistencias; i++) {
					if (!asistenciasPrevias[i].asistio) inasistencias++;
				}
				return inasistencias<maxInasistencias;
			}
		}
		
		private function registrarAsistencia(asistenciaID:int, entrada:int):void {
			resultGroup.styleName = "well-success text-size-lg";
			resultLabel.text = "ASISTENCIA REGISTRADA";
			GestionClientes.asistencias.actualizar(asistenciaID,entrada);					
			if (GestionClientes.config.sonidos) GestionClientes.config.asistencia_registrada.play(0,1);
		}
	}
}