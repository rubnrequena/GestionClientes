package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOGrupo;

	public class Grupos
	{
		private var updateFlag:Boolean;
		
		private var _data:Vector.<VOGrupo>;
		public function get data():Vector.<VOGrupo> {
			if (updateFlag) commitData();
			return _data;
		}				
		public function Grupos() {
			updateFlag=true;
		}
		public function insertar (grupo:VOGrupo):VOGrupo {
			grupo.grupoID = GestionClientes.sql.insertar("grupos",grupo.toObject).lastInsertRowID;
			_data.push(grupo);
			return grupo;
		}
		protected function commitData():void {
			_data = VectorUtil.toVector(GestionClientes.sql.sql('SELECT * FROM grupos',VOGrupo).data,Vector.<VOGrupo>);
			updateFlag=false;
		}
		public function byID (grupoID:int):VOGrupo {
			if (updateFlag) commitData();
			var i:int;
			for (i = 0; i < _data.length; i++) {
				if (grupoID==_data[i].grupoID) return _data[i];	
			}
			return null;
		}
		public function remover (grupoID:int):void {
			GestionClientes.sql.remover("grupos",new <Value>[
				Value.fromPool("grupoID",grupoID)
			]);
			updateFlag=true;
		}
		public function grupoIndex (grupoID:int):int {
			var i:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].grupoID==grupoID) return i;	
			}
			return -1;
		}
	}
}