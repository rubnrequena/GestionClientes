package views
{
	import com.morosos.QuickMorosos;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import utils.DateUtil;

	public class Inicio extends InicioUI
	{
		private var qm:QuickMorosos;
		
		public function Inicio() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		override protected function createChildren():void {
			super.createChildren();
			
			
		}
		override protected function childrenCreated():void {
			var d:Date = new Date;
			numClientes.text = GestionClientes.clientes.data.length.toString();
			var i:int = GestionClientes.clientes.cumpleaneros(d.month+1).length;
			numCumpleanos.text = i.toString();
			
			numGrupos.text = GestionClientes.grupos.data.length.toString();
			numInstructores.text = GestionClientes.instructores.data.length.toString();
			numSalones.text = GestionClientes.salones.data.length.toString();
			numClases.text = GestionClientes.clasess.data.length.toString();
			
			var data:Array = GestionClientes.sql.sql('SELECT asistio, COUNT(asistio) num FROM asistencias WHERE fechaIngreso = "'+DateUtil.dateToString(d,"YYYY-MM-DD")+'" GROUP BY asistio').data;
			data ||= [];
			var total:int;
			for (i = 0; i < data.length; i++) {
				if (data[i].asistio==true)
					asistencias_num.text = data[i].num;
				else
					inasistencias_num.text = data[i].num;
				total += data[i].num;
			}
			esperada_num.text = total.toString();
			
			data = GestionClientes.sql.sql(StringUtil.substitute('SELECT * FROM clases_asistencia WHERE fecha = "{0}"',DateUtil.dateToString(d,'YYYY-MM-DD'))).data;
			if (data) clases_num.text = data.length.toString();
						
			if (GestionClientes.config.morosos_en_pantalla) {
				if (!qm) {
					qm = new QuickMorosos;
					addElement(qm);
				}
			} else {
				if (qm && getChildByName(qm.name)) {
					removeElement(qm);
					qm=null;
				}
			}
		}
	}
}