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
			//Signal Line
			this.addCurrent(1,TileID.Signal_Wire,0)
			this.addCurrent(2,TileID.Signal_Wire,1)
			this.addCurrent(3,TileID.Signal_Wire,2)
			this.addCurrent(4,TileID.Signal_Wire,3)
			this.addCurrent(5,TileID.Signal_Wire,4)
			this.addCurrent(6,TileID.Signal_Wire,5)
			//Signal Machines
			this.addCurrent(7,TileID.Signal_Patcher,0)
			this.addCurrent(8,TileID.Random_Tick_Signal_Generater,0)
			this.addCurrent(9,TileID.Wireless_Signal_Transmitter,0)
		}
	}
}