package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	
	public class Shape_Other extends Shape_Common
	{
		public function Shape_Other():void
		{
			this.addCurrent(1,TileID.Barrier,0)
			this.addCurrent(2,TileID.Pushable_Block,0)
		}
	}
}