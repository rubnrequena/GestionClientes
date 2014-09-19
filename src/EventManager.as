package
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	public class EventManager
	{
		private var mListeners:Dictionary;
		
		public function EventManager()
		{
			
		}
		
		public function addListener (parent:DisplayObject,event:String,listener:Function):void {
			if (mListeners==null) mListeners = new Dictionary;
			
			var events:Dictionary = mListeners[parent];
			var listeners:Vector.<Function>;
			var e:Dictionary;
			if (events) {
				e = listener[event];
				listeners = e
			} else {
				e = new Dictionary;
				e[event] = new <Function>[listener];
				events[parent] = e;
			}
		}
	}
}