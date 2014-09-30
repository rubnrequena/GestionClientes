package views.clientes
{
	import bootstrap.controls.FormItem;
	
	import com.ListPicker;
	import com.ListPickerSearch;
	import com.Modal;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	import mx.core.ITextInput;
	
	import org.apache.flex.collections.VectorCollection;
	import org.apache.flex.collections.VectorList;
	import org.osflash.signals.natives.NativeSignal;
	
	import spark.components.Alert;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableTextBase;
	
	import utils.DateUtil;
	
	import vo.VOCliente;
	import vo.VOGrupo;

	public class Cliente extends ClienteUI
	{
		private var onRemove:NativeSignal;
		private var onAdded:NativeSignal;
		
		public var cliente:VOCliente;
		
		public function Cliente() {
			super();
			onAdded = new NativeSignal(this,Event.ADDED_TO_STAGE,Event);
			onAdded.addOnce(addedStage);
		}		
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelClick);
			btnGuardar.addEventListener(MouseEvent.CLICK,guardar_click);			
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
			
			grupoInput.pickerClass = new ClassFactory(ListPickerSearch);
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			super.childrenCreated();
			nombreInput.setFocus();
		}
		
		private function addedStage(e:Event):void {
			if (initialized)
				childrenCreated();
			
			onRemove = new NativeSignal(this,Event.REMOVED_FROM_STAGE,Event);
			onRemove.addOnce(removeStage);
		}
		
		private function removeStage(e:Event):void {
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelClick);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardar_click);	
			onRemove=null;
			
			btnReset.removeEventListener(MouseEvent.CLICK,resetClick);
			onAdded.addOnce(addedStage);
		}
		
		protected function guardar_click(event:MouseEvent):void {
			if (validateCampos) {
				var cliente:VOCliente = new VOCliente;
				cliente.nombres = nombreInput.text;
				cliente.cedula = cedulaInput.text;
				cliente.telefonos = tlfInput.text;
				cliente.direccion = dirInput.text;
				cliente.fechaNacimiento = DateUtil.toggleDate(fechaInput.fullText);
				cliente.fechaRegistro = DateField.dateToString(new Date,"YYYY-MM-DD");
				cliente.grupoID = grupoInput.selectedItem.grupoID;
				cliente.meta = "";
				
				GestionClientes.clientes.insertar(cliente);
				ModalAlert.showDelay("Cliente Guardado","Cliente",null,2000,function ():void {
					resetClick();
				},"well-info");
			}
		}
		
		private function get validateCampos():Boolean {
			var campos:Vector.<SkinnableTextBase> = new <SkinnableTextBase>[
				nombreInput,
				cedulaInput,
				fechaInput,
				dirInput,
				tlfInput
			];
			var v:Boolean=true;
			for (var i:int = 0; i < campos.length; i++) {
				if (campos[i].text=="") {
					(campos[i].owner as FormItem).styleName = "well-danger";
					v=false;
				} else {
					(campos[i].owner as FormItem).styleName = "well-default";
				}
			}
			if (grupoInput.selectedIndex<0) {
				(grupoInput.owner as FormItem).styleName = "well-danger";
				v = false;
			} else {
				(grupoInput.owner as FormItem).styleName = "well-default";
			}
			return v;
		}
		protected function resetClick(event:MouseEvent=null):void {
			nombreInput.text="";
			cedulaInput.text="";
			tlfInput.text="";
			dirInput.text="";
			fechaInput.text="";
			grupoInput.label="Seleccionar Grupo...";
			cliente=null;
		}
		protected function cancelClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}