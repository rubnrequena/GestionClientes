package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOAsistencia;
	import vo.VOHorario;
	import vo.VOUsuario;
	
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
		public function insertar_lote (asistencias:Array):void {
			GestionClientes.sql.insertarUnion("asistencias",asistencias);
			updateFlag=true;
		}
		public function actualizar (asistenciaID:int,entrada:int):void {
			GestionClientes.sql.actualizar("asistencias",new <Value>[
				Value.fromPool("horaIngreso",entrada),
				Value.fromPool("asistio",true),
				Value.fromPool("usuarioID",VOUsuario.USUARIO_ACTIVO)
			],new <Value>[
				Value.fromPool("asistenciaID",asistenciaID)
			]);
			updateFlag=true;
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
		public function byIndice (indice:int):VOAsistencia {
			return _data[indice];
		}
		public function asistenciaPrevia (clienteID:int,fecha:String):Boolean {
			if (updateFlag) update();
			return _data.some(function (asistencia:VOAsistencia,indice:int,data:*):Boolean {
				return asistencia.clienteID==clienteID && asistencia.fechaIngreso==fecha;
			})
		}
		public function registrarAsistencia (clienteID:int,fecha:String,entrada:int):int {
			if (updateFlag) update();
			var ret:int = VOAsistencia.RECHAZADA_HORARIO_INVALIDO;
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].fechaIngreso==fecha && _data[i].clienteID==clienteID) {
					if (_data[i].enRango(entrada)) {
						if (_data[i].asistio==false) {
							return _data[i].asistenciaID;	
						} else {
							ret = VOAsistencia.RECHAZADA_ASISTENCIA_PREVIA;
						}
					} else {
						ret = VOAsistencia.RECHAZADA_HORARIO_INVALIDO;
					}
				}
			}
			return ret;
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