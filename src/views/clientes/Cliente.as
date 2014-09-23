package views.clientes
{
	import com.ListPicker;
	import com.Modal;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.DateField;
	
	import org.apache.flex.collections.VectorList;
	import org.osflash.signals.natives.NativeSignal;
	
	import spark.components.Alert;
	
	import utils.DateUtil;
	
	import vo.VOCliente;
	import vo.VOGrupo;

	public class Cliente extends ClienteUI
	{
		private var onRemove:NativeSignal;
		private var onAdded:NativeSignal;
		
		public var cliente:VOCliente;
		private var _grupo:VOGrupo;

		public function get grupo():VOGrupo { return _grupo; }
		public function set grupo(value:VOGrupo):void {
			_grupo = value;
			grupoInput.label = value.nombre;
		}

		
		public function Cliente() {
			super();
			onAdded = new NativeSignal(this,Event.ADDED_TO_STAGE,Event);
			onAdded.addOnce(addedStage);
		}		
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelClick);
			btnGuardar.addEventListener(MouseEvent.CLICK,guardarClick);			
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
			grupoInput.addEventListener(MouseEvent.CLICK,seleccionarGrupo);
			
			super.childrenCreated();
			nombreInput.setFocus();
		}
		
		private function addedStage(e:Event):void {
			if (initialized)
				childrenCreated();
			
			onRemove = new NativeSignal(this,Event.REMOVED_FROM_STAGE,Event);
			onRemove.addOnce(removeStage);
		}
		
		protected function seleccionarGrupo(event:MouseEvent):void {
			var sg:ListPicker = new ListPicker();
			sg.title = "Seleccionar grupo";
			sg.onClose = function (indice:int,data:VOGrupo):void {
				grupo = data;
			};
			sg.labelField = "nombre";
			sg.dataProvider = new VectorList(GestionClientes.grupos.data);
			sg.popUp();
		}
		private function removeStage(e:Event):void {
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelClick);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardarClick);	
			onRemove=null;
			
			btnReset.removeEventListener(MouseEvent.CLICK,resetClick);
			onAdded.addOnce(addedStage);
		}
		
		protected function guardarClick(event:MouseEvent):void {
			var c:Object = {};
			c.nombres = nombreInput.text;
			c.cedula = cedulaInput.text;
			c.telefonos = tlfInput.text;
			c.direccion = dirInput.text;
			c.fechaNacimiento = DateUtil.toggleDate(fechaInput.fullText);
			c.fechaRegistro = DateField.dateToString(new Date,"YYYY-MM-DD");
			c.grupoID = grupo.grupoID;
			c.meta = "";
			
			GestionClientes.sql.insertar("clientes",c);
			ModalAlert.show("Cliente Guardado","Cliente",null,[ModalAlert.OK],function ():void {
				resetClick();
			});
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
			(owner as ViewNavigator).popBack();
		}
	}
}