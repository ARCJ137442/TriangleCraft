package 
{
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
		
		public function isEqual(InputItem:InventoryItem):Boolean
		{
			return General.isEqualObject(this,InputItem)
		}
	}
}