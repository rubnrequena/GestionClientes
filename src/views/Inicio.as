package views
{
	import flash.events.Event;

	public class Inicio extends InicioUI
	{
		public function Inicio()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void {
			if (initialized)
				childrenCreated();
		}
		override protected function childrenCreated():void {
			var d:Date = new Date;
			numClientes.text = GestionClientes.clientes.clientes.length.toString();
			var i:int = GestionClientes.clientes.cumpleaneros(d.month+1).length;
			numCumpleanos.text = i.toString();
		}
	}
}