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
			this.setCurrent(1,TileID.XX_Virus,0)
			this.setCurrent(2,TileID.XX_Virus_Red,0)
			this.setCurrent(3,TileID.XX_Virus_Blue,0)
			this.setCurrent(4,TileID.XX_Virus_Yellow,0)
			this.setCurrent(5,TileID.XX_Virus_Green,0)
			this.setCurrent(6,TileID.XX_Virus_White,0)
			this.setCurrent(7,TileID.XX_Virus_Black,0)
		}
	}
}