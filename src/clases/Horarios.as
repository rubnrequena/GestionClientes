package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOCliente;
	import vo.VOHorario;

	public class Horarios
	{
		private var changedFlag:Boolean=true;
		private var horarios:Vector.<VOHorario>;
		private var numHorarios:int;
		
		public function Horarios() {
			
		}
		
		private function updateHorarios():void {
			horarios = VectorUtil.toVector(GestionClientes.sql.sql('SELECT * FROM horarios',VOHorario).data,Vector.<VOHorario>);
			numHorarios = horarios.length;
			changedFlag=false;
		}
		
		public function insertar (horario:VOHorario):VOHorario {
			horario.horarioID = GestionClientes.sql.insertar("horarios",horario.toObject).lastInsertRowID;
			changedFlag=true;
			return horario;
		}
		public function remover (horarioID:int):void {
			GestionClientes.sql.remover("horarios",new <Value>[
				Value.fromPool("horarioID",horarioID)
			]);
		}
		public function byGrupo (grupoID:int):Vector.<VOHorario> {
			var data:Array = GestionClientes.sql.sql('SELECT * FROM horarios WHERE grupo = '+grupoID,VOHorario).data;
			return VectorUtil.toVector(data,Vector.<VOHorario>);
		}
		public function entradaPermitida (fecha:Date,cliente:VOCliente):Boolean {
			if (changedFlag) updateHorarios();
			
			var now:int = (fecha.hours*100)+fecha.minutes;
			var i:int; var x:int;
			for (i = 0; i < numHorarios; i++) {
				if (horarios[i].grupo==cliente.grupoID) {
					x = horarios[i].enRango(now);
					if (x==0) {
						var s:String = horarios[i].tipo==0?fecha.day.toString():fecha.date.toString();
						x = horarios[i].listDias.indexOf(s);
						if (x>-1) return true;
					}
				}
			}
			return false;
		}
	}
}