package views.sistema
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Impresion extends ImpresionUI
	{
		public function Impresion() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		
		override protected function childrenCreated():void {
			anchoPapel.text = GestionClientes.config.anchoPapel.toString();
			
			btnGuardar.addEventListener(MouseEvent.CLICK,guardar_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		protected function guardar_click(event:MouseEvent):void {
			if (GestionClientes.config.anchoPapel!=int(anchoPapel.text))
				GestionClientes.config.update("anchoPapel",anchoPapel.text);
		}
	}
}