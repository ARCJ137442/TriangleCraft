package TriangleCraft.Structure.Structures
{
	//TriangleCraft
	import TriangleCraft.Structure.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.InventoryItem;
	import TriangleCraft.Common.*;
	
	
	public class Structure_2 implements IStructure
	{
		//============Instance Variables============//
		private var tileGrid:TileGrid=new TileGrid()
		private var _x:int=0,_y:int=0
		
		//============Instance Functions============//
		public function Structure_2(x_:int,y_:int,size:uint=5,seed:int=0):void
		{
			this.x=x_
			this.y=y_
			//----====Structure====----//
			//Wall And Void
			for(var x:int=-size;x<=size;x++)
			{
				for(var y:int=-size;y<=size;y++)
				{
					if((Math.abs(x)==size)!=(Math.abs(y)==size))
					{
						this.tileGrid.setTileAt(x,y,new Tile(null,null,x,y,TileID.Colored_Block,0x000000))
					}
					else if((Math.abs(x)==size-1)!=(Math.abs(y)==size-1)||(Math.abs(x)==size-1)&&(Math.abs(y)==size-1))
					{
						this.tileGrid.setTileAt(x,y,new Tile(null,null,x,y,TileID.Colored_Block,0x888888))
					}
					else if(!((Math.abs(x)==size)&&(Math.abs(y)==size)))
					{
						this.tileGrid.setTileAt(x,y,new Tile(null,null,x,y,TileID.Void))
					}
				}
			}
			//Block Spawner
			var ms:uint=Math.floor(size/2)
			this.tileGrid.setTileAt(ms,ms,new Tile(null,null,ms,ms,TileID.Block_Spawner))
			this.tileGrid.setTileAt(-ms,ms,new Tile(null,null,-ms,ms,TileID.Block_Spawner))
			this.tileGrid.setTileAt(-ms,-ms,new Tile(null,null,-ms,-ms,TileID.Block_Spawner))
			this.tileGrid.setTileAt(ms,-ms,new Tile(null,null,ms,-ms,TileID.Block_Spawner))
			//----====Structure====----//
		}
		
		//============Implements From IStructure============//
		public function get blocks():TileGrid
		{
			return this.tileGrid
		}
		
		public function get x():int
		{
			return this._x
		}
		
		public function set x(value:int):void
		{
			this._x=value
		}
		
		public function get y():int
		{
			return this._y
		}
		
		public function set y(value:int):void
		{
			this._y=value
		}
	}
}