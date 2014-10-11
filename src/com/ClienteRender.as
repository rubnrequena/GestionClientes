package com
{
	import bootstrap.renders.DefaultItem;
	
	public class ClienteRender extends DefaultItem
	{
		public function ClienteRender()
		{
			super();
			columnas = [
				{name:"nombres",percentWidth:100},
				{name:"cedula",width:100}
			];
		}
	}
}