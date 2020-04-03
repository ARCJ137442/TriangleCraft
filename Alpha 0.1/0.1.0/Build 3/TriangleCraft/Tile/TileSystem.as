package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.General;
	import TriangleCraft.Tile.*;
	
	//Class
	public class TileSystem
	{
		function TileSystem(Sys:TileSystem)
		{
		}
		//==========Idefined==========//
		//Global
		public static const globalTileSize:uint=32
		
		//Tile IDs
		public static const Void:String="Void"
		public static const Colored_Block:String="Colored_Block"
		public static const Color_Mixer:String="Color_Mixer"
		public static const Block_Crafter:String="Block_Crafter"
		public static const Basic_Wall:String="Basic_Wall"
		public static const Block_Spawner:String="Block_Spawner"
		public static const XX_Virus:String="XX_Virus"
		public static const XX_Virus_Red:String="XX_Virus_Red"
		public static const XX_Virus_Blue:String="XX_Virus_Blue"
		public static const Arrow_Block:String="Arrow_Block"
		public static const Barrier:String="Barrier"
		public static const Crystal_Wall:String="Crystal_Wall"
		public static const Walls_Spawner:String="Walls_Spawner"
		
		public static const AllBlockID:Array=[Void,
											 Colored_Block,
											 Color_Mixer,
											 Block_Crafter,
											 Basic_Wall,
											 Block_Spawner,
											 XX_Virus,
											 XX_Virus_Red,
											 XX_Virus_Blue,
											 Arrow_Block,
											 Barrier,
											 Crystal_Wall,
											 Walls_Spawner]
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
				case TileSystem.Crystal_Wall:
					return 12;
					break;
				case TileSystem.Barrier:
					return 4096;
					break;
				case TileSystem.Arrow_Block:
					return 3;
					break;
				case TileSystem.XX_Virus:
					return 1+General.random(2);
					break;
				case TileSystem.XX_Virus_Red:
					return 1;
					break;
				case TileSystem.XX_Virus_Blue:
					return 2+General.random(9);
					break;
				case TileSystem.Basic_Wall:
					return 8;
					break;
				case TileSystem.Walls_Spawner:
				case TileSystem.Block_Spawner:
				case TileSystem.Block_Crafter:
				case TileSystem.Color_Mixer:
					return 4;
					break;
				case TileSystem.Colored_Block:
					return 3;
					break;
				case TileSystem.Void:
					return 0;
					break;
			}
			return 0;
		}
		
		public static function getFrameByID(Id:String):uint
		{
			if(TileSystem.isAllowID(Id)&&!needColor(Id))
			{
				switch(Id)
				{
					case TileSystem.Void:
					return 0
					case TileSystem.Color_Mixer:
					return 1
					case TileSystem.Block_Crafter:
					return 2
					case TileSystem.Basic_Wall:
					return 3
					case TileSystem.Block_Spawner:
					return 4
					case TileSystem.XX_Virus:
					return 5
					case TileSystem.XX_Virus_Red:
					return 6
					case TileSystem.XX_Virus_Blue:
					return 7
					case TileSystem.Arrow_Block:
					return 8
					case TileSystem.Barrier:
					return 9
					case TileSystem.Crystal_Wall:
					return 10
					case TileSystem.Walls_Spawner:
					return 11
					default:
					return General.IinA(Id,TileSystem.AllTileID)
				}
			}
			return 0
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			return TileTag.getTagFromID(Id)
		}
		
		public static function needColor(Id:String):Boolean
		{
			if(TileSystem.isAllowID(Id))
			{
				if(Id==TileSystem.Colored_Block)
				{
					return true
				}
			}
			return false
		}
	}
}