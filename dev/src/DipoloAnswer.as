package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class DipoloAnswer extends ObjMoveable
	{
		private var sprDipolo:SprDipolo = new SprDipolo();
		private var fatorPalco = 500 / 700;
		
		public function DipoloAnswer(campo:ICampo, graph:Coord) 
		{
			super(graph, campo);
			addChild(sprDipolo);
			//this.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}
		
		public function rotate():void {
			var dx:Number = (campo.xmax - campo.xmin);
			var dy:Number = (campo.ymax - campo.ymin);
			
			var fator:Number =  dx/dy;
			
			var rot:Number;
			//if(Math.abs(dx) < Math.abs(dy)) rot = -(Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y) * fator, campo.xcomp(this.mover.position.x, this.mover.position.y))) * (180 / Math.PI);
			//else 							rot = -(Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y) * fator)) * (180 / Math.PI);
			
			rot = -(Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y) * fator * fatorPalco, campo.xcomp(this.mover.position.x, this.mover.position.y))) * (180 / Math.PI);
			
			this.rotation = rot;
			
			//var tPos:TextField = new TextField();
			//tPos.text = this.mover.position.x.toFixed(2) + ",  " + this.mover.position.y.toFixed(2);
			//addChild(tPos);
			//tPos.y = 10;
			//tPos.rotation = -rot;
			//
			//var tComp:TextField = new TextField();
			//tComp.text = campo.xcomp(this.mover.position.x, this.mover.position.y).toString() + ", " + campo.ycomp(this.mover.position.x, this.mover.position.y).toString();
			//addChild(tComp);
			//tComp.y = 25;
			//tComp.rotation = -rot;
			//
			//var tRot:TextField = new TextField();
			//tRot.text = rot.toString();
			//addChild(tRot);
			//tRot.y = 40;
			//tRot.rotation = -rot;
			//
			//var tFat:TextField = new TextField();
			//tFat.text = fator.toString();
			//addChild(tFat);
			//tFat.y = 65;
			//tFat.rotation = -rot;
		}
		
		public var locked:Boolean = false;
		private function initDrag(e:MouseEvent):void 
		{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moving);
		}
		
		private function moving(e:MouseEvent):void 
		{
			rotate();
		}
		
		private function stopDragging(e:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moving);
		}
		
	}
	
}