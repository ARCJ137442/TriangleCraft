package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Class
	public class TileTag
	{
		public static var AllAttributes:Array=["canPass",
											   "canGet",
											   "canPlace",
											   "canPlaceBy",
											   "canDestroy",
											   "canUse",
											   "canRotate",
											   "allowRandomTick",
											   "pushable",
											   "hasInventory",
											   "dropInventory"]
		
		intc var specialTags:TileSpecialTag
		intc var canPass:Boolean
		intc var canGet:Boolean
		intc var canPlace:Boolean
		intc var canPlaceBy:Boolean
		intc var canDestroy:Boolean
		intc var canUse:Boolean
		intc var canRotate:Boolean
		intc var allowRandomTick:Boolean
		intc var pushable:Boolean
		intc var hasInventory:Boolean
		intc var dropInventory:Boolean
		
		public function TileTag(Id:String="Default"):void
		{
			if(Id=="Default"||Id==null||Id=="")
			{
				LoadDefaultTag()
			}
			else if(TileSystem.isAllowID(Id))
			{
				LoadByTileId(Id)
			}
		}
		
		//==========Load Functions==========//
		public function LoadByTileId(Id:String):void
		{
			LoadDefaultTag()
			this.specialTags=new TileSpecialTag(Id)
			//Internal Ids
			switch (Id)
			{
				//====Special====//
				//Void
				case TileID.Void:
					canPass=true;
					canGet=false;
					canPlace=false;
					canPlaceBy=true;
					canDestroy=false;
					break;
				//Virus
				case TileID.XX_Virus:
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Blue:
					canGet=false;
					allowRandomTick=true;
					break;
				//Pushable Block
				case TileID.Pushable_Block:
					canRotate=true;
					pushable=true
					break;
				//Inventory Block
				case TileID.Inventory_Block:
					canUse=true;
					hasInventory=true
					dropInventory=true
					break;
				//====Basic====//
				//UseRandomTick
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
				case TileID.Crystal_Wall:
					allowRandomTick=true;
					break;
				//Can't Destroy
				case TileID.Barrier:
					canDestroy=false;
					break;
				//UseRotate
				case TileID.Arrow_Block:
					canRotate=true;
				//Can Use
				case TileID.Color_Mixer:
				case TileID.Block_Crafter:
					canUse=true;
					break;
			}
			//Custom Ids
			if(TileInfornation.hasInfornationByID(Id))
			{
				this.copyFromTag(TileInfornation.getInfornationByID(Id).defaultTag)
			}
		}
		
		public function LoadDefaultTag():void
		{
			//Solid
			canPass=false
			canGet=true
			canDestroy=true
			canPlace=true
			canPlaceBy=false
			canUse=false
			canRotate=false
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
		}
		
		public function LoadAsItem():void
		{
			canPass=true
			canGet=true
			canDestroy=true
			canPlace=false
			canPlaceBy=true
			canUse=false
			canRotate=true
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
		}
		
		//==========Main Functions==========//
		public function copyFromTag(Tag:TileTag):void
		{
			this.canPass=Tag.canPass
			this.canGet=Tag.canGet
			this.canDestroy=Tag.canDestroy
			this.canPlace=Tag.canPlace
			this.canPlaceBy=Tag.canPlaceBy
			this.canUse=Tag.canUse
			this.canRotate=Tag.canRotate
			this.allowRandomTick=Tag.allowRandomTick
			this.pushable=Tag.pushable
			this.hasInventory=Tag.hasInventory
			this.dropInventory=Tag.dropInventory
			/*for(var i:uint=0;i<AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				this[a]=Tag[a]
			}*/
		}
		
		public function getCopy():TileTag
		{
			var ReturnTag:TileTag=new TileTag()
			ReturnTag.copyFromTag(this)
			return ReturnTag
		}
		
		public function isEqual(tag:TileTag):Boolean
		{
			for(var i:uint=0;i<AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				if(this[a]!=tag[a]) return false
			}
			return true
		}
		
		public function getString(Space:uint=0):String
		{
			var returnStr:String=new String()
			var spaceStr:String=new String()
			var i:uint
			for(i=0;i<Space;i++) spaceStr+=" "
			returnStr+=spaceStr+"<Tag>\n"
			for(i=0;i<AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				returnStr+=spaceStr+spaceStr+a+"="+this[a]
				if(i<AllAttributes.length-1)
				{
					returnStr+="\n"
				}
			}
			returnStr+=spaceStr+"<Tag>"
			return returnStr
		}
		
		//======Static Functions======//
		public static function get DefaultTag():TileTag
		{
			return new TileTag()
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			var Tag:TileTag=new TileTag();
			Tag.LoadByTileId(Id)
			return Tag;
		}
		
		public static function isEqual(tag1:TileTag,tag2:TileTag):Boolean
		{
			if(tag1==null||tag2==null)
			{
				if(tag1==null&&tag2==null)
				{
					return true
				}
				return false
			}
			return tag1.isEqual(tag2)
		}
	}
}