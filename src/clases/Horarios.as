package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOClase;
	import vo.VOCliente;
	import vo.VOHorario;

	public class Horarios
	{
		private var updateFlag:Boolean=true;

		private var _data:Vector.<VOHorario>;
		public function get horarios():Vector.<VOHorario> {
			if (updateFlag) update();
			return _data;
		}
		
		public function Horarios() {
			
		}
		
		private function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.sql('SELECT * FROM horarios',VOHorario).data,Vector.<VOHorario>);
			updateFlag=false;
		}
		
		public function insertar (horario:VOHorario):VOHorario {
			if (updateFlag) update();
			horario.horarioID = GestionClientes.sql.insertar("horarios",horario.toObject).lastInsertRowID;
			_data.push(horario);
			return horario;
		}
		public function remover (horarioID:int):void {
			GestionClientes.sql.remover("horarios",new <Value>[
				Value.fromPool("horarioID",horarioID)
			]);
			updateFlag=true;
		}
		public function byClase (claseID:int):Vector.<VOHorario> {
			if (updateFlag) update();
			return _data.filter(function (clase:VOHorario,index:int,data:*):Boolean {
				return clase.claseID==this;
			},claseID);
		}
		
		public function byGrupo (grupoID:int):Vector.<VOHorario> {
			if (updateFlag) update();
			return _data.filter(function (clase:VOHorario,index:int,data:*):Boolean {
				return clase.grupoID==this;
			},grupoID);
		}
	}
}