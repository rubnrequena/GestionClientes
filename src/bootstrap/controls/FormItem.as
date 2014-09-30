package bootstrap.controls
{
	import interfaces.IListPicker;
	
	import mx.core.IVisualElement;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableTextBase;
	
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
		
		protected var _label:Label;		
		public var labelWidth:int = 25;

		private var _numElementos:int;
		public function get numElementos():int { return _numElementos; }		
		
		public function FormItem() {
			super();
			percentWidth = 100;
			styleName = "formItem "+styleName;
		}
		override public function set styleName(value:Object):void {
			super.styleName = value is String?"formItem "+value:value;
		}
		override public function set mxmlContent(value:Array):void {
			var i:int; _numElementos = value?value.length:0;
			if (_numElementos==1)
				value[0].percentWidth = 50;
			
			for (i = 0; i < _numElementos; i++) 
				(value[i] as IVisualElement).height = childHeight;
			
			_label = new Label;
			_label.percentWidth = labelWidth;
			_label.styleName = "formItem-label";
			_label.text = _nombre;
			
			value.unshift(_label);
			super.mxmlContent = value;			
		}
		
		public var validateFunction:Function;
		
		public function get input ():SkinnableTextBase {
			for (var i:int = 1, item:SkinnableTextBase; i < _numElementos+1; i++)  {
				item = getElementAt(i) as SkinnableTextBase;
				if (item) return item;
			}			
			return null;
		}
		public function get picker():IListPicker {
			for (var i:int = 1, item:IListPicker; i < _numElementos+1; i++)  {
				item = getElementAt(i) as IListPicker;
				if (item) return item;
			}			
			return null;
		}
	}
}