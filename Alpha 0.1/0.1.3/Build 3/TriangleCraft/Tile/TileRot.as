package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Entity.Mobile.MobileRot;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class TileRot
	{
		//============STATIC VARIABLES============//
		intc static const UP:int=3
		intc static const DOWN:int=1
		intc static const LEFT:int=2
		intc static const RIGHT:int=0
		
		//============STATIC FUNCTIONS============//
		public static function toTileRot(rot:int):int
		{
			switch(rot%4)
			{
				case UP:
				return MobileRot.UP
				case DOWN:
				return MobileRot.DOWN
				case LEFT:
				return MobileRot.LEFT
				case RIGHT:
				return MobileRot.RIGHT
				default:
				return rot
			}
		}
		
		public static function randomRot(up:Boolean=true,down:Boolean=true,
										 left:Boolean=true,right:Boolean=true):int
		{
			var listArr:Array=new Array()
			if(up) listArr.push(TileRot.UP)
			if(down) listArr.push(TileRot.DOWN)
			if(left) listArr.push(TileRot.LEFT)
			if(right) listArr.push(TileRot.RIGHT)
			return General.returnRandom2(listArr)
		}
	}
}