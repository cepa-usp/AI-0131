package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo8 implements ICampo
	{
		private var spr_campo:Sprite = new Spr_Campo8();
		
		public function Campo8() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return -1;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return 1;
		}
		
		public function get xmin():Number 
		{
			return -10;
		}
		
		public function get xmax():Number 
		{
			return 10;
		}
		
		public function get ymin():Number 
		{
			return -8;
		}
		
		public function get ymax():Number 
		{
			return 8;
		}
		
		public function get image():Sprite
		{
			return spr_campo;
		}
		
	}
	
}