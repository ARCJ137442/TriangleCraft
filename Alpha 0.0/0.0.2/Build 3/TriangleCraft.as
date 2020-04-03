package 
{
	import flash.display.MovieClip;
	import Game
	public class TriangleCraft extends MovieClip
	{
		public function TriangleCraft()
		{
			var game=new Game();
			addChild(game);
			stop();
		}
	}
}