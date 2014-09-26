package views.clientes
{
	import clases.Asistencias;
	
	import com.ListPicker;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	
	import sr.helpers.Value;
	
	import utils.DateUtil;
	
	import views.finanzas.NuevoPago;
	
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOHorario;

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
		
		protected function onAdded(event:Event):void {
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
			
			grupo = cliente.grupo;
			grupoIndex = GestionClientes.grupos.grupoIndex(cliente.grupoID);
			
			hoy = new Date;
			clienteAsistencias.dataProvider = new VectorCollection(cliente.asistenciasDelMes(hoy.month+1,hoy.fullYear).sort(Asistencias.ordenarDESC).slice(0,9));
			clientePagos.dataProvider = new VectorCollection(cliente.facturas(20));
			
			mesInput.label = VOHorario.MESES[hoy.month].label;
			mesInput.dataProvider = new ArrayList(VOHorario.MESES);
			mesInput.selectedIndex = hoy.month;
			mesInput.onClose = mesInput_close;
			asistenciasMes.text = cliente.asistenciasDelMes(hoy.month+1,hoy.fullYear).length.toString();			
						
			grupoInput.addEventListener(MouseEvent.CLICK,btnGrupo_click);
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
		}
		
		protected function estadoCuenta_click(event:MouseEvent):void {
			(owner as ViewNavigator).addView("estado_cliente",EstadoCuenta,{
				cliente:this.cliente
			});
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
			});
		}
		
		protected function actualizarClick(event:MouseEvent):void {
			var changes:Vector.<Value> = new Vector.<Value>;
			cliente.update("nombres",nombreInput.text);
			cliente.update("cedula",cedulaInput.text);
			cliente.update("fechaNacimiento",DateUtil.toggleDate(fechaInput.fullText));
			cliente.update("telefonos",tlfInput.text);
			cliente.update("direccion",dirInput.text);
			cliente.update("grupoID",grupo.grupoID);
			cliente.commitUpdate();
			ModalAlert.show("Datos de cliente actualizados","Cliente",null,[{label:"OK"}]);
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
	}
}