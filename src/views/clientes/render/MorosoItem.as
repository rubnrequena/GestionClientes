package views.clientes.render
{
	import bootstrap.renders.DefaultItem;
	
	public class MorosoItem extends DefaultItem
	{
		public function MorosoItem()
		{
			super();
			columnas = [
				{name:"nombres"},
				{name:"monto"},
				{name:"fecha"},
			];
		}
	}
}