package bootstrap.controls
{
	import spark.components.HGroup;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import spark.components.HGroup;
	import spark.components.Spinner;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	import spark.layouts.VerticalAlign;
	
	public class DateStepper extends HGroup
	{
		public function DateStepper(type:int) {
			super();
			gap=-1;
			verticalAlign = VerticalAlign.MIDDLE;
			_type=type;
			minimum = type==HOUR?1:0;
			minChar = type==HOUR?1:6;
		}
		
		public static const TIME_REACHED:String = "timeReached";
		public static const DAY_CHANGED:String = "dayChanged";
		
		public static const HOUR:int=12;
		public static const MINUTE:int=60;
		
		private var input:TextInput;
		private var spin:Spinner;
		
		private var multiplier:int;	
		private var timeElapsed:int;
		
		private var _type:int;
		
		private var minimum:int=0;
		private var minChar:int;
		private var changePending:Boolean;
		
		private var _value:int;
		public function get value():int { return _value; }
		public function set value(value:int):void {
			_value = value;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			input = new TextInput;
			input.percentWidth = 100;
			input.restrict = "0-9";
			input.height = 30;
			
			spin = new Spinner;
			spin.maximum = Number.MAX_VALUE;
			spin.minimum = 0;
			spin.value = Number.MAX_VALUE*0.5;
			spin.height = 30;
			spin.tabFocusEnabled=false;
			
			addElement(input);
			addElement(spin);
			
			input.addEventListener(TextOperationEvent.CHANGE,timeReached);		
			spin.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		protected function onMouseWheel (event:MouseEvent):void {
			_value += event.delta>0?1:-1;
			invalidateProperties();
		}
		protected function timeReached(event:TextOperationEvent):void {
			_value = int(input.text);
			if (int(input.text)>minChar || input.text.length>1) {
				invalidateProperties();
				dispatchEvent(new Event(TIME_REACHED));
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void {
			changePending=true;
			multiplier = event.target==spin.incrementButton?1:-1;
			timeElapsed=getTimer();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);		
		}
		protected function onMouseUp (event:MouseEvent):void {
			if (changePending) {
				_value += multiplier;			
				invalidateProperties();
			}
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		protected function onEnterFrame (event:Event):void {
			if (getTimer()-timeElapsed>100) {
				changePending=false;
				timeElapsed=getTimer();
				_value += multiplier;			
				invalidateProperties();
			}
		}
		override protected function commitProperties():void {
			super.commitProperties();
			if (_value>_type) {
				_value=minimum;
				dispatchEvent(new Event(DAY_CHANGED));
			} else if (_value<minimum) {
				_value = _type;
				dispatchEvent(new Event(DAY_CHANGED));
			}
			input.text = trim(_value);
		}
		override public function setFocus():void {
			input.setFocus();
		}
		private function trim(n:int):String {
			return n<10?"0"+n:n.toString();
		}
		public function get text():String {
			return input.text;
		}
		public function dispose():void {
			input.removeEventListener(TextOperationEvent.CHANGE,timeReached);		
			spin.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
	}
}