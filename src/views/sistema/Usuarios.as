package views.sistema
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Usuarios extends UsuariosUI
	{
		public function Usuarios()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}