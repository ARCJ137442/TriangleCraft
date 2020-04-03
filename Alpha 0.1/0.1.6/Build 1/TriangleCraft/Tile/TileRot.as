package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Entity.Mobile.MobileRot;
	import TriangleCraft.Common.*;
	
	
	//Flash
	import flash.geom.Point;
	
	public class TileRot
	{
		//============STATIC VARIABLES============//
		public static const UP:int=3
		public static const DOWN:int=1
		public static const LEFT:int=2
		public static const RIGHT:int=0
		
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
		
		public static function toOpposite(rot:uint):uint
		{
			return (rot+2)%4
		}
		
		public static function toPos(rot:uint,dis:uint=1):Vector.<int>
		{
			var xd:int
			var yd:int
			switch(rot%4)
			{
				case TileRot.RIGHT:
					xd=dis;
					break;
				case TileRot.DOWN:
					yd=dis;
					break;
				case TileRot.LEFT:
					xd=-dis;
					break;
				case TileRot.UP:
					yd=-dis;
					break;
			}
			return new <int>[xd,yd];
		}
		
		public static function toPosPoint(rot:uint,dis:uint=1):Point
		{
			var xd:int
			var yd:int
			switch(rot%4)
			{
				case TileRot.RIGHT:
					xd=dis;
					break;
				case TileRot.DOWN:
					yd=dis;
					break;
				case TileRot.LEFT:
					xd=-dis;
					break;
				case TileRot.UP:
					yd=-dis;
					break;
			}
			return new Point(xd,yd);
		}
	}
}