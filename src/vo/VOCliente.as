package vo
{
	import sr.helpers.Value;
	import sr.modulo.MapObject;
	
	import utils.DateUtil;
	import utils.VectorUtil;
	

	public class VOCliente extends MapObject
	{
		public var clienteID:int;
		public var nombres:String;
		public var cedula:String;
		public var telefonos:String;
		public var direccion:String;
		public var fechaNacimiento:String;
		public var fechaRegistro:String;
		public var grupoID:int;
		public var meta:String;
		public var exonerado:Boolean;
		
		public function VOCliente() {
			super();
		}
		
		public function get fechaRegistroLocal():String {
			return DateUtil.toggleDate(fechaRegistro);
		}
		public function get fechaNacimientoLocal():String {
			return DateUtil.toggleDate(fechaNacimiento);
		}
		public function get edad():int {
			var anio:int = int(fechaNacimiento.split("-").shift());
			var now:Date = new Date;
			return now.fullYear-anio;
		}
		public function asistencias(num:int=-1):Vector.<VOAsistencia> {
			var a:Array = GestionClientes.sql.seleccionar("asistencias",new <Value>[
				Value.fromPool("clienteID",clienteID)
			],VOAsistencia,"*",'ORDER BY fechaIngreso DESC, horaIngreso DESC',num.toString()).data;
			return VectorUtil.toVector(a,Vector.<VOAsistencia>);
		}
		public function asistenciasDelMes(mes:int,anio:int):Vector.<VOAsistencia> {
			var m:String = mes<10?"0"+mes:mes.toString();
			return GestionClientes.asistencias.asistenciasClienteMes(clienteID,[anio,m].join("-"));
		}
		public function get horarios():Vector.<VOHorario> {
			return GestionClientes.horarios.byGrupo(grupoID);
		}
		public function pagos (num:int=-1):Vector.<VOPago> {
			var a:Array = GestionClientes.sql.seleccionar("pagos",new <Value>[
				Value.fromPool("clienteID",clienteID)
			],VOPago,"*",'ORDER BY fecha DESC',num.toString()).data;
			return VectorUtil.toVector(a,Vector.<VOPago>);
		}
		public function pagosPendientes():Vector.<VOPago> {
			return GestionClientes.pagos.pagosPendientes(clienteID);
		}
		public function facturas (num:int=-1):Vector.<VOFactura> {
			var a:Array = GestionClientes.sql.seleccionar("facturas",new <Value>[
				Value.fromPool("clienteID",clienteID)
			],VOFactura,"*",'ORDER BY fecha DESC',num.toString()).data;
			return VectorUtil.toVector(a,Vector.<VOFactura>);
		}
		public function get grupo():VOGrupo {
			return GestionClientes.grupos.byID(grupoID);
		}
		public function get grupoNombre():String {
			return grupo.nombre;
		}
		private var _queue:Vector.<Value>;
		public function update (campo:String,valor:*):void {
			if (this[campo]!=valor) {
				if (_queue)
					_queue.push(Value.fromPool(campo,valor));
				else
					_queue = new <Value>[Value.fromPool(campo,valor)];
			}
		}
		public function commitUpdate():void {
			if (!_queue) return;
			GestionClientes.sql.actualizar("clientes",_queue,new <Value>[
				Value.fromPool("clienteID",clienteID)
			]);
			for each (var v:Value in _queue) {
				this[v.campo] = v.valor;
			}
			_queue=null;
		}
		public function toString():String {
			return nombres;
		}
		override public function get toObject():Object {
			var o:Object = super.toObject;
			delete o.clienteID;
			return o;
		}
	}
}