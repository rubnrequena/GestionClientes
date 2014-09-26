package views.clientes
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import vo.VOCliente;
	import vo.VOMoroso;

	public class Morosos extends MorososUI
	{
		public function Morosos()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		
		override protected function childrenCreated():void {
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnVer.addEventListener(MouseEvent.CLICK,ver_click);
			
			morosoGrid.dataProvider = new VectorCollection(GestionClientes.pagos.morosos);
		}
		
		protected function ver_click(event:MouseEvent):void {
			if (morosoGrid.selectedIndex>-1) {
				var m:VOMoroso = morosoGrid.selectedItem as VOMoroso;
				(owner as ViewNavigator).addView("cliente_"+m.clienteID,FichaCliente,{cliente:m.cliente},true);
			}
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}