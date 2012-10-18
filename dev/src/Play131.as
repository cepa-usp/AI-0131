package 
{
	import cepa.ai.IPlayInstance;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Play131 implements IPlayInstance 
	{
		private var _playMode:int;
		private var score:Number;
		
		
		
		public function Play131() 
		{
			
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function get playMode():int 
		{
			return _playMode;
		}
		
		public function set playMode(value:int):void 
		{
			_playMode = value;
		}
		
		public function returnAsObject():Object 
		{
			var o:Object = new Object();
			o.score = this.score;
			o.playMode = _playMode;
			return o;
		}
		
		public function bind(obj:Object):void 
		{
			this.score = obj.score;
			this._playMode = obj.playMode;
		}
		
		public function getScore():Number 
		{
			return score;
		}
		
		public function setScore(score:Number):void {
			this.score = score;
		}
		
		public function evaluate():void 
		{
			
		}
		
	}

}