package com
{
	import bootstrap.controls.FormItem;
	
	import spark.components.CheckBox;
	import spark.layouts.TileLayout;
	import spark.layouts.VerticalAlign;
	
	import vo.VOHorario;
	
	public class DayPicker extends FormItem
	{		
		private var _tipo:int=-1;
		
		public var separador:String=",";
		public var multipleSelection:Boolean=true;
		private var _layout:TileLayout;
		
		public function DayPicker() {
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			_layout = new TileLayout;
			_layout.verticalAlign = VerticalAlign.MIDDLE;
			layout = _layout;
			minHeight = 30;
		}
		
		[Inspectable(category="General", enumeration="0,1", defaultValue="0")]
		public function set tipo (value:int):void {
			if (_tipo!=value) {
				_tipo=value;
				removeAllElements();
				if (_tipo==0)
					buildSemana()
				else if (_tipo==1)
					buildMes();
				else
					reset();
			}
		}
		
		override public function reset():void {
			super.reset();
			removeAllElements();
			height = 30;
		}
		public function get dias():String {
			var c:CheckBox; var i:int; var d:Array = [];
			for (i = 0; i < numElements; i++) {
				c = getElementAt(i) as CheckBox;
				if (c.selected) d.push((i+_tipo));
			}
			return d.join(separador);
		}
		private function buildSemana():void {
			var c:CheckBox; var dia:String;
			for each (dia in VOHorario.DIAS_SEMANA) {
				c = new CheckBox;
				c.focusEnabled=false;
				c.label = dia;
				addElement(c);
			}
		}
		
		private function buildMes():void {
			var c:CheckBox; var i:int;
			for (i = 1; i < 32; i++) {
				c = new CheckBox;
				c.focusEnabled=false;
				c.label = i.toString();
				addElement(c);
			}
		}
		override protected function measure():void {
			height = 30*_layout.rowCount;
			super.measure();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			invalidateSize();
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
	}
}