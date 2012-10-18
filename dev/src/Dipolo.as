package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Brunno
	 */
	public class Dipolo extends Sprite 
	{
		private var sprDipolo:SprDipolo = new SprDipolo();
		private var _selected:Boolean = false;
		private var filter:GlowFilter = new GlowFilter(0xFF0000, 1, 8, 8, 2);
		private var antAngle:Number;
		private var ant_angle;
		
		private var movingSpr:Sprite;
		private var rotatingSpr:Sprite;
		
		public var locked:Boolean = false;
		
		public function Dipolo(movingSpr:Sprite, rotatingSpr:Sprite) 
		{
			this.movingSpr = movingSpr;
			this.rotatingSpr = rotatingSpr;
			
			this.mouseChildren = false;
			
			this.addChild(sprDipolo);
			this.graphics.beginFill(0x00FF00, 0);
			this.graphics.drawCircle(0, 0, 12);
			this.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		}
		
		private function mouseOver(e:MouseEvent):void 
		{
			if (locked) return;
			if (rotatingSpr.visible || movingSpr.visible) return;
			
			Mouse.hide();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movingMouse);
			stage.addEventListener(MouseEvent.MOUSE_OUT, outMouse);
		}
		
		private function movingMouse(e:MouseEvent):void 
		{
			if (Point.distance(new Point(this.mouseX, this.mouseY), new Point(0,0)) <= 10) {
				rotatingSpr.visible = false;
				movingSpr.x = stage.mouseX;
				movingSpr.y = stage.mouseY;
				movingSpr.visible = true;
			}else {
				movingSpr.visible = false;
				rotatingSpr.x = stage.mouseX;
				rotatingSpr.y = stage.mouseY;
				rotatingSpr.rotation = Math.atan2(stage.mouseY - this.y, stage.mouseX - this.x) * 180/Math.PI + 90;
				rotatingSpr.visible = true;
			}
		}
		
		private function outMouse(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingMouse);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, outMouse);
			rotatingSpr.visible = false;
			movingSpr.visible = false;
			Mouse.show();
		}
		
		private var posClick:Point;
		private function initDrag(e:MouseEvent):void 
		{
			if(!locked){
				posClick = new Point(stage.mouseX, stage.mouseY);
				stage.addEventListener(MouseEvent.MOUSE_UP, verifySelection);
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				if (Point.distance(new Point(this.mouseX, this.mouseY), new Point(0, 0)) < 10) {
					this.startDrag();
					stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
				}else {
					getClickPoint();
				}
			}
		}
		
		private function verifySelection(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, verifySelection);
			if (Point.distance(posClick, new Point(stage.mouseX, stage.mouseY)) < 2) {
				this.selected = !this.selected;
			}
			posClick = null;
		}
		
		private function stopDragging(e:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			dispatchEvent(new Event(Event.CHANGE, true));
		}

		private function getClickPoint(e:MouseEvent = null):void
		{
			//if (selected)
			//{
				var clickPoint:Point = new Point(this.mouseX, this.mouseY);
				//if (Point.distance(new Point(0,0),clickPoint) < this.width*1.2 && Point.distance(new Point(0,0),clickPoint) > this.width)
				//{
					antAngle = (Math.atan2(stage.mouseY - this.y, stage.mouseX - this.x)) * 180/Math.PI;
					ant_angle = this.rotation;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, getAngle);
					stage.addEventListener(MouseEvent.MOUSE_UP, stopAngle);
				//}
			//}
		}

		private function getAngle(e:MouseEvent):void
		{	
			this.rotation = (Math.atan2(stage.mouseY - this.y, stage.mouseX - this.x)) * 180/Math.PI - antAngle + ant_angle;
		}

		private function stopAngle(e:MouseEvent):void
		{	
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, getAngle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopAngle);
		}
		
		/**
		 * Get and Set about selection.
		 */
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if (value)
			{
				this.filters = [filter];
			}else {
				this.filters = [];
			}
		}
	}

}