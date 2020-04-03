package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Machine extends Shape_Common
	{
		public function Shape_Machine():void
		{
			this.addCurrent(1,TileID.Color_Mixer,0)
			this.addCurrent(2,TileID.Block_Crafter,0)
			this.addCurrent(3,TileID.Block_Spawner,0)
			this.addCurrent(4,TileID.Arrow_Block,0)
			this.addCurrent(5,TileID.Walls_Spawner,0)
			this.addCurrent(6,TileID.Inventory_Block,0)
		}
	}
}