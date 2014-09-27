package clases.imprimir
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeStyle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.utils.ObjectUtil;
	
	import spark.formatters.DateTimeFormatter;
	
	public class Print
	{
		public static var PRINT_META:Boolean=false;
		
		private var _paginas:Vector.<Sprite>;
		private var _currentPage:Sprite;
		private var _job:PrintJob;
		
		private var _defaultFormat:TextFormat;

		public function set defaultFormat(value:TextFormat):void {
			_defaultFormat = value;
		}

		private var _text:TextField;
		
		private var _cy:int;
		private const BOTTOM_MARGIN:Number=30;
		private const TOP_MARGIN:Number=20;
		
		private var _printableArea:Rectangle;

		private var _headerFormat:TextFormat;
		public function set headerFormat(value:TextFormat):void {
			_headerFormat = value;
		}

		public function get printableArea():Rectangle { return _printableArea; }
		public function set printableArea(value:Rectangle):void {
			_printableArea = value;
		}

		public function Print(job:PrintJob) {
			_job = job;
			_paginas = new <Sprite>[];
			_defaultFormat = new TextFormat();
			_headerFormat = new TextFormat();
			_headerFormat.bold = true;
			_printableArea = job.printableArea;
			newPage();
		}
		public function printAll(bitmap:Boolean=false):void {
			var i:int; var o:PrintJobOptions = new PrintJobOptions(bitmap);
			var df:DateTimeFormatter = new DateTimeFormatter;
			df.setStyle("locale","es_VE");
			df.dateStyle = DateTimeStyle.MEDIUM;
			df.timeStyle = DateTimeStyle.LONG;
			
			for (i = 0; i < _paginas.length; i++) {
				_currentPage = _paginas[i];
				if (PRINT_META) addTextAt("Página: "+(i+1)+" - "+_paginas.length+", "+df.format(new Date)+", sistemasrequena.com",5,0,printableArea.width);
				_job.addPage(_paginas[i],null,o);
			}
			_job.send();
		}
		public function pringPage(page:uint=1,bitmap:Boolean=false):void {
			var o:PrintJobOptions = new PrintJobOptions(bitmap);
			_job.addPage(_paginas[page],null,o);
			_job.send();
		}
		public function newPage():void {
			_currentPage = new Sprite;
			_cy=TOP_MARGIN;
			_paginas.push(_currentPage);
		}
		public function addDataGrid (data:*,columnas:Vector.<PrintColumn>,offset:int=0):void {
			var i:int; var j:int; var cx:int=0; var cy:int=0;
			var anchoDisponible:int=printableArea.width;
			//CLONAR COLUMNAS
			var columns:Vector.<PrintColumn> = new <PrintColumn>[];
			for (i = 0; i < columnas.length; i++) {
				if (columnas[i].active) { columns.push(columnas[i].clone); }
			}
			
			for (i = 0; i < columns.length; i++) {
				if (columns[i].width>0) {
					anchoDisponible -= columns[i].width;
				} else {
					cy++;
				}
			}
			j = anchoDisponible/cy;
			//trace(printableArea.width,anchoDisponible,(printableArea.width-anchoDisponible),columns.length);
			for (i = 0; i < columns.length; i++) {
				if (columns[i].width==0) {
					columns[i].width = j;
				}
				cx += columns[i].width;
			}
			cy=_cy; cx=0;
			var h:int;
			_currentPage.graphics.beginFill(0,1);
			_currentPage.graphics.lineStyle(0,0x454545,1);
			for (i = 0; i < columns.length; i++) {
				addTextAt(columns[i].header,cx,cy,columns[i].width,_headerFormat);
				cx += _text.width; h = _text.textHeight>h?_text.textHeight:h; // medir desplazamiento de cursor
			}
			cy+=h;
			_currentPage.graphics.moveTo(0,cy+2); 
			_currentPage.graphics.lineTo(printableArea.width,cy+2);
			for (i = offset; i < data.length; i++) {
				if (cy>printableArea.height-BOTTOM_MARGIN) {
					newPage();
					addDataGrid(data,columns,i);
					return;
				}
				cx=0; h=0; //nueva linea
				for (j = 0; j < columns.length; j++) {
					addTextAt(data[i][columns[j].field],cx,cy,columns[j].width,columns[j].format); //insertar texto
					cx += columns[j].width; h = _text.textHeight>h?_text.textHeight:h; // medir desplazamiento de cursor
				}
				cy+=h; // desplazar cursor
				_currentPage.graphics.moveTo(0,cy+2); 
				_currentPage.graphics.lineTo(printableArea.width,cy+2);
				_currentPage.graphics.endFill();
			}
			_cy = cy;
		}
		public function addTextAt(htmlText:String,x:int,y:int,width:int=0,format:TextFormat=null):TextField {
			_text = new TextField;
			_text.defaultTextFormat = format?format:_defaultFormat;
			_text.width = width>0?width:_text.textWidth;
			_text.wordWrap = true;
			_text.x = x; _text.y = y;
			_text.htmlText = htmlText?htmlText:"";
			_currentPage.addChild(_text);
			return _text;
		}
		/**
		 * 
		 * @param htmlText text to print
		 * @param format TextFormat
		 * @param eol Insert End Of Line \n
		 * @return TextField
		 * 
		 */		
		public function addLine (htmlText:String,format:TextFormat=null,eol:Boolean=true):TextField {
			_text = new TextField;
			_text.defaultTextFormat = format?format:_defaultFormat;
			_text.width = printableArea.width;
			_text.y = _cy; _text.x = 0;
			_text.htmlText = htmlText?htmlText:"";
			_currentPage.addChild(_text);
			if (eol) _cy += _text.textHeight;
			return _text;
		}
		public function addSpace (space:int):void {
			_cy += space;
		}
	}
}