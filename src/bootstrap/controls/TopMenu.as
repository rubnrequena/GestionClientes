package bootstrap.controls
{
	import flash.events.MouseEvent;
	
	import mx.core.ContainerCreationPolicy;
	import mx.core.IVisualElement;
	
	import org.osflash.signals.natives.NativeSignal;
	
	import spark.components.ButtonBar;
	import spark.components.SkinnableContainer;
	import spark.containers.Navigator;
	import spark.events.IndexChangeEvent;
	
	public class TopMenu extends SkinnableContainer
	{
		public static var MIN_HEIGHT:int = 30;

		private var _height:Number;
		
		private var _buttonBar:ButtonBar;
		private var _nav:Navigator;
				
		private var _clickBar:NativeSignal;

		private var _indexChange:NativeSignal;
		public function get indexChange():NativeSignal { return _indexChange; }

		public function TopMenu() {
			super();
			_nav = new Navigator;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			minHeight = MIN_HEIGHT;
			
			_nav.percentWidth = _nav.percentHeight = 100;
			_nav.x = 0;
			_nav.y = MIN_HEIGHT;
			_nav.creationPolicy = ContainerCreationPolicy.ALL;
			_indexChange = new NativeSignal(_nav,IndexChangeEvent.CHANGE,IndexChangeEvent);
						
			_buttonBar = new ButtonBar;
			_buttonBar.styleName = "topMenuBar";
			_buttonBar.x = _buttonBar.y = 0;
			_buttonBar.height = MIN_HEIGHT;
			_buttonBar.dataProvider = _nav;
			_buttonBar.labelField = "name";
			_clickBar = new NativeSignal(_buttonBar,MouseEvent.CLICK,MouseEvent);
			_clickBar.add(onBarClick);
			
			addElement(_buttonBar);
			addElement(_nav);
			
			_height = height;
		}
		
		private function onBarClick(e:MouseEvent):void {
			_nav.visible = _nav.includeInLayout = e.target.selected;
			height = e.target.selected?_height:MIN_HEIGHT;
		}
		public function set views (value:Array):void {
			_nav.mxmlContent = value;
		}
		public function addItem (item:IVisualElement):IVisualElement {
			return _nav.addElement(item);
		}
		public function addItemAt (item:IVisualElement,index:int):IVisualElement {
			return _nav.addElementAt(item,index);
		}
		public function removeItemAt (index:int):IVisualElement {
			return _nav.removeElementAt(index);
		}
		public function removeAll ():void {
			_nav.removeAll();
		}
	}
}