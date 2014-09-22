package com
{
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	import views.asistencias.Asistencia;
	import views.asistencias.Asistencias;
	import views.clientes.BuscarCliente;
	import views.clientes.Cumpleanos;
	import views.clientes.Ingresos;
	import views.organizacion.Grupos;
	import views.horarios.HorarioNuevo;
	import views.horarios.Horarios;
	import views.finanzas.NuevoPago;

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
			if (e.target is MButton) {
				GestionClientes.nav.addView(e.target.name,e.target.view);
			} else {
				switch(e.target.name) {
					case "grupos_nuevo" : {
						GestionClientes.nav.addView("nuevo_grupo",Grupos); break;
					}
					case "cliente_buscar": {
						GestionClientes.nav.addView("buscar_clientes",BuscarCliente); break;
					}
					case "asistencia_registrar": {
						GestionClientes.nav.addView("asistencia_registrar",Asistencia); break;
					}
					case "asistencias": {
						GestionClientes.nav.addView(e.target.name,Asistencias); break;
					}
					case "clientes_cumple": {
						GestionClientes.nav.addView(e.target.name,Cumpleanos); break;
					}
					case "cliente_ingresos": {
						GestionClientes.nav.addView(e.target.name,Ingresos); break;
					}
					case "horario_nuevo": {
						GestionClientes.nav.addView(e.target.name,HorarioNuevo); break;
					}
					case "horarios": {
						GestionClientes.nav.addView(e.target.name,Horarios); break;
					}
					case "pago_nuevo": {
						GestionClientes.nav.addView(e.target.name,NuevoPago); break;
					}
				}	
			}
		}
	}
}