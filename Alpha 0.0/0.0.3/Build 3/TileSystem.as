package 
{
	import General;
	import TileTag;
	public class TileSystem
	{
		function TileSystem(Sys:TileSystem)
		{
			
		}
		//==========Idefined==========//
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
		
		public static const AllTileID:Array=[Void,
											 Colored_Block,
											 Color_Mixer,
											 Block_Crafter,
											 Basic_Wall,
											 Block_Spawner,
											 XX_Virus,
											 XX_Virus_Red,
											 XX_Virus_Blue,
											 Arrow_Block]
		public static const globalTileSize:uint=32;
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
		
		public static function getHardnessFromID(Id:String):uint
		{
			switch (Id)
			{
				case Arrow_Block:
					return 3;
					break;
				case XX_Virus_Blue:
					return 2;
					break;
				case XX_Virus_Red:
					return 1;
					break;
				case XX_Virus:
					return 1+Game.random(2);
					break;
				case Block_Spawner:
					return 4;
					break;
				case Basic_Wall:
					return 8;
					break;
				case Block_Crafter:
					return 4;
					break;
				case Color_Mixer:
					return 4;
					break;
				case Colored_Block:
					return 3;
					break;
				case Void:
					return 0;
					break;
			}
			return 0;
		}
		
		protected static function getFrameByID(Id:String):uint
		{
			if(isAllowID(Id)&&!needColor(Id))
			{
				switch(Id)
				{
					case Color_Mixer:
					return 1
					break
					case Block_Crafter:
					return 2
					break
					case Basic_Wall:
					return 3
					break
					case Block_Spawner:
					return 4
					break
					case XX_Virus:
					return 5
					break
					case XX_Virus_Red:
					return 6
					break
					case XX_Virus_Blue:
					return 7
					break
					case Arrow_Block:
					return 8
					break
				}
			}
			return 0
		}
		
		protected static function needColor(Id:String):Boolean
		{
			if(isAllowID(Id))
			{
				if(Id==Void||Id==Colored_Block)
				{
					return true
				}
			}
			return false
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			return TileTag.getTagFromID(Id)
		}
	}
}