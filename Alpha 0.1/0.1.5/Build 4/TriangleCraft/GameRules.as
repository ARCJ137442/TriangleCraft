package TriangleCraft 
{
	public class GameRules 
	{
		//================Static Variables================//
		public static const d_generateTiles:Boolean=true
		public static const d_blockDropItems:Boolean=true
		
		//================Instance Variables================//
		public var generateTiles:Boolean
		public var blockDropItems:Boolean
		
		//================Init Class================//
		public function GameRules():void
		{
			loadDefault()
		}
		
		public function loadDefault():void
		{
			this.generateTiles=d_generateTiles
			this.blockDropItems=d_blockDropItems
		}
	}
}