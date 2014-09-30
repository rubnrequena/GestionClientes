package views.sistema
{
	import clases.Config;
	
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;

	public class Config extends ConfigUI
	{
		
		private var inputCampos:Array = [
			"razon_social",
			"rif",
			"correlativo",
			"impresion_anchoPapel"
		];
		private var selectCampos:Array = [
			"impresion_fuente"		
		];
		public function Config() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function onAdded(event:Event):void {
			if (initialized) childrenCreated();
		}
		
		override protected function childrenCreated():void {
			razon_social.text = GestionClientes.config.razon_social;
			rif.text = GestionClientes.config.rif;
			correlativo.text = GestionClientes.config.correlativo.toString();
			
			impresion_anchoPapel.text = GestionClientes.config.impresion_anchoPapel.toString();
			impresion_fuente.dataProvider = new ArrayList(clases.Config.IMPRESION_FUENTES);
			impresion_fuente.selectedIndex = GestionClientes.config.impresion_fuente;
			
			btnGuardar.addEventListener(MouseEvent.CLICK,guardar_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
		}
		
		protected function atras_click(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		protected function guardar_click(event:MouseEvent):void {
			var campo:String;
			for each (campo in inputCampos) {
				validateInput(campo);
			}
			for each (campo in selectCampos) {
				validateSelect(campo);
			}
			ModalAlert.showDelay("Configuración guardada con éxito","Guardar cambios",null,1000,null,"well-info");
		}
		
		private function validateInput(campo:String):void {
			if (GestionClientes.config[campo]!=this[campo].text)
				GestionClientes.config.update(campo,this[campo].text);
		}
		private function validateSelect (campo:String):void {
			if (GestionClientes.config[campo]!=this[campo].selectedIndex)
				GestionClientes.config.update(campo,this[campo].selectedIndex);
		}
	}
}