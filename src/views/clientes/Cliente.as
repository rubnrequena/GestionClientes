package views.clientes
{
	import bootstrap.controls.FormItem;
	
	import com.ListPicker;
	import com.ListPickerSearch;
	import com.ModalAlert;
	import com.adobe.crypto.MD5;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	import org.apache.flex.collections.VectorCollection;
	import org.osflash.signals.natives.NativeSignal;
	
	import spark.components.supportClasses.SkinnableTextBase;
	
	import utils.DateUtil;
	
	import views.finanzas.NuevoPago;
	
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOPago;
	import vo.VOProducto;
	import vo.VOTarea;
	import vo.VOUsuario;

	public class Cliente extends ClienteUI
	{		
		public var _cliente:VOCliente;
		
		public function Cliente() {
			super();
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
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized)
				childrenCreated();
		}
		
		override protected function onRemoved(event:Event):void {
			super.onRemoved(event);
			btnCancelar.removeEventListener(MouseEvent.CLICK,cancelClick);
			btnGuardar.removeEventListener(MouseEvent.CLICK,guardar_click);
			
			btnReset.removeEventListener(MouseEvent.CLICK,resetClick);
		}
		
		protected function guardar_click(event:MouseEvent):void {
			if (validateCampos) {
				_cliente = new VOCliente;
				_cliente.nombres = nombreInput.text;
				_cliente.cedula = cedulaInput.text;
				_cliente.telefonos = tlfInput.text;
				_cliente.direccion = dirInput.text;
				_cliente.fechaNacimiento = DateUtil.toggleDate(fechaInput.fullText);
				_cliente.fechaRegistro = DateField.dateToString(new Date,"YYYY-MM-DD");
				_cliente.grupoID = grupoInput.selectedItem.grupoID;
				_cliente.meta = obsInput.text;
				
				GestionClientes.clientes.insertar(_cliente);
				
				var _grupo:VOGrupo = GestionClientes.grupos.byID(grupoInput.selectedItem.grupoID);
				if (_grupo.inscripcion>0) {
					var _pago:VOPago = new VOPago;
					_pago.clienteID = _cliente.clienteID;
					_pago.descripcion = "[SISTEMA] INSCRIPCION "+_grupo.nombre;
					_pago.monto = _grupo.inscripcion;
					_pago.cantidad = 1;
					_pago.fecha = _cliente.fechaRegistro;
					_pago.pendiente = true;
					_pago.tipo = VOProducto.INSCRIPCION;
					_pago.usuarioID = VOUsuario.USUARIO_ACTIVO;
					GestionClientes.pagos.insertar(_pago);
				}
				
				if (tarea.selected) {
					var pick:ListPicker = new ListPicker;
					pick.cancelable = false;
					pick.dataProvider = new ArrayList([
						{label:"SEMANAL",tipo:0},
						{label:"MENSUAL",tipo:1}
					]);
					pick.labelField = "label";
					pick.title = "Seleccione...";
					pick.onClose = function (index:int,data:Object):void {
						var hoy:Date = new Date;
						var _tarea:VOTarea = new VOTarea;
						_tarea.meta = [_cliente.clienteID,"MENSUALIDAD DE {MES}, {AÑO}"].join(";");
						_tarea.tipo = data.tipo;
						_tarea.dia = data.tipo==VOTarea.TIPO_SEMANAL?hoy.day:hoy.date;
						_tarea.type = "clases.tareas::TPagoCliente";
						_tarea.tarea = "[SISTEMA] Mensualidad, "+_cliente.nombres;
						
						GestionClientes.tareas.insertar(_tarea);
						alertSave();
					};
					pick.popUp(true,this);
				} else {
					alertSave();
				}
			}
		}
		
		private function alertSave():void {
			ModalAlert.show("Cliente Guardado","Cliente",null,[{label:"Nuevo"},{label:"Facturar"}],function (button:int):void {
				if (button==0)
					resetClick();
				else if (button==1)
					facturarCliente();	
			},0,"well-info");
		}
		private function facturarCliente():void {
			(owner as ViewNavigator).addView("factura_"+_cliente.clienteID,NuevoPago,{cliente:_cliente},true);
			resetClick();
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
			_cliente=null;
		}
		protected function cancelClick(event:MouseEvent):void {
			(owner as ViewNavigatorHistory).popBack();
		}
	}
}