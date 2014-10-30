package com
{
	import bootstrap.controls.FormItem;
	import bootstrap.validators.Validator;
	import bootstrap.validators.ValidatorType;
	
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	import vo.VOUsuario;

	public class ModalAdmin extends ModalAlert
	{
		private var pass:TextInput;

		private var formItem:FormItem;
		public function ModalAdmin(message:String, title:String="", onClose:Function=null, defaultButton:int=0, style:String="") {
			super(message, title, [ModalAlert.OK,ModalAlert.CANCEL], onClose, defaultButton, style);
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			formItem = new FormItem;
			formItem.percentWidth = 100;
			formItem.label = "Contraseña";
			formItem.validateType = ValidatorType.CUSTOM;
			formItem.validateFunctions = new <Function>[
				Validator.validateText,
				validateUser
			];
			pass = new TextInput;
			pass.displayAsPassword = true;
			formItem.addElement(pass);
			addElement(formItem);
			
			pass.setFocus();
		}
		
		private function validateUser(items:Array):void {
			pass.errorString = pass.text==VOUsuario.USUARIO.pass?"":"Contraseña inválida";
		}
		override protected function clickHandler(event:Event):void {
			if (event.target is Button) {
				var index:int = (event.target.parent as IVisualElementContainer).getElementIndex(event.target as IVisualElement);
				if (index==0)
					if (!formItem.isValid) return;
				closing(index,event.target.name);
			}
		}
		
		private function get isAdmin():Boolean {
			return false;
		}
	}
}