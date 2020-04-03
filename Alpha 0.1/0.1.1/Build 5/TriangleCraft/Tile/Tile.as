package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*;
	use namespace intc

	//Flash
	import flash.errors.IllegalOperationError;

	//Class
	public class Tile extends TileDisplayObj
	{
		//================Static Consts================//
		public static const Rot_Up:int=3
		public static const Rot_Down:int=1
		public static const Rot_Left:int=2
		public static const Rot_Right:int=0
		
		//================Dynamic Variables================//
		//==========Graphics==========//
		public var Level:String=TileSystem.Level_NA;
		
		//==========Attributes==========//
		public var DropItems:ItemInventory=new ItemInventory()
		public var Inventory:ItemInventory

		//--------Set Tile--------//
		public function Tile(X:int=0,Y:int=0,
							 id:String=TileID.Void,data:uint=0,tag:TileTag=null,rot:int=0,
							 Level:String=TileSystem.Level_NA,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//super
			super(X,Y,id,data,tag,rot,sizeX,sizeY)
			//Set Define
			this.Define(id,data,tag,rot);
			//Set Display
			this.SetDisplay();
		}

		//--------Define Functions--------//
		protected override function Define(Id:String,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				//Set Tag
				setTag(Tag)
				//Set Inventory
				setInventory()
				//Set DropItems
				setDropItems()
				//Set Rot
				this.Rot=Rot%4
				//Set Hardness
				resetHardness();
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