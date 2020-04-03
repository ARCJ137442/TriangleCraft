package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileRot;
	import TriangleCraft.Common.*;
	
	
	//Flash
	import flash.geom.Point;
	
	public class MobileRot
	{
		//============STATIC VARIABLES============//
		public static const UP:uint=3
		public static const DOWN:uint=1
		public static const LEFT:uint=2
		public static const RIGHT:uint=0
		
		//============STATIC FUNCTIONS============//
		public static function lockToPositive(rot:int):uint
		{
			return (rot<0?lockToPositive(rot+4):rot)%4
		}
		
		public static function toTileRot(rot:int):uint
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
				return lockToPositive(rot)
			}
		}
		
		public static function randomRot(up:Boolean=true,down:Boolean=true,
										 left:Boolean=true,right:Boolean=true):int
		{
			var listArr:Array=new Array()
			if(up) listArr.push(MobileRot.UP)
			if(down) listArr.push(MobileRot.DOWN)
			if(left) listArr.push(MobileRot.LEFT)
			if(right) listArr.push(MobileRot.RIGHT)
			return General.returnRandom2(listArr)
		}
		
		public static function toOpposite(rot:uint):uint
		{
			return (lockToPositive(rot)+2)%4
		}
		
		public static function toPos(rot:uint,dis:uint=1):Vector.<int>
		{
			var xd:int
			var yd:int
			switch(rot%4)
			{
				case MobileRot.RIGHT:
					xd=dis;
					break;
				case MobileRot.DOWN:
					yd=dis;
					break;
				case MobileRot.LEFT:
					xd=-dis;
					break;
				case MobileRot.UP:
					yd=-dis;
					break;
			}
			return new <int>[xd,yd];;
		}
		
		public static function toPosPoint(rot:uint,dis:uint=1):Point
		{
			var xd:int
			var yd:int
			switch(rot%4)
			{
				case MobileRot.RIGHT:
					xd=dis;
					break;
				case MobileRot.DOWN:
					yd=dis;
					break;
				case MobileRot.LEFT:
					xd=-dis;
					break;
				case MobileRot.UP:
					yd=-dis;
					break;
			}
			return new Point(xd,yd);
		}
	}
}