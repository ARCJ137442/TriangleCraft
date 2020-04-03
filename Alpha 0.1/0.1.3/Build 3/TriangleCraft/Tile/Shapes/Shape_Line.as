package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc

	public class Shape_Line extends Shape_Common
	{
		//============Init Line============//
		public function Shape_Line():void
		{
			this.addCurrent(1,TileID.Link_Line,0)
			this.addCurrent(2,TileID.Link_Line,1)
			this.addCurrent(3,TileID.Link_Line,2)
			this.addCurrent(4,TileID.Link_Line,3)
			this.addCurrent(5,TileID.Link_Line,4)
			this.addCurrent(6,TileID.Link_Line,5)
		}
	}

}