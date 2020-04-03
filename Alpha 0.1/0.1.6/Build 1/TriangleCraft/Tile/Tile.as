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
		public var level:String=TileSystem.Level_NA;
		
		//==========Attributes==========//
		public var dropItems:ItemList=new ItemList()
		protected var _inventory:ItemList
		protected var _customVariables:TileCustomVariables=new TileCustomVariables()
		
		protected var _host:Game
		protected var _tickRunFunction:Function;

		//============Init Tile============//
		public function Tile(displayFrom:String,Host:Game,
							 X:int=0,Y:int=0,
							 id:String=TileID.Void,data:uint=0,rot:int=0,
							 Level:String=TileSystem.Level_NA,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Host
			this._host=Host
			//super
			super(displayFrom,X,Y,id,data,rot,sizeX,sizeY)
		}

		//============Implements IhasInventory============//
		public function get inventory():ItemList
		{
			return this._inventory
		}
		
		public function get allItemCount():uint
		{
			return this.inventory==null?0:this.inventory.itemCount
		}
		
		public function get allItemTypeCount():uint
		{
			return this.inventory==null?0:this.inventory.typeCount
		}
		
		public function addItem(id:String,count:uint=1,data:int=0):void
		{
			if(!this.attributes.hasInventory) return
			this.inventory.addItem(id,count,data)
			initDropItem()
		}
		
		public function removeItem(id:String,count:uint=1,data:int=0):void
		{
			if(!this.attributes.hasInventory) return
			this.inventory.removeItem(id,count,data)
			initDropItem()
		}
		
		public function hasItemIn(id:String,count:uint=1,data:int=0):Boolean
		{
			return this.inventory.hasItemIn(new InventoryItem(id,count,data))
		}

		//============Change Functions============//
		public override function changeTile(id:String,data:uint=0,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			super.changeTile(id,data,rot,hard,maxHard)
			if(TileSystem.isAllowID(id))
			{
				//Set Inventory
				initInventory()
				//Set DropItems
				initDropItem()
				//Set Level
				setLevel()
			}
		}

		protected function initInventory():void
		{
			if(this.attributes.hasInventory&&this.inventory==null)
			{
				this._inventory=new ItemInventory()
			}
			else if(!this.attributes.hasInventory)
			{
				this._inventory=null
			}
		}

		public function initDropItem():void
		{
			this.dropItems=new ItemList()
			if(!this.attributes.technical)
			{
				this.dropItems.addItem(this._id,1,this._data)
			}
			else
			{
				var replaceID:String=this.attributes.replaceDropAs
				var replaceAttributes:TileAttributes
				while(true)
				{
					replaceAttributes=TileAttributes.fromID(replaceID)
					if(replaceID==null||!TileSystem.isAllowID(replaceID))
					{
						break
					}
					else if(replaceAttributes.technical)
					{
						replaceID=replaceAttributes.replaceDropAs
					}
					else
					{
						this.dropItems.addItem(replaceID,1,this._data)
						break
					}
				}
			}
			//Drop Inventory
			if(this.attributes.hasInventory&&this.attributes.dropInventory)
			{
				if(this.inventory.hasItem)
				{
					this.dropItems.addItemsFromInventory(this.inventory)
				}
			}
		}

		protected function setLevel()
		{
			this.level=TileSystem.getLevelFromID(this.id)
		}

		public function get customVariables():TileCustomVariables
		{
			return this._customVariables
		}

		//==========Transform Function==========//
		public function get tileDisObj():TileDisplayObj
		{
			return new TileDisplayObj(this.displayFrom,
									  this.x,this.y,
									  this.id,this.data,
									  this.rot,
									  this.xSize,this.ySize)
		}
	}
}