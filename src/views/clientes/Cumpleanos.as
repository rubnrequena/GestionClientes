package views.clientes
{
	import com.ListPicker;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class Cumpleanos extends CumpleanosUI
	{
		private var meses:Array = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
		protected var mesPicker:ListPicker;
		protected var now:Date = new Date;

		protected var _clientes:ArrayCollection;
		
		public function Cumpleanos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void {
			btnMes.addEventListener(MouseEvent.CLICK,mesChange);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			mesPicker_close(now.month);
		}
		override protected function childrenCreated():void {
			btnMes.addEventListener(MouseEvent.CLICK,mesChange);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnMes.setFocus();
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		protected function mesChange(event:MouseEvent):void {
			mesPicker = new ListPicker();
			mesPicker.title = "Seleccione mes";
			mesPicker.onClose = mesPicker_close;
			mesPicker.dataProvider = new ArrayList(meses);
			mesPicker.selectedIndex = now.month;
			mesPicker.popUp();
		}
		
		private function mesPicker_close(mes:int):void {
			mesPicker=null;
			now.month = mes;
			btnMes.setFocus();
			btnMes.label = meses[mes];
			_clientes = new ArrayCollection(GestionClientes.clientes.cumpleaneros(mes+1));
			clientes.dataProvider = _clientes;
		}
	}
}