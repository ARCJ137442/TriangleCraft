﻿package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileRot;
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.geom.Point;
	
	public class MobileRot
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
			if(up) listArr.push(MobileRot.UP)
			if(down) listArr.push(MobileRot.DOWN)
			if(left) listArr.push(MobileRot.LEFT)
			if(right) listArr.push(MobileRot.RIGHT)
			return General.returnRandom2(listArr)
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