package views.clientes
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import views.finanzas.VerFactura;
	
	import vo.VOCliente;
	import vo.VOFactura;

	public class EstadoCuenta extends EstadoCuentaUI
	{
		public var cliente:VOCliente;
		private var _facturas:VectorCollection;
		private var _pendientes:VectorCollection;
		public function EstadoCuenta()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void {
			
		}		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}		
		override protected function childrenCreated():void {
			_facturas = new VectorCollection(cliente.facturas());
			_pendientes = new VectorCollection(cliente.pagosPendientes());
			facturasGrid.dataProvider = _facturas;
			pendientesGrid.dataProvider = _pendientes;
			
			var i:int; var total:Number;
			
			total=0;
			for (i = 0; i < _facturas.length; i++)
				total += _facturas.getItemAt(i).monto;
			ingresoInput.text = total.toString();
			
			total=0;
			for (i = 0; i < _pendientes.length; i++)
				total += _pendientes.getItemAt(i).monto;
			pendienteInput.text = total.toString();
			
			
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelar_click);
			btnAbrir.addEventListener(MouseEvent.CLICK,abrirFactura_click);
		}
		
		protected function abrirFactura_click(event:MouseEvent):void {
			if (facturasGrid.selectedIndex>-1) {
				var _factura:VOFactura = facturasGrid.selectedItem as VOFactura;
				(owner as ViewNavigator).addView("ver_factura_"+_factura.facturaID,VerFactura,{
					factura:_factura
				},true);
			}
		}
		
		protected function cancelar_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}