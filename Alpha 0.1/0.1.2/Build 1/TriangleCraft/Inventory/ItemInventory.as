package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileSystem
	use namespace intc
	
	public class ItemInventory
	{
		private var Inventory:Array
		private var InventorySelect:uint

		//Set ItemInventory
		public function ItemInventory(...Items):void
		{
			//Reset
			ResetInventory()
			//Add Items
			if(!General.isEmptyArray(Items))
			{
				var i:uint
				for(i=0;i<Items.length;i++)
				{
					if(Items[i] is InventoryItem)
					{
						Inventory.push(Items[i])
					}
				}
			}
		}
		
		//====================Static Functions====================//
		public static function isEmpty(Inv:ItemInventory):Boolean
		{
			if(Inv==null) return false
			return Inv.isEmpty
		}
		
		//==============Getter And Setter Functions==============//
		public function get isEmpty():Boolean
		{
			return General.isEmptyArray(this.Inventory)
		}

		public function get hasItem():Boolean
		{
			return !this.isEmpty
		}

		public function get TypeCount():uint
		{
			if(this.isEmpty) return 0
			return this.Inventory.length
		}

		public function get ItemCount():uint
		{
			if(this.hasItem)
			{
				var sum:uint,i:uint,item:InventoryItem
				for(i=0;i<this.TypeCount;i++)
				{
					item=this.getItemAt(i)
					if(item!=null)
					{
						sum+=item.Count
					}
				}
				return sum
			}
			return 0
		}

		//Start At 0
		public function getItemAt(Num:uint):InventoryItem
		{
			if(this.isEmpty) return null
			return this.Inventory[Math.min(Num,this.TypeCount)] as InventoryItem
		}

		public function hasItemAt(Num:uint):Boolean
		{
			if(Num>=this.TypeCount) return false
			return true
		}

		//Select is Start At 1
		public function get Select():uint
		{
			return Math.min(this.InventorySelect,this.TypeCount)
		}

		public function set Select(Num:uint):void
		{
			this.InventorySelect=Math.min(Num,this.TypeCount)
		}

		public function get hasSelect():Boolean
		{
			return this.Select>0
		}
		
		public function get SelectItem():InventoryItem
		{
			if(this.isEmpty||this.InventorySelect<1) return null
			return this.Inventory[this.InventorySelect-1] as InventoryItem
		}
		
		public function get FirstItem():InventoryItem
		{
			if(this.hasItem)
			{
				return this.getItemAt(0)
			}
			return null
		}
		
		public function get LastItem():InventoryItem
		{
			if(this.hasItem)
			{
				return this.getItemAt(this.TypeCount-1)
			}
			return null
		}
		
		public function hasItemIn(Item:InventoryItem):Boolean
		{
			for(var i in this.Inventory)
			{
				var Item2:InventoryItem=this.Inventory[i];
				if(Item2.Count>0&&Item2.isEqual(Item))
				{
					return true
				}
			}
			return false
		}
		
		public function SelectAnother():void
		{
			if(this.Select<this.TypeCount) this.Select++
			else if(this.Select>0) this.Select--
		}

		//==============Add And Remove Functions==============//
		public function AddItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			//Real Add
			var Item:InventoryItem=new InventoryItem(Id,Count,Data,Tag,Rot)
			//Use
			this.AddInvItem(Item)
		}

		public function AddInvItem(Item:InventoryItem):void
		{
			//Detect
			if(!TileSystem.isAllowID(Item.Id)) return
			//Real Add
			var AddNewItem:Boolean=true;
			var i;
			for(i in this.Inventory)
			{
				var Item2:InventoryItem=this.Inventory[i] as InventoryItem
				if(Item2!=null&&Item.isEqual(Item2))
				{
					AddNewItem=false;
					Item2.Count+=Item.Count;
				}
			}
			if(AddNewItem) this.Inventory.push(Item);
			//Repair
			this.Repair()
		}

		public function AddItems(...Items):void
		{
			if(!General.isEmptyArray(Items))
			{
				for(var i:uint=0;i<Items.length;i++)
				{
					if(Items[i]!=null&&Items[i] is InventoryItem)
					{
						this.AddInvItem(Items[i] as InventoryItem)
					}
				}
			}
		}
		
		public function AddItemsFromInventory(Inv:ItemInventory):void
		{
			if(Inv.hasItem)
			{
				for(var i:uint=0;i<Inv.TypeCount;i++)
				{
					if(Inv.getItemAt(i)!=null)
					{
						this.AddInvItem(Inv.getItemAt(i))
					}
				}
			}
		}

		public function RemoveItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			var Item:InventoryItem=new InventoryItem(Id,Count,Data,Tag,Rot)
			this.RemoveInvItem(Item)
		}

		public function RemoveInvItem(Item:InventoryItem):void
		{
			//Detect
			if(!TileSystem.isAllowID(Item.Id)) return
			//Real Remove
			for(var i in this.Inventory)
			{
				var Item2:InventoryItem=this.Inventory[i];
				if(Item2.isEqual(Item))
				{
					if(Item2.Count-Item.Count>0)
					{
						Item2.Count-=Item.Count;
					}
					else
					{
						this.Inventory.splice(i,1);
						if(this.Select==i) SelectAnother()
					}
					break;
				}
			}
			//Repair
			this.Repair()
		}

		public function RemoveItems(...Items):void
		{
			if(!General.isEmptyArray(Items))
			{
				for(var i:uint=0;i<Items.length;i++)
				{
					if(Items[i]!=null&&Items[i] is InventoryItem)
					{
						this.RemoveInvItem(Items[i] as InventoryItem)
					}
				}
			}
		}

		public function RemoveItemsFromInventory(Inv:ItemInventory):void
		{
			if(Inv.hasItem)
			{
				for(var i:uint=0;i<Inv.TypeCount;i++)
				{
					if(Inv.getItemAt(i)!=null)
					{
						this.RemoveInvItem(Inv.getItemAt(i))
					}
				}
			}
		}

		//==============Other Functions==============//
		public function concatInventory(Inv:ItemInventory):ItemInventory
		{
			var returnInv:ItemInventory=new ItemInventory()
			returnInv.AddItemsFromInventory(this)
			returnInv.AddItemsFromInventory(Inv)
			return returnInv
		}

		public function ResetInventory():void
		{
			this.Inventory=new Array()
			this.InventorySelect=0
		}

		public function Repair():void
		{
			if(this.hasItem)
			{
				//Remove Not-Allow Items
				for(var i:int=this.Inventory.length-1;i>=0;i--)
				{
					var Item:InventoryItem=this.Inventory[i] as InventoryItem
					var Conditions:Boolean=(Item==null||
											Item.Count==0||
											!TileSystem.isAllowID(Item.Id))
					if(Conditions)
					{
						this.Inventory.splice(i,1)
						if(this.Select==i) this.SelectAnother()
					}
				}
				//Repair Select
				if(this.Select>this.TypeCount)
				{
					this.Select=this.TypeCount
				}
			}
		}
	}
}