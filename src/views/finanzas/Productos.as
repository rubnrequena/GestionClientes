package views.finanzas
{
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import vo.VOProducto;

	public class Productos extends ProductosUI
	{
		public function Productos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			updateProductosList();
			descInput.setFocus();
		}
		
		protected function remover_click(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				ModalAlert.show("¿Seguro desea remover producto?","Producto",null,[ModalAlert.YES,ModalAlert.NO],function (detalle:int):void {
					if (detalle==0) {
						GestionClientes.productos.remover(grid.selectedItem.productoID);
						updateProductosList();
					}
				});
			}
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		private function limpiarCampos():void {
			montoInput.text=cantInput.text="0";
			descInput.text="";
			descInput.setFocus();
		}
		
		private function updateProductosList():void {
			grid.dataProvider = new VectorList(GestionClientes.productos.data);
		}
		
		protected function insertar_click(event:MouseEvent):void {
			if (form.validate) {
				var p:VOProducto = new VOProducto;
				p.descripcion = descInput.text;
				p.monto = Number(montoInput.text);
				p.cantidad = Number(cantInput.text);
				
				GestionClientes.productos.insertar(p);
				updateProductosList();
				limpiarCampos();
			}
		}
	}
}