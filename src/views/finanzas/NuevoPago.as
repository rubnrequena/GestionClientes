package views.finanzas
{
	import clases.Imprimir;
	
	import com.ListPickerSearch;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import org.apache.flex.collections.VectorCollection;
	
	import spark.layouts.HorizontalLayout;
	
	import utils.DateUtil;
	
	import views.finanzas.modal.ArticuloPicker;
	
	import vo.VOCliente;
	import vo.VOFactura;
	import vo.VOPago;
	import vo.VOProducto;
	import vo.VOUsuario;
	
	public class NuevoPago extends NuevoPagoUI
	{
		protected var _pagos:Vector.<VOPago>;
		protected var _pagosPendientes:VectorCollection;
		protected var _totalPagos:Number;
		
		public var factura:VOFactura;
		
		private var _cliente:VOCliente;
		public function get cliente():VOCliente { return _cliente; }
		public function set cliente(value:VOCliente):void {
			_cliente = value;
			_pagosPendientes = new VectorCollection(_cliente.pagosPendientes());
		}
		
		private var pagosPicker:ListPickerSearch = new ListPickerSearch;		
		
		public function NuevoPago() {
			super();
			_pagos=new Vector.<VOPago>;
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
		}
		
		override protected function onComplete(event:FlexEvent):void {
			super.onComplete(event);
			removeEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
			if (cliente)
				descInput.setFocus();
			else
				clienteInput.setFocus();
			
			(controlBarLayout as HorizontalLayout).verticalAlign = "middle";
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) {
				childrenCreated();
				if (cliente)
					descInput.setFocus();
				else
					clienteInput.setFocus();
			}
		}
		override protected function createChildren():void {
			super.createChildren();
			if (cliente) {
				clienteInput.label = cliente.nombres;
				clienteInput.enabled=false;
			}
			clienteInput.dataProvider = new VectorCollection(GestionClientes.clientes.data);
		}
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnProductos.addEventListener(MouseEvent.CLICK,productos_click);
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,remover_click);
			btnFacturar.addEventListener(MouseEvent.CLICK,facturar_click);
			btnPendientes.addEventListener(MouseEvent.CLICK,pagosPendientes_click);
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			clienteInput.onClose = seleccionarCliente_close;
			clienteInput.properties.width = 400;
			credito.enabled = credito.visible = GestionClientes.config.empleado_credito;
			
			pagosPicker.labelField = "descripcion";
			pagosPicker.title = "Pagos";
			pagosPicker.onClose = pagosPendiente_selected;
			updatePagos();
			checkPagosPendientes();
		}
		
		private function pagosPendiente_selected(index:int,pago:VOPago):void {
			_pagos.push(pago);
			updatePagos();
			limpiarCampos();
			descInput.setFocus();
		}
		
		protected function pagosPendientes_click(event:MouseEvent):void {
			pagosPicker.popUp();
		}
		
		protected function remover_click(event:MouseEvent):void {
			var len:uint = grid.selectedIndices.length;
			for (var i:int = len-1; i > -1; i--) {
				_pagos.splice(grid.selectedIndices[i],1);				
			}
			updatePagos();
		}
		
		protected function facturar_click(event:MouseEvent):void {
			if (form.isValid) {
				if (_pagos.length>0) {
					if (credito.selected)
						ModalAlert.show("¿Esta seguro desea aumentar crédito?","Crédito",this,[{label:"Sí",styleName:"btn-primary"},{label:"No"}],creditoHandler);
					else
						ModalAlert.show("¿Esta seguro desea realizar factura?","Facturar",this,[{label:"Sí",styleName:"btn-primary"},{label:"No"}],facturarHandler);
				} else {
					ModalAlert.show("Se necesita agregue al menos un articulo o pago a cancelar","Pagos",null,[ModalAlert.OK],function ():void {
						descInput.setFocus();
					});
				}
			}
		}
		
		private function creditoHandler(detalle:int):void {
			if (detalle>0) return;
			var now:String = DateField.dateToString(new Date,"YYYY-MM-DD");
			for each (var pago:VOPago in _pagos) {
				if (pago.pagoID==0) {
					pago.facturaID = 0;
					pago.clienteID = cliente.clienteID;
					pago.fecha = now;
					pago.pendiente = credito.selected;
					GestionClientes.pagos.insertar(pago);
				}
			}
			var producto:VOProducto;
			for each (pago in _pagos) {
				if (pago.tipo==VOProducto.PRODUCTO) {
					producto = GestionClientes.productos.byDescripcion(pago.descripcion);
					GestionClientes.productos.updateStock(producto.productoID,producto.cantidad-pago.cantidad);						
				}
			}			
			cancelarClick();
		}
		protected function facturarHandler (detalle:int):void {
			if (detalle==0) {
				var now:String = DateField.dateToString(new Date,"YYYY-MM-DD");
				factura = new VOFactura;
				factura.clienteID = cliente.clienteID;
				factura.fecha = DateUtil.toggleDate(fechaInput.text);
				factura.usuarioID = VOUsuario.USUARIO_ACTIVO;
				factura.monto = _totalPagos;
				factura.correlativo = GestionClientes.config.correlativo;
				
				GestionClientes.facturas.instertar(factura);
				for each (var pago:VOPago in _pagos) {
					if (pago.pagoID>0) {
						pago.asignarFactura(factura.facturaID);
					} else {
						pago.facturaID = factura.facturaID;
						pago.clienteID = cliente.clienteID;
						pago.fecha = now;
						pago.pendiente = credito.selected;
						GestionClientes.pagos.insertar(pago);
					}
				}
				factura.cancelarPagos();
				
				var producto:VOProducto;
				for each (pago in _pagos) {
					if (pago.tipo==VOProducto.PRODUCTO) {
						producto = GestionClientes.productos.byDescripcion(pago.descripcion);
						GestionClientes.productos.updateStock(producto.productoID,producto.cantidad-pago.cantidad);						
					}
				}
				
				GestionClientes.config.update("correlativo",GestionClientes.config.correlativo+1);
				ModalAlert.show("","Factura Generada",this,[
					{
						label:"Imprimir",
						styleName:"btn-primary icon-imprimir-sm"
					},
					{
						label:"Volver",
						styleName:"btn-danger icon-atras-sm"
					}
				],function (detalle:int):void {
					if (detalle==0) {
						clases.Imprimir.imprimirFactura(factura);
						if (copia.selected)
							clases.Imprimir.imprimirFactura(factura,true);
					}
					cancelarClick();
				});
			}
		}
		protected function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode==Keyboard.INSERT) {
				productos_click();
			}
		}
		protected function productos_click(event:MouseEvent=null):void {
			var articulo:ArticuloPicker = new ArticuloPicker;
			articulo.onClose = function (pago:VOPago):void {
				_pagos.push(pago);
				updatePagos();
				descInput.setFocus();
			};
			articulo.popUp();
		}
		
		private function updatePagos():void {
			_totalPagos=0;
			for each (var pago:VOPago in _pagos) {
				_totalPagos += pago.monto*pago.cantidad;
			}
			totalInput.text = _totalPagos.toFixed(2);
			grid.dataProvider = new VectorCollection(_pagos);
		}
		
		protected function insertar_click(event:MouseEvent):void {
			if (form_item.isValid) {
				var p:VOPago = new VOPago;
				p.descripcion = descInput.text.toUpperCase();
				p.monto = Number(montoInput.text);
				p.cantidad = Number(cantInput.text);
				p.tipo = tipoInput.selectedItem.data;
				
				_pagos.push(p);
				updatePagos();
				limpiarCampos();
				descInput.setFocus();
			}
		}
		
		private function limpiarCampos():void {
			descInput.text = "";
			montoInput.text = "0"; 
			cantInput.text = "1"; 
			tipoInput.selectedIndex-1;
		}
		
		protected function cancelarClick(event:MouseEvent=null):void {
			(owner as ViewNavigatorHistory).popBack();
		}
		
		
		protected function seleccionarCliente_close (indice:int,data:VOCliente):void {
			cliente = data;
			checkPagosPendientes();
		}
		
		private function checkPagosPendientes():void {
			pagosPicker.dataProvider = _pagosPendientes;
			if (_pagosPendientes && _pagosPendientes.length>0) {
				btnPendientes.enabled = true;
				btnPendientes.styleName = "icon-pagos_pendientes-sm btn-silent"					
			} else {
				btnPendientes.enabled = false;
				btnPendientes.styleName = "icon-pagos_pendientes_vacia-sm btn-silent"
			}
		}
	}
}