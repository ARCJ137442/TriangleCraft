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
	public class Tile extends TileDisplayObj
	{
		//================Static Consts================//
		intc static const Rot_Up:int=3
		intc static const Rot_Down:int=1
		intc static const Rot_Left:int=2
		intc static const Rot_Right:int=0
		
		//================Dynamic Variables================//
		//==========Graphics==========//
		public var Level:String=TileSystem.Level_NA;
		
		//==========Attributes==========//
		intc var DropItems:ItemInventory=new ItemInventory()
		intc var Inventory:ItemInventory
		
		protected var Host:Game
		protected var TickRunFunction:Function;

		//--------Set Tile--------//
		public function Tile(Host:Game,
							 X:int=0,Y:int=0,
							 id:String=TileID.Void,data:uint=0,tag:TileTag=null,rot:int=0,
							 Level:String=TileSystem.Level_NA,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Host
			this.Host=Host
			//super
			super(X,Y,id,data,tag,rot,sizeX,sizeY)
		}

		//--------Define Functions--------//
		public override function changeTile(id:String,data:uint=0,tag:TileTag=null,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			super.changeTile(id,data,tag,rot,hard,maxHard)
			if(TileSystem.isAllowID(id))
			{
				//Set Inventory
				setInventory()
				//Set DropItems
				setDropItems()
				//Set Level
				setLevel()
			}
		}
		
		protected function setInventory():void
		{
			if(this.Tag.hasInventory&&this.Inventory==null)
			{
				this.Inventory=new ItemInventory()
			}
			else if(!this.Tag.hasInventory)
			{
				this.Inventory=null
			}
		}
		
		protected function setDropItems():void
		{
			this.DropItems=new ItemInventory(new InventoryItem(this.ID,1,this.Data,this.Tag,this.Rot))
			if(this.Tag.hasInventory&&this.Tag.dropInventory)
			{
				if(this.Inventory.hasItem)
				{
					this.DropItems.AddItemsFromInventory(this.Inventory)
				}
			}
		}
		
		protected function setLevel()
		{
			this.Level=TileSystem.getLevelFromID(this.ID)
		}
		
		//========Inventory Functions========//
		public function AddItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(this.Tag.hasInventory)
			{
				this.Inventory.AddItem(Id,Count,Data,Tag,Rot)
				setDropItems()
			}
		}
		
		public function RemoveItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(this.Tag.hasInventory)
			{
				this.Inventory.RemoveItem(Id,Count,Data,Tag,Rot)
				setDropItems()
			}
		}
		
		//--------Tick Run Functions--------//
		public function get hasTickFunction():Boolean
		{
			return (this.TickRunFunction!=null)
		}
		
		public function set TickFunction(Func:Function):void
		{
			this.TickRunFunction=Func
		}
		
		public function get TickFunction():Function
		{
			return this.TickRunFunction
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