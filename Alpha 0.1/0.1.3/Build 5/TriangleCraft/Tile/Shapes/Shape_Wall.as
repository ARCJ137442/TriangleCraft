﻿package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.Shapes.Shape_Common
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Shape_Wall extends Shape_Common
	{
		public function Shape_Wall():void
		{
			this.setCurrent(1,TileID.Basic_Wall,0)
			this.setCurrent(2,TileID.Crystal_Wall,0)
		}
	}
}