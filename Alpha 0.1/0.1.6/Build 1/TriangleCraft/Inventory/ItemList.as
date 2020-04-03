package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*
	import TriangleCraft.Tile.TileAttributes
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileSystem
	
	
	public class ItemList
	{
		//============Instance Variables============//
		protected var _inventory:Vector.<InventoryItem>
		protected var _itemFilter:Vector.<InventoryItem>
		protected var _strictByFilter:Boolean

		//============Static Functions============//
		public static function isEmpty(Inv:ItemList):Boolean
		{
			if(Inv==null) return false
			return Inv.isEmpty
		}
		
		//============Init ItemList============//
		public function ItemList(...Items)
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
						this._inventory.push(Items[i])
					}
				}
			}
		}
		
		//============Getters And Setters============//
		public function get inventory():Vector.<InventoryItem>
		{
			return this._inventory
		}
		
		public function get isEmpty():Boolean
		{
			return (this._inventory==null||this._inventory.length<1)
		}

		public function get hasItem():Boolean
		{
			return !this.isEmpty
		}

		public function get typeCount():uint
		{
			if(this.isEmpty) return 0
			return this._inventory.length
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
						sum+=item.count
					}
				}
				return sum
			}
			return 0
		}

		public function get randomItem():InventoryItem
		{
			return this.getItemAt(tcMath.random(this.typeCount)+1)
		}

		//Start At 0
		public function get firstItem():InventoryItem
		{
			if(this.hasItem)
			{
				return this.getItemAt(0)
			}
			return null
		}

		public function get lastItem():InventoryItem
		{
			if(this.hasItem)
			{
				return this.getItemAt(this.typeCount-1)
			}
			return null
		}

		public function get isLock():Boolean
		{
			return this._inventory.fixed
		}

		public function set isLock(value:Boolean):void
		{
			this._inventory.fixed=value
		}

		public function get filter():Vector.<InventoryItem>
		{
			return this._itemFilter
		}

		public function set filter(value:Vector.<InventoryItem>):void
		{
			this._itemFilter=value
		}

		public function get strictByFilter():Boolean 
		{
			return this._strictByFilter
		}

		public function set strictByFilter(value:Boolean):void 
		{
			this._strictByFilter=value
		}

		//============Instance Functions============//
		public function getItemAt(Num:uint):InventoryItem
		{
			if(this.isEmpty) return null
			return this._inventory[this.lockLoc(Num)] as InventoryItem
		}

		public function hasItemAt(Num:uint):Boolean
		{
			if(Num>=this.typeCount) return false
			return true
		}

		public function hasItemIn(item:InventoryItem,ignoreCount:Boolean=true):Boolean
		{
			for each(var item2:InventoryItem in this._inventory)
			{
				if(item.count>0&&item2.count>0)
				{
					if(item2.isEqual(item)||item2.isEqual(item,ignoreCount)&&item2.count>item.count)
					{
						return true
					}
				}
			}
			return false
		}

		public function canHasItemIn(Id:String,Data:int,
									 IgnoreData:Boolean=false)
		{
			return !strictByFilter||canHasInvItemIn(new InventoryItem(Id,1,Data))
		}

		public function canHasInvItemIn(item:InventoryItem,
										IgnoreData:Boolean=false)
		{
			if(!strictByFilter) return true
			return this._itemFilter.some(function(item2:InventoryItem,index:uint,vector:Vector.<InventoryItem>)
										 {
											 return item2.isEqual(item,true,IgnoreData)
										 })
		}

		public function addItem(Id:String,Count:uint=1,Data:int=0):void
		{
			//Real add
			var item:InventoryItem=new InventoryItem(Id,Count,Data)
			//Use
			this.addInvItem(item)
		}

		public function addInvItem(Item:InventoryItem):void
		{
			//Detect
			if(Item.count<=0||!TileSystem.isAllowID(Item.id)||!this.canHasInvItemIn(Item)) return
			//Real add
			var addNewItem:Boolean=true;
			var i;
			for(i in this._inventory)
			{
				var Item2:InventoryItem=this._inventory[i] as InventoryItem
				if(Item2!=null&&Item.isEqual(Item2))
				{
					addNewItem=false;
					Item2.count+=Item.count;
				}
			}
			if(addNewItem) this._inventory.push(Item);
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
		
		public function addItemsFromArray(Arr:Array):void
		{
			if(!General.isEmptyArray(Arr))
			{
				for(var i:uint=0;i<Arr.length;i++)
				{
					var item:InventoryItem=Arr[i] as InventoryItem
					if(item!=null)
					{
						this.addInvItem(item)
					}
				}
			}
		}
		
		public function addItemsFromVector(Vec:Vector.<InventoryItem>):void
		{
			if(Vec!=null&&Vec.length>0)
			{
				for(var i:uint=0;i<Vec.length;i++)
				{
					if(Vec[i]!=null)
					{
						this.addInvItem(Vec[i])
					}
				}
			}
		}
		
		public function addItemsFromInventory(Inv:ItemList):void
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

		public function removeItem(Id:String,Count:uint=1,Data:int=0):void
		{
			var Item:InventoryItem=new InventoryItem(Id,Count,Data)
			this.removeInvItem(Item)
		}

		public function removeInvItem(Item:InventoryItem):void
		{
			//Detect
			if(!TileSystem.isAllowID(Item.id)) return
			//Real remove
			for(var i in this._inventory)
			{
				var Item2:InventoryItem=this._inventory[i];
				if(Item2.isEqual(Item))
				{
					if(Item2.count-Item.count>0)
					{
						Item2.count-=Item.count;
					}
					else
					{
						this._inventory.splice(i,1);
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
		
		public function removeItemsFromArray(Arr:Array):void
		{
			if(!General.isEmptyArray(Arr))
			{
				for(var i:uint=0;i<Arr.length;i++)
				{
					var item:InventoryItem=Arr[i] as InventoryItem
					if(item!=null)
					{
						this.removeInvItem(item)
					}
				}
			}
		}
		
		public function removeItemsFromVector(Vec:Vector.<InventoryItem>):void
		{
			if(Vec!=null&&Vec.length>0)
			{
				for(var i:uint=0;i<Vec.length;i++)
				{
					if(Vec[i]!=null)
					{
						this.removeInvItem(Vec[i])
					}
				}
			}
		}

		public function removeItemsFromInventory(Inv:ItemList):void
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

		//============Other Functions============//
		public function concatInventory(Inv:ItemList):ItemList
		{
			var returnInv:ItemList=new ItemInventory()
			returnInv.addItemsFromInventory(this)
			returnInv.addItemsFromInventory(Inv)
			return returnInv
		}

		public function resetInventory():void
		{
			this._inventory=new Vector.<InventoryItem>
		}
		
		public function resetToInventory(inventory:ItemList):void
		{
			this.resetInventory()
			this.addItemsFromInventory(inventory)
		}
		
		public function giveItemTo(IL:ItemList,id:String,count:uint=1,data:int=0):void
		{
			giveInvItemTo(IL,new InventoryItem(id,count,data))
		}
		
		public function giveInvItemTo(IL:ItemList,item:InventoryItem):void
		{
			if(this.hasItemIn(item))
			{
				this.removeInvItem(item)
				IL.addInvItem(item)
			}
		}
		
		public function lock():void
		{
			this._inventory.fixed=true
		}
		
		public function unlock():void
		{
			this._inventory.fixed=false
		}
		
		public function toggleLock():void
		{
			this._inventory.fixed=!this._inventory.fixed
		}

		public function repair():void
		{
			if(this.hasItem)
			{
				//remove Not-Allow Items
				for(var i:int=this._inventory.length-1;i>=0;i--)
				{
					var Item:InventoryItem=this._inventory[i] as InventoryItem
					var Conditions:Boolean=(Item==null||
											Item.count==0||
											!TileSystem.isAllowID(Item.id)||
											!this.canHasInvItemIn(Item))
					if(Conditions)
					{
						this._inventory.splice(i,1)
					}
				}
			}
		}
		
		protected function lockLoc(loc:int):uint
		{
			return uint(tcMath.NumberBetween(loc,0,this.typeCount-1))
		}
	}
}