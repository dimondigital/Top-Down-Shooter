package 
{
	/*
	* ElionSea
	*
	*
	* Класс реализующий передвижение камеры за позицией игрока. Скорость перемещения
	* зависит от расстояния между двумя точками: точкой привязки и точкой координат игрока
	* Параметры _centralStagePoint и _player должны быть изначально одинаковы
	*/
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MapMover extends Sprite
	{
		// объект к которому привязывается камера
		private var _player:DisplayObject;
		private var _stage:Stage;
		// скорости передвижения камеры по х, у
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		// центральная точка сцены
		private var _fixPoint:Point;
		// глобальные координаты объекта
		private var _globalPlayerPoint:Point;
		// коэффицинт скорости
		private var _speedFactor:Number;
		
		private var _isMoving:Boolean = false;
		private var distX:Number;
		private var distY:Number;
		private const fixWidth:Number = DisplayObject(this).width;
		private const fixHeight:Number = DisplayObject(this).height;
		
		
//......................CONSTRUCTOR....................................
		
		/* ПАРАМЕТРЫ
			stage:Stage - сцена приложения
			player:DisplayObject - объект к которому привязывается камера
			fixPoint:Point - изначальная точка координат объекта (player.x, player.y),
							к которой будет постоянно тянуться камера
			speedFactor - коэффициент скорости камеры 
					(от 0.05 (очень медленно) до 1(камера просто движется за объектом))
		*/

		
		
		public function MapMover (stage:Stage, player:DisplayObject, 
								  fixPoint:Point, speedFactor:Number)
		{
			_player = player;
			_stage = stage;
			_fixPoint = fixPoint;
			_speedFactor = speedFactor;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

//.......................INIT..........................................
		private function init(e:Event):void
		{
			root.addEventListener(Event.ENTER_FRAME, cameraLoop);
			//
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}

//.........................CAMERA LOOP.................................
		protected function cameraLoop(event:Event):void
		{
			// предотвращение расширения высоты и ширины карты
			widthHeightFix();
			// глобальные координаты игрока
			globalPlayerPoint = localToGlobal(new Point(_player.x, _player.y));
			// расчёт дистанции между игроком и его нужными координатами
			distX = distanceX(_fixPoint.x, globalPlayerPoint.x);
			distY = distanceY(_fixPoint.y, globalPlayerPoint.y);
			// ускорение передвижения камеры в зависимости от расстояния между координатами
			speedX = distX * speedFactor;
			speedY = distY * speedFactor;
			// проверка на столкновение стен сцены со стенами карты
			checkBordersCollission();
			// передвижение камеры
			moveCamera();
			
		}
		
		private function widthHeightFix():void
		{
			
			/*if (this.width >= fixWidth)
			{
				this.width = fixWidth;
			}
			if (this.height >= fixHeight)
			{
				this.height = fixHeight;
			}*/
		}
		
//.......................CHECK BORDERS COLLISION.............................
		private function checkBordersCollission():void
		{
			var globalMapPoint:Point = root.localToGlobal(new Point(this.x, this.y));
			// если сцена касается левого края карты...
			if(stage.x <= this.x) 
			{
				// ...и игрок находится левее центра сцены
				if (globalPlayerPoint.x <= _stage.stageWidth / 2)
				{
					speedX = 0;
				}
				
				// ...и если игрок ушёл правее центра сцены
				if (globalPlayerPoint.x > _stage.stageWidth / 2)
				{
					speedX = distX * speedFactor;
				}
			}
			// если сцена касается правого края карты...
			if(stage.x + stage.stageWidth >= this.x + this.width)
			{
				// ...и игрок находится правее центра сцены
				if (globalPlayerPoint.x > _stage.stageWidth / 2)
				{
					speedX = 0;
				}
				
				// ...и если игрок ушёл левее центра сцены
				if (globalPlayerPoint.x < _stage.stageWidth / 2)
				{
					speedX = distX * speedFactor;
				}
			}
			// если сцена касается ВЕРХнего края карты...
			if(stage.y <= this.y) 
			{
				// ...и игрок находится выше центра сцены
				if (globalPlayerPoint.y < _stage.stageHeight / 2)
				{
					speedY = 0;
				}
				
				// ...и если игрок ушёл ниже центра сцены
				if (globalPlayerPoint.y > _stage.stageHeight / 2)
				{
					speedY = distY * speedFactor;
				}
			}
			// если сцена касается НИЖнего края карты...
			if(stage.y + stage.stageHeight >= this.y + this.height) 
			{
				// ...и игрок находится ниже центра сцены
				if (globalPlayerPoint.y > _stage.stageHeight / 2)
				{
					speedY = 0;
				}
				
				// ...и если игрок ушёл выше центра сцены
				else if (globalPlayerPoint.y < _stage.stageHeight / 2)
				{
					speedY = distY * speedFactor;
				}
			}
			
		}
		
//.......................MOVE CAMERA........................................
		private function moveCamera():void
		{
			if (globalPlayerPoint.x != fixPoint.x)
			{
				this.x += speedX;
			}
			else 
			{
				speedX = 0;
			}
			if (globalPlayerPoint.y != fixPoint.y)
			{
				this.y += speedY;
			}
			else 
			{
				speedY = 0;
			}
		}

//.................DISTANCE X Y.....................................................
		// функции расчёта расстояния по Х и У
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
		

		// speed factor
		public function get speedFactor():Number
		{
			return _speedFactor;
		}

		public function set speedFactor(value:Number):void
		{
			if (value < 0.05)
			{
				value = 0.05;
				_speedFactor = value;
			}
			else if (value > 1)
			{
				value = 1;
				_speedFactor = value;
			}
			
		}
		
//..........................GETTERS & SETTERS.........................................
		// speedX
		public function get speedX():Number
		{
			return _speedX;
		}

		public function set speedX(value:Number):void
		{
			_speedX = value;
		}

		// speedY
		public function get speedY():Number
		{
			return _speedY;
		}

		public function set speedY(value:Number):void
		{
			_speedY = value;
		}

		// global player point
		public function get globalPlayerPoint():Point
		{
			return _globalPlayerPoint;
		}

		public function set globalPlayerPoint(value:Point):void
		{
			_globalPlayerPoint = value;
		}

		// fix point
		public function get fixPoint():Point
		{
			return _fixPoint;
		}

		public function set fixPoint(value:Point):void
		{
			_fixPoint = value;
		}
	}
}





