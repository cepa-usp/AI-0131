package  
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public interface IMoveable 
	{
		function get mover():Mover;
		function set mover(value:Mover):void;
		function update():void;
	}
	
}