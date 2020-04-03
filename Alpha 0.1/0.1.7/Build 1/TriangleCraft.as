package
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Events.*;
	import flash.events.Event;
	
	//Flash
	import flash.display.MovieClip;
	import flash.system.fscommand;
	
	//Class
	public class TriangleCraft extends MovieClip
	{
		public var game:Game;
		
		public function TriangleCraft():void
		{
			//fscommand("trapallkeys","true");
			this.game=new Game();
			this.game.addEventListener(GameEvent.LOAD_COMPLETE,dealEvent);
			addChild(game);
			stop();
		}
		
		public function dealEvent(event:GameEvent):void
		{
			
		}
	}
}