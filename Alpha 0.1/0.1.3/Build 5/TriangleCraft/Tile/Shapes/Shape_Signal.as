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
			//Signal Wire
			this.setCurrent(1,TileID.Signal_Wire,0)
			this.setCurrent(2,TileID.Signal_Wire,1)
			this.setCurrent(3,TileID.Signal_Wire,2)
			this.setCurrent(4,TileID.Signal_Wire,3)
			this.setCurrent(5,TileID.Signal_Wire,4)
			this.setCurrent(6,TileID.Signal_Wire,5)
			//Signal Machines
			this.setCurrent(7,TileID.Signal_Patcher)
			this.setCurrent(8,TileID.Random_Tick_Signal_Generater)
			this.setCurrent(9,TileID.Wireless_Signal_Transmitter)
			//Signal Lamp With Colors
			this.setCurrent(10,TileID.Signal_Lamp,0)
			this.setCurrent(11,TileID.Signal_Lamp,1)
			this.setCurrent(12,TileID.Signal_Lamp,2)
			this.setCurrent(13,TileID.Signal_Lamp,3)
			this.setCurrent(14,TileID.Signal_Lamp,4)
			this.setCurrent(15,TileID.Signal_Lamp,5)
			this.setCurrent(16,TileID.Signal_Lamp,6)
			//Signal Machines II
			this.setCurrent(17,TileID.Block_Update_Detector)
		}
	}
}