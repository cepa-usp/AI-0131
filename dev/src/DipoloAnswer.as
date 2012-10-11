package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class DipoloAnswer extends ObjMoveable
	{
		private var sprDipolo:SprDipolo = new SprDipolo();
		//private var
		
		public function DipoloAnswer(campo:ICampo, graph:Coord) 
		{
			super(graph, campo);
			addChild(sprDipolo);
		}
		
		public function rotate():void {
			var fator:Number = (campo.xmax - campo.xmin) / (campo.ymax - campo.ymin);
			//var fator:Number = 640/Math.abs(;
			this.rotation = (Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y)* fator, campo.xcomp(this.mover.position.x, this.mover.position.y))) * (180/ Math.PI);
		}
		
	}
	
}