package views.finanzas
{
	import clases.Pagos;
	
	import com.ModalAlert;
	
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import vo.VOFactura;

	public class VerFactura extends VerFacturaUI
	{
		private var _factura:VOFactura;

		public function get factura():VOFactura { return _factura; }
		public function set factura(value:VOFactura):void { _factura = value; }
		

		public function VerFactura() {
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			btnAtras.addEventListener(MouseEvent.CLICK,btnAtras_click);
			
			if (_factura) {
				title = "Factura #"+[_factura.correlativoString,_factura.cliente.nombres].join(" - ");
				facturaInput.text = _factura.correlativoString;
				clienteInput.text = _factura.cliente.nombres;
				fechaInput.text = _factura.fechaLocal;
				totalInput.text = _factura.monto.toFixed(2);
				usuarioInput.text = _factura.usuarioID.toString();
				
				grid.dataProvider = new VectorList(_factura.pagos);
			} else {
				ModalAlert.show("Error al cargar factura","ERROR",null,[ModalAlert.OK]);
			}
		}
		
		protected function btnAtras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}