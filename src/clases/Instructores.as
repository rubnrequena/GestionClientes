package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOInstructor;

	public class Instructores
	{
		private var updateFlag:Boolean=true;
		
		private var _data:Vector.<VOInstructor>;

		public function get data():Vector.<VOInstructor> {
			if (updateFlag) update();
			return _data;
		}
		
		private function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("instructores",null,VOInstructor).data,Vector.<VOInstructor>);
			updateFlag=false;
		}
		public function insertar (instructor:VOInstructor):VOInstructor {
			instructor.instructorID = GestionClientes.sql.insertar("instructores",instructor.toObject).lastInsertRowID;
			updateFlag=true;
			return instructor;
		}
		public function byID (instructorID:int):VOInstructor {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].instructorID==instructorID) return _data[i];	
			}
			return null;
		}
		public function remover (instructorID:int):void {
			GestionClientes.sql.remover("instructores",new <Value>[
				Value.fromPool("instructorID",instructorID)
			]);
			updateFlag=true;
		}
		public function Instructores()
		{
		}
	}
}