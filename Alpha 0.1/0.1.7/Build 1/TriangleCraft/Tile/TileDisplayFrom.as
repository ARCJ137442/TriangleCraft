package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	
	public class TileDisplayFrom
	{
		//============Static Variables============//
		public static const NULL:TileDisplayFrom=null
		
		public static const IN_GAME:TileDisplayFrom=new TileDisplayFrom("inGame")
		public static const IN_PLAYER:TileDisplayFrom=new TileDisplayFrom("inPlayer")
		public static const IN_ENTITY:TileDisplayFrom=new TileDisplayFrom("inEntity")
		public static const UNKNOWN:TileDisplayFrom=new TileDisplayFrom("unknown")
		
		//============Instance Variables============//
		protected var _name:String
		
		//============Init Class============//
		public function TileDisplayFrom(name:String):void
		{
			this._name=name
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name
		}
	}
}