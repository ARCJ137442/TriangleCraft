package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Signal extends Shape_Common
	{
		public function Shape_Signal():void
		{
			//====Signal Wire====//
			this.addCurrent(TileID.Signal_Wire,0)
			this.addCurrent(TileID.Signal_Wire,1)
			this.addCurrent(TileID.Signal_Wire,2)
			this.addCurrent(TileID.Signal_Wire,3)
			this.addCurrent(TileID.Signal_Wire,4)
			this.addCurrent(TileID.Signal_Wire,5)
			//====Signal Diode====//
			this.addCurrent(TileID.Signal_Diode,0)
			this.addCurrent(TileID.Signal_Diode,1)
			this.addCurrent(TileID.Signal_Diode,2)
			this.addCurrent(TileID.Signal_Diode,3)
			//====Signal Diode====//
			this.addCurrent(TileID.Signal_Decelerator,0)
			this.addCurrent(TileID.Signal_Decelerator,1)
			this.addCurrent(TileID.Signal_Decelerator,2)
			this.addCurrent(TileID.Signal_Decelerator,3)
			//====Signal Machines====//
			this.addCurrent(TileID.Signal_Patcher)
			this.addCurrent(TileID.Random_Tick_Signal_Generater)
			this.addCurrent(TileID.Wireless_Signal_Transmitter)
			//====Signal Lamp With Colors====//
			this.addCurrent(TileID.Signal_Lamp,0)
			this.addCurrent(TileID.Signal_Lamp,1)
			this.addCurrent(TileID.Signal_Lamp,2)
			this.addCurrent(TileID.Signal_Lamp,3)
			this.addCurrent(TileID.Signal_Lamp,4)
			this.addCurrent(TileID.Signal_Lamp,5)
			this.addCurrent(TileID.Signal_Lamp,6)
			//====Signal Machines II====//
			this.addCurrent(TileID.Block_Update_Detector)
			this.addCurrent(TileID.Block_Destroyer)
		}
	}
}