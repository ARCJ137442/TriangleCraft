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
			this.addCurrent(TileID.XX_Virus)
			this.addCurrent(TileID.XX_Virus_Red)
			this.addCurrent(TileID.XX_Virus_Blue)
			this.addCurrent(TileID.XX_Virus_Yellow)
			this.addCurrent(TileID.XX_Virus_Green)
			this.addCurrent(TileID.XX_Virus_White)
			this.addCurrent(TileID.XX_Virus_Black)
			this.addCurrent(TileID.XX_Virus_Purple)
		}
	}
}