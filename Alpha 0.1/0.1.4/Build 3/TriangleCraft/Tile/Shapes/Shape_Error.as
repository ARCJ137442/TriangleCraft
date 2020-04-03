package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Error extends Shape_Common
	{
		public function Shape_Error():void
		{
			this.addCurrent(TileID.NoCurrent)
			this.addCurrent(TileID.Technical)
			this.addCurrent(TileID.Unknown)
		}
	}
}