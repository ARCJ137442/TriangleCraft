package 
{
	public class TileSystem
	{
		//==========Idefined==========//
		public static const Void:String="Void"
		public static const Colored_Block:String="Colored_Block"
		public static const Color_Mixer:String="Color_Mixer"
		public static const Block_Crafter:String="Block_Crafter"
		public static const Basic_Wall:String="Basic_Wall"
		public static const Block_Spawner:String="Block_Spawner"
		public static const XX_Virus:String="XX_Virus"
		public static const Arrow_Block:String="Arrow_Block"
		
		public static const AllTileID:Array=[Void,
											 Colored_Block,
											 Color_Mixer,
											 Block_Crafter,
											 Basic_Wall,
											 Block_Spawner,
											 XX_Virus,
											 Arrow_Block]
		public static const TotalTileCount:uint=AllTileID.length
		
		//==========Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(General.IinA(Id,AllTileID)>=0)
			{
				return true
			}
			trace("Not Allow ID:"+Id)
			return false
		}
	}
}