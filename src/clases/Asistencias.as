package clases
{
	import utils.VectorUtil;
	
	import vo.VOAsistencia;

	public class Asistencias
	{
		private var updateFlag:Boolean=true;
		
		private var _data:Vector.<VOAsistencia>;
		public function get data():Vector.<VOAsistencia> {
			if (updateFlag) update();
			return _data;
		}
		
		private function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("asistencias",null,VOAsistencia).data,Vector.<VOAsistencia>);
			updateFlag=false;
		}
		
		public function asistenciasClienteMes (clienteID:int,mes:String):Vector.<VOAsistencia> {
			if (updateFlag) update();
			var v:Vector.<VOAsistencia> = new Vector.<VOAsistencia>;
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].clienteID==clienteID) {
					if (_data[i].fechaIngreso.indexOf(mes)>-1) v.push(_data[i]);
				}
			}
			return v;
		}
		public static function ordenarDESC (item1:VOAsistencia,item2:VOAsistencia):Number {
			var d1:int = int(item1.fechaIngreso.split("-").join(""));
			var d2:int = int(item2.fechaIngreso.split("-").join(""));
			if (d1<d2) {
				if (item1.horaIngreso<item2.horaIngreso)
					return 1;
				else if (item1.horaIngreso>item2.horaIngreso)
					return -1
				else
					return 0;
			} else if (d1>d2) {
				if (item1.horaIngreso<item2.horaIngreso)
					return 1;
				else if (item1.horaIngreso>item2.horaIngreso)
					return -1
				else
					return 0;
			} else { 
				return 0;
			}
		}
		public static function format24(fecha:Date):int {
			var m:String = fecha.minutes<10?"0"+fecha.minutes:fecha.minutes.toString();
			return int(fecha.hours+m);
		}
		public function Asistencias()
		{
		}
	}
}