package views.organizacion
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import vo.VOSalon;

	public class Salones extends SalonesUI
	{
		public function Salones() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
		}
		
		protected function onComplete(event:FlexEvent):void {
			removeEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
			nombreInput.setFocus();
		}
		
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		override protected function childrenCreated():void {
			btnInsertar.addEventListener(MouseEvent.CLICK,insertarClick);
			btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
			btnAtras.addEventListener(MouseEvent.CLICK,atrasClick);
			salonesGrid.dataProvider = new VectorList(GestionClientes.salones.data);
		}
		
		protected function atrasClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		protected function removerClick(event:MouseEvent):void {
			if (salonesGrid.selectedIndex>-1) {
				GestionClientes.salones.remover(salonesGrid.selectedItem.salonID);
				updateData();
			}
		}
		private function updateData():void {
			salonesGrid.dataProvider = new VectorList(GestionClientes.salones.data);
		}
		protected function insertarClick(event:MouseEvent):void {
			var salon:VOSalon = new VOSalon;
			salon.nombre = nombreInput.text;			
			GestionClientes.salones.insertar(salon);
			updateData();
			nombreInput.text = "";
			nombreInput.setFocus();
		}
	}
}