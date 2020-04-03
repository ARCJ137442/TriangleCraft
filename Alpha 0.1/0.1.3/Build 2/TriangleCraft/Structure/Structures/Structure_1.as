package TriangleCraft.Structure.Structures
{
	//TriangleCraft
	import TriangleCraft.Structure.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.InventoryItem;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class Structure_1 implements IStructure
	{
		//============Instance Variables============//
		private var tileGrid:TileGrid=new TileGrid()
		private var _x:int=0,_y:int=0
		
		//============Instance Functions============//
		public function Structure_1(x_:int,y_:int,size:uint=5,seed:int=0):void
		{
			this.x=x_
			this.y=y_
			//----====Structure====----//
			//Wall And Void
			for(var x:int=-size;x<=size;x++)
			{
				for(var y:int=-size;y<=size;y++)
				{
					if(Math.abs(x)+Math.abs(y)==size)
					{
						if(Math.abs(this.x)%Math.abs(this.y)==0)
						{
							this.tileGrid.setTileAt(x,y,new Tile(null,x,y,TileID.Crystal_Wall))
						}
						else
						{
							this.tileGrid.setTileAt(x,y,new Tile(null,x,y,TileID.Basic_Wall))
						}
					}
					else if(Math.abs(x)+Math.abs(y)<size)
					{
						this.tileGrid.setTileAt(x,y,new Tile(null,x,y,TileID.Void))
					}
				}
			}
			//Walls Spawner
			this.tileGrid.setTileAt(0,0,new Tile(null,0,0,TileID.Walls_Spawner))
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