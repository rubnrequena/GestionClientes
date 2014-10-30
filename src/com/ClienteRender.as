package com
{
	import bootstrap.renders.DefaultItem;
	
	import spark.layouts.HorizontalLayout;
	
	public class ClienteRender extends DefaultItem
	{
		public function ClienteRender()
		{
			super();
			var hl:HorizontalLayout = new HorizontalLayout;
			hl.paddingLeft = hl.paddingRight = 5;
			layout = hl;
			
			columnas = [
				{name:"nombres",percentWidth:100},
				{name:"cedula",width:100}
			];
		}
	}
}