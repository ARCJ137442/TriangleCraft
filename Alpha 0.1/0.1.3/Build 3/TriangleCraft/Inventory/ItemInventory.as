﻿package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileSystem
	use namespace intc
	
	public class ItemInventory extends ItemList
	{
		//============Instance Variables============//
		protected var _inventorySelect:uint
		
		//============Static Functions============//
		public static function isEmpty(Inv:ItemInventory):Boolean
		{
			if(Inv==null) return false
			return Inv.isEmpty
		}

		//============Init ItemInventory============//
		public function ItemInventory(...Items):void
		{
			super.addItemsFromArray(Items as Array)
		}
		
		//============Getters And Setters============//
		//Select is Start At 1
		public function get select():uint
		{
			return General.NumberBetween(this._inventorySelect,0,this.typeCount)
		}

		public function set select(Num:uint):void
		{
			this._inventorySelect=General.NumberBetween(Num,0,this.typeCount)
		}

		public function get hasSelect():Boolean
		{
			return this.select>0
		}
		
		public function get selectItem():InventoryItem
		{
			if(this.isEmpty||this._inventorySelect<1) return null
			return this._inventory[this._inventorySelect-1] as InventoryItem
		}

		//============Other Functions============//
		public function selectAnother():void
		{
			if(this.select<this.typeCount) this.select++
			else if(this.select>0) this.select--
		}

		public override function resetInventory():void
		{
			super.resetInventory()
			this._inventorySelect=0
		}

		public override function repair():void
		{
			if(this.hasItem)
			{
				//remove Not-Allow Items
				for(var i:int=this._inventory.length-1;i>=0;i--)
				{
					var Item:InventoryItem=this._inventory[i] as InventoryItem
					var Conditions:Boolean=(Item==null||
											Item.Count==0||
											!TileSystem.isAllowID(Item.Id))
					if(Conditions)
					{
						this._inventory.splice(i,1)
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
	}
}