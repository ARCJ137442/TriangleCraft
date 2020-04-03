package TriangleCraft.General
{
	//TriangleCraft
	import TriangleCraft.Tile.TileRot;
	import TriangleCraft.Common.*;
	
	
	//Flash
	import flash.geom.Point;
	
	public class MobileRot
	{
		//============STATIC VARIABLES============//
		public static const ROT_UP:uint=3
		public static const ROT_DOWN:uint=1
		public static const ROT_LEFT:uint=2
		public static const ROT_RIGHT:uint=0
		
		//============STATIC FUNCTIONS============//
		public static function lockRotToPositive(rot:int):uint
		{
			return (rot<0?lockRotToPositive(rot+4):rot)%4
		}
		
		public static function mobileRotToTileRot(rot:int):uint
		{
			switch(rot%4)
			{
				case ROT_UP:
				return MobileRot.ROT_UP
				case ROT_DOWN:
				return MobileRot.ROT_DOWN
				case ROT_LEFT:
				return MobileRot.ROT_LEFT
				case ROT_RIGHT:
				return MobileRot.ROT_RIGHT
				default:
				return lockRotToPositive(rot)
			}
		}
		
		public static function randomRot(up:Boolean=true,down:Boolean=true,left:Boolean=true,right:Boolean=true):int
		{
			var listArr:Array=new Array()
			if(up) listArr.push(MobileRot.ROT_UP)
			if(down) listArr.push(MobileRot.ROT_DOWN)
			if(left) listArr.push(MobileRot.ROT_LEFT)
			if(right) listArr.push(MobileRot.ROT_RIGHT)
			return General.returnRandom2(listArr)
		}
		
		public static function toOpposite(rot:uint):uint
		{
			return (lockRotToPositive(rot)+2)%4
		}
		
		public static function rotToPos(rot:uint,dis:uint=1):Vector.<int>
		{
			var xd:int
			var yd:int
			switch(rot%4)
			{
				case MobileRot.ROT_RIGHT:
					xd=dis;
					break;
				case MobileRot.ROT_DOWN:
					yd=dis;
					break;
				case MobileRot.ROT_LEFT:
					xd=-dis;
					break;
				case MobileRot.ROT_UP:
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
				case MobileRot.ROT_RIGHT:
					xd=dis;
					break;
				case MobileRot.ROT_DOWN:
					yd=dis;
					break;
				case MobileRot.ROT_LEFT:
					xd=-dis;
					break;
				case MobileRot.ROT_UP:
					yd=-dis;
					break;
			}
			return new Point(xd,yd);
		}
	}
}