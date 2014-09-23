package bootstrap.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.HGroup;
	import spark.components.Spinner;
	import spark.components.TextInput;
	import spark.layouts.VerticalAlign;
	
	public class TimePicker extends HGroup
	{
		private var ampm:Array = ["AM","PM"];
		
		private var hourInput:DateStepper;
		private var minuteInput:DateStepper;
		private var dianocheInput:TextInput;
		private var apm:Spinner;

		private var now:Date;
		private var multiplier:Number;
		
		private var dianoche_value:int;
		
		public function TimePicker() {
			super();
			gap = -1;
			verticalAlign = VerticalAlign.MIDDLE;
		}
		override protected function createChildren():void {
			super.createChildren();
			
			now = new Date;			
			hourInput = new DateStepper(DateStepper.HOUR);			
			hourInput.percentWidth = 100;
			minuteInput = new DateStepper(DateStepper.MINUTE);
			minuteInput.percentWidth = 100;
			apm = new Spinner;
			dianocheInput = new TextInput;
			
			dianocheInput.widthInChars = 2;
			dianocheInput.editable=false;
			dianocheInput.height = 30;
			
			apm.tabFocusEnabled=false;
			apm.maximum=1;
			apm.minimum=0;
			apm.height = 30;
			
			dianoche_value = now.hours>12?1:0;
			hourInput.value = now.hours-(dianoche_value*12);
			minuteInput.value = now.minutes;
			
			addElement(hourInput);
			addElement(minuteInput);
			addElement(dianocheInput);
			addElement(apm);
			
			hourInput.addEventListener(DateStepper.TIME_REACHED,hourTimeReached);
			hourInput.addEventListener(DateStepper.DAY_CHANGED,dayChanged);
			minuteInput.addEventListener(DateStepper.TIME_REACHED,minuteTimeReached);
			apm.addEventListener(MouseEvent.CLICK,apm_click);
		}
		protected function apm_click (event:MouseEvent):void {
			dianoche_value = dianoche_value==0?1:0;
			invalidateProperties();
		}
		protected function dayChanged (event:Event):void {
			dianoche_value = dianoche_value==0?1:0;
			invalidateProperties();
		}
		protected function hourTimeReached (e:Event):void {
			minuteInput.setFocus();
		}
		protected function minuteTimeReached (e:Event):void {
			dianocheInput.setFocus();
		}
		override protected function commitProperties():void {
			super.commitProperties();			
			dianocheInput.text = ampm[dianoche_value];
		}
		public function get text():String {
			return [hourInput.text,minuteInput.text,ampm[dianoche_value]].join(":");
		}
		public function set text (value:String):void {
			var s:Array = value.split(":");
			if (s.length==3) {
				hourInput.value = int(s[0]);
				minuteInput.value = int(s[1]);
				dianoche_value = s[2]=="AM"?0:1;
			}
			invalidateProperties();
		}
		public function get time():int {
			return int([hourInput.value+(dianoche_value*12),minuteInput.text].join(""));
		}
	}
}