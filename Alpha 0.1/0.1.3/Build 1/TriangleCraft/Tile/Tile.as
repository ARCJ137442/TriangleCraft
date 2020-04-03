package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*;
	use namespace intc

	//Flash
	import flash.errors.IllegalOperationError;

	//Class
	public class Tile extends TileDisplayObj implements IhasInventory
	{
		//================Static Variables================//
		intc static const Rot_Up:int=3
		intc static const Rot_Down:int=1
		intc static const Rot_Left:int=2
		intc static const Rot_Right:int=0
		
		//================Instance Variables================//
		//==========Graphics==========//
		public var Level:String=TileSystem.Level_NA;
		
		//==========Attributes==========//
		intc var DropItems:ItemInventory=new ItemInventory()
		protected var _inventory:ItemInventory
		
		protected var host:Game
		protected var tickRunFunction:Function;

		//============Init Tile============//
		public function Tile(Host:Game,
							 X:int=0,Y:int=0,
							 id:String=TileID.Void,data:uint=0,tag:TileTag=null,rot:int=0,
							 Level:String=TileSystem.Level_NA,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Host
			this.host=Host
			//super
			super(X,Y,id,data,tag,rot,sizeX,sizeY)
		}

		//============Implements IhasInventory============//
		public function get Inventory():ItemInventory
		{
			return this._inventory
		}
		
		public function get AllItemCount():uint
		{
			return this.Inventory.itemCount
		}
		
		public function get AllItemTypeCount():uint
		{
			return this.Inventory.typeCount
		}
		
		public function addItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(this.Tag.hasInventory)
			{
				this.Inventory.addItem(Id,Count,Data,Tag,Rot)
				initDropItem()
			}
		}
		
		public function removeItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(this.Tag.hasInventory)
			{
				this.Inventory.removeItem(Id,Count,Data,Tag,Rot)
				initDropItem()
			}
		}
		
		public function hasItemIn(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):Boolean
		{
			return this.Inventory.hasItemIn(new InventoryItem(Id,Count,Data,Tag,Rot))
		}

		//============Change Functions============//
		public override function changeTile(id:String,data:uint=0,tag:TileTag=null,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			super.changeTile(id,data,tag,rot,hard,maxHard)
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
			if(this.Tag.hasInventory&&this.Inventory==null)
			{
				this._inventory=new ItemInventory()
			}
			else if(!this.Tag.hasInventory)
			{
				this._inventory=null
			}
		}
		
		protected function initDropItem():void
		{
			this.DropItems=new ItemInventory(new InventoryItem(this.ID,1,this.Data,this.Tag,this.Rot))
			if(this.Tag.hasInventory&&this.Tag.dropInventory)
			{
				if(this.Inventory.hasItem)
				{
					this.DropItems.addItemsFromInventory(this.Inventory)
				}
			}
		}
		
		protected function setLevel()
		{
			this.Level=TileSystem.getLevelFromID(this.ID)
		}
		
		//============Tick Run Functions============//
		public function get hasTickFunction():Boolean
		{
			return (this.tickRunFunction!=null)
		}
		
		public function set TickFunction(Func:Function):void
		{
			this.tickRunFunction=Func
		}
		
		public function get TickFunction():Function
		{
			return this.tickRunFunction
		}
		
		public function runTickFunction():void
		{
			if(this.hasTickFunction)
			{
				this.TickFunction(this)
			}
		}
		
		//==========Transform Function==========//
		public function get tileDisObj():TileDisplayObj
		{
			return new TileDisplayObj(this.x,this.y,
									  this.ID,this.Data,
									  this.Tag,this.Rot,
									  this.xSize,this.ySize)
		}
	}
}