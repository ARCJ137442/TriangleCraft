package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*;

	//Flash
	import flash.errors.IllegalOperationError;

	//Class
	public class Tile extends TileDisplayObj implements IhasInventory
	{
		//================Instance Variables================//
		//==========Graphics==========//
		public var level:TileDisplayLevel=TileDisplayLevel.NULL;
		
		//==========Attributes==========//
		protected var _inventory:ItemList
		protected var _customVariables:TileCustomVariables=new TileCustomVariables()
		
		protected var _host:Game
		protected var _tickRunFunction:Function;

		//============Init Tile============//
		public function Tile(displayFrom:TileDisplayFrom,
							 host:Game,
							 x:int,y:int,
							 id:TileID,data:uint=0,rot:int=0,
							 level:TileDisplayLevel=TileDisplayLevel.NULL,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Host
			this._host=host
			//super
			super(displayFrom,x,y,id,data,rot,sizeX,sizeY)
		}

		//============Implements IhasInventory============//
		public function get inventory():ItemList
		{
			if(this.attributes.hasInventory)
			{
				if(this._inventory==null) this._inventory=new ItemInventory()
				return this._inventory
			}
			else
			{
				return null
			}
		}
		
		public function get allItemCount():uint
		{
			return this.inventory==null?0:this.inventory.itemCount
		}
		
		public function get allItemTypeCount():uint
		{
			return this.inventory==null?0:this.inventory.typeCount
		}
		
		public function addItem(id:TileID,count:uint=1,data:int=0):void
		{
			if(this.inventory==null) return
			this.inventory.addItem(id,count,data)
		}
		
		public function removeItem(id:TileID,count:uint=1,data:int=0):void
		{
			if(this.inventory==null) return
			this.inventory.removeItem(id,count,data)
		}
		
		public function hasItemIn(id:TileID,count:uint=1,data:int=0):Boolean
		{
			if(this.inventory==null) return false
			return this.inventory.hasItemIn(new InventoryItem(id,count,data))
		}

		//============Change Functions============//
		public override function changeTile(id:TileID,data:uint=0,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			super.changeTile(id,data,rot,hard,maxHard)
			if(TileSystem.isAllowID(id))
			{
				//Set Level
				setLevel()
			}
		}

		protected function setLevel()
		{
			this.level=TileAttributes.getDisplayLevelByID(this.id)
		}

		public function get dropItems():ItemList
		{
			var returnDropItems=new ItemList()
			if(!this.attributes.technical)
			{
				returnDropItems.addItem(this._id,1,this._data)
			}
			else if(this.attributes.replaceDropAs!=null)
			{
				var replaceID:TileID=this.attributes.replaceDropAs
				var replaceAttributes:TileAttributes
				while(replaceID!=null)
				{
					replaceAttributes=TileAttributes.fromID(replaceID)
					if(replaceAttributes.technical)
					{
						replaceID=replaceAttributes.replaceDropAs
					}
					else
					{
						returnDropItems.addItem(replaceID,1,this._data)
						break
					}
				}
			}
			//Drop Inventory
			if(this.attributes.hasInventory&&this.attributes.dropInventory)
			{
				if(this.inventory.hasItem)
				{
					returnDropItems.addItemsFromInventory(this._inventory)
				}
			}
			return returnDropItems
		}

		public function get customVariables():TileCustomVariables
		{
			return this._customVariables
		}

		//==========Transform Function==========//
		public function get tileDisObj():TileDisplayObj
		{
			return new TileDisplayObj(this._displayFrom,
									  this.x,this.y,
									  this.id,this.data,
									  this.rot,
									  this._xSize,this._ySize)
		}
	}
}