package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Tile.*;
	
	//Class
	public class InventoryItem extends Object
	{
		//Static Consts
		public static const DefaultId:String="Colored_Block"
		
		//Define Variables
		protected var _id:String
		protected var _count:uint=1
		protected var _data:int=0
		
		public function get id():String
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
		
		public function InventoryItem(Id:String=InventoryItem.DefaultId,Count:uint=1,
									  Data:int=0):void
		{
			this.setItem(Id,Count,Data)
		}
		
		public function setItem(Id:String=DefaultId,Count:uint=1,
								Data:int=0):void
		{
			this.id=Id
			this.count=Count
			this.data=Data
		}
		
		public function set id(Id:String):void
		{
			if(TileSystem.isAllowID(Id))
			{
				this._id=Id
			}
		}
		
		public function set count(Count:uint):void
		{
			this._count=Count
		}
		
		public function set data(Data:int):void
		{
			this._data=Data
		}
		
		public function getCopy():InventoryItem
		{
			var TempItem:InventoryItem=new InventoryItem(this._id,this._count,this._data)
			return TempItem
		}
		
		public function copyFrom(InputItem:InventoryItem):Boolean
		{
			if(TileSystem.isAllowID(InputItem.id))
			{
				this.setItem(InputItem.id,InputItem.count,InputItem.data)
				return true
			}
			return false
		}
		
		public function isEqual(item:InventoryItem,
								ignoreCount:Boolean=true,
								ignoreData:Boolean=false):Boolean
		{
			//Detect
			if(this._id!=item._id||
			   !ignoreCount&&this._count!=item.count||
			   !ignoreData&&this._data!=item.data)
			return false
			return true
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
			return new Tile(null,null,0,0,this._id,this._data)
		}
	}
}