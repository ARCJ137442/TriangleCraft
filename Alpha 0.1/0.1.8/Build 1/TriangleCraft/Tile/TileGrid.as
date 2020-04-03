package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.*
	import TriangleCraft.Common.*;
	
	
	public class TileGrid extends Object
	{
		//============Instance Variables============//
		protected var _data:Object=new Object()
		
		//============Static Functions============//
		public static function toIndex(x:int,y:int):String
		{
			return String(x+"_"+y)
		}
		
		//============Init TileGrid============//
		public function TileGrid():void
		{
			
		}
		
		//============Methods============//
		public function hasTileAt(x:int,y:int):Boolean
		{
			return (toIndex(x,y) in this._data)&&(this._data[toIndex(x,y)] is TriangleCraft.Tile.Tile)
		}
		
		public function getTileAt(x:int,y:int):Tile
		{
			if(this.hasTileAt(x,y))
			{
				return this._data[toIndex(x,y)] as Tile
			}
			else return null
		}
		
		public function setTileAt(x:int,y:int,tile:Tile,forceOld:Boolean=true):void
		{
			if(!hasTileAt(x,y)||forceOld)
			{
				this._data[toIndex(x,y)]=tile
			}
		}
		
		public function setNullAt(x:int,y:int,forceOld:Boolean=true)
		{
			if(!hasTileAt(x,y)||forceOld)
			{
				this._data[toIndex(x,y)]=null
			}
		}
		
		public function clearTileAt(x:int,y:int,needRemove:Boolean=true):void
		{
			if(hasTileAt(x,y))
			{
				if(needRemove) getTileAt(x,y).removeSelf()
				setTileAt(x,y,null)
			}
		}
		
		public function deleteTileAt(x:int,y:int,needRemove:Boolean=true):void
		{
			if(this._data.hasOwnProperty(toIndex(x,y)))
			{
				if(needRemove)getTileAt(x,y).removeSelf()
				delete this._data[toIndex(x,y)]
			}
		}
		
		public function clearRandomTile():void
		{
			for(var index in this._data)
			{
				if(this._data[index]!=null&&this._data[index] is Tile)
				{
					var tile:Tile=this._data[index] as Tile
					tile.removeSelf()
					delete this._data[index]
					return
				}
			}
		}
		
		public function clearAllVoid():void
		{
			for(var index in this._data)
			{
				var tile:Tile=this._data[index] as Tile
				if(tile==null) delete this._data[index]
			}
		}
		
		public function clearAllTile(needRemove:Boolean=true):void
		{
			if(needRemove)
			{
				for each(var tile in this._data)
				{
					if(tile is Tile) (tile as Tile).removeSelf()
				}
			}
			this._data=new Object()
		}
		
		//============Getters============//
		public function get allTileCount():uint
		{
			var returnCount:uint
			for each(var tile in this._data)
			{
				if(tile!=null)returnCount++
			}
			return returnCount
		}
		
		public function get allVoidCount():uint
		{
			var returnCount:uint
			for each(var tile in this._data)
			{
				if(tile==null)returnCount++
			}
			return returnCount
		}
		
		public function get randomTile():Tile
		{
			for each(var tile in this._data)
			{
				return (tile as Tile)
			}
			return null
		}
		
		public function get tileData():Object
		{
			return this._data
		}
	}
}