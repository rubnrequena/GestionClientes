package views.horarios
{
	import com.ListPicker;
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	
	import org.apache.flex.collections.VectorList;
	
	import spark.components.CheckBox;
	
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOSalon;

	public class HorarioNuevo extends HorarioNuevoUI
	{				
		public function HorarioNuevo() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized) childrenCreated();	
		}
		override protected function createChildren():void {
			super.createChildren();
			tipoInput.onClose = tipoInput_change;
			grupoInput.dataProvider = new VectorList(GestionClientes.grupos.data);
		}
		override protected function childrenCreated():void {
			btnGuardar.addEventListener(MouseEvent.CLICK,guardarClick);
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			grupoInput.setFocus();
			
			salonInput.dataProvider = new VectorList(GestionClientes.salones.data);
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		protected function resetClick(event:MouseEvent=null):void {
			entradaInput.text= salidaInput.text="";
			grupoInput.selectedIndex=-1;
			tipoInput.selectedIndex=-1;
			salonInput.selectedIndex=-1;
			
			var i:int;
			for (i = 0; i < diasMeses.numElements; i++)
				(diasMeses.getElementAt(i) as CheckBox).selected = false;
			for (i = 0; i < diasSemanas.numElements; i++)
				(diasSemanas.getElementAt(i) as CheckBox).selected = false;
			
			grupoInput.setFocus();
		}
		
		protected function guardarClick(event:MouseEvent):void {
			if (validarCampos) {
				var h:VOHorario = new VOHorario;
				h.entrada = int(entradaInput.fullText.split(":").join(""));
				h.salida = int(salidaInput.fullText.split(":").join(""));
				h.dias = tipoInput.selectedIndex==0?diasSemana:diasMes;
				h.grupo = (grupoInput.selectedItem as VOGrupo).grupoID;
				h.tipo = tipoInput.selectedIndex;
				h.salonID = (salonInput.selectedItem as VOSalon).salonID;
				
				GestionClientes.horarios.insertar(h);
				ModalAlert.show("Horario nuevo registrado","Horarios",null,[{label:"Confirmar"}],function ():void {
					resetClick();
				});
			}
		}
		
		private function get validarCampos():Boolean {
			var s:Array = [];
			if (!grupoInput.selectedIndex>0)
				s.push("- Seleccione grupo");
			if (!validarHora(entradaInput.fullText))
				s.push("- Campo de entrada inválida");
			if (!validarHora(salidaInput.fullText))
				s.push("- Campo de salida inválida");
			if (s.length>0) ModalAlert.show(s.join("\n"),"Corregir campos inválidos",null,[{label:"Confirmar",styleName:"btn-danger"}]);
			return s.length==0;
		}
		protected function validarHora (h:String):Boolean {
			var ha:Array = h.split(":");
			if (ha.length==2 && !isNaN(Number(ha[0])) && !isNaN(Number(ha[1]))) 
				return true;
			else
				return false;
		}		
		private function tipoInput_change(tipo:int):void {
			currentState = tipo==0?"semanal":"mensual";
		}
		
		private function get diasSemana():String {
			var d:Array = []; var l:int = diasSemanas.numElements;
			var c:CheckBox;
			for (var i:int = 0; i < l; i++) {
				c = diasSemanas.getElementAt(i) as CheckBox;
				if (c.selected) d.push(i);
			}
			return d.join(",");
		}
		private function get diasMes():String {
			var d:Array = []; var l:int = diasMeses.numElements;
			var c:CheckBox; var i:int;
			for (i = 0; i < l; i++) {
				c = diasMeses.getElementAt(i) as CheckBox;
				if (c.selected) d.push(i+1);
			}
			return d.join(",");
		}
	}
}