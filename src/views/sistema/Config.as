package views.sistema
{
	import clases.Config;
	
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import spark.components.Button;
	import spark.components.ToggleButton;

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
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) childrenCreated();
		}
		
		override protected function childrenCreated():void {
			razon_social.text = GestionClientes.config.razon_social;
			rif.text = GestionClientes.config.rif;
			correlativo.text = GestionClientes.config.correlativo.toString();
			
			impresion_anchoPapel.text = GestionClientes.config.impresion_anchoPapel.toString();
			impresion_fuente.dataProvider = new ArrayList(clases.Config.IMPRESION_FUENTES);
			impresion_fuente.selectedIndex = GestionClientes.config.impresion_fuente;
			
			toggleButton(GestionClientes.config.sonidos,sonidos);
			sonidos.addEventListener(MouseEvent.CLICK,sonidos_click);
			
			toggleButton(GestionClientes.config.morosos_en_pantalla,morosos);
			morosos.addEventListener(MouseEvent.CLICK,morosos_click);
			
			toggleButton(GestionClientes.config.empleado_credito,credito);
			credito.addEventListener(MouseEvent.CLICK,credito_click);
			
			btnGuardar.addEventListener(MouseEvent.CLICK,guardar_click);
			btnAtras.addEventListener(MouseEvent.CLICK,atras_click);
		}
		
		protected function credito_click(event:MouseEvent):void {
			toggleButton(event.target.selected,event.target as ToggleButton);
		}
		
		protected function morosos_click(event:MouseEvent):void {
			toggleButton(morosos.selected,morosos);
		}
		
		protected function sonidos_click(event:MouseEvent):void {
			toggleButton(sonidos.selected,sonidos);
		}
		
		private function toggleButton(value:Boolean,button:ToggleButton):void {
			button.label = value?"Activado":"Desactivado";
			button.selected = value;
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
			var toggles:Vector.<ToggleButton> = new <ToggleButton>[
				sonidos,
				morosos,
				credito
			];
			for (var i:int = 0; i < toggles.length; i++) {
				GestionClientes.config.update(toggles[i].name,toggles[i].selected);
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