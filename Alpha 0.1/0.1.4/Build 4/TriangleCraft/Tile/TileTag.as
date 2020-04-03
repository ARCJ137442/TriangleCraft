package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*
	use namespace intc
	
	//Class
	public dynamic class TileTag
	{
		//============Static Variables============//
		public static const AllAttributes:Vector.<String>=new <String>[
		"canPass","canGet","canPlace","canPlaceBy","canDestroy",
		"canUse","canRotate","canBeMove","canBeLink","canPickupItems",
		"allowRandomTick","pushable","hasInventory","dropInventory",
		"technical","resetDataOnDestroy","needTickRun"]
		
		//============Static Functions============//
		public static function get DefaultTag():TileTag
		{
			return new TileTag()
		}
		
		public static function getTagFromID(Id:String):TileTag
		{
			var Tag:TileTag=new TileTag()
			Tag.LoadByTileId(Id)
			return Tag
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
		intc var canPickupItems:Boolean

		intc var specialTags:TileSpecialTag=new TileSpecialTag()
		intc var allowRandomTick:Boolean
		intc var pushable:Boolean
		intc var hasInventory:Boolean
		intc var dropInventory:Boolean
		intc var technical:Boolean
		intc var resetDataOnDestroy:Boolean
		intc var needTickRun:Boolean
		intc var replaceDropAs:String
		intc var resizeByData:Boolean

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
					canPass=true
					canGet=false
					canPlace=true
					canPlaceBy=true
					canDestroy=false
					technical=true
					break
				//Virus
				case TileID.XX_Virus:
					resizeByData=true
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Blue:
				case TileID.XX_Virus_Yellow:
				case TileID.XX_Virus_Green:
				case TileID.XX_Virus_Cyan:
				case TileID.XX_Virus_Black:
				case TileID.XX_Virus_Purple:
					canGet=false
					allowRandomTick=true
					break
				//Basic Wall
				case TileID.Basic_Wall:
					canBeLink=15
					break
					//Crystal Wall
				case TileID.Crystal_Wall:
					canBeLink=15
					allowRandomTick=true
					canBeMove=false
					break
				//Barrier
				case TileID.Barrier:
					canDestroy=false
					canBeMove=false
					break
				//Arrow Block
				case TileID.Arrow_Block:
					canRotate=true
					resetDataOnDestroy=true
					break
				//Pushable Block
				case TileID.Pushable_Block:
					canRotate=true
					resetDataOnDestroy=true
					pushable=true
					break
				//Inventory Block
				case TileID.Inventory_Block:
					canUse=true
					hasInventory=true
					dropInventory=true
					canPickupItems=true
					canBeLink=15
					break
				//Signal Wire
				case TileID.Signal_Wire:
					canPass=true
					resetDataOnDestroy=true
					canBeLink=15
					break
				//Signal Diode And Signal Decelerator
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
					canPass=true
					canRotate=true
					canBeLink=General.booleansToBinary(true,false,true,false)
					resetDataOnDestroy=true
					break
				//Basic Machine
				case TileID.Color_Mixer:
				case TileID.Block_Crafter:
				case TileID.Signal_Patcher:
					canUse=true
					canBeLink=15
					break
				//Random Tick Signal Generater
				case TileID.Random_Tick_Signal_Generater:
					allowRandomTick=true
					canBeLink=15
					break
				//Wireless Signal Transmitter
				case TileID.Wireless_Signal_Transmitter:
					canRotate=true
					canBeLink=General.booleansToBinary(false,true,true,true)
					resetDataOnDestroy=true
					break
				//Signal Lamp
				case TileID.Signal_Lamp:
					canUse=true
					canBeLink=15
					resetDataOnDestroy=true
					break
				//Block Update Detector
				case TileID.Block_Update_Detector:
					canBeLink=15
					break
				//Block Destroyer,Block Pusher & Block Puller
				case TileID.Block_Destroyer:
				case TileID.Block_Pusher:
				case TileID.Block_Puller:
					canUse=true
					canRotate=true
					canBeLink=General.booleansToBinary(false,true,true,true)
					resetDataOnDestroy=true
					break
				//====Basic====//
				//UseRandomTick
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
					allowRandomTick=true
					break
				//Can't Destroy
				//UseRotate
				//Can Use
			}
			//Custom Ids
			if(TileInfornation.hasInfornationByID(Id))
			{
				this.copyFrom(TileInfornation.getInfornationByID(Id).defaultTag)
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
			canPickupItems=false
			
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
			technical=false
			resetDataOnDestroy=false
			needTickRun=false
			replaceDropAs=null
			resizeByData=false
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
			canPickupItems=false
			
			allowRandomTick=false
			pushable=false
			hasInventory=false
			dropInventory=false
			technical=false
			resetDataOnDestroy=false
			needTickRun=false
			replaceDropAs=null
			resizeByData=false
		}
		
		//============Main Functions============//
		public function copyFrom(tag:TileTag):void
		{
			//Copy Variables
			for(var i:uint=0;i<AllAttributes.length;i++)
			{
				var a:String=AllAttributes[i]
				this[a]=tag[a]
			}
			//Copy Special Tag
			this.specialTags.copyFrom(tag.specialTags)
		}
		
		public function getCopy():TileTag
		{
			var ReturnTag:TileTag=new TileTag()
			ReturnTag.copyFrom(this)
			return ReturnTag
		}
		
		public function isEqual(tag2:TileTag):Boolean
		{
			var tag:TileTag=this
			return AllAttributes.every(function(a,i:uint,t:Vector.<String>):Boolean
									   {
										   return tag[a]==tag[a]
									   })
		}
		
		public function toString(Space:uint=0,newLine:Boolean=true):String
		{
			var returnStr:String=new String()
			var spaceStr:String=new String()
			for(var i:uint=0;i<Space;i++,spaceStr+=" ")
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