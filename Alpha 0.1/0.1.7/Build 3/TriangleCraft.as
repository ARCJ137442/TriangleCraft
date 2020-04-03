package
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Events.*;
	import flash.events.Event;
	
	//Flash
	import flash.display.MovieClip;
	import flash.system.fscommand;
	import flash.net.SharedObject;
	
	//Class
	public class TriangleCraft extends MovieClip
	{
		public var game:Game;
		
		public function TriangleCraft():void
		{
			//fscommand("trapallkeys","true");
			/*//Try To Load Old Game
			var savedGame:Game;
			try
			{
				savedGame=Game.SAVED_GAME;
			}
			catch(error)
			{
				savedGame=null;
			}
			//Load Local Game
			if(savedGame!=null)
			{
				this.game=savedGame;
			}
			//Create New Game
			else
			{
				*/this.game=new Game();/*
			}*/
			this.game.addEventListener(GameEvent.LOAD_COMPLETE,dealEvent);
			addChild(this.game);
			stop();
		}
		
		public function dealEvent(event:GameEvent):void
		{
			
		}
	}
}