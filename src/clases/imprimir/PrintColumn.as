package clases.imprimir
{
	import flash.text.TextFormat;

	public class PrintColumn
	{
		public var field:String;
		public var width:int;
		public var header:String;
		public var active:Boolean;
		public var format:TextFormat;
		
		public function PrintColumn(field:String,width:int,header:String="",format:TextFormat=null,active:Boolean=true) {
			this.field = field;
			this.width = width;
			this.header = header;
			this.active = active;
			this.format = format;
		}
		
		public function get clone():PrintColumn {
			return new PrintColumn(field,width,header,format,active);
		}
	}
}