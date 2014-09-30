package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOClase;
	import vo.VOCliente;

	public class Clases
	{
		private var updateFlag:Boolean=true;
		
		protected var _data:Vector.<VOClase>;
		public function get data():Vector.<VOClase> {
			if (updateFlag) update();
			return _data;
		}
		public function Clases()
		{
		}
		
		public function insertar (clase:VOClase):VOClase {
			clase.claseID = GestionClientes.sql.insertar("clases",clase.toObject).lastInsertRowID;
			updateFlag=true;
			return clase;
		}
		public function remover (instructorID:int):void {
			GestionClientes.sql.remover("clases",new <Value>[
				Value.fromPool("claseID",instructorID)
			]);
			updateFlag=true;
		}
		public function byFecha (fecha:String):Vector.<VOClase> {
			return VectorUtil.toVector(GestionClientes.sql.seleccionar("clases",new <Value>[
				Value.fromPool("fecha",fecha)
			],VOClase).data,Vector.<VOClase>);
		}
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("clases",null,VOClase).data,Vector.<VOClase>);
			updateFlag=false;
		}
		public function entradaPermitida (fecha:Date,cliente:VOCliente):Boolean {
			/*if (updateFlag) update();
			
			var now:int = (fecha.hours*100)+fecha.minutes;
			var i:int; var x:int;
			for (i = 0; i < _data.length; i++) {
				if (_data[i].grupoID==cliente.grupoID) {
					x = _data[i].enRango(now);
					if (x==0) {
						var s:String = _data[i].tipo==0?fecha.day.toString():fecha.date.toString();
						x = _data[i].listDias.indexOf(s);
						if (x>-1) return true;
					}
				}
			}*/
			return false;
		}
	}
}