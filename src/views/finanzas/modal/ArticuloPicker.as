package views.finanzas.modal
{
	
	import bootstrap.controls.Form;
	import bootstrap.controls.FormItem;
	import bootstrap.validators.Validator;
	import bootstrap.validators.ValidatorType;
	
	import com.ListPickerButton;
	import com.ListPickerSearch;
	import com.Modal;
	import com.ModalAlert;
	
	import flash.events.MouseEvent;
	
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	
	import vo.VOPago;
	import vo.VOProducto;
	
	public class ArticuloPicker extends Modal
	{
		private var form:Form;
		private var articuloInput:ListPickerButton;
		private var montoInput:TextInput;
		private var cantInput:TextInput;
		private var confirmarButton:Button;
		private var atrasButton:Button;
		
		public var clientes:int=1;
		public function ArticuloPicker()
		{
			super();
			width = 500;
		}
		override protected function childrenCreated():void {
			super.childrenCreated();
			
			form = new Form;
			form.percentWidth = form.percentHeight = 100;
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
				name = "-Articulo";
				onClose = articulo_select;
			}
			formItem.validateType = ValidatorType.LIST;
			formItem.addElement(articuloInput);
			form.addElement(formItem);
			
			formItem = new FormItem;
			formItem.label = "Monto";
			formItem.validateFunctions = new <Function>[
				Validator.validateNumber,
				validarStock
			];
			montoInput = new TextInput;
			montoInput.restrict = "0-9.\-";
			montoInput.enabled=false;
			montoInput.name = "-Monto";
			
			var lbl:Label = new Label;
			lbl.styleName = "text-align-right";
			lbl.text = "Cantidad";
			
			cantInput = new TextInput;
			cantInput.restrict = "0-9.";
			cantInput.name = "-Cantidad";
			
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
		
		private function validarStock(items:Array):void {
			var cant:Number = Number(cantInput.text)*clientes;
			var art:VOProducto = articuloInput.selectedItem as VOProducto;
			if (art) {
				if (art.tipo==VOProducto.PRODUCTO && cant>art.cantidad) {
					cantInput.errorString = [cantInput.name,"Stock insuficiente"].join(" ");
				} else {
					cantInput.errorString = "";
				}
			}
		}
		
		private function articulo_select(indice:int,articulo:VOProducto):void {
			montoInput.text = articulo.monto.toString();
			cantInput.setFocus();
		}
		
		protected function atras_click(event:MouseEvent):void {
			popOff();
		}
		
		protected function confirmar_click(event:MouseEvent):void {
			if (form.isValid) {
				var pago:VOPago = new VOPago;
				pago.descripcion = articuloInput.selectedItem.descripcion;
				pago.monto = articuloInput.selectedItem.monto;
				pago.cantidad = Number(cantInput.text);
				pago.tipo = articuloInput.selectedItem.tipo;
				
				closing(pago);
			} else {
				ModalAlert.show(form.elementErrorStrings.join("\n"),"Campos inválidos",null,[ModalAlert.OK]);
			}
		}
	}
}