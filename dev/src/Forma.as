package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Forma extends MovieClip 
	{
		
		public var condutor:Condutor;
		
		public function Forma() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			getChildren();
		}
		
		private function getChildren():void 
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if (getChildAt(i) is Condutor) {
					condutor = Condutor(getChildAt(i));
				}
			}
		}
		
	}

}