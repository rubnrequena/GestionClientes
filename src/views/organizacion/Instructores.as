package views.organizacion
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	import org.apache.flex.collections.VectorList;
	
	import vo.VOInstructor;

	public class Instructores extends InstructoresUI
	{
		public function Instructores() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		override protected function childrenCreated():void {
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			updateData();
			super.childrenCreated();
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		protected function remover_click(event:MouseEvent):void {
			if (instructoresGrid.selectedIndex>-1) {
				GestionClientes.instructores.remover(instructoresGrid.selectedItem.instructorID);
				updateData();
			}
		}
		
		protected function insertar_click(event:MouseEvent):void {
			var instructor:VOInstructor = new VOInstructor;
			instructor.cedula = cedulaInput.text;
			instructor.nombres = nombresInput.text;
			instructor.telefonos = tlfInput.text;
			
			GestionClientes.instructores.insertar(instructor);
			updateData();
			reset();
		}
		
		private function reset():void {
			nombresInput.text=cedulaInput.text=tlfInput.text="";
			nombresInput.setFocus();
		}
		
		private function updateData():void {
			instructoresGrid.dataProvider = new VectorList(GestionClientes.instructores.data);
		}
	}
}