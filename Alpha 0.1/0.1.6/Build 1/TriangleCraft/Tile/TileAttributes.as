package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*
	
	
	//Flash
	import flash.utils.Dictionary;
	
	//Class
	public dynamic class TileAttributes
	{
		//============Static Variables============//
		protected static const _attributeDictionary:Dictionary=new Dictionary()
		
		protected static var _inited:Boolean=false
		protected static var _enableNewAttributeCreate:Boolean=false
		
		//============Static Functions============//
		protected static function classInit():void
		{
			_inited=true
			//Open create permissions
			_enableNewAttributeCreate=true
			//Internal Block Attributes
			var attributes:TileAttributes
			for each(var tileId:String in TileSystem.AllInternalTileID)
			{
				attributes=new TileAttributes(tileId)
				TileAttributes._attributeDictionary[tileId]=attributes
			}
			//Close create permissions
			_enableNewAttributeCreate=false
		}
		
		public static function onNewCustomIdRegister(id:String,attributes:TileAttributes):void
		{
			//Open create permissions
			_enableNewAttributeCreate=true
			TileAttributes._attributeDictionary[id]=attributes
			//Close create permissions
			_enableNewAttributeCreate=false
		}
		
		public static function get DefaultTag():TileAttributes
		{
			if(!TileAttributes._inited) TileAttributes.classInit()
			return new TileAttributes()
		}
		
		public static function fromID(Id:String):TileAttributes
		{
			if(!TileAttributes._inited) TileAttributes.classInit()
			return TileAttributes._attributeDictionary[Id]
		}
		
		public static function isEqual(tag1:TileAttributes,tag2:TileAttributes):Boolean
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
		public var canPass:Boolean
		public var canGet:Boolean
		public var canPlace:Boolean
		public var canPlaceBy:Boolean
		public var canDestroy:Boolean
		public var canUse:Boolean
		public var canRotate:Boolean
		public var canBeMove:Boolean
		public var canBeLink:uint
		public var canPickupItems:Boolean

		public var allowRandomTick:Boolean
		public var pushable:Boolean
		public var hasInventory:Boolean
		public var dropInventory:Boolean
		public var technical:Boolean
		public var resetDataOnDestroy:Boolean
		public var needTickRun:Boolean
		public var replaceDropAs:String
		public var resizeByData:Boolean
		public var ignoreDataInCraftRecipe:Boolean
		public var ignoreRotInCraftRecipe:Boolean

		//============Init TileTag============//
		public function TileAttributes(Id:String=null):void
		{
			//Class Init
			if(!TileAttributes._inited) TileAttributes.classInit()
			//Instance Init
			if(!_enableNewAttributeCreate)
			{
				throw new Error("invalid type signin!")
			}
			LoadDefaultTag()
			if(TileSystem.isAllowID(Id))
			{
				LoadByTileId(Id)
			}
		}
		
		//============Load Functions============//
		public function LoadByTileId(Id:String,Data:int=0):void
		{
			LoadDefaultTag()
			//Internal Ids
			switch(Id)
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
					canUse=true
					break
				//Arrow Block
				case TileID.Arrow_Block:
					canRotate=true
					resetDataOnDestroy=true
					break
				//Pushable Block
				case TileID.Pushable_Block:
					canRotate=true
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
					canBeLink=15
					resetDataOnDestroy=true
					ignoreRotInCraftRecipe=true
					ignoreDataInCraftRecipe=true
					break
				//Signal Transmitters
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
				case TileID.Signal_Delayer:
				case TileID.Signal_Random_Filter:
					canBeLink=General.booleansToBinary(true,false,true,false)
					canPass=true
					canRotate=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				case TileID.Signal_Byte_Getter:
					canBeLink=General.booleansToBinary(true,true,false,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				case TileID.Signal_Byte_Setter:
					canBeLink=General.booleansToBinary(false,true,true,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				case TileID.Signal_Byte_Copyer:
					canBeLink=General.booleansToBinary(false,true,false,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
					canBeLink=General.booleansToBinary(false,false,true,false)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				//Basic Machine
				case TileID.Color_Mixer:
				case TileID.Block_Crafter:
				case TileID.Signal_Patcher:
					canUse=true
					canBeLink=15
					break
				//Spawners
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
					canUse=true
					canBeLink=15
					allowRandomTick=true
					resetDataOnDestroy=true
					break
				//Random Tick Signal Generater
				case TileID.Random_Tick_Signal_Generater:
					allowRandomTick=true
					canBeLink=15
					break
				//Wireless Signal Transmitter & Wireless_Signal_Charger
				case TileID.Wireless_Signal_Transmitter:
				case TileID.Wireless_Signal_Charger:
					canRotate=true
					canBeLink=15
					resetDataOnDestroy=true
					break
				//Signal Lamp,Signal Byte Storage
				case TileID.Signal_Lamp:
					canBeLink=15
				case TileID.Signal_Byte_Storage:
					canUse=true
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
				case TileID.Block_Swaper:
					canUse=true
					canRotate=true
					canBeLink=General.booleansToBinary(false,true,true,true)
					resetDataOnDestroy=true
					break
				case TileID.Signal_Byte_Pointer:
					canRotate=true
					break
				//====Basic====//
				//UseRandomTick
				//Can't Destroy
				//UseRotate
				//Can Use
			}
			//Custom Ids
			if(TileInformation.hasInfornationByID(Id))
			{
				this.copyFrom(TileInformation.getInfornationByID(Id).defaultTag)
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
		public function isEqual(tag2:TileAttributes):Boolean
		{
			return this==tag2
		}
	}
}