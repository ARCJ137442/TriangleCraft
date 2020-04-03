package
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Common.intc
	use namespace intc
	
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