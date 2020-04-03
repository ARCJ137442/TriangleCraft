package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Other extends Shape_Common
	{
		public function Shape_Other():void
		{
			this.setCurrent(1,TileID.Barrier,0)
			this.setCurrent(2,TileID.Pushable_Block,0)
		}
	}
}