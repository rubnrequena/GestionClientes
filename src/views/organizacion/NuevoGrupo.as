package views.organizacion
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Alert;
	
	
	import vo.VOGrupo;

	public class NuevoGrupo extends NuevoGrupoUI
	{
		public var grupo:VOGrupo;
		
		public function NuevoGrupo() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		override protected function childrenCreated():void {
			super.childrenCreated();
			nombreInput.setFocus();
		}
		protected function onAdded(event:Event):void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnGuardar.addEventListener(MouseEvent.CLICK,guardarClick);
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
		}
		
		protected function resetClick(event:MouseEvent=null):void {
			nombreInput.text="";
			descInput.text="";
			rentaInput.text="";
			grupo=null;
		}
		protected function onRemoved(event:Event):void {
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelarClick);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardarClick);
		}		
		protected function guardarClick(event:MouseEvent):void {
			grupo = new VOGrupo;
			grupo.nombre = nombreInput.text;
			grupo.descripcion = descInput.text;
			grupo.renta = Number(rentaInput.text);
			
			GestionClientes.grupos.insertar(grupo);
			Alert.show("Grupo guardado exitosamente","Gestion Clientes",4,null,function ():void {
				resetClick();
			});
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
	}
}