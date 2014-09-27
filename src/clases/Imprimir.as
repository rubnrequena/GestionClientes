package clases
{
	import clases.imprimir.Print;
	import clases.imprimir.PrintColumn;
	
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import utils.DateUtil;
	
	import vo.VOFactura;
	
	public class Imprimir
	{
		private static var formatRight:TextFormat;
		private static var formatCenter:TextFormat;
		private static var formatHeader:TextFormat;
		
		private static var formatsInitialized:Boolean;
		private static var defaultFormat:TextFormat;
		public function Imprimir() {
			
		}
		public static function imprimirFactura (factura:VOFactura,copia:Boolean=false):void {
			if (!formatsInitialized) initializeFormats();
			
			var pj:PrintJob = new PrintJob;
			var print:Print;
			var now:Date=new Date;
			if (pj.start()) {
				print = new Print(pj);
				print.defaultFormat = defaultFormat;
				print.headerFormat = formatHeader;
				
				print.printableArea = new Rectangle(0,0,GestionClientes.config.anchoPapel,pj.printableArea.height);
				print.addLine(GestionClientes.config.razon_social,formatCenter);
				print.addLine(GestionClientes.config.rif,formatCenter);
				print.addLine(DateUtil.dateToString(now,"DD/MM/YYYY"),formatCenter);
				print.addLine(DateUtil.dateToString(now,"hh:nn:ss a"),formatCenter);
				if (copia) print.addLine("--- COPIA ---",formatCenter);
				print.addLine("Factura",formatCenter);
				print.addLine(factura.correlativoString,formatCenter);
				print.addSpace(10);
				print.addLine("Cliente: "+factura.cliente.nombres);
				print.addLine("Fecha: "+factura.fechaLocal);
				print.addSpace(10);
				print.addLine("DETALLES",formatCenter);
				print.addSpace(10);
								
				print.addDataGrid(factura.pagos,new <PrintColumn>[
					new PrintColumn("descripcion",percentWidth(65,GestionClientes.config.anchoPapel),"Descripcion"),
					new PrintColumn("cantidad",percentWidth(15,GestionClientes.config.anchoPapel),"Cant",formatRight),
					new PrintColumn("total",percentWidth(20,GestionClientes.config.anchoPapel),"Total",formatRight)
				]);
				print.addSpace(5);
				formatHeader.align = TextAlign.LEFT;
				print.addLine("TOTAL:",formatHeader,false);
				formatHeader.align = TextAlign.RIGHT;
				print.addLine(factura.monto.toString(),formatHeader);
				formatHeader.align = TextAlign.CENTER;
				print.printAll();
			}
		}
		private static function percentWidth (percent:Number,fullWidth:Number):Number {
			return (percent*fullWidth)*0.01;
		}
		
		private static function initializeFormats():void {
			formatRight = new TextFormat();
			formatRight.align = TextAlign.RIGHT;
			formatRight.font = "Verdana";
			
			defaultFormat = new TextFormat;
			defaultFormat.font = "Verdana";			
			
			formatCenter = new TextFormat;
			formatCenter.align = TextAlign.CENTER;
			formatCenter.font = "Verdana";
			
			formatHeader = new TextFormat();
			formatHeader.bold = true;
			formatHeader.align = TextAlign.CENTER;
			formatHeader.font = "Verdana";
			
			formatsInitialized=true;
		}
	}
}