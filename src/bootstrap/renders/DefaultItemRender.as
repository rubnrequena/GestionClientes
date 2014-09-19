package bootstrap.renders
{
	import spark.skins.spark.DefaultItemRenderer;
	
	public class DefaultItemRender extends DefaultItemRenderer
	{
		public function DefaultItemRender()
		{
			super();
			mouseChildren=false;
		}
	}
}