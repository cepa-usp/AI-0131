package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import graph.Coord;
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Mover extends Sprite
	{
		
		private var _position:Point = new Point();
		private var _id:int;
		private var _objParent:DisplayObject;
		private var _coord:Coord;

		
		public function Mover(objParent:DisplayObject, coord:Coord) 
		{
			this.objParent = objParent;
			_id = IDGenerator.newID();
			this._coord = coord;
			
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get position():Point 
		{
			return _position;
		}
		
		public function returnPixelsFromPosition(p:Point):Point {
			//trace(p,  new Point(coord.x2pixel(p.x), coord.y2pixel(p.y)))
			//return objParent.globalToLocal(new Point(coord.x2pixel(p.x) + coord.x, coord.y2pixel(p.y) + coord.y));
			//return objParent.localToGlobal(new Point(coord.x2pixel(p.x), coord.y2pixel(p.y)));
			return new Point(coord.x2pixel(p.x) + coord.x, coord.y2pixel(p.y) + coord.y);
		}

		
		public function returnPositionFromPixels(p:Point):Point {
			
			var pp:Point = coord.globalToLocal(p);
			return new Point(coord.pixel2x(pp.x), coord.pixel2y(pp.y));
		}
		
		public function setPositionByPixels(p:Point):void 
		{
			position = returnPositionFromPixels(new Point(p.x, p.y));
		}
		
		public var shiftKeyPressed:Boolean = false;
		
		public function set position(p:Point):void 
		{
			if (!shiftKeyPressed) {
				var pointNext:Point = new Point(Math.round(p.x), Math.round(p.y));
				if (Point.distance(pointNext, p) < 0.1) {
					_position.x = pointNext.x;
					_position.y = pointNext.y;					
				}else{
					//_position.x = Math.max(coord.xmin, Math.min(coord.xmax, p.x));
					//_position.y = Math.max(coord.ymin, Math.min(coord.ymax, p.y));
					_position.x = p.x;
					_position.y = p.y;
				}
			}else{
				//_position.x = Math.max(coord.xmin, Math.min(coord.xmax, p.x));
				//_position.y = Math.max(coord.ymin, Math.min(coord.ymax, p.y));
				_position.x = p.x;
				_position.y = p.y;
			}
			objParent.x = coord.x2pixel(position.x) + coord.x;
			objParent.y = coord.y2pixel(position.y) + coord.y;
		}
		
		public function moveTo(x:int, y:int):void {
			_position.x = x;
			_position.y = y;
			objParent.x = _position.x;
			objParent.y = _position.y;		
		}
		
		public function get objParent():DisplayObject 
		{
			return _objParent;
		}
		
		public function set objParent(value:DisplayObject):void 
		{
			_objParent = value;
		}
		
		public function get coord():Coord 
		{
			return _coord;
		}
		
	}
	
}