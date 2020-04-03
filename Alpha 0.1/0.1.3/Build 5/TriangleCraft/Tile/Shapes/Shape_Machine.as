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
			this.setCurrent(1,TileID.Color_Mixer,0)
			this.setCurrent(2,TileID.Block_Crafter,0)
			this.setCurrent(3,TileID.Block_Spawner,0)
			this.setCurrent(4,TileID.Arrow_Block,0)
			this.setCurrent(5,TileID.Walls_Spawner,0)
			this.setCurrent(6,TileID.Inventory_Block,0)
		}
	}
}