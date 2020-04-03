package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	
	public class TileDisplayLevel
	{
		//============Static Variables============//
		public static const NULL:TileDisplayLevel=null
		
		public static const TOP:TileDisplayLevel=new TileDisplayLevel("Top")
		public static const BACK:TileDisplayLevel=new TileDisplayLevel("Back")
		public static const ALL_LEVEL:Vector.<TileDisplayLevel>=new <TileDisplayLevel>[NULL,
																						  TOP,
																						  BACK]
		
		//============Static Getter And Setter============//
		public function get TOTAL_LEVEL_COUNT():uint
		{
			return ALL_LEVEL.length
		}
		
		//============Instance Variables============//
		protected var _name:String
		
		//============Init Class============//
		public function TileDisplayLevel(name:String):void
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