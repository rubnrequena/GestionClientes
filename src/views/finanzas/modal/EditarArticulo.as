package views.finanzas.modal
{
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
		
	public class EditarArticulo extends ArticuloModal
	{
		
		
		public function EditarArticulo() {
			super();
			title = "Editar Articulo";
		}
		
		override protected function childrenCreated():void {
			super.childrenCreated();
			
			descInput.text = producto.descripcion;
			montoInput.text = producto.monto.toString();
			cantInput.text = producto.cantidad.toString();			
		}
		
		override protected function confirmar_click(event:MouseEvent):void {
			if (form.isValid) {
				producto.descripcion = descInput.text.toUpperCase();
				producto.monto = Number(montoInput.text);
				producto.cantidad = Number(cantInput.text);
				
				GestionClientes.productos.actualizar(producto);
				closing();
			}
		}
	}
}