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
																		  TileID.Crystal_Wall,
																		  TileID.Block_Spawner,
																		  TileID.Walls_Spawner,
																		  TileID.Inventory_Block,
																		  TileID.Arrow_Block,
																		  TileID.Barrier,
																		  TileID.Pushable_Block,
																		  TileID.XX_Virus,
																		  TileID.XX_Virus_Red,
																		  TileID.XX_Virus_Green,
																		  TileID.XX_Virus_Blue,
																		  TileID.XX_Virus_Cyan,
																		  TileID.XX_Virus_Purple,
																		  TileID.XX_Virus_Yellow,
																		  TileID.XX_Virus_Black,
																		  TileID.Signal_Wire,
																		  TileID.Signal_Diode,
																		  TileID.Signal_Decelerator,
																		  TileID.Wireless_Signal_Transmitter,
																		  TileID.Wireless_Signal_Charger,
																		  TileID.Signal_Patcher,
																		  TileID.Random_Tick_Signal_Generater,
																		  TileID.Block_Update_Detector,
																		  TileID.Signal_Lamp,
																		  TileID.Block_Destroyer,
																		  TileID.Block_Pusher,
																		  TileID.Block_Puller,
																		  TileID.Block_Swaper,
																		  TileID.Signal_Byte_Storage,
																		  TileID.Signal_Byte_Getter,
																		  TileID.Signal_Byte_Setter,
																		  TileID.Signal_Byte_Copyer]
		public static var AllCustomBlockID:Vector.<String>=new <String>[]
		public static var AllItemID:Vector.<String>=new <String>[]
		public static var AllSpecialID:Vector.<String>=new <String>[TileID.Technical,
																	TileID.Unknown,
																	TileID.NoCurrent]
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
			if(TileSystem.AllTileID.indexOf(Id)>-1||
			   TileSystem.AllSpecialID.indexOf(Id)>-1)
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

		public static function isVirus(id:String):Boolean
		{
			return TileIDSpace.VIRUS.has(id)
		}

		public static function isWall(id:String):Boolean
		{
			return TileIDSpace.WALL.has(id)
		}

		public static function isMechine(id:String):Boolean
		{
			return (TileIDSpace.MECHINES.has(id)||
					TileIDSpace.MECHINES_SIGNAL.has(id))
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
					return 1+tcMath.random(2);
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Yellow:
				case TileID.XX_Virus_Green:
				case TileID.XX_Virus_Purple:
				case TileID.XX_Virus_Black:
					return 1;
				case TileID.XX_Virus_Blue:
					return 2+tcMath.random(9);
				case TileID.XX_Virus_Cyan:
					return 4;
				//Wall
				case TileID.Basic_Wall:
					return 8;
				case TileID.Crystal_Wall:
					return 12;
				//Machine
				case TileID.Inventory_Block:
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				case TileID.Block_Crafter:
				case TileID.Color_Mixer:
					return 4;
				//Signal Machine
				case TileID.Signal_Wire:
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
					return 1;
				case TileID.Signal_Patcher:
				case TileID.Random_Tick_Signal_Generater:
				case TileID.Block_Update_Detector:
				case TileID.Signal_Lamp:
				case TileID.Block_Destroyer:
				case TileID.Block_Pusher:
				case TileID.Block_Puller:
				case TileID.Block_Swaper:
				case TileID.Signal_Byte_Storage:
					return 4;
				//Signal Byte Getter|Setter,Wireless Signal Transmitter
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
				case TileID.Signal_Byte_Copyer:
				case TileID.Wireless_Signal_Transmitter:
				case TileID.Wireless_Signal_Charger:
					return 2
					break
				//Other
				case TileID.Barrier:
					return 4096;
				case TileID.Colored_Block:
				case TileID.Arrow_Block:
				case TileID.Pushable_Block:
					return 3;
			}
			//Custom Ids
			if(TileInformation.hasInfornationByID(Id))
			{
				return TileInformation.getInfornationByID(Id).defaultMaxHard
			}
			return 0;
		}
		
		public static function getLevelFromID(Id:String):String
		{
			switch(Id)
			{
				case TileID.Signal_Wire:
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
				case TileID.Signal_Byte_Copyer:
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