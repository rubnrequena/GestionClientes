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
		}
		
		override protected function onComplete(event:FlexEvent):void {
			super.onComplete(event);
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized)
				childrenCreated();
		}
		override protected function childrenCreated():void {
			super.childrenCreated();
			if (accessGranted) {
				btnInsertar.addEventListener(MouseEvent.CLICK,insertarClick);
				btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
				btnAtras.addEventListener(MouseEvent.CLICK,atrasClick);
				salonesGrid.dataProvider = new VectorList(GestionClientes.salones.data);
				
				nombreInput.setFocus();
			}
		}
		
		protected function atrasClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
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
			if (form.isValid) {
				var salon:VOSalon = new VOSalon;
				salon.nombre = nombreInput.text;			
				GestionClientes.salones.insertar(salon);
				updateData();
				nombreInput.text = "";
				nombreInput.setFocus();
			}
		}
	}
}