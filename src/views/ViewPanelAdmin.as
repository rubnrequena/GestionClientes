package views
{
	import com.ModalAlert;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import vo.VOHorario;
	import vo.VOUsuario;

	public class ViewPanelAdmin extends ViewPanel
	{
		protected var accessGranted:Boolean;
		public function ViewPanelAdmin() {
			super();
		}
		override protected function childrenCreated():void {
			accessGranted = VOUsuario.USUARIO_ACTIVO.acceso>0?false:true; 
			if (VOUsuario.USUARIO_ACTIVO.acceso>0) {
				stage.focus = null;
				ModalAlert.show("Acceso restringido","",null,[ModalAlert.OK],function ():void {
					if (VOUsuario.USUARIO_ACTIVO.acceso>0) (owner as ViewNavigatorHistory).popBack(true);
				},0,"well-danger");
			}
		}
	}
}