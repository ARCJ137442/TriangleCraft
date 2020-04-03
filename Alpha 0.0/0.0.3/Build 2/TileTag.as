package 
{
	import TileSystem
	import General
	public class TileTag extends Object
	{
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
		
		public function LoadByTileId(Id:String):void
		{
			switch (Id)
			{
				case TileSystem.Arrow_Block:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=true;
					allowRandomTick=false;
					break;
				case TileSystem.XX_Virus:
					canPass=false;
					canGet=false;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=true;
					break;
				case TileSystem.Block_Spawner:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=true;
					break;
				case TileSystem.Basic_Wall:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileSystem.Block_Crafter:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=true;
					canRotate=false;//true
					allowRandomTick=false;
					break;
				case TileSystem.Color_Mixer:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=true;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileSystem.Colored_Block:
					canPass=false;
					canGet=true;
					canPlace=true;
					canPlaceBy=false;
					canDestroy=true;
					canUse=false;
					canRotate=false;
					allowRandomTick=false;
					break;
				case TileSystem.Void:
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
		
		public function copyFromTag(Tag:TileTag):void
		{
			canPass=Tag.canPass
			canGet=Tag.canGet
			canDestroy=Tag.canDestroy
			canPlace=Tag.canPlace
			canPlaceBy=Tag.canPlaceBy
			canUse=Tag.canUse
			canRotate=Tag.canRotate
			allowRandomTick=Tag.allowRandomTick
		}
		
		public function getCopy():TileTag
		{
			var ReturnTag:TileTag=new TileTag()
			ReturnTag.copyFromTag(this)
			return ReturnTag
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			var Tag:TileTag=new TileTag();
			Tag.LoadByTileId(Id)
			return Tag;
		}
	}
}