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
			this.setCurrent(1,TileID.NoCurrent,0)
			this.setCurrent(2,TileID.Technical,0)
			this.setCurrent(3,TileID.Unknown,0)
		}
	}
}