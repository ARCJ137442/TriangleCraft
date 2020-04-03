package 
{
	import flash.display.MovieClip;
	import flash.system.fscommand;
	import Game
	public class TriangleCraft extends MovieClip
	{
		public function TriangleCraft()
		{
			//fscommand("trapallkeys","true");
			var game=new Game();
			addChild(game);
			stop();
		}
	}
}