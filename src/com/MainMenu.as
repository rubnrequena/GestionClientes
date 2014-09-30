package com
{
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;

	public class MainMenu extends MainMenuUI
	{
		private var _click:NativeSignal;
		public function MainMenu()
		{
			super();
			
			_click = new NativeSignal(this,MouseEvent.CLICK,MouseEvent);
			_click.add(onClick);
		}
		private function onClick(e:MouseEvent):void {
			if (e.target is MButton)
				GestionClientes.nav.addView(e.target.name,e.target.view,null,true);
		}
	}
}