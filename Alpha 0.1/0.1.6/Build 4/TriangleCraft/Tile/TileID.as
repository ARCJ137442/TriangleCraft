package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	
	public class TileID
	{
		//============Tile IDs============//
		//Void
		public static const Void:TileID=new TileID("Void")
		//Colored Block
		public static const Colored_Block:TileID=new TileID("Colored_Block")
		//Mechine
		public static const Color_Mixer:TileID=new TileID("Color_Mixer")
		public static const Block_Crafter:TileID=new TileID("Block_Crafter")
		public static const Block_Spawner:TileID=new TileID("Block_Spawner")
		public static const Walls_Spawner:TileID=new TileID("Walls_Spawner")
		public static const Arrow_Block:TileID=new TileID("Arrow_Block")
		public static const Inventory_Block:TileID=new TileID("Inventory_Block")
		//Other
		public static const Barrier:TileID=new TileID("Barrier")
		public static const Pushable_Block:TileID=new TileID("Pushable_Block")
		//Signal
		public static const Signal_Wire:TileID=new TileID("Signal_Wire")
		public static const Signal_Diode:TileID=new TileID("Signal_Diode")
		public static const Signal_Patcher:TileID=new TileID("Signal_Patcher")
		public static const Random_Tick_Signal_Generater:TileID=new TileID("Random_Tick_Signal_Generater")
		public static const Wireless_Signal_Transmitter:TileID=new TileID("Wireless_Signal_Transmitter")
		public static const Wireless_Signal_Charger:TileID=new TileID("Wireless_Signal_Charger")
		public static const Signal_Lamp:TileID=new TileID("Signal_Lamp")
		//Signal II
		public static const Block_Update_Detector:TileID=new TileID("Block_Update_Detector")
		public static const Block_Destroyer:TileID=new TileID("Block_Destroyer")
		public static const Signal_Decelerator:TileID=new TileID("Signal_Decelerator")
		public static const Signal_Delayer:TileID=new TileID("Signal_Delayer")
		public static const Signal_Random_Filter:TileID=new TileID("Signal_Random_Filter")
		public static const Block_Pusher:TileID=new TileID("Block_Pusher")
		public static const Block_Puller:TileID=new TileID("Block_Puller")
		public static const Block_Swaper:TileID=new TileID("Block_Swaper")
		//Signal Byte Mechine
		public static const Signal_Byte_Storage:TileID=new TileID("Signal_Byte_Storage")
		public static const Signal_Byte_Getter:TileID=new TileID("Signal_Byte_Getter")
		public static const Signal_Byte_Setter:TileID=new TileID("Signal_Byte_Setter")
		public static const Signal_Byte_Copyer:TileID=new TileID("Signal_Byte_Copyer")
		public static const Signal_Byte_Operator_OR:TileID=new TileID("Signal_Byte_Operator_OR")
		public static const Signal_Byte_Operator_AND:TileID=new TileID("Signal_Byte_Operator_AND")
		public static const Signal_Byte_Operator_XOR:TileID=new TileID("Signal_Byte_Operator_XOR")
		public static const Signal_Byte_Pointer:TileID=new TileID("Signal_Byte_Pointer")
		//Wall
		public static const Basic_Wall:TileID=new TileID("Basic_Wall")
		public static const Ruby_Wall:TileID=new TileID("Ruby_Wall")
		public static const Emerald_Wall:TileID=new TileID("Emerald_Wall")
		public static const Sapphire_Wall:TileID=new TileID("Sapphire_Wall")
		//XX_VIRUS
		public static const XX_Virus:TileID=new TileID("XX_Virus")
		public static const XX_Virus_Red:TileID=new TileID("XX_Virus_Red")
		public static const XX_Virus_Green:TileID=new TileID("XX_Virus_Green")
		public static const XX_Virus_Blue:TileID=new TileID("XX_Virus_Blue")
		public static const XX_Virus_Cyan:TileID=new TileID("XX_Virus_Cyan")
		public static const XX_Virus_Purple:TileID=new TileID("XX_Virus_Purple")
		public static const XX_Virus_Yellow:TileID=new TileID("XX_Virus_Yellow")
		public static const XX_Virus_Black:TileID=new TileID("XX_Virus_Black")
		//Error
		public static const Unknown:TileID=new TileID("Unknown")
		public static const Technical:TileID=new TileID("Technical")
		public static const NoCurrent:TileID=new TileID("NoCurrent")
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _name:String
		
		//============Init Class============//
		public function TileID(name:String):void 
		{
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		//============Instance Functions============//
		public function toString():String
		{
			return this.name
		}
	}
}