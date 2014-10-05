package clases
{
	import sr.helpers.Value;
	
	import utils.VectorUtil;
	
	import vo.VOProducto;

	public class Productos
	{
		private var updateFlag:Boolean=true;
		private var _numProductos:uint;

		protected var _productos:Vector.<VOProducto>;
		public function get data():Vector.<VOProducto> {
			if (updateFlag) update();
			return _productos;
		}
		
		public function update():void {
			_productos = VectorUtil.toVector(GestionClientes.sql.seleccionar("productos",null,VOProducto).data,Vector.<VOProducto>);
			_numProductos = _productos.length;
			updateFlag=false;
		}
		
		public function insertar (producto:VOProducto):VOProducto {
			producto.productoID = GestionClientes.sql.insertar("productos",producto.toObject).lastInsertRowID;
			_productos.push(producto);
			return producto;
		}
		public function remover (productoID:int):void {
			GestionClientes.sql.remover("productos",new <Value>[
				Value.fromPool("productoID",productoID)
			]);
			updateFlag=true;
		}
		public function Productos() {
			
		}
	}
}