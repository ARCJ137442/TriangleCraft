package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.Tile
	import TriangleCraft.Tile.TileSystem
	
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
											   "allowRandomTick"]
		
		public var canPass:Boolean
		public var canGet:Boolean
		public var canPlace:Boolean
		public var canPlaceBy:Boolean
		public var canDestroy:Boolean
		public var canUse:Boolean
		public var canRotate:Boolean
		public var allowRandomTick:Boolean
		
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
			switch (Id)
			{
				case TileID.Crystal_Wall:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=true;
					break;
				case TileID.Barrier:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=false;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileID.Arrow_Block:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=true;
					allowRandomTick=false;
					break;
				case TileID.XX_Virus:
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Blue:
					canPass=false;
					canGet=false;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=true;
					break;
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=true;
					break;
				case TileID.Basic_Wall:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileID.Block_Crafter:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=true;
					canRotate=false;//true
					allowRandomTick=false;
					break;
				case TileID.Color_Mixer:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=true;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileID.Colored_Block:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileID.Void:
					canPass=true;
					canGet=false;
					canPlace=false;
					canPlaceBy=true;
					canDestroy=false;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
			}
		}
		
		public function LoadDefaultTag():void
		{
			canPass=false
			canGet=true
			canDestroy=true
			canPlace=true
			canPlaceBy=false
			canUse=false
			canRotate=false
			allowRandomTick=false
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
		}
		
		//==========Main Functions==========//
		public function copyFromTag(Tag:TileTag):void
		{
			/*canPass=Tag.canPass
			canGet=Tag.canGet
			canDestroy=Tag.canDestroy
			canPlace=Tag.canPlace
			canPlaceBy=Tag.canPlaceBy
			canUse=Tag.canUse
			canRotate=Tag.canRotate
			allowRandomTick=Tag.allowRandomTick*/
			for(var i:uint=0;i<AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				this[a]=Tag[a]
			}
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
		
		//======Getter And Setter======//
		
		//======Static Functions======//
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