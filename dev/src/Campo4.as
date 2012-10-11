package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo4 implements ICampo
	{
		private var spr_campo:Sprite = new Spr_Campo4();
		
		public function Campo4() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return y;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return x;
		}
		
		public function get xmin():Number 
		{
			return -5;
		}
		
		public function get xmax():Number 
		{
			return 5;
		}
		
		public function get ymin():Number 
		{
			return -10;
		}
		
		public function get ymax():Number 
		{
			return -2;
		}
		
		public function get image():Sprite
		{
			return spr_campo;
		}
		
	}
	
}