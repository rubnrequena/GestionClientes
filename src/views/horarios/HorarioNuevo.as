package views.horarios
{
	import com.ModalAlert;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.apache.flex.collections.VectorList;
	
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
		}
		override protected function childrenCreated():void {
			btnGuardar.addEventListener(MouseEvent.CLICK,guardarClick);
			btnReset.addEventListener(MouseEvent.CLICK,resetClick);
			btnCancelar.addEventListener(MouseEvent.CLICK,cancelarClick);
			
			grupoInput.dataProvider = new VectorList(GestionClientes.grupos.data);
			salonInput.dataProvider = new VectorList(GestionClientes.salones.data);
			grupoInput.setFocus();
		}
		
		protected function cancelarClick(event:MouseEvent):void {
			(owner as ViewNavigator).popBack();
		}
		
		protected function resetClick(event:MouseEvent=null):void {
			salidaInput.text="";
			grupoInput.selectedIndex=-1;
			tipoInput.selectedIndex=-1;
			salonInput.selectedIndex=-1;			
			diaInput.tipo = -1;
			grupoInput.setFocus();
		}
		
		protected function guardarClick(event:MouseEvent):void {
			if (validarCampos) {
				var h:VOHorario = new VOHorario;
				h.entrada = entradaInput.time;
				h.salida = salidaInput.time;
				h.dias = diaInput.dias;
				h.grupoID = (grupoInput.selectedItem as VOGrupo).grupoID;
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
			if (grupoInput.selectedIndex==-1)
				s.push("- Seleccione grupo");
			if (entradaInput.time>=salidaInput.time) 
				s.push("- Horario inválido, la hora de entrada no puede ser menor o igual a la salida");
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
			diaInput.tipo = tipo;
		}
	}
}