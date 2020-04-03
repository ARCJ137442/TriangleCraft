package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.General
	import TriangleCraft.Tile.Tile
	
	public class TileGrid
	{
		//==========Variables==========//
		private var TilesAO:Tile
		
		private var TilesAx:Array=new Array()
		private var TilesAx_:Array=new Array()
		
		private var TilesAy:Array=new Array()
		private var TilesAy_:Array=new Array()
		
		private var TilesAxy:Array=new Array()
		private var TilesAx_y:Array=new Array()
		private var TilesAx_y_:Array=new Array()
		private var TilesAxy_:Array=new Array()
		
		public function TileGrid()
		{
			//Constructor Code
		}
		
		public function getTileAt(x:int,y:int):Tile
		{
			this.setAllArray(x,y)
			if(x==0)
			{
				if(y>0) return this.TilesAy[y] as Tile
				if(y==0) return this.TilesAO as Tile
				if(y>0) return this.TilesAy_[y] as Tile
			}
			else if(y==0)
			{
				if(x>0) return this.TilesAx[x] as Tile
				if(x<0) return this.TilesAx_[x] as Tile
			}
			else
			{
				if(x>0&&y>0) return this.TilesAxy[x][y] as Tile
				if(x<0&&y>0) return this.TilesAx_y[x][y] as Tile
				if(x<0&&y<0) return this.TilesAx_y_[x][y] as Tile
				if(x>0&&y<0) return this.TilesAxy_[x][y] as Tile
			}
			return null
		}
		
		public function setTileAt(x:int,y:int,T:Tile):void
		{
			this.setAllArray(x,y)
			if(x==0)
			{
				if(y>0) this.TilesAy[y]=T
				if(y==0) this.TilesAO=T
				if(y>0) this.TilesAy_[y]=T
			}
			else if(y==0)
			{
				if(x>0) this.TilesAx[x]=T
				if(x<0) this.TilesAx_[x]=T
			}
			else
			{
				if(x>0&&y>0) this.TilesAxy[x][y]=T
				if(x<0&&y>0) this.TilesAx_y[x][y]=T
				if(x<0&&y<0) this.TilesAx_y_[x][y]=T
				if(x>0&&y<0) this.TilesAxy_[x][y]=T
			}
		}
		
		public function get AllTiles():Array
		{
			return new Array(this.TilesAO).concat(this.TilesAx,this.TilesAx_,
												  this.TilesAy,this.TilesAy_,
												  this.TilesAxy,this.TilesAxy_,
												  this.TilesAx_y,this.TilesAx_y_)
		}
		
		public function clearAllTile():void
		{
			//Remove Tiles
			for each(var tile in this.AllTiles)
			{
				if(tile is Tile)
				{
					tile.removeSelf()
				}
			}
			//Clear Variables
			this.resetVariables()
		}
		
		private function setAllArray(x:int,y:int):void
		{
			var loc:uint=Math.abs(x)
			var loc2:uint=Math.abs(y)
			
			this.TilesAx.length=Math.min(this.TilesAx.length,loc)
			this.TilesAx_.length=Math.min(this.TilesAx_.length,loc)
			this.TilesAy.length=Math.min(this.TilesAy.length,loc)
			this.TilesAy_.length=Math.min(this.TilesAy_.length,loc)
			this.TilesAxy.length=Math.min(this.TilesAxy.length,loc)
			this.TilesAx_y.length=Math.min(this.TilesAx_y.length,loc)
			this.TilesAx_y_.length=Math.min(this.TilesAx_y_.length,loc)
			this.TilesAxy_.length=Math.min(this.TilesAxy_.length,loc)
			
			if(!this.TilesAx[loc] is Array)
			{
				this.TilesAx[loc]=new Array()
			}
			if(!this.TilesAx_[loc] is Array)
			{
				this.TilesAx_[loc]=new Array()
			}
			if(!this.TilesAy[loc] is Array)
			{
				this.TilesAy[loc]=new Array()
			}
			if(!this.TilesAy_[loc] is Array)
			{
				this.TilesAy_[loc]=new Array()
			}
			if(!this.TilesAxy[loc] is Array)
			{
				this.TilesAxy[loc]=new Array()
			}
			if(!this.TilesAx_y[loc] is Array)
			{
				this.TilesAx_y[loc]=new Array()
			}
			if(!this.TilesAx_y_[loc] is Array)
			{
				this.TilesAx_y_[loc]=new Array()
			}
			if(!this.TilesAxy_[loc] is Array)
			{
				this.TilesAxy_[loc]=new Array()
			}
			this.TilesAx[loc].length=Math.min(this.TilesAx[loc].length,loc2)
			this.TilesAx_[loc].length=Math.min(this.TilesAx_[loc].length,loc2)
			this.TilesAy[loc].length=Math.min(this.TilesAy[loc].length,loc2)
			this.TilesAy_[loc].length=Math.min(this.TilesAy_[loc].length,loc2)
			this.TilesAxy[loc].length=Math.min(this.TilesAxy[loc].length,loc2)
			this.TilesAx_y[loc].length=Math.min(this.TilesAx_y[loc].length,loc2)
			this.TilesAx_y_[loc].length=Math.min(this.TilesAx_y_[loc].length,loc2)
			this.TilesAxy_[loc].length=Math.min(this.TilesAxy_[loc].length,loc2)
		}
		
		private function resetVariables():void
		{
			this.TilesAO=null
			this.TilesAx=new Array()
			this.TilesAx_=new Array()
			this.TilesAy=new Array()
			this.TilesAy_=new Array()
			this.TilesAxy=new Array()
			this.TilesAx_y=new Array()
			this.TilesAx_y_=new Array()
			this.TilesAxy_=new Array()
		}
	}
}