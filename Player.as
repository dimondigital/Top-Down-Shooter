package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Player extends MovieClip
	{
		private var _stage:Stage;
		private var _left:Boolean;
		private var _right:Boolean;
		private var _up:Boolean;
		private var _down:Boolean;
		private const speed:Number = 5;
		private var _halfWidth:uint;
	
//......................CONSTRUCTOR....................................
		public function Player(stage:Stage)
		{
			_stage = stage;
			_halfWidth = this.width / 2;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

//.......................INIT..........................................
		private function init(e:Event):void
		{
			//root.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			root.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			root.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			root.addEventListener(Event.ENTER_FRAME, playerLoop);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function playerLoop(event:Event):void
		{
			checkingParentBounderies();
			movePlayer();
			mouseRotation();
		}
	
//.......................CHECKING PARENT BOUNDERIES.............................
		// проверка на столкновения с границами контейнера, содержащего игрока
		private function checkingParentBounderies():void
		{
			var cont:DisplayObject = parent;
			const contWidth:Number = cont.width;
			// если коснулся левой стороны контейнера
			if (this.x <= cont.x + halfWidth)
			{
				left = false;
			}
			// если коснулся верхней стороны контейнера
			if (this.y <= cont.y + halfWidth)
			{
				up = false;
			}
			// если коснулся правой стороны контейнера
			if (this.x >= cont.width - halfWidth)
			{
				right = false;
			}
			// если коснулся нижней стороны контейнера
			if (this.y >= cont.height - halfWidth)
			{
				down = false;
				
			}
		}
		
		private function movePlayer():void
		{
			if (left)
			{
				this.x -= speed;
			}
			if(right)
			{
				this.x += speed;
			}
			if(up)
			{
				this.y -= speed;
			}
			if(down)
			{
				this.y += speed;
			}
		}
		
//........................MOUSE MOVE.......................................
		protected function mouseRotation():void
		{
			var globalMousePoint:Point = localToGlobal(new Point(mouseX, mouseY));
			var globalPlayerPoint:Point = parent.localToGlobal(new Point(this.x, this.y));
			var dx:Number = globalMousePoint.x - globalPlayerPoint.x;
			var dy:Number = globalMousePoint.y - globalPlayerPoint.y;
			var radians:Number = Math.atan2(dy, dx)  * 180 / Math.PI;
			this.rotation = radians;
			//trace(radians);
		}

//.......................KEY DOWN............................................
		private function keyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{
				case 37:
					left = true;
					break;
				case 38:
					up = true;
					break;
				case 39:
					right = true;
					break;
				case 40:
					down = true;
					break;
			}
		}
		
//.......................KEY UP...............................................
		private function keyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{
				case 37:
					left = false;
					break;
				case 38:
					up = false;
					break;
				case 39:
					right = false;
					break;
				case 40:
					down = false;
					break;
			}
		}

//.......................GETTERS & SETTERS........................................
		public function get left():Boolean
		{
			return _left;
		}

		public function set left(value:Boolean):void
		{
			_left = value;
		}

		public function get right():Boolean
		{
			return _right;
		}

		public function set right(value:Boolean):void
		{
			_right = value;
		}

		public function get up():Boolean
		{
			return _up;
		}

		public function set up(value:Boolean):void
		{
			_up = value;
		}

		public function get down():Boolean
		{
			return _down;
		}

		public function set down(value:Boolean):void
		{
			_down = value;
		}

		public function get halfWidth():uint
		{
			return _halfWidth;
		}

		public function set halfWidth(value:uint):void
		{
			_halfWidth = value;
		}


	}
}







