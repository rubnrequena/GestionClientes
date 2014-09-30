package views.sistema
{
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import vo.VOUsuario;

	public class Usuarios extends UsuariosUI
	{
		public function Usuarios()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		override protected function childrenCreated():void {
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			btnRegistrar.addEventListener(MouseEvent.CLICK,registrar_click);
			btnLimpiar.addEventListener(MouseEvent.CLICK,limpiar_click);
			updateData();
		}
		
		protected function remover_click(event:MouseEvent):void {
			if (usuariosGrid.selectedIndex>-1) {
				ModalAlert.show("¿Seguro desea remover usuario?","Remover Usuario",null,[ModalAlert.YES,ModalAlert.NO],function (detalle:int):void {
					if (detalle==0) {
						GestionClientes.usuarios.remover(usuariosGrid.selectedItem.usuarioID);
						updateData();
					}
				});
			}
		}
		
		protected function registrar_click(event:MouseEvent):void {
			if (form.validate) {
				var usuario:VOUsuario = new VOUsuario;
				usuario.usuario = usuarioInput.text;
				usuario.pass = passInput.text;
				usuario.acceso = accesoInput.selectedIndex;
				usuario.nombre = nombreInput.text;
				
				GestionClientes.usuarios.insertar(usuario);
				updateData();
				limpiar_click();
			}
		}
		
		private function limpiar_click(event:MouseEvent=null):void {
			usuarioInput.text = passInput.text = pass2Input.text = nombreInput.text = "";
			accesoInput.selectedIndex = -1;
			form.reset();
		}
		
		private function updateData():void {
			usuariosGrid.dataProvider = new VectorCollection(GestionClientes.usuarios.data);
		}	
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}