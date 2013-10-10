package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class DrawCampo extends Sprite 
	{
		private var field:ICampo;
		private var coord:Coord;
		
		public function DrawCampo(coord:Coord, field:ICampo) 
		{
			this.field = field;
			//Testes
			this.coord = coord;
			//addChild(coord);
			addParticulas();
		}
		
		private var particulas:Vector.<Particula> = new Vector.<Particula>();
		private var olderPos:Vector.<Point> = new Vector.<Point>();
		private function addParticulas():void 
		{
			var w:Number = 700;
			for (var i:int = coord.xmin; i <= coord.xmax; i++) 
			{
				var particulaX1:Particula = new Particula(coord, field);
				particulas.push(particulaX1);
				particulaX1.mover.position = new Point(i, coord.ymin);
				addChild(particulaX1);
				
				olderPos.push(new Point(particulaX1.x, particulaX1.y));
				
				//var particulaX2:Particula = new Particula(coord, field);
				//particulas.push(particulaX2);
				//particulaX2.mover.position = new Point(i, coord.ymax);
				//addChild(particulaX2);
				//
				//olderPos.push(new Point(particulaX2.x, particulaX2.y));
			}
			
			/*var h:Number = 500;
			for (var j:int = coord.ymin; j <= coord.ymax; j++) 
			{
				var particulaY1:Particula = new Particula(coord, field);
				particulas.push(particulaY1);
				particulaY1.mover.position = new Point(coord.xmin, j);
				addChild(particulaY1);
				
				olderPos.push(new Point(particulaY1.x, particulaY1.y));
				
				var particulaY2:Particula = new Particula(coord, field);
				particulas.push(particulaY2);
				particulaY2.mover.position = new Point(coord.xmax, j);
				addChild(particulaY2);
				
				olderPos.push(new Point(particulaY2.x, particulaY2.y));
			}*/
			
			addEventListener(Event.ENTER_FRAME, drawField);
			
			for each (var item:Particula in particulas) 
			{
				item.startMoving();
			}
		}
		
		private function drawField(e:Event):void 
		{
			this.graphics.lineStyle(1, 0xFF0000);
			for (var i:int = 0; i < particulas.length; i++) 
			{
				this.graphics.moveTo(olderPos[i].x, olderPos[i].y);
				this.graphics.lineTo(particulas[i].x, particulas[i].y);
				
				olderPos[i] = new Point(particulas[i].x, particulas[i].y);
			}
		}
		
	}

}