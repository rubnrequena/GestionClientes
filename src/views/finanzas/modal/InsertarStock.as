package views.finanzas.modal
{
	import flash.events.MouseEvent;
		
	public class InsertarStock extends ArticuloModal
	{
				
		
		public function InsertarStock()
		{
			super();
			title = "Insertar stock";
		}
		
		override protected function childrenCreated():void {
			super.childrenCreated();
			
			descInput.editable = false;
			descInput.text = producto.descripcion;
			montoInput.text = producto.monto.toString();
		}
		
		override protected function confirmar_click(event:MouseEvent):void {
			if (form.isValid) {
				GestionClientes.productos.updateStock(producto.productoID,producto.cantidad+Number(cantInput.text));
				closing();
			}
		}
		
	}
}