package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Common.*;
	use namespace intc
	
	internal class TileSpecialTag
	{
		//=========Static Variables=========//
		
		//========Instance Variables========//
		protected var tags:Array=new Array()
		
		//========Init Functions========//
		public function TileSpecialTag(...Tags):void
		{
			if(!General.isEmptyArray(Tags))
			{
				//init as tileId
				if(Tags.length==1)
				{
					var Id:String=String(Tags[0])
					this.initAsId(Id)
				}
				//init as array
				else
				{
					for(var i:uint=0;i<Tags.length-Tags.length%2;i++)
					{
						this.tags.push(String(Tags[i]),Tags[i+1])
					}
				}
			}
		}
		
		intc function initAsId(Id:String):void
		{
			//Internal Ids
			if(TileSystem.isAllowID(Id))
			{
				switch(Id)
				{
					
				}
			}
			//Custom Ids
		}
		
		//========Main Functions========//
		//====Getters And Setters====//
		public function get tagCount():uint
		{
			return Math.ceil(this.tags.length/2)
		}
		
		public function get allTagNames():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i+1<this.tags.length;i+=2)
			{
				returnArr.push(this.tags[i])
			}
			return returnArr
		}
		
		public function get allTagValues():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=1;i+1<this.tags.length;i+=2)
			{
				returnArr.push(this.tags[i])
			}
			return returnArr
		}
		
		//====Functions====//
		public function hasTag(Name:String=null):Boolean
		{
			if(Name==null)
			{
				return !General.isEmptyArray(this.tags)
			}
			else
			{
				return this.tags.indexOf(Name)>-1
			}
		}
		
		public function addNewTag(Name:String,Value:*=null):void
		{
			if(this.hasTag(Name))
			{
				this.setTagValue(Name,Value)
			}
			else
			{
				this.tags.push(Name,Value)
			}
		}
		
		public function getTagValue(Name:String):*
		{
			if(this.hasTag(Name)) return this.tags[this.tags.indexOf(Name)+1]
			return undefined
		}
		
		public function setTagValue(Name:String,Value:*=null):void
		{
			if(this.hasTag(Name)) this.tags[this.tags.indexOf(Name)+1]=Value
		}
		
		public function removeTag(Name:String):void
		{
			if(this.hasTag(Name)) this.tags.splice(this.tags.indexOf(Name),2)
		}
		
		public function removeTags(...Names):void
		{
			if(!General.isEmptyArray(Names))
			{
				for each(var name in Names)
				{
					removeTag(String(name))
				}
			}
		}
		
		public function removeAllTag():void
		{
			this.tags=null
		}
	}
}