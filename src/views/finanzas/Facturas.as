package views.finanzas
{
	import com.ListPickerSearch;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
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
			clienteInput.dataProvider = new VectorCollection(GestionClientes.clientes.clientes);
			clienteInput.onClose = buscarCliente_click;
			
			buscarFecha.addEventListener(MouseEvent.CLICK,buscarFecha_click);
			btnVer.addEventListener(MouseEvent.CLICK,btnVer_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		protected function btnVer_click(event:MouseEvent):void {
			if (facturasGrid.selectedIndex>-1) {
				var _factura:VOFactura = facturasGrid.selectedItem as VOFactura;
				(owner as ViewNavigator).addView("ver_factura_"+_factura.facturaID,VerFactura,{factura:_factura});
			}
		}
		
		protected function buscarFecha_click(event:MouseEvent):void {
			formFechas.styleName = "formItem well-success";
			formCliente.styleName = "formItem well-default";
			
			var inicio:String = DateUtil.toggleDate(inicioInput.text);
			var fin:String = DateUtil.toggleDate(finInput.text);
			facturasGrid.dataProvider = new VectorCollection(GestionClientes.facturas.byFechas(inicio,fin));
		}
		
		protected function buscarCliente_click():void {
			formCliente.styleName = "formItem well-success";
			formFechas.styleName = "formItem well-default";
			
			facturasGrid.dataProvider = new VectorCollection(GestionClientes.facturas.byCliente((clienteInput.selectedItem as VOCliente).clienteID));
		}
	}
}