/*Singleton*/
package clases
{
	import utils.VectorUtil;
	import vo.VOClaseAsistencia;

	public class ClasesAsistencia
	{

		private static var _instancia:ClasesAsistencia;
		public static function get instancia():ClasesAsistencia {
			if (!_instancia) _instancia = new ClasesAsistencia;
			return _instancia;
		}
		
		private var updateFlag:Boolean=true;
		
		private var _data:Vector.<VOClaseAsistencia>;
		public function get data():Vector.<VOClaseAsistencia> {
			if (updateFlag) update();
			return _data;
		}

		public function ClasesAsistencia() {
					
		}
		
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("clases_asistencia",null,VOClaseAsistencia).data,Vector.<VOClaseAsistencia>);
			updateFlag=false;
		}
		
		public function insertar (clase:VOClaseAsistencia):VOClaseAsistencia {
			if (updateFlag) update();
			clase.ID = GestionClientes.sql.insertar("clases_asistencia",clase.toObjectExcluding(["ID"])).lastInsertRowID;
			_data.push(clase);
			return clase;
		}
		public function existe (claseID:int,fecha:String):Boolean {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].fecha==fecha) {
					if (_data[i].claseID==claseID) return true;
				}
			}
			return false;
		}
	}
}