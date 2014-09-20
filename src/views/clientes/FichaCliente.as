package views.clientes
{
	import clases.Horarios;
	
	import com.ListPicker;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			
			clienteAsistencias.dataProvider = new VectorList(cliente.asistencias(10));
			clientePagos.dataProvider = new VectorList(cliente.facturas(20));
			
			var hoy:Date = new Date;
			mesInput.label = VOHorario.MESES[hoy.month].label;
			asistenciasMes.text = cliente.asistenciasDelMes(hoy.month,hoy.fullYear).length.toString();			
			
			grupoInput.addEventListener(MouseEvent.CLICK,btnGrupo_click);
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
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnActualizar.addEventListener(MouseEvent.CLICK,actualizarClick);
			
			btnNuevoPago.addEventListener(MouseEvent.CLICK,nuevoPago_click);
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