package views.clientes
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Ingresos extends IngresosUI
	{
		public function Ingresos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}