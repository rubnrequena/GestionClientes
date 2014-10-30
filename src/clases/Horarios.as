package clases
{
	import sr.helpers.Value;
	
	import utils.DateUtil;
	import utils.VectorUtil;
	
	import vo.VOAsistencia;
	import vo.VOClase;
	import vo.VOClaseAsistencia;
	import vo.VOCliente;
	import vo.VOGrupo;
	import vo.VOHorario;
	import vo.VOUsuario;

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
		
		public function horariosDelDia (hoy:Date):Vector.<VOHorario> {
			if (updateFlag) update();
			var _horarios:Vector.<VOHorario> = new Vector.<VOHorario>;
			var time:int = int(DateUtil.dateToString(hoy,"HHnn"));
			
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].enRango(time)) {
					if (_data[i].tipo==0) {
						if (_data[i].listDias.indexOf(hoy.day)>-1)
							_horarios.push(_data[i]);
					} else if (_data[i].tipo==1) {
						if (_data[i].listDias.indexOf(hoy.date)>-1)
							_horarios.push(_data[i]);
					}
				}
			}	
			return _horarios;
		}
		public function registro_programado():void {
			if (updateFlag) update();
			var hoy:Date = new Date;
			var _horarios:Vector.<VOHorario> = new Vector.<VOHorario>;
			var time:int = int(DateUtil.dateToString(hoy,"HHnn"));
			var i:int;
			
			for (i = 0; i < _data.length; i++) {
				if (_data[i].clase.auto_registro && _data[i].enRango(time)) {
					if (_data[i].tipo==0) {
						if (_data[i].listDias.indexOf(hoy.day)>-1)
							_horarios.push(_data[i]);
					} else if (_data[i].tipo==1) {
						if (_data[i].listDias.indexOf(hoy.date)>-1)
							_horarios.push(_data[i]);
					}
				}
			}
			var hoyString:String = DateUtil.dateToString(hoy,"YYYY-MM-DD");			
			var clase:VOClaseAsistencia = new VOClaseAsistencia;
			for (i = 0; i < _horarios.length; i++) {
				if (ClasesAsistencia.instancia.existe(_horarios[i].claseID,hoyString)==false) {
					clase.fecha = hoyString;
					clase.usuarioID = VOUsuario.USUARIO_ACTIVO;
					clase.claseID = _horarios[i].claseID;
					asistencias_clientes(_horarios[i].clase);
					ClasesAsistencia.instancia.insertar(clase);
				}
			}
		}
		private function asistencias_clientes (clase:VOClase):void {
			var clientes:Vector.<VOCliente> = clase.clientes;
			if (clientes.length==0)
				return;
			
			var asistencias:Array = new Array(clientes.length);
			var asistencia:VOAsistencia;
			var ahora:Date = new Date;
			for (var i:int = 0; i < clientes.length; i++) {
				asistencia = new VOAsistencia;
				asistencia.clienteID = clientes[i].clienteID;
				asistencia.grupoID = clientes[i].grupoID;
				asistencia.claseID = clase.claseID;
				asistencia.salonID = clase.salonID;
				asistencia.usuarioID = VOUsuario.USUARIO_ACTIVO;
				
				var horarios:Vector.<VOHorario> = clase.horarios;
				
				if (horarios.length==1) {
					asistencia.entrada = horarios[0].entrada;  
					asistencia.salida = horarios[0].salida;
				} else {
					for (var j:int = 0; j < horarios.length; j++) {
						if (horarios[j].tipo==VOHorario.TIPO_SEMANAL) {
							if (horarios[j].listDias.indexOf(ahora.day)>-1) {
								asistencia.entrada = horarios[j].entrada; 
								asistencia.salida = horarios[j].salida;
							}
						} else if (horarios[j].tipo==VOHorario.TIPO_MENSUAL) {
							if (horarios[j].listDias.indexOf(ahora.date)>-1) {
								asistencia.entrada = horarios[j].entrada; 
								asistencia.salida = horarios[j].salida;
							}
						}
					}
				}
				asistencia.asistio = false;
				asistencia.horaIngreso = int(DateUtil.dateToString(ahora,"HHnn"));
				asistencia.fechaIngreso = DateUtil.dateToString(ahora,"YYYY-MM-DD");
				asistencias[i] = asistencia.toObject;
			}
			GestionClientes.asistencias.insertar_lote(asistencias);
		}
	}
}