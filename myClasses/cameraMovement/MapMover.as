package myClasses.cameraMovement 
{
	/*
	* ElionSea
	*
	*
	* Класс реализующий передвижение камеры за позицией игрока. Скорость перемещения
	* зависит от расстояния центра сцены и игрока.
	*
	*/
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MapMover extends Sprite
	{
		private var _player:DisplayObject;
		private var _stage:Stage;
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		private var _centralStagePoint:Point;
		
//......................CONSTRUCTOR....................................
		public function MapMover (stage:Stage, player:DisplayObject)
		{
			_player = player;
			_stage = stage;
			_centralStagePoint = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

//.......................INIT..........................................
		private function init(e:Event):void
		{
			parent.addEventListener(Event.ENTER_FRAME, cameraLoop);
			//
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}

//.........................CAMERA LOOP.................................
		protected function cameraLoop(event:Event):void
		{
			// глобальная центральная точка сцены
			var centralPoint:Point = new Point(_stage.width / 2,
				_stage.height / 2);
			// глобальные координаты игрока
			var centralPlayerPoint:Point = localToGlobal(new Point(_player.x, _player.y));
			// расчёт дистанции между игроком и центральной точкой сцены
			var distX:Number = distanceX(_centralStagePoint.x, centralPlayerPoint.x);
			var distY:Number = distanceY(_centralStagePoint.y, centralPlayerPoint.y);
			/*trace("centralStagePoint" + _centralStagePoint);
			trace("centralPlayerPoint" + centralPlayerPoint);*/
			/*trace("distX" + distX);
			trace("distY" + distY);*/
			_speedX = distX / 30;
			_speedY = distY / 30;
			//trace("_speedX :" + _speedX);
			//_speedY = centralStagePoint.y / centralPlayerPoint.y;
			moveCamera(centralPlayerPoint);
		}
		
		private function moveCamera(centralPlayerPoint:Point):void
		{
			var playerPoint:Point = centralPlayerPoint;
			
			// смещение камеры по x
			if (playerPoint.x < _centralStagePoint.x)
			{
				this.x += _speedX;
			}
			else if (playerPoint.x > _centralStagePoint.x)
			{
				this.x += _speedX;
			}
			else 
			{
				_speedX = 0;
			}
			
			// смещение камеры по y
			if (playerPoint.y < _centralStagePoint.y)
			{
				this.y += _speedY;
			}
			else if (playerPoint.y > _centralStagePoint.y)
			{
				this.y += _speedY;
			}
			else 
			{
				_speedY = 0;
			}
			
			//if (this.x + _stage.stageWidth == playerPoint.x)
			//{ 
				//_speedX = 0;
				//trace("stop");
			//}
		}
		
		function distanceX(x1:Number, x2:Number):Number 
		{
			var dx:Number = x1-x2;
			return dx;
		}
		
		function distanceY(y1:Number, y2:Number):Number 
		{
			var dy:Number = y1-y2;
			return dy;
		}
	}
}





