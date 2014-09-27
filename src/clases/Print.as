package clases
{
	import Print.Page;
	
	import PrintGUI.GridColumn;
	
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import utils.DateUtil;
	import utils.VectorUtil;
	
	import vo.VOFactura;
	
	public class Print
	{
		private static var formatRight:TextFormat;
		private static var formatHeader:TextFormat;
		
		private static var formatsInitialized:Boolean;
		public function Print() {
			
		}
		
		public static function imprimirFactura (factura:VOFactura,copia:Boolean=false):void {
			if (!formatsInitialized) initializeFormats();
			
			var pj:PrintJob = new PrintJob;
			var now:Date = new Date;
			var page:Page;
			if (pj.start()) {
				var anchoPagina:Number = GestionClientes.config.anchoPapel>0?GestionClientes.config.anchoPapel:pj.printableArea.width;
				var rect:Rectangle = new Rectangle(pj.printableArea.x,pj.printableArea.y,anchoPagina,pj.printableArea.height); 
				page = new Page(rect);
				page.defaultGridLineStyle(1,0xffffff,1);
				page.pushLine(GestionClientes.config.razon_social,TextAlign.CENTER);
				page.pushLine(GestionClientes.config.rif,TextAlign.CENTER);
				page.pushLine(DateUtil.dateToString(now,"DD/MM/YYYY"),TextAlign.CENTER);
				page.pushLine(DateUtil.dateToString(now,"hh:nn:ss a"),TextAlign.CENTER);
				page.pushLine("--- COPIA ---",TextAlign.CENTER);
				page.pushLine("Factura",TextAlign.CENTER);
				page.pushLine(factura.correlativoString,TextAlign.CENTER);
				
				page.pushLine("Cliente: "+factura.cliente.nombres);
				page.pushLine("Fecha: "+factura.fechaLocal);
				page.pushWhiteSpace(10);
				page.pushLine("DETALLES",TextAlign.CENTER);
				page.pushWhiteSpace(10);
				
				page.addGrid(VectorUtil.toArray(factura.pagos),new <GridColumn>[
					new GridColumn("Descripcion","descripcion",65),
					new GridColumn("Cant","cantidad",15,formatRight),
					new GridColumn("Monto","monto",20,formatRight)
				],true,formatHeader);
				
				pj.addPage(page);
				pj.send();
			}
		}
		
		private static function initializeFormats():void {
			formatRight = new TextFormat();
			formatRight.align = TextAlign.RIGHT;
			
			formatHeader = new TextFormat();
			formatHeader.bold = true;
			
			formatsInitialized=true;
		}
	}
}