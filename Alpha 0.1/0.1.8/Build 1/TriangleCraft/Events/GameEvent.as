package TriangleCraft.Events
{
	import flash.events.Event;
	
	
	public class GameEvent extends Event
	{
		//============Static Variables============//
		//GameGeneral
		public static const START_LOADING:String="startLoading"
		public static const LOAD_COMPLETE:String="loadComplete"
		public static const GAME_TICK:String="gameTick"
		public static const START_RESET:String="startReset"
		public static const RESET_COMPLETE:String="resetComplete"
		
		//GamePlay
		public static const RANDOM_TICK:String="randomTick"
		public static const TILE_UPDATE:String="tileUpdate"
		public static const NEARBY_TILE_UPDATE:String="nearbyTileUpdate"
		public static const PLAYER_ADDED:String="playerAdded"
		public static const PLAYER_DESTROY_BLOCK:String="playerDestroyBlock"
		public static const PLAYER_DESTROYING_BLOCK:String="playerDestroyingBlock"
		public static const PLAYER_PLACE_BLOCK:String="playerPlaceBlock"
		public static const PLAYER_USE_BLOCK:String="playerUseBlock"
		public static const PLAYER_USE_ITEM:String="playerUseItem"
		public static const PLAYER_PUSH_BLOCK:String="playerPushBlock"
		public static const ENTITY_ADDED:String="entityAdded"
		public static const ENTITY_REMOVE:String="entityRemove"
		public static const PATCH_A_SIGNAL:String="patchASingal"
		
		//============Static Functions============//
		
		
		//============Instance Variables============//
		
		
		//============Constructor Function============//
		public function GameEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false):void
		{ 
			super(type,bubbles,cancelable);
		} 
		
		//============Instance Functions============//
		//Overridden by Event
		public override function clone():Event
		{ 
			return new GameEvent(type,bubbles,cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvent","type","bubbles","cancelable","eventPhase");
		}
	}
}