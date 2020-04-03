package TriangleCraft.Structure
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	
	
	public interface IStructure
	{
		//============Interface Functions============//
		function get blocks():TileGrid
		function get x():int
		function get y():int
		function set x(value:int):void
		function set y(value:int):void
	}
}