package views.clientes
{
	import com.ListPicker;
	import com.adobe.crypto.MD5;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.apache.flex.collections.VectorCollection;
	
	import vo.VOCliente;
	import vo.VOHorario;

	public class Cumpleanos extends CumpleanosUI
	{
		protected var now:Date = new Date;

		protected var _clientes:VectorCollection;
		
		public function Cumpleanos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		override protected function onRemoved(event:Event):void {
			super.onRemoved(event);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
		}
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			mesPicker_close(now.month,null);
		}
		override protected function childrenCreated():void {
			btnMes.dataProvider = new ArrayList(VOHorario.MESES);
			btnMes.onClose = mesPicker_close;
			btnMes.selectedIndex = now.month;
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnMes.setFocus();
			
			btnVer.addEventListener(MouseEvent.CLICK,ver_click);
		}
		
		protected function ver_click(event:MouseEvent):void {
			var _cliente:VOCliente = clientes.selectedItem as VOCliente;
			(owner as ViewNavigatorHistory).addView("cliente_"+_cliente.clienteID,FichaCliente,{
				cliente:_cliente
			},true);
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		private function mesPicker_close(mes:int,item:Object):void {
			now.month = mes;
			btnMes.label = VOHorario.MESES[mes].label;
			_clientes = new VectorCollection(GestionClientes.clientes.cumpleaneros(mes+1));
			clientes.dataProvider = _clientes;
		}
	}
}