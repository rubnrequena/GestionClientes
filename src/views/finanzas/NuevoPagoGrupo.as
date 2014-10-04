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
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
		}
		
		protected function onComplete(event:FlexEvent):void {
			removeEventListener(FlexEvent.CREATION_COMPLETE,onComplete);
			if (grupo)
				descInput.setFocus();
			else
				grupoInput.setFocus();
		}
		
		protected function onAdded(event:Event):void {
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
			btnProductos.addEventListener(MouseEvent.CLICK,btnProductos_click);
			btnInsertar.addEventListener(MouseEvent.CLICK,btnInsertar_click);
			btnRemover.addEventListener(MouseEvent.CLICK,removerClick);
			btnFacturar.addEventListener(MouseEvent.CLICK,facturarClick);
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		protected function removerClick(event:MouseEvent):void {
			if (grid.selectedIndex>-1) {
				_pagos.splice(grid.selectedIndex,1);
				updatePagos();
			}
		}
		
		protected function facturarClick(event:MouseEvent):void {
			ModalAlert.show("¿Esta seguro desea realizar factura?","Facturar",this,[{label:"Sí",styleName:"btn-primary"},{label:"No"}],facturarHandler);
		}
		protected function facturarHandler (detalle:int):void {
			if (detalle==0) {
				var now:String = DateField.dateToString(new Date,"YYYY-MM-DD");
				var clientes:Vector.<VOCliente> = (grupoInput.selectedItem as VOGrupo).clientes();
				var facturas:Vector.<VOFactura> = new Vector.<VOFactura>;
				for (var i:int = 0; i < clientes.length; i++) {
					factura = new VOFactura;
					factura.clienteID = grupo.grupoID;
					factura.fecha = DateUtil.toggleDate(fechaInput.text);
					factura.usuarioID = 0;
					factura.monto = _totalPagos;
					factura.correlativo = GestionClientes.config.correlativo;
					
					GestionClientes.facturas.instertar(factura);
					var pagosGrupo:Vector.<VOPago> = _pagos.slice();
					for each (var pago:VOPago in pagosGrupo) {
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
					if (detalle==0)
						clases.Imprimir.imprimirFacturas(facturas);
					cancelarClick();
				});
			}
		}
		protected function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode==Keyboard.INSERT) {
				btnProductos_click();
			}
		}
		protected function btnProductos_click(event:MouseEvent=null):void {
			var productosPicker:ListPickerSearch = new ListPickerSearch();
			productosPicker.title = "Seleccione producto o servicio";
			productosPicker.onClose = function (indice:int,producto:VOProducto):void {
				descInput.text = producto.descripcion;
				montoInput.text = producto.monto.toString();
				cantInput.setFocus();
			};
			productosPicker.dataProvider = new VectorCollection(GestionClientes.productos.data);
			productosPicker.labelField = "descripcion";
			productosPicker.selectedIndex=-1;
			productosPicker.popUp();
		}
		
		private function updatePagos():void {
			_totalPagos=0;
			for each (var pago:VOPago in _pagos) {
				_totalPagos += pago.monto*pago.cantidad;
			}
			totalInput.text = _totalPagos.toFixed(2);
			grid.dataProvider = new VectorCollection(_pagos);
		}
		
		protected function btnInsertar_click(event:MouseEvent):void {
			var p:VOPago = new VOPago;
			p.descripcion = descInput.text.toUpperCase();
			p.monto = Number(montoInput.text);
			p.cantidad = Number(cantInput.text);
			
			_pagos.push(p);
			updatePagos();
			limpiarCampos();
			descInput.setFocus();
		}
		
		private function limpiarCampos():void {
			descInput.text = "";
			montoInput.text = "0"; 
			cantInput.text = "1"; 
		}
		
		protected function cancelarClick(event:MouseEvent=null):void {
			(owner as ViewNavigatorHistory).popBack();
		}	
	}
}