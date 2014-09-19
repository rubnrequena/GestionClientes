package views.horarios
{
	import com.ListPicker;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	
	import org.apache.flex.collections.VectorList;
	
	import spark.components.Alert;
	
	import vo.VOGrupo;

	public class Horarios extends HorariosUI
	{		
		public function Horarios() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			grupoInput.dataProvider = new VectorList(GestionClientes.grupos.data);
			grupoInput.onClose = grupoInput_change;
		}
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
		}
		
		protected function removerClick(event:MouseEvent):void {
			if (horarios.selectedIndex>-1) {
				ModalAlert.show("¿Seguro desea remover horario?","Horarios",this,[{label:"Sí"},{label:"No"}],function (detalle:int):void {
					if (detalle==0) {
						GestionClientes.horarios.remover(horarios.selectedItem.horarioID);
						horarios.dataProvider = new VectorList(GestionClientes.horarios.byGrupo((grupoInput.selectedItem as VOGrupo).grupoID));
					}
				});
			}
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		private function grupoInput_change(indice:int,grupo:VOGrupo):void {
			horarios.dataProvider = new VectorList(GestionClientes.horarios.byGrupo(grupo.grupoID));
		}
	}
}