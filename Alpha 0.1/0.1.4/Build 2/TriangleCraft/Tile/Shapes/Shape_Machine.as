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
			this.addCurrent(TileID.Color_Mixer)
			this.addCurrent(TileID.Block_Crafter)
			this.addCurrent(TileID.Block_Spawner)
			this.addCurrent(TileID.Arrow_Block)
			this.addCurrent(TileID.Walls_Spawner)
			this.addCurrent(TileID.Inventory_Block)
		}
	}
}