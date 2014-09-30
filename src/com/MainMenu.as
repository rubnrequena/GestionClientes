package com
{
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import org.osflash.signals.natives.NativeSignal;
	
	import vo.VOUsuario;

	public class MainMenu extends MainMenuUI
	{
		private var _click:NativeSignal;
		public var nav:ViewNavigatorHistory;
		public function MainMenu()
		{
			super();
			
			_click = new NativeSignal(this,MouseEvent.CLICK,MouseEvent);
			_click.add(onClick);
			
			VOUsuario.usuarioChange.add(usuarioUpdated);
		}
		private var temp:Vector.<IVisualElement>;
		private function usuarioUpdated(usuario:VOUsuario):void {
			if (usuario.acceso>0) {
				temp = new <IVisualElement> [
					removeItemAt(4),
					removeItemAt(1)
				];
			} else {
				if (temp) {
					addItemAt(temp.pop(),1);
					addItem(temp.pop());
					temp=null;
				}
			}
		}
		private function onClick(e:MouseEvent):void {
			if (e.target is MButton)
				nav.addView(e.target.name,e.target.view,null,true);
		}
	}
}