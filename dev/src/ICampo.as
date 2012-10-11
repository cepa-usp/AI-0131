package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public interface ICampo 
	{
		function xcomp(x:Number, y:Number):Number 
		function ycomp(x:Number, y:Number):Number 
		function get xmin():Number
		function get xmax():Number
		function get ymin():Number
		function get ymax():Number	
		function get image():Sprite	
	}
	
}