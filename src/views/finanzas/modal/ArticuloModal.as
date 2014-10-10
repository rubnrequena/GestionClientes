package views.finanzas.modal
{
	import bootstrap.controls.Form;
	import bootstrap.controls.FormItem;
	import bootstrap.validators.ValidatorType;
	
	import com.Modal;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	
	import vo.VOProducto;
	
	public class ArticuloModal extends Modal
	{
		protected var form:Form;		
		protected var descInput:TextInput;
		protected var montoInput:TextInput;
		protected var cantInput:TextInput;
		protected var confirmarButton:Button;
		protected var atrasButton:Button;
		
		public var producto:VOProducto;
		
		public function ArticuloModal()
		{
			super();
			width = 400;
		}
		
		override protected function childrenCreated():void {
			super.childrenCreated();
			
			form = new Form;
			form.percentWidth = 100;
			addElement(form);
			
			var formItem:FormItem;
			
			formItem = new FormItem;
			formItem.validateType = ValidatorType.TEXT;
			formItem.label = "Descripción";
			descInput = new TextInput;
			formItem.addElement(descInput);
			form.addElement(formItem);
			
			formItem = new FormItem;
			formItem.label = "Monto";
			formItem.validateType = ValidatorType.NUMBER;
			montoInput = new TextInput;
			montoInput.restrict = "0-9.";
			formItem.addElement(montoInput);
			form.addElement(formItem);
			
			formItem = new FormItem;
			formItem.label = "Nuevo Stock";
			formItem.validateType = ValidatorType.NUMBER;
			cantInput = new TextInput;
			cantInput.restrict = "0-9.";
			formItem.addElement(cantInput);
			form.addElement(formItem);
		
			confirmarButton = new Button;
			confirmarButton.label = "Confirmar";
			confirmarButton.styleName = "btn-success icon-insertar-sm";
			confirmarButton.percentWidth = 50;
			confirmarButton.addEventListener(MouseEvent.CLICK,confirmar_click);
			atrasButton = new Button;
			atrasButton.label = "Cancelar";
			atrasButton.styleName = "btn-danger icon-atras-sm";
			atrasButton.percentWidth = 50;
			atrasButton.addEventListener(MouseEvent.CLICK,atras_click);
			
			controlBarContent = [confirmarButton,atrasButton];
			
			montoInput.setFocus();
		}
		
		protected function atras_click(event:MouseEvent):void {
			popOff();
		}
		
		protected function confirmar_click(event:MouseEvent):void {
			
		}
	}
}