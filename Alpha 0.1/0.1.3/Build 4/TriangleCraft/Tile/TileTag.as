package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Class
	public dynamic class TileTag
	{
		//============Static Variables============//
		public static const AllAttributes:Vector.<String>=new <String>["canPass",
																	   "canGet",
																	   "canPlace",
																	   "canPlaceBy",
																	   "canDestroy",
																	   "canUse",
																	   "canRotate",
																	   "canBeMove",
																	   "canBeLink",
																	   "allowRandomTick",
																	   "pushable",
																	   "hasInventory",
																	   "dropInventory",
																	   "technical",
																	   "resetDataOnDestroy"]
		
		//============Static Functions============//
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
		
		//============Instance Variables============//
		intc var canPass:Boolean
		intc var canGet:Boolean
		intc var canPlace:Boolean
		intc var canPlaceBy:Boolean
		intc var canDestroy:Boolean
		intc var canUse:Boolean
		intc var canRotate:Boolean
		intc var canBeMove:Boolean
		intc var canBeLink:uint
		
		intc var specialTags:TileSpecialTag
		intc var allowRandomTick:Boolean
		intc var pushable:Boolean
		intc var hasInventory:Boolean
		intc var dropInventory:Boolean
		intc var technical:Boolean
		intc var resetDataOnDestroy:Boolean
		
		//============Init TileTag============//
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
		
		//============Load Functions============//
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
					technical=true;
					break;
				//Virus
				case TileID.XX_Virus:
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Blue:
				case TileID.XX_Virus_Yellow:
				case TileID.XX_Virus_Green:
				case TileID.XX_Virus_White:
				case TileID.XX_Virus_Black:
					canGet=false;
					allowRandomTick=true;
					break;
				//Barrier
				case TileID.Barrier:
					canDestroy=false;
					canBeMove=false
					break;
				//Arrow Block
				case TileID.Arrow_Block:
					canRotate=true
					resetDataOnDestroy=true
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
					canBeLink=15
					break;
				//Signal Wire
				case TileID.Signal_Wire:
					canPass=true;
					resetDataOnDestroy=true
					canBeLink=15
					break;
				//Basic Machine
				case TileID.Color_Mixer:
				case TileID.Block_Crafter:
				case TileID.Signal_Patcher:
					canUse=true;
					canBeLink=15
					break;
				//Wireless Signal Transmitter
				case TileID.Wireless_Signal_Transmitter:
					canRotate=true;
					canBeLink=General.booleansToBinary(false,true,true,true)
					break;
				//Random Tick Signal Generater
				case TileID.Random_Tick_Signal_Generater:
					allowRandomTick=true;
					canBeLink=15
					break;
				//====Basic====//
				//UseRandomTick
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
				case TileID.Crystal_Wall:
					allowRandomTick=true;
					break;
				//Can't Destroy
				//UseRotate
				//Can Use
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
			canBeMove=true
			canBeLink=0
			
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
			technical=false
			resetDataOnDestroy=false
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
			canBeMove=true
			canBeLink=0
			
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
			technical=false
			resetDataOnDestroy=false
		}
		
		//============Main Functions============//
		public function copyFromTag(Tag:TileTag):void
		{
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
		
		public function toString(Space:uint=0,newLine:Boolean=true):String
		{
			var returnStr:String=new String()
			var spaceStr:String=new String()
			for(var i:uint=0;i<Space;i++) spaceStr+=" "
			returnStr+=spaceStr+"<Tag>"
			if(newLine)returnStr+="\n"
			for(i=0;i<TileTag.AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				returnStr+=spaceStr+spaceStr+a+"="+this[a]
				if(newLine&&i<AllAttributes.length-1)
				{
					returnStr+="\n"
				}
			}
			returnStr+=spaceStr+"<Tag>"
			return returnStr
		}
	}
}