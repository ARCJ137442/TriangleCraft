﻿package 
{
	import Tile
	import TileTag;
	import General;
	import TileSystem;
	
	public class InventoryItem extends Object
	{
		//Define Variables
		public var Id:String
		public var Count:uint=1
		public var Data:int=0
		public var Tag:TileTag=new TileTag()
		public var Rot:int=0
		
		public function InventoryItem(Id:String=TileSystem.Colored_Block,Count:uint=1,
									  Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			this.setItem(Id,Count,Data,Tag)
		}
		
		public function setItem(Id:String=TileSystem.Colored_Block,Count:uint=1,
									  Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			this.setItemID(Id)
			this.setItemCount(Count)
			this.setItemData(Data)
			this.setItemTag(Tag)
			this.setItemRot(Rot)
		}
		
		public function setItemID(Id:String):void
		{
			if(TileSystem.isAllowID(Id))
			{
				this.Id=Id
			}
		}
		
		public function setItemCount(Count:uint):void
		{
			this.Count=Count
		}
		
		public function setItemData(Data:int):void
		{
			this.Data=Data
		}
		
		public function setItemTag(Tag:TileTag):void
		{
			if(TileSystem.isAllowID(Id))
			{
				if(Tag==null)
				{
					this.Tag=new TileTag(Id)
				}
				else
				{
					this.Tag.copyFromTag(Tag)
				}
			}
		}
		
		public function setItemRot(Rot:int):void
		{
			this.Rot=Rot%4
		}
		
		public function getCopy():InventoryItem
		{
			var TempItem:InventoryItem=new InventoryItem(this.Id,this.Count,this.Data,
														 this.Tag,this.Rot)
			return TempItem
		}
		
		public function copyFrom(InputItem:InventoryItem):Boolean
		{
			if(TileSystem.isAllowID(InputItem.Id))
			{
				this.setItem(InputItem.Id,InputItem.Count,InputItem.Data,InputItem.Tag,InputItem.Rot)
				return true
			}
			return false
		}
		
		public function isEqual(item:InventoryItem):Boolean
		{
			if(this.Id==item.Id&&
			   this.Count==item.Count&&
			   this.Data==item.Data&&
			   this.Rot==item.Rot)
			
			{
				return true
			}
			return false
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
			return new Tile(0,0,this.Id,this.Data,this.Tag,this.Rot)
		}
	}
}