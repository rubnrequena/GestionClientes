package views.clientes
{
	import vo.VOCliente;

	public class ClienteCard extends ClienteCardUI
	{
		private var _cliente:VOCliente;

		public function get cliente():VOCliente { return _cliente; }
		public function set cliente(value:VOCliente):void {
			_cliente = value;
			childrenCreated();
		}

		public function ClienteCard() {
			super();
		}
		
		override protected function childrenCreated():void {
			if (_cliente) {
				nombreInput.text = _cliente.nombres;
				cedulaInput.text = _cliente.cedula;
				tlfInput.text = _cliente.telefonos;
				grupoInput.text = _cliente.grupoNombre;
			}
		}
	}
}