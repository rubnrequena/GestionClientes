package views.finanzas
{
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
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			updateProductosList();
			descInput.setFocus();
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