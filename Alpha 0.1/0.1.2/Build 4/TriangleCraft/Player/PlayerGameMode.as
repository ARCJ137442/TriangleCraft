package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class PlayerGameMode
	{
		//==========Variables==========//
		public static const BASIC:String="Basic"
		public static const ADMIN:String="Admin"
		public static const NULL:String="Null"
		
		//==========Functions==========//
		public static function get _defaultMode():String
		{
			return PlayerGameMode.BASIC
		}
		
		public static function get _allModes():Array
		{
			return PlayerGameMode._allModesWithoutNull.concat(PlayerGameMode.NULL)
		}
		
		public static function get _allModesWithoutNull():Array
		{
			return new Array(PlayerGameMode.BASIC,
							 PlayerGameMode.ADMIN)
		}
		
		public static function get _random():String
		{
			return General.returnRandom2(PlayerGameMode._allModes)
		}
		
		public static function get _randomWithoutNull():String
		{
			return General.returnRandom2(PlayerGameMode._allModesWithoutNull)
		}
	}
}