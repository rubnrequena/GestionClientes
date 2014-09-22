package views.organizacion
{
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import spark.components.Alert;
	
	import vo.VOGrupo;

	public class Grupos extends GruposUI
	{		
		public function Grupos() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		override protected function childrenCreated():void {
			nombreInput.setFocus();
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnGuardar.addEventListener(MouseEvent.CLICK,guardarClick);
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
			btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
			
			updateData();
		}
		
		private function updateData():void {
			gruposGrid.dataProvider = new VectorCollection(GestionClientes.grupos.data);
		}
		
		protected function removerClick(event:MouseEvent):void {
			if (gruposGrid.selectedIndex>-1) 
				removerGrupo();
		}
		
		private function removerGrupo():void {
			GestionClientes.grupos.remover(gruposGrid.selectedItem.grupoID);
			updateData();
		}
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();			
		}
		
		protected function resetClick(event:MouseEvent=null):void {
			nombreInput.text="";
			descInput.text="";
			rentaInput.text="";
			nombreInput.setFocus();
		}
		protected function onRemoved(event:Event):void {
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelarClick);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardarClick);
		}		
		protected function guardarClick(event:MouseEvent):void {
			var grupo:VOGrupo = new VOGrupo;
			grupo.nombre = nombreInput.text;
			grupo.descripcion = descInput.text;
			grupo.renta = Number(rentaInput.text);
			
			GestionClientes.grupos.insertar(grupo);
			ModalAlert.show("Grupo guardado exitosamente","Gestion Clientes",null,[ModalAlert.OK],function ():void {
				resetClick();
				updateData();
			});
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
	}
}