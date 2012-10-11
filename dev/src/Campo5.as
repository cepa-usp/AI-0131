package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo5 implements ICampo
	{
		private var spr_campo:Sprite = new Spr_Campo5();
		
		public function Campo5() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return x * y;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return x + y;
		}
		
		public function get xmin():Number 
		{
			return -20;
		}
		
		public function get xmax():Number 
		{
			return -10;
		}
		
		public function get ymin():Number 
		{
			return -10;
		}
		
		public function get ymax():Number 
		{
			return 10;
		}
		
		public function get image():Sprite
		{
			return spr_campo;
		}
		
	}
	
}