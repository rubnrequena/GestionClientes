package com
{
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	import views.asistencias.AsistenciaRegistro;
	import views.asistencias.Asistencias;
	import views.clientes.BuscarCliente;
	import views.clientes.Cumpleanos;
	import views.clientes.Ingresos;
	import views.finanzas.NuevoPago;
	import views.horarios.HorarioNuevo;
	import views.horarios.Horarios;
	import views.organizacion.Grupos;

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