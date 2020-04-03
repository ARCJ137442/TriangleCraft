package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Virus extends Shape_Common
	{
		public function Shape_Virus():void
		{
			this.addCurrent(1,TileID.XX_Virus,0)
			this.addCurrent(2,TileID.XX_Virus_Red,0)
			this.addCurrent(3,TileID.XX_Virus_Blue,0)
		}
	}
}