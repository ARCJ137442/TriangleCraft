package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class TileSpecialTag
	{
		//=============Static Variables=============//
		
		//============Instance Variables============//
		protected var tags:Array=new Array()
		
		//============Init TileSpecialTag============//
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
					case TileID.Signal_Decelerator:
					this.addNewTag("delay",0,uint)
					break
				}
			}
			//Custom Ids
		}
		
		//============Instance Functions============//
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
		public function hasTag(name:String=null):Boolean
		{
			if(name==null) return !General.isEmptyArray(this.tags)
			else return this.tags.indexOf(name)>-1
		}
		
		public function addNewTag(name:String,value:*=null,shouldClass:Class=null):void
		{
			if(this.hasTag(name)) this.setTagValue(name,value)
			else this.tags.push(name,shouldClass!=null?new shouldClass():value)
		}
		
		public function getTagValue(name:String,shouldClass:Class=null):*
		{
			if(this.hasTag(name)) return this.tags[this.tags.indexOf(name)+1]
			else if(shouldClass!=null) return new shouldClass()
			return undefined
		}
		
		public function setTagValue(name:String,value:*=undefined):void
		{
			if(this.hasTag(name)) this.tags[this.tags.indexOf(name)+1]=value
		}
		
		public function removeTag(name:String):void
		{
			if(this.hasTag(name)) this.tags.splice(this.tags.indexOf(name),2)
		}
		
		public function removeTags(...names):void
		{
			if(!General.isEmptyArray(names))
			{
				for each(var name in names)
				{
					removeTag(String(name))
				}
			}
		}
		
		public function removeAllTag():void
		{
			this.tags=null
		}
		
		//====Copy Functions====//
		public function getCopy():TileSpecialTag
		{
			var tempTag:TileSpecialTag=new TileSpecialTag()
			tempTag.copyFrom(this)
			return tempTag
		}
		
		public function copyFrom(tag:TileSpecialTag):void
		{
			if(tag==null) return
			if(this.tagCount>0) this.removeAllTag()
			for(var i:uint=0;i<this.allTagNames.length;i++)
			{
				this.addNewTag(this.allTagNames[i],this.allTagValues[i])
			}
		}
	}
}