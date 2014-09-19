package bootstrap.controls
{
	import mx.core.IVisualElement;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.layouts.HorizontalLayout;
	
	[DefaultProperty("items")]
	public class FormItem extends SkinnableContainer
	{
		// public static var DEFAULT_CHILD_HEIGHT:Number=30;
		
		private var _childHeight:Number=30;
		public function get childHeight():int { return _childHeight; }
		public function set childHeight(value:int):void { _childHeight = value; }
		
		protected var _nombre:String="";
		public function get label():String {
			return _nombre;
		}
		public function set label(value:String):void {
			_nombre = value;
		}
		
		protected var _items:Array;
		public function get items():Array { return _items; }
		public function set items(value:Array):void {
			_items = value;
		}

		protected var _label:Label;
		
		public var labelWidth:int = 25;

		private var _numElementos:int;

		public function get numElementos():int { return _numElementos; }

		public function FormItem() {
			super();
			percentWidth = 100;
		}
		override protected function createChildren():void {
			super.createChildren();
			styleName = "formItem "+styleName;
			
			_label = new Label;
			_label.percentWidth = labelWidth;
			_label.styleName = "formItem-label";
			_label.text = _nombre;
			addElement(_label);
			
			var i:int; _numElementos = _items?_items.length:0;
			for (i = 0; i < _numElementos; i++) {
				(_items[i] as IVisualElement).height = childHeight;
				addElement(_items[i] as IVisualElement);
			}
		}
	}
}