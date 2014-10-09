package views.finanzas.modal
{
	import bootstrap.controls.Form;
	import bootstrap.controls.FormItem;
	
	import com.ListPickerButton;
	import com.ListPickerSearch;
	import com.Modal;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	
	public class ArticuloModal extends Modal
	{
		private var form:Form;
		private var articuloInput:ListPickerButton;
		private var montoInput:TextInput;
		private var cantInput:TextInput;
		private var confirmarButton:Button;
		private var atrasButton:Button;
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
			formItem.label = "Articulo";
			articuloInput = new ListPickerButton;
			with (articuloInput) {
				label = "Seleccione producto o servicio";
				dataProvider = new VectorCollection(GestionClientes.productos.data);
				pickerClass = new ClassFactory(ListPickerSearch);
				labelField = "descripcion";
				title = "Productos/Servicios";
			}
			formItem.addElement(articuloInput);
			form.addElement(formItem);
			
			formItem = new FormItem;
			formItem.label = "Monto";
			montoInput = new TextInput;
			montoInput.restrict = "0-9.\-";
			
			var lbl:Label = new Label;
			lbl.text = "Cantidad";
			
			cantInput = new TextInput;
			cantInput.restrict = "0-9.";
			
			formItem.addElement(montoInput);
			formItem.addElement(lbl);
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
		}
		
		protected function atras_click(event:MouseEvent):void {
			popOff();
		}
		
		protected function confirmar_click(event:MouseEvent):void {
			closing();
		}		
		
		
		protected function validarInput (item:FormItem):Boolean {
			return item.input.text.length>0;
		}
		protected function validarList (item:FormItem):Boolean {
			return item.picker.selectedIndex>-1;
		}
		protected function validarItem (item:FormItem):Boolean {
			var m:Number = Number(montoInput.text);
			var c:Number = Number(cantInput.text);
			return (!isNaN(m) && !isNaN(c)) && (m!=0 && c!=0);
		}
	}
}