package views.clientes
{
	import clases.Asistencias;
	
	import com.ListPicker;
	import com.ModalAlert;
	import com.modal.XLTextArea;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import sr.helpers.Value;
	
	import utils.DateUtil;
	
	import views.asistencias.Asistencias;
	import views.finanzas.NuevoPago;
	
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOUsuario;

	public class FichaCliente extends FichaClienteUI
	{
		public var cliente:VOCliente;
		
		protected var _grupo:VOGrupo;
		public function get grupo():VOGrupo { return _grupo; }
		public function set grupo(value:VOGrupo):void {
			_grupo = value;
			grupoInput.label = value.nombre;
		}

		protected var grupoIndex:int;

		private var hoy:Date;
		
		public function FichaCliente() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			title = cliente.nombres+" - "+cliente.cedula;
			
			nombreInput.text = cliente.nombres;
			cedulaInput.text = cliente.cedula;
			tlfInput.text = cliente.telefonos;
			dirInput.text = cliente.direccion;
			fechaInput.text = cliente.fechaNacimientoLocal;
			grupoInput.label = cliente.grupo.toString();
			obsInput.text = cliente.meta;
			
			exoneradoInput.selectedIndex = int(cliente.exonerado);
			exoneradoInput.enabled = GestionClientes.usuarios.byID(VOUsuario.USUARIO_ACTIVO).acceso==VOUsuario.USER_ADMIN;
			
			grupo = cliente.grupo;
			grupoIndex = GestionClientes.grupos.grupoIndex(cliente.grupoID);
			
			hoy = new Date;
			clienteAsistencias.dataProvider = new VectorCollection(cliente.asistenciasDelMes(hoy.month+1,hoy.fullYear).sort(clases.Asistencias.ordenarDESC).slice(0,9));
			clientePagos.dataProvider = new VectorCollection(cliente.facturas(20));
			
			mesInput.label = VOHorario.MESES[hoy.month].label;
			mesInput.dataProvider = new ArrayList(VOHorario.MESES);
			mesInput.selectedIndex = hoy.month;
			mesInput.onClose = mesInput_close;
			asistenciasMes.text = cliente.asistenciasDelMes(hoy.month+1,hoy.fullYear).length.toString();			
						
			grupoInput.addEventListener(MouseEvent.CLICK,btnGrupo_click);
			obsXL.addEventListener(MouseEvent.CLICK,obsXL_click);
		}
		
		protected function obsXL_click(event:MouseEvent):void
		{
			var obs:XLTextArea = new XLTextArea;
			obs.title = "Observación";
			obs.popUp();
			obs.areaInput.text = obsInput.text;
			obs.onClose = function (data:String):void {
				obsInput.text = data;
			}
		}
		
		private function mesInput_close(mes:int):void {
			hoy.month = mes;
			asistenciasMes.text = cliente.asistenciasDelMes(hoy.month+1,hoy.fullYear).length.toString();	
		}
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnActualizar.addEventListener(MouseEvent.CLICK,actualizarClick);
			
			btnNuevoPago.addEventListener(MouseEvent.CLICK,nuevoPago_click);
			btnEstadoCuenta.addEventListener(MouseEvent.CLICK,estadoCuenta_click);
			btnAsistencias.addEventListener(MouseEvent.CLICK,asistencias_click);
		}
		
		protected function asistencias_click(event:MouseEvent):void {
			(owner as ViewNavigator).addView("buscar_asistencias_",views.asistencias.Asistencias,{
				busq_pre:cliente
			},true);
		}
		
		protected function estadoCuenta_click(event:MouseEvent):void {
			(owner as ViewNavigator).addView("estado_cliente_"+cliente.clienteID,EstadoCuenta,{
				cliente:this.cliente
			},true);
		}
		
		protected function btnGrupo_click(event:MouseEvent):void {
			var sg:ListPicker = new ListPicker();
			sg.title = "Seleccionar Grupo";
			sg.onClose = function (indice:int,data:VOGrupo):void {
				grupo = data;
				grupoIndex=indice;
			};
			sg.labelField = "nombre";
			sg.dataProvider = new VectorList(GestionClientes.grupos.data);
			sg.selectedIndex = grupoIndex;
			sg.popUp();
		}
		
		protected function nuevoPago_click(event:MouseEvent):void {
			(owner as ViewNavigator).addView("nuevo_pago_"+cliente.clienteID,NuevoPago,{
				cliente:this.cliente
			},true);
		}
		
		protected function actualizarClick(event:MouseEvent):void {
			cliente.update("nombres",nombreInput.text);
			cliente.update("cedula",cedulaInput.text);
			cliente.update("fechaNacimiento",DateUtil.toggleDate(fechaInput.fullText));
			cliente.update("telefonos",tlfInput.text);
			cliente.update("direccion",dirInput.text);
			cliente.update("grupoID",grupo.grupoID);
			cliente.update("meta",obsInput.text);
			cliente.commitUpdate();
			ModalAlert.show("Datos de cliente actualizados","Cliente",null,[{label:"OK"}]);
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}