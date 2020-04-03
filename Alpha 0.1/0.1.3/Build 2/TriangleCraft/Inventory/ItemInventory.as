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
		private var Inventory:Vector.<InventoryItem>
		private var InventorySelect:uint

		//Set ItemInventory
		public function ItemInventory(...Items):void
		{
			//Reset
			resetInventory()
			//add Items
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
			return (this.Inventory==null||this.Inventory.length<1)
		}

		public function get hasItem():Boolean
		{
			return !this.isEmpty
		}

		public function get typeCount():uint
		{
			if(this.isEmpty) return 0
			return this.Inventory.length
		}

		public function get itemCount():uint
		{
			if(this.hasItem)
			{
				var sum:uint,i:uint,item:InventoryItem
				for(i=0;i<this.typeCount;i++)
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
		
		public function get randomItem():InventoryItem
		{
			return this.getItemAt(General.random(this.typeCount)+1)
		}

		//Start At 0
		public function getItemAt(Num:uint):InventoryItem
		{
			if(this.isEmpty) return null
			return this.Inventory[this.lockLoc(Num)] as InventoryItem
		}

		public function hasItemAt(Num:uint):Boolean
		{
			if(Num>=this.typeCount) return false
			return true
		}

		//Select is Start At 1
		public function get select():uint
		{
			return Math.min(this.InventorySelect,this.typeCount)
		}

		public function set select(Num:uint):void
		{
			this.InventorySelect=Math.min(Num,this.typeCount)
		}

		public function get hasSelect():Boolean
		{
			return this.select>0
		}
		
		public function get selectItem():InventoryItem
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
				return this.getItemAt(this.typeCount-1)
			}
			return null
		}
		
		public function hasItemIn(Item:InventoryItem):Boolean
		{
			for each(var Item2:InventoryItem in this.Inventory)
			{
				if(Item2.Count>0&&Item2.isEqual(Item))
				{
					return true
				}
			}
			return false
		}
		
		public function selectAnother():void
		{
			if(this.select<this.typeCount) this.select++
			else if(this.select>0) this.select--
		}
		
		public function get isLock():Boolean
		{
			return this.Inventory.fixed
		}
		
		public function set isLock(value:Boolean):void
		{
			this.Inventory.fixed=value
		}

		//==============add And remove Functions==============//
		public function addItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			//Real add
			var Item:InventoryItem=new InventoryItem(Id,Count,Data,Tag,Rot)
			//Use
			this.addInvItem(Item)
		}

		public function addInvItem(Item:InventoryItem):void
		{
			//Detect
			if(!TileSystem.isAllowID(Item.Id)) return
			//Real add
			var addNewItem:Boolean=true;
			var i;
			for(i in this.Inventory)
			{
				var Item2:InventoryItem=this.Inventory[i] as InventoryItem
				if(Item2!=null&&Item.isEqual(Item2))
				{
					addNewItem=false;
					Item2.Count+=Item.Count;
				}
			}
			if(addNewItem) this.Inventory.push(Item);
			//repair
			this.repair()
		}

		public function addItems(...Items):void
		{
			if(!General.isEmptyArray(Items))
			{
				for(var i:uint=0;i<Items.length;i++)
				{
					if(Items[i]!=null&&Items[i] is InventoryItem)
					{
						this.addInvItem(Items[i] as InventoryItem)
					}
				}
			}
		}
		
		public function addItemsFromInventory(Inv:ItemInventory):void
		{
			if(Inv.hasItem)
			{
				for(var i:uint=0;i<Inv.typeCount;i++)
				{
					if(Inv.getItemAt(i)!=null)
					{
						this.addInvItem(Inv.getItemAt(i))
					}
				}
			}
		}

		public function removeItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			var Item:InventoryItem=new InventoryItem(Id,Count,Data,Tag,Rot)
			this.removeInvItem(Item)
		}

		public function removeInvItem(Item:InventoryItem):void
		{
			//Detect
			if(!TileSystem.isAllowID(Item.Id)) return
			//Real remove
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
						if(this.select==i) selectAnother()
					}
					break;
				}
			}
			//repair
			this.repair()
		}

		public function removeItems(...Items):void
		{
			if(!General.isEmptyArray(Items))
			{
				for(var i:uint=0;i<Items.length;i++)
				{
					if(Items[i]!=null&&Items[i] is InventoryItem)
					{
						this.removeInvItem(Items[i] as InventoryItem)
					}
				}
			}
		}

		public function removeItemsFromInventory(Inv:ItemInventory):void
		{
			if(Inv.hasItem)
			{
				for(var i:uint=0;i<Inv.typeCount;i++)
				{
					if(Inv.getItemAt(i)!=null)
					{
						this.removeInvItem(Inv.getItemAt(i))
					}
				}
			}
		}

		//==============Other Functions==============//
		public function concatInventory(Inv:ItemInventory):ItemInventory
		{
			var returnInv:ItemInventory=new ItemInventory()
			returnInv.addItemsFromInventory(this)
			returnInv.addItemsFromInventory(Inv)
			return returnInv
		}

		public function resetInventory():void
		{
			this.Inventory=new Vector.<InventoryItem>
			this.InventorySelect=0
		}
		
		public function lock():void
		{
			this.Inventory.fixed=true
		}
		
		public function unlock():void
		{
			this.Inventory.fixed=false
		}
		
		public function toggleLock():void
		{
			this.Inventory.fixed=!this.Inventory.fixed
		}

		public function repair():void
		{
			if(this.hasItem)
			{
				//remove Not-Allow Items
				for(var i:int=this.Inventory.length-1;i>=0;i--)
				{
					var Item:InventoryItem=this.Inventory[i] as InventoryItem
					var Conditions:Boolean=(Item==null||
											Item.Count==0||
											!TileSystem.isAllowID(Item.Id))
					if(Conditions)
					{
						this.Inventory.splice(i,1)
						if(this.select==i) this.selectAnother()
					}
				}
				//repair select
				if(this.select>this.typeCount)
				{
					this.select=this.typeCount
				}
			}
		}
		
		private function lockLoc(loc:int):uint
		{
			return uint(General.NumberBetween(loc,0,this.typeCount-1))
		}
	}
}