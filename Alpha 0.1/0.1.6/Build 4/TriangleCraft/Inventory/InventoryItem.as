package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Tile.*;
	
	//Class
	public class InventoryItem extends Object
	{
		//============Instance Variables============//
		protected var _id:TileID
		protected var _count:uint=1
		protected var _data:int=0
		
		//============Init Class============//
		public function InventoryItem(id:TileID,count:uint=1,data:int=0):void
		{
			this.setItem(id,count,data)
		}
		
		//============Instance Getter And Setter============//
		public function get id():TileID
		{
			return this._id
		}
		
		public function get count():uint
		{
			return this._count
		}
		
		public function get data():int
		{
			return this._data
		}
		
		public function get attributes():TileAttributes
		{
			return TileAttributes.fromID(this._id)
		}
		
		public function set id(value:TileID):void
		{
			if(TileSystem.isAllowID(value))
			{
				this._id=value
			}
		}
		
		public function set count(value:uint):void
		{
			this._count=value
		}
		
		public function set data(value:int):void
		{
			this._data=value
		}
		
		//============Instance Functions============//
		public function setItem(id:TileID,count:uint=1,data:int=0):void
		{
			this.id=id
			this.count=count
			this.data=data
		}
		
		public function getCopy():InventoryItem
		{
			var TempItem:InventoryItem=new InventoryItem(this._id,this._count,this._data)
			return TempItem
		}
		
		public function copyFrom(item:InventoryItem):Boolean
		{
			if(TileSystem.isAllowID(item.id))
			{
				this.setItem(item.id,item.count,item.data)
				return true
			}
			return false
		}
		
		public function isEqual(item:InventoryItem,
								ignoreCount:Boolean=true,
								ignoreData:Boolean=false):Boolean
		{
			//Detect
			return (this.id==item.id&&
					(ignoreCount||this.count==item.count)&&
					(ignoreData||this.data==item.data))
		}
		
		public static function isEqual(item1:InventoryItem,item2:InventoryItem):Boolean
		{
			if(item1==null||item2==null)
			{
				if(item1==null&&item2==null)
				{
					return true
				}
				return false
			}
			return item1.isEqual(item2)
		}
		
		//==========Transform Function==========//
		public function get tile():Tile
		{
			return new Tile(TileDisplayFrom.NULL,null,0,0,this._id,this._data)
		}
		
		public function get tileDisplayObj():TileDisplayObj
		{
			return new TileDisplayObj(TileDisplayFrom.NULL,0,0,this._id,this._data)
		}
	}
}