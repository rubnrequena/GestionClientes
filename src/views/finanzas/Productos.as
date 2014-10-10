package views.finanzas
{
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import views.finanzas.modal.EditarArticulo;
	import views.finanzas.modal.InsertarStock;
	
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
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			stockButton.addEventListener(MouseEvent.CLICK,stock_click);
			editarButton.addEventListener(MouseEvent.CLICK,editar_click);
			updateProductosList();
			descInput.setFocus();
		}
		
		protected function editar_click(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				var editarModal:EditarArticulo = new EditarArticulo;
				editarModal.producto = grid.selectedItem as VOProducto;
				editarModal.onClose = function ():void {
					updateProductosList();
				};
				editarModal.popUp();
			}
		}
		
		protected function stock_click(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				if (grid.selectedItem.tipo==VOProducto.PRODUCTO) {
					var stockModal:InsertarStock = new InsertarStock;
					stockModal.producto = grid.selectedItem as VOProducto;
					stockModal.onClose = function ():void {
						updateProductosList();
					};
					stockModal.popUp();
				} else {
					ModalAlert.showDelay("Stock solo es válido para productos","Inventario");
				}
			}
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
		
		protected function cancelar_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		private function limpiarCampos():void {
			montoInput.text=cantInput.text="0";
			descInput.text="";
			descInput.setFocus();
			tipoInput.selectedIndex=-1;
		}
		
		private function updateProductosList():void {
			grid.dataProvider = new VectorList(GestionClientes.productos.data);
		}
		
		protected function insertar_click(event:MouseEvent):void {
			if (form.isValid) {
				var p:VOProducto = new VOProducto;
				p.descripcion = descInput.text.toUpperCase();
				p.monto = Number(montoInput.text);
				p.cantidad = Number(cantInput.text);
				p.tipo = tipoInput.selectedIndex;
				
				GestionClientes.productos.insertar(p);
				updateProductosList();
				limpiarCampos();
			}
		}
	}
}