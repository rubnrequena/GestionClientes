package views.clientes
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.DateField;
	
	import vo.VOCliente;

	public class BuscarCliente extends BuscarClienteUI
	{
		private var _clientes:ArrayCollection;
		
		public function BuscarCliente()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedHandler);
		}
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnBuscar.addEventListener(MouseEvent.CLICK,buscarClienteClick);
			btnBuscarFecha.addEventListener(MouseEvent.CLICK,buscarFechaClick);
			btnVer.addEventListener(MouseEvent.CLICK,abrirClick);
			busqInput.setFocus();
		}
		
		protected function abrirClick(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				var c:VOCliente = grid.selectedItem as VOCliente;
				(owner as ViewNavigatorHistory).addView("cliente_"+c.clienteID,FichaCliente,{cliente:c},true);
			}
		}
		override protected function createChildren():void {
			super.createChildren();
			var d:Date = new Date;
			fechaInput1.selectedDate = d;
			fechaInput2.selectedDate = d;
		}
		protected function buscarFechaClick(event:MouseEvent):void {
			var d1:String = DateField.dateToString(fechaInput1.selectedDate,"YYYY-MM-DD");
			var d2:String = DateField.dateToString(fechaInput2.selectedDate,"YYYY-MM-DD");
			_clientes = new ArrayCollection(GestionClientes.sql.sql('SELECT * FROM Clientes WHERE fechaRegistro BETWEEN "'+d1+'" AND "'+d2+'"',VOCliente).data);
			grid.dataProvider = _clientes;
		}
		protected function removedHandler(e:Event):void {
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelarClick);
			btnBuscar.removeEventListener(MouseEvent.CLICK,buscarClienteClick);
			btnBuscarFecha.removeEventListener(MouseEvent.CLICK,buscarFechaClick);
		}
		private function addedHandler(e:Event):void {
			if (initialized)
				childrenCreated();
		}
		protected function buscarClienteClick(event:MouseEvent):void {
			var w:String;
			if (isNaN(Number(busqInput.text))) {
				w = 'WHERE nombres LIKE "%'+busqInput.text+'%"';
			} else {
				w = 'WHERE cedula LIKE "%'+busqInput.text+'%"';
			}
			_clientes = new ArrayCollection(GestionClientes.sql.sql("SELECT * FROM Clientes "+w,VOCliente).data);
			grid.dataProvider = _clientes;
		}
		private function cancelarClick(e:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}