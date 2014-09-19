package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOSalon;

	public class Salones
	{
		private var updateFlag:Boolean=true;
		
		protected var _data:Vector.<VOSalon>;
		public function get data():Vector.<VOSalon> {
			if (updateFlag) update();
			return _data;
		}

		public function Salones() { }
		
		public function insertar (salon:VOSalon):VOSalon {
			salon.salonID = GestionClientes.sql.insertar("salones",salon.toObject).lastInsertRowID;
			updateFlag=true;
			return salon;
		}
		public function remover (salonID:int):void {
			GestionClientes.sql.remover("salones",new <Value>[
				Value.fromPool("salonID",salonID)
			]);
			updateFlag=true;
		}
		public function byID (salonID:int):VOSalon {
			if (updateFlag) update();
			for (var i:int = 0; i < _data.length; i++) {
				if (_data[i].salonID==salonID) return _data[i];	
			}
			return null;
		}
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("salones",null,VOSalon).data,Vector.<VOSalon>);
			updateFlag=false;
		}
	}
}