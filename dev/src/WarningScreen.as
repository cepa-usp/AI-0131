package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class WarningScreen extends MovieClip
	{
		
		public function WarningScreen() 
		{
			this.x = 700 / 2;
			this.y = 500 / 2;
			
			this.gotoAndStop("END");
			
			this.addEventListener(MouseEvent.CLICK, closeScreen);
		}
		
		private function closeScreen(e:MouseEvent):void 
		{
			this.play();
		}
		
		public function openScreen():void
		{
			this.gotoAndStop("BEGIN");
		}
		
	}

}