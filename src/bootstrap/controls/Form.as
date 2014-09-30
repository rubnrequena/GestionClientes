package bootstrap.controls
{
	import spark.components.Form;
	
	public class Form extends spark.components.Form
	{
		public function Form() {
			super();
		}
		
		public function get validate():Boolean {
			var valid:Boolean=true;
			for (var i:int=0, item:FormItem; i < numElements; i++) {
				item = getElementAt(i) as FormItem;
				if (item && item.validateFunction!=null) {
						if (item.validateFunction.call(null,item)==false) {
							valid = false;
							item.styleName = "well-danger";
						} else {
							item.styleName = "well-default";
						}
				}
			}
			return valid;
		}
		public function reset():void {
			for (var i:int, item:FormItem, total:int=numElements; i < total; i++) {
				item = getElementAt(i) as FormItem;
				if (item) item.styleName = "well-default";
			}
		}
	}
}