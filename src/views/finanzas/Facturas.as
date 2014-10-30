package views.finanzas
{
	import com.ListPickerSearch;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import utils.DateUtil;
	
	import vo.VOCliente;
	import vo.VOFactura;

	public class Facturas extends FacturasUI
	{
		public function Facturas()
		{
			super();
		}
		override protected function childrenCreated():void {
			clienteInput.pickerClass = new ClassFactory(ListPickerSearch);
			clienteInput.dataProvider = new VectorCollection(GestionClientes.clientes.data);
			clienteInput.onClose = buscarCliente_click;
			
			buscarFecha.addEventListener(MouseEvent.CLICK,buscarFecha_click);
			facturaInput.addEventListener(FlexEvent.ENTER,buscarFactura_handler);
			btnBuscarFactura.addEventListener(MouseEvent.CLICK,buscarFactura_handler);
			btnVer.addEventListener(MouseEvent.CLICK,btnVer_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			
			inicioInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,inicioInput_change);
			finInput.addEventListener(CalendarLayoutChangeEvent.CHANGE,finInput_change);
		}
		
		protected function finInput_change(event:CalendarLayoutChangeEvent):void {
			if (finInput.selectedDate<inicioInput.selectedDate)
				inicioInput.selectedDate = finInput.selectedDate;
		}
		
		protected function inicioInput_change(event:CalendarLayoutChangeEvent):void {
			if (inicioInput.selectedDate>finInput.selectedDate)
				finInput.selectedDate = inicioInput.selectedDate;
		}
		
		protected function buscarFactura_handler(event:Event):void {
			var _factura:VOFactura = GestionClientes.facturas.byCorrelativo(int(facturaInput.text));
			if (_factura) {
				(owner as ViewNavigator).addView("ver_factura_"+_factura.facturaID,VerFactura,{
					factura:_factura
				},true);
			} else {
				ModalAlert.showDelay("Factura no encontrada","Facturas",null,1000,function ():void {
					facturaInput.setFocus();
				},"well-danger");
			}
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		protected function btnVer_click(event:MouseEvent):void {
			if (facturasGrid.selectedIndex>-1) {
				var _factura:VOFactura = facturasGrid.selectedItem as VOFactura;
				(owner as ViewNavigator).addView("ver_factura_"+_factura.facturaID,VerFactura,{factura:_factura},true);
			}
		}
		
		protected function buscarFecha_click(event:MouseEvent):void {
			formFechas.styleName = "well-success";
			formCliente.styleName = "well-default";
			var inicio:String = DateUtil.toggleDate(inicioInput.text);
			var fin:String = DateUtil.toggleDate(finInput.text);
			facturasGrid.dataProvider = new VectorCollection(GestionClientes.facturas.byFechas(inicio,fin));
		}
		
		protected function buscarCliente_click():void {
			formCliente.styleName = "well-success";
			formFechas.styleName = "well-default";
			
			facturasGrid.dataProvider = new VectorCollection(GestionClientes.facturas.byCliente((clienteInput.selectedItem as VOCliente).clienteID));
		}
	}
}