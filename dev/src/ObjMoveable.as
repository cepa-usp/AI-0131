package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class ObjMoveable extends Sprite implements IMoveable
	{
		private var _mover:Mover;
		private var _campo:ICampo;
		private var _selected:Boolean = false;
		protected var glowSelect:GlowFilter = new GlowFilter(0xEE6F11, 1, 2, 2, 7, 1, true);
		private var _commands:Array;
				
		public function get campo():ICampo 
		{
			return _campo;
		}
		
		public function prepareToRemove():void {
			
		}
		
		/**
		 * Quando um objeto é registrado, esse método é executado
		 */
		public function init():void {
			
		}
	
		public function set campo(value:ICampo):void 
		{
			_campo = value;
		}
		

		public function ObjMoveable(coord:Coord, campo:ICampo) 
		{
			_mover = new Mover(this, coord);
			_campo = campo;
		}
		
	
		public function get mover():Mover 
		{
			return _mover;
		}
		
		public function set mover(value:Mover):void 
		{
			_mover = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (value) {
				this.filters = [glowSelect]
			} else {
				this.filters = []
			}
			
			
		}
		
		public function get commands():Array 
		{
			return _commands;
		}
		
		public function set commands(value:Array):void 
		{
			_commands = value;
		}
		
		public function update():void
		{
			mover.position = mover.position;			
		}
		
		
	}
	
}