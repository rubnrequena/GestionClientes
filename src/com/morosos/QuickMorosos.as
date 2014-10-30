package com.morosos
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import views.clientes.EstadoCuenta;
	
	import vo.VOCliente;
	import vo.VOMoroso;

	public class QuickMorosos extends QuickMorososUI
	{
		public function QuickMorosos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		override protected function childrenCreated():void {
			update();
		}
		override protected function createChildren():void {
			super.createChildren();
			
			morosos.addEventListener(MouseEvent.CLICK,morosos_click);
		}
		public function update():void {
			morosos.dataProvider = new VectorList(GestionClientes.pagos.morosos);
		}
		protected function morosos_click(event:MouseEvent):void {
			if (event.target is MorosoItem) {
				var _cliente:VOCliente = (morosos.selectedItem as VOMoroso).cliente;
				(owner["owner"] as ViewNavigator).addView("estado_cliente_"+_cliente.clienteID,EstadoCuenta,{
					cliente:_cliente
				},true);
			}
		}
	}
}