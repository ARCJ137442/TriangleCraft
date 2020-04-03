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
		
		public static var AllInternalBlockID:Array=[TileID.Void,
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
		public static var AllCustomBlockID:Array=[]
		public static var AllItemID:Array=[]
		//Tile Levels
		public static const Level_NA:String="N/A"
		public static const Level_Top:String="Top"
		public static const Level_Back:String="Back"
		public static const AllTileLevel:Array=[Level_NA,
												Level_Top,
												Level_Back]
		public static const TotalLevelCount:uint=AllTileLevel.length
		
		//==========Getters And Setters==========//
		public static function get AllBlockID():Array
		{
			return TileSystem.AllInternalBlockID.concat(TileSystem.AllCustomBlockID)
		}
		
		public static function get AllTileID():Array
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
			if(General.IsiA(Id,AllTileID))
			{
				return true
			}
			//trace("Not Allow ID:"+Id)
			return false
		}
		
		public static function isAllowLevel(Level:String):Boolean
		{
			if(General.IsiA(Level,AllTileLevel))
			{
				return true
			}
			//trace("Not Allow Level:"+Level)
			return false
		}
		
		//==========Getter Functions===========//
		public static function getHardnessFromID(Id:String):uint
		{
			//Internal Ids
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
		
		//==========Setter Functions===========//
		intc static function addNewTile(infornation:TileInfornation):void
		{
			//Add New TileID
			if(!TileSystem.isAllowID(infornation.tileName))
			{
				TileSystem.AllCustomBlockID.push(infornation.tileName)
			}
			//Add To Shape_Custom
			Shape_Custom.addCurrent(infornation.displaySettings.externalUrl,infornation.tileName,0)
			//Add To Infornations
			TileInfornation.addInfornation(infornation)
		}
	}
}