package  
{
	import flash.display.*;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo1 implements ICampo 
	{
		private var spr_campo:Sprite = new Spr_Campo1();
		
		public function Campo1() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return Math.sin(y/3);
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return 2;
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
			return -15;
		}
		
		public function get ymax():Number 
		{
			return 15;
		}
		
		public function get image():Sprite
		{
			return spr_campo;
		}
		
	}
	
}