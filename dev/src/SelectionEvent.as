package  
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class SelectionEvent extends Event 
	{
		private var _coordRect:Rectangle = new Rectangle(0, 0, 1, 1);
		private var _globalRect:Rectangle =  new Rectangle(0, 0, 1, 1);
		public static const SELECT:String = "FIM_SELECAO";
		
		public function SelectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);

		} 
		
		public override function clone():Event 
		{ 
			return new SelectionEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SelectionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get coordRect():Rectangle 
		{
			return _coordRect;
		}
		
		public function set coordRect(value:Rectangle):void 
		{
			_coordRect = value;
		}
		
		public function get globalRect():Rectangle 
		{
			return _globalRect;
		}
		
		public function set globalRect(value:Rectangle):void 
		{
			_globalRect = value;
		}
		
	}
	
}