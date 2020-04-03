package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.General;
	import TriangleCraft.Tile.*;
	
	//Class
	public class TileSystem
	{
		//==========Idefined==========//
		//Global
		public static const globalTileSize:uint=32
		
		public static const AllBlockID:Array=[TileID.Void,
											  TileID.Colored_Block,
											  TileID.Color_Mixer,
											  TileID.Block_Crafter,
											  TileID.Basic_Wall,
											  TileID.Block_Spawner,
											  TileID.XX_Virus,
											  TileID.XX_Virus_Red,
											  TileID.XX_Virus_Blue,
											  TileID.Arrow_Block,
											  TileID.Barrier,
											  TileID.Crystal_Wall,
											  TileID.Walls_Spawner,
											  TileID.Pushable_Block,
											  TileID.Inventory_Block]
		public static const AllItemID:Array=[]
		public static const AllTileID:Array=AllBlockID.concat(AllItemID)
		public static const TotalTileCount:uint=AllTileID.length
		//Tile Levels
		public static const Level_NA:String="N/A"
		public static const Level_Top:String="Top"
		public static const Level_Back:String="Back"
		public static const AllTileLevel:Array=[Level_NA,
												Level_Top,
												Level_Back]
		public static const TotalLevelCount:uint=AllTileLevel.length
		
		//==========Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(General.IsiA(Id,AllTileID))
			{
				return true
			}
			trace("Not Allow ID:"+Id)
			return false
		}
		
		public static function isAllowLevel(Level:String):Boolean
		{
			if(General.IsiA(Level,AllTileLevel))
			{
				return true
			}
			trace("Not Allow Level:"+Level)
			return false
		}
		
		public static function getHardnessFromID(Id:String):uint
		{
			switch (Id)
			{
				case TileID.Crystal_Wall:
					return 12;
				case TileID.Barrier:
					return 4096;
				case TileID.Colored_Block:
				case TileID.Arrow_Block:
				case TileID.Pushable_Block:
					return 3;
				case TileID.XX_Virus:
					return 1+General.random(2);
				case TileID.XX_Virus_Red:
					return 1;
				case TileID.XX_Virus_Blue:
					return 2+General.random(9);
				case TileID.Basic_Wall:
					return 8;
				case TileID.Inventory_Block:
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				case TileID.Block_Crafter:
				case TileID.Color_Mixer:
					return 4;
				case TileID.Void:
					return 0;
			}
			return 0;
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			return TileTag.getTagFromID(Id)
		}
		
		public static function needColor(Id:String):Boolean
		{
			if(TileSystem.isAllowID(Id))
			{
				if(Id==TileID.Colored_Block)
				{
					return true
				}
			}
			return false
		}
	}
}