package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	
	public class Main extends Sprite
	{
		private var player:Player;
		private var camera:MapMover;
		
		public function Main()
		{
			// add player
			player = new Player(stage);
			
			player.x = stage.stageWidth / 2;
			player.y = stage.stageHeight / 2;
			
			// add camera
			camera = new MapMover(stage, player, 
				new Point(player.x, player.y), 0.1);
			trace(camera.speedFactor);
			stage.addChild(camera);
			camera.addChild(player);
		}
	}
}