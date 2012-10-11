package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Particula extends ObjMoveable 
	{
		//Passo em coordenadas do gráfico de cada frame.
		//private var step:Number = 0.02;
		private var step:Number = 0.1;
		private var spriteParticula:Sprite;
		private var intrv:int;
		private var ms:int = 10;
		
		public function Particula(coord:Coord, campo:ICampo) 
		{
			super(coord, campo);
			createParticula();
		}
		
		
		
		private function createParticula():void 
		{
			spriteParticula = new Sprite();
			spriteParticula.graphics.beginFill(0x000000, 1);
			spriteParticula.graphics.drawCircle(0, 0, 3);
			addChild(spriteParticula);
		}
		
		public function startMoving():void
		{
			setLifeTime(10);
			this.mover.shiftKeyPressed = true;
			addEventListener(Event.ENTER_FRAME, moving);
			//intrv = setInterval(movingPrecise, ms)
			//intrv = setInterval(moving, ms)
			//addEventListener(Event.ENTER_FRAME, movingPrecise);
		}
		
		private var lifeTimer:Timer;
		private function setLifeTime(time:Number):void 
		{
			lifeTimer = new Timer(time * 1000, 1);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			lifeTimer.start();
		}
		
		private var faderTimer:Timer;
		private function timerComplete(e:TimerEvent):void 
		{
			faderTimer = new Timer(100);
			faderTimer.addEventListener(TimerEvent.TIMER, removeParticula);
			faderTimer.start();
		}
		
		
		override public function prepareToRemove():void {
			//removeEventListener(Event.ENTER_FRAME, moving);
			stopMoving();
		}
		
		override public function init():void {
			//addEventListener(Event.ENTER_FRAME, moving);	
		}

		
		
		private function removeParticula(e:TimerEvent):void 
		{
			
			this.alpha -= 0.1;
			if (this.alpha <= 0) {
				stopMoving();
				this.visible = false;
				faderTimer.removeEventListener(TimerEvent.TIMER, removeParticula);
				faderTimer.stop();
				dispatchEvent(new Event(Event.UNLOAD, true));
			}
		}
		
		public function stopMoving():void
		{
			clearInterval(intrv);
		}
		
		private function moving(e:Event = null):void 
		{
			var angle:Number = -Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y));
			
			var xMove:Number = step * Math.cos(angle);
			var yMove:Number = step * Math.sin(angle);
			
			//var positionPixels:Point = mover.returnPixelsFromPosition(mover.position);
			mover.position = new Point(mover.position.x + xMove, mover.position.y - yMove);
		}
		
		/*private function moving():void 
		{
			var angle:Number = -Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y));
			
			var xMove:Number = step * Math.cos(angle);
			var yMove:Number = step * Math.sin(angle);
			
			var positionPixels:Point = mover.returnPixelsFromPosition(mover.position);
			mover.setPositionByPixels(new Point(positionPixels.x + xMove, positionPixels.y + yMove));
		}*/
		
		private function movingPrecise():void
		{
			for (var i:int = 0; i < 10; i++) 
			{
				var angle:Number = Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y));
				
				var xMove:Number = step/10 * Math.cos(angle);
				var yMove:Number = -step/10 * Math.sin(angle);
				
				var positionPixels:Point = mover.returnPixelsFromPosition(mover.position);
				mover.setPositionByPixels(new Point(positionPixels.x + xMove, positionPixels.y + yMove));
			}
		}
		
	}

}