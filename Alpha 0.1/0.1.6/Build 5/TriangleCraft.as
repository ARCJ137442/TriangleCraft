package
{
	//TriangleCraft
	import TriangleCraft.Game
	
	//Flash
	import flash.display.MovieClip;
	import flash.system.fscommand;
	
	//Class
	public class TriangleCraft extends MovieClip
	{
		public function TriangleCraft():void
		{
			//fscommand("trapallkeys","true");
			var game=new Game();
			addChild(game);
			stop();
		}
	}
}