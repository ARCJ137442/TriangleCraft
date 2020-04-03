package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	
	//Class
	public class TileSystem
	{
		//==========Idefined==========//
		//Global
		public static const globalTileSize:uint=32
		
		public static const AllInternalBlockID:Vector.<TileID>=new <TileID>[
			TileID.Void,
			TileID.Colored_Block,
			TileID.Color_Mixer,
			TileID.Color_Adder,
			TileID.Block_Crafter,
			TileID.Basic_Wall,
			TileID.Ruby_Wall,
			TileID.Emerald_Wall,
			TileID.Sapphire_Wall,
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
			TileID.Signal_Wire_Block,
			TileID.Signal_Diode,
			TileID.Signal_Decelerator,
			TileID.Signal_Delayer,
			TileID.Signal_Random_Filter,
			TileID.Wireless_Signal_Transmitter,
			TileID.Wireless_Signal_Charger,
			TileID.Signal_Patcher,
			TileID.Random_Tick_Signal_Generater,
			TileID.Block_Update_Detector,
			TileID.Signal_Clock,
			TileID.Signal_Lamp,
			TileID.Block_Destroyer,
			TileID.Block_Pusher,
			TileID.Block_Puller,
			TileID.Block_Swaper,
			TileID.Block_Lasher,
			TileID.Block_Thrower,
			TileID.Block_Transporter,
			TileID.Signal_Byte_Storage,
			TileID.Signal_Byte_Trigger,
			TileID.Signal_Byte_Pointer,
			TileID.Signal_Byte_Getter,
			TileID.Signal_Byte_Setter,
			TileID.Signal_Byte_Copyer,
			TileID.Signal_Byte_Operator_OR,
			TileID.Signal_Byte_Operator_AND,
			TileID.Signal_Byte_Operator_XOR]
		public static const AllInternalItemID:Vector.<TileID>=new <TileID>[]
		public static var AllCustomBlockID:Vector.<TileID>=new <TileID>[]
		public static var AllCustomItemID:Vector.<TileID>=new <TileID>[]
		public static var AllSpecialID:Vector.<TileID>=new <TileID>[TileID.Technical,
																	TileID.Unknown,
																	TileID.NoCurrent]
		
		//==========Getters And Setters==========//
		public static function get AllBlockID():Vector.<TileID>
		{
			return TileSystem.AllInternalBlockID.concat(TileSystem.AllCustomBlockID)
		}
		
		public static function get AllItemID():Vector.<TileID>
		{
			return TileSystem.AllInternalItemID.concat(TileSystem.AllCustomItemID)
		}
		
		public static function get AllInternalTileID():Vector.<TileID>
		{
			return TileSystem.AllInternalBlockID.concat(TileSystem.AllInternalItemID)
		}
		
		public static function get AllCustomTileID():Vector.<TileID>
		{
			return TileSystem.AllCustomBlockID.concat(TileSystem.AllCustomItemID)
		}

		public static function get AllTileID():Vector.<TileID>
		{
			return AllBlockID.concat(AllItemID)
		}
		
		public static function get TotalTileCount():uint
		{
			return TileSystem.AllTileID.length
		}

		//==========Test Functions===========//
		public static function isAllowID(id:TileID):Boolean
		{
			if(TileSystem.AllTileID.indexOf(id)>-1||
			   TileSystem.AllSpecialID.indexOf(id)>-1)
			{
				return true
			}
			trace("Not Allow ID:"+id)
			return false
		}

		public static function isAllowLevel(Level:TileDisplayLevel):Boolean
		{
			if(TileDisplayLevel.ALL_LEVEL.indexOf(Level)>-1)
			{
				return true
			}
			trace("Not Allow Level:"+Level)
			return false
		}

		public static function isInternalID(id:TileID):Boolean
		{
			return id in TileSystem.AllInternalTileID
		}

		public static function isCustomID(id:TileID):Boolean
		{
			return id in TileSystem.AllCustomTileID
		}

		public static function isVirus(id:TileID):Boolean
		{
			return TileIDSpace.VIRUS.has(id)
		}

		public static function isWall(id:TileID):Boolean
		{
			return TileIDSpace.WALL.has(id)
		}

		public static function isMechine(id:TileID):Boolean
		{
			return (TileIDSpace.MECHINES.has(id)||
					TileIDSpace.MECHINES_SIGNAL.has(id))
		}
		
		public static function needColor(Id:TileID):Boolean
		{
			switch(Id)
			{
				case TileID.Colored_Block:
				return true
				default:return false
			}
		}
	}
}