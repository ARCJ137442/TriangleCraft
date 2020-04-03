package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.Shapes.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Class
	public class TileSystem
	{
		//==========Idefined==========//
		//Global
		public static const globalTileSize:uint=32
		
		public static var AllInternalBlockID:Vector.<String>=new <String>[TileID.Void,
																		  TileID.Colored_Block,
																		  TileID.Color_Mixer,
																		  TileID.Block_Crafter,
																		  TileID.Basic_Wall,
																		  TileID.Block_Spawner,
																		  TileID.XX_Virus,
																		  TileID.XX_Virus_Red,
																		  TileID.XX_Virus_Blue,
																		  TileID.XX_Virus_Yellow,
																		  TileID.XX_Virus_Green,
																		  TileID.XX_Virus_White,
																		  TileID.XX_Virus_Black,
																		  TileID.Arrow_Block,
																		  TileID.Barrier,
																		  TileID.Crystal_Wall,
																		  TileID.Walls_Spawner,
																		  TileID.Pushable_Block,
																		  TileID.Inventory_Block,
																		  TileID.Signal_Wire,
																		  TileID.Signal_Patcher,
																		  TileID.Random_Tick_Signal_Generater,
																		  TileID.Wireless_Signal_Transmitter]
		public static var AllCustomBlockID:Vector.<String>=new <String>[]
		public static var AllItemID:Vector.<String>=new <String>[]
		//Tile Levels
		public static const Level_NA:String="N/A"
		public static const Level_Top:String="Top"
		public static const Level_Back:String="Back"
		public static const AllTileLevel:Vector.<String>=new <String>[Level_NA,
																	  Level_Top,
																	  Level_Back]
		public static const TotalLevelCount:uint=AllTileLevel.length
		
		//==========Getters And Setters==========//
		public static function get AllBlockID():Vector.<String>
		{
			return TileSystem.AllInternalBlockID.concat(TileSystem.AllCustomBlockID)
		}
		
		public static function get AllTileID():Vector.<String>
		{
			return AllBlockID.concat(AllItemID)
		}
		
		public static function get TotalTileCount():uint
		{
			return TileSystem.AllTileID.length
		}
		
		//==========Test Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(TileSystem.AllTileID.indexOf(Id)>-1)
			{
				return true
			}
			trace("Not Allow ID:"+Id)
			return false
		}
		
		public static function isAllowLevel(Level:String):Boolean
		{
			if(TileSystem.AllTileID.indexOf(Level)>-1)
			{
				return true
			}
			trace("Not Allow Level:"+Level)
			return false
		}
		
		//==========Getter Functions===========//
		public static function getHardnessFromID(Id:String):uint
		{
			//Internal Ids
			switch (Id)
			{
				//Void
				case TileID.Void:
					return 0;
				//Virus
				case TileID.XX_Virus:
				case TileID.XX_Virus_Yellow:
				case TileID.XX_Virus_Green:
					return 1+General.random(2);
				case TileID.XX_Virus_Red:
				case TileID.Signal_Wire:
					return 1;
				case TileID.XX_Virus_Blue:
					return 2+General.random(9);
				case TileID.XX_Virus_White:
					return 4;
				case TileID.XX_Virus_Black:
					return 10;
				//Wall
				case TileID.Basic_Wall:
					return 8;
				case TileID.Crystal_Wall:
					return 12;
				//Machine
				case TileID.Inventory_Block:
					return 6
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				case TileID.Block_Crafter:
				case TileID.Color_Mixer:
					return 4;
				//Signal Machine
				case TileID.Signal_Patcher:
				case TileID.Random_Tick_Signal_Generater:
					return 5;
				case TileID.Wireless_Signal_Transmitter:
					return 2;
				//Other
				case TileID.Barrier:
					return 4096;
				case TileID.Colored_Block:
				case TileID.Arrow_Block:
				case TileID.Pushable_Block:
					return 3;
			}
			//Custom Ids
			if(TileInfornation.hasInfornationByID(Id))
			{
				return TileInfornation.getInfornationByID(Id).defaultMaxHard
			}
			return 0;
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			return TileTag.getTagFromID(Id)
		}
		
		public static function getLevelFromID(Id:String):String
		{
			switch(Id)
			{
				case TileID.Signal_Wire:
				return TileSystem.Level_Back
				default:
				return TileSystem.Level_NA
			}
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