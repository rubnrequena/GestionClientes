package bootstrap.controls
{
	import spark.components.supportClasses.SkinnableTextBase;

	public class FormInput extends FormItem
	{
		public function FormInput() {
			super();
		}
		
		override public function set mxmlContent(value:Array):void {
			super.mxmlContent = value;
			var i:int; var l:int = value?value.length:0;
			for (i = 1; i < l; i++)
				value[i].percentWidth=50;
		}
	}
}