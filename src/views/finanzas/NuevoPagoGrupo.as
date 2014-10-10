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
	
	import utils.DateUtil;
	
	import views.finanzas.modal.ArticuloPicker;
	
	import vo.VOCliente;
	import vo.VOFactura;
	import vo.VOGrupo;
	import vo.VOPago;
	import vo.VOProducto;
	
	public class NuevoPagoGrupo extends NuevoPagoGrupoUI
	{
		protected var _pagos:Vector.<VOPago>;
		protected var _pagosPendientes:VectorCollection;
		protected var _totalPagos:Number;
		
		public var factura:VOFactura;
		
		private var _grupo:VOGrupo;
		public function get grupo():VOGrupo { return _grupo; }
		public function set grupo(value:VOGrupo):void {
			_grupo = value;
		}
		
		
		public function NuevoPagoGrupo() {
			super();
			_pagos=new Vector.<VOPago>;
		}
		
		override protected function onComplete(event:FlexEvent):void {
			super.onComplete(event);
			removeEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
			if (grupo)
				descInput.setFocus();
			else
				grupoInput.setFocus();
		}
		
		override protected function onAdded(event:Event):void {
			super.onAdded(event);
			if (initialized) {
				childrenCreated();
				if (grupo)
					descInput.setFocus();
				else
					grupoInput.setFocus();
			}
		}
		override protected function createChildren():void {
			super.createChildren();
			if (grupo) {
				grupoInput.label = grupo.nombre;
				grupoInput.enabled=false;
			}
			grupoInput.dataProvider = new VectorCollection(GestionClientes.grupos.data);
			grupoInput.onClose = grupoInput_close;
		}
		
		private function grupoInput_close(indice:int,grupo:VOGrupo):void {
			this.grupo = grupo;
		}
		override protected function childrenCreated():void {
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			btnProductos.addEventListener(MouseEvent.CLICK,productos_click);
			btnInsertar.addEventListener(MouseEvent.CLICK,insertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
			btnFacturar.addEventListener(MouseEvent.CLICK,facturar_click);
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		protected function removerClick(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				_pagos.splice(grid.selectedIndex,1);
				updatePagos();
			}
		}
		
		protected function facturar_click(event:MouseEvent):void {
			if (form.isValid) {
				if (_pagos.length>0)
					ModalAlert.show("¿Esta seguro desea realizar factura?","Facturar",this,[{label:"Sí",styleName:"btn-primary"},{label:"No"}],facturarHandler);
				else
					ModalAlert.show("Se necesita agregue al menos un articulo o pago a cancelar","Pagos",null,[ModalAlert.OK],function ():void {
						descInput.setFocus();
					});
			}
		}
		protected function facturarHandler (detalle:int):void {
			if (detalle==0) {
				var pago:VOPago; var pagosGrupo:Vector.<VOPago>;
				var now:String = DateField.dateToString(new Date,"YYYY-MM-DD");
				var clientes:Vector.<VOCliente> = (grupoInput.selectedItem as VOGrupo).clientes();
				var facturas:Vector.<VOFactura> = new Vector.<VOFactura>;
				var i:int;
				for (i = 0; i < clientes.length; i++) {
					factura = new VOFactura;
					factura.clienteID = grupo.grupoID;
					factura.fecha = DateUtil.toggleDate(fechaInput.text);
					factura.usuarioID = 0;
					factura.monto = _totalPagos;
					factura.correlativo = GestionClientes.config.correlativo;
					
					GestionClientes.facturas.instertar(factura);
					pagosGrupo = _pagos.slice();
					for each (pago in pagosGrupo) {
						if (pago.pagoID>0) {
							pago.asignarFactura(factura.facturaID);
						} else {
							pago.facturaID = factura.facturaID;
							pago.clienteID = clientes[i].clienteID;
							pago.fecha = now;
							GestionClientes.pagos.insertar(pago);
						}
						pago.pagoID = 0;
					}
					factura.cancelarPagos();					
					GestionClientes.config.update("correlativo",GestionClientes.config.correlativo+1);
					facturas.push(factura);
				}
				var producto:VOProducto; 
				i = grupo.clientes().length;
				for each (pago in _pagos) {
					if (pago.tipo==VOProducto.PRODUCTO) {
						producto = GestionClientes.productos.byDescripcion(pago.descripcion);						 
						GestionClientes.productos.updateStock(producto.productoID,producto.cantidad-(pago.cantidad*i));						
					}
				}
				ModalAlert.show("","Facturas Generadas",this,[
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
						clases.Imprimir.imprimirFacturas(facturas);
						if (copia.selected)
							clases.Imprimir.imprimirFacturas(facturas,true);
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
			if (grupo) {
				var articulo:ArticuloPicker = new ArticuloPicker;
				articulo.clientes = grupo.clientes().length;
				articulo.onClose = function (pago:VOPago):void {
					_pagos.push(pago);
					updatePagos();
					descInput.setFocus();
				};
				articulo.popUp();
			} else {
				ModalAlert.showDelay("Debe seleccionar un grupo","Información");
			}
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
			tipoInput.selectedIndex=-1;
		}
		
		protected function cancelarClick(event:MouseEvent=null):void {
			(owner as ViewNavigatorHistory).popBack();
		}	
	}
}