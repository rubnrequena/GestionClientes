package bootstrap.controls
{
	import spark.components.supportClasses.SkinnableTextBase;

	public class FormInput extends FormItem
	{
		public function FormInput() {
			super();
		}
		override protected function createChildren():void {
			super.createChildren();
			
			var i:int; var l:int = _items?_items.length:0;
			for (i = 0; i < l; i++) {
				_items[i].percentWidth=50;
				_items[i].height=childHeight;
			}
		}
		
		public function get input():SkinnableTextBase {
			return _items[0] as SkinnableTextBase;
		}
		public function set restrict (value:String):void {
			_items[0].restrict = value;
		}
	}
}