package com
{
	import bootstrap.controls.FormItem;
	
	import spark.components.CheckBox;
	import spark.components.TileGroup;
	
	import vo.VOHorario;
	
	public class DayPicker extends FormItem
	{
		protected var _groupDays:TileGroup = new TileGroup;
		
		private var _tipo:int=-1;
		
		public var separador:String=",";
		public var multipleSelection:Boolean=true;
		
		public function DayPicker() {
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			_groupDays.paddingTop = 5;
			addElement(_groupDays);
		}
		
		[Inspectable(category="General", enumeration="0,1", defaultValue="0")]
		public function set tipo (value:int):void {
			if (_tipo!=value) {
				_tipo=value;
				_groupDays.removeAllElements();
				if (value==1)
					buildMes();
				else if (value==0)
					buildSemana();
				else
					reset();
			}
		}
		
		override public function reset():void {
			super.reset();
			_groupDays.removeAllElements();
			height = 30;
		}
		public function get dias():String {
			var c:CheckBox; var i:int; var d:Array = [];
			for (i = 0; i < _groupDays.numElements; i++) {
				c = _groupDays.getElementAt(i) as CheckBox;
				if (c.selected) d.push((i+_tipo));
			}
			return d.join(separador);
		}
		private function buildSemana():void {
			var c:CheckBox; var dia:String;
			for each (dia in VOHorario.DIAS_SEMANA) {
				c = new CheckBox;
				c.label = dia;
				_groupDays.addElement(c);
			}
			height = _groupDays.height = 50;
		}
		
		private function buildMes():void {
			var c:CheckBox; var i:int;
			for (i = 1; i < 32; i++) {
				c = new CheckBox;
				c.label = i.toString();
				_groupDays.addElement(c);
			}			
			height = _groupDays.height = 100;
		}
	}
}