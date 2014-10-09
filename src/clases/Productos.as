package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOProducto;

	public class Productos
	{
		private var updateFlag:Boolean=true;
		private var _numProductos:uint;

		protected var _data:Vector.<VOProducto>;
		public function get data():Vector.<VOProducto> {
			if (updateFlag) update();
			return _data;
		}
		
		public function update():void {
			_data = VectorUtil.toVector(GestionClientes.sql.seleccionar("productos",null,VOProducto).data,Vector.<VOProducto>);
			_numProductos = _data.length;
			updateFlag=false;
		}
		
		public function insertar (producto:VOProducto):VOProducto {
			producto.productoID = GestionClientes.sql.insertar("productos",producto.toObject).lastInsertRowID;
			_data.push(producto);
			return producto;
		}
		public function remover (productoID:int):void {
			GestionClientes.sql.remover("productos",new <Value>[
				Value.fromPool("productoID",productoID)
			]);
			updateFlag=true;
		}
		public function byID (productoID:int):VOProducto {
			for (var i:int = 0; i < data.length; i++)
				if (_data[i].productoID==productoID) return _data[i];
			return null;
		}
		public function byDescripcion (descripcion:String):VOProducto {
			for (var i:int = 0; i < data.length; i++)
				if (_data[i].descripcion==descripcion) return _data[i];
			return null;
		}
		public function Productos() {
			
		}
	}
}