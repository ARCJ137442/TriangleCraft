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
		
		//============Static Getter And Setter============//
		public static function get DEFAULT():TileAttributes
		{
			if(!TileAttributes._inited) TileAttributes.classInit()
			return TileAttributes.fromID(TileID.Colored_Block)
		}
		
		//============Static Functions============//
		protected static function classInit():void
		{
			_inited=true
			//Open create permissions
			var isOpenBefore:Boolean=_enableNewAttributeCreate
			if(!isOpenBefore) _enableNewAttributeCreate=true
			//Internal Block Attributes
			var attributes:TileAttributes
			for each(var tileId:TileID in TileSystem.AllInternalTileID)
			{
				attributes=new TileAttributes(tileId)
				TileAttributes._attributeDictionary[tileId]=attributes
			}
			if(!isOpenBefore) _enableNewAttributeCreate=false
		}
		
		public static function onNewCustomIdRegister(id:TileID,attributes:TileAttributes):void
		{
			//Open create permissions
			var isOpenBefore:Boolean=_enableNewAttributeCreate
			if(!isOpenBefore) _enableNewAttributeCreate=true
			TileAttributes._attributeDictionary[id]=attributes
			//Close create permissions
			if(!isOpenBefore) _enableNewAttributeCreate=false
		}
		
		public static function registerNewCustomAttributes(id:TileID=null):TileAttributes
		{
			//Open create permissions
			_enableNewAttributeCreate=true
			var attributes:TileAttributes=new TileAttributes(id)
			//Close create permissions
			_enableNewAttributeCreate=false
			return attributes
		}
		
		//============Static Functions============//
		public static function fromID(id:TileID):TileAttributes
		{
			if(!TileAttributes._inited) TileAttributes.classInit()
			return TileAttributes._attributeDictionary[id]
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
		
		public static function getHardnessByID(id:TileID):uint
		{
			var attributes:TileAttributes=TileAttributes.fromID(id)
			return attributes==null?0:attributes.defaultMaxHard
		}
		
		protected static function getHardnessByInternalID(id:TileID):uint
		{
			//Internal Ids
			switch(id)
			{
				//Void
				case TileID.Void:
					return 0;
				//Virus
				case TileID.XX_Virus:
					return 1+tcMath.random(2);
				case TileID.XX_Virus_Red:
				case TileID.XX_Virus_Yellow:
				case TileID.XX_Virus_Green:
				case TileID.XX_Virus_Purple:
				case TileID.XX_Virus_Black:
					return 1;
				case TileID.XX_Virus_Blue:
					return 2+tcMath.random(9);
				case TileID.XX_Virus_Cyan:
					return 4;
				//Signal Error Mark
				case TileID.Signal_Error_Mark:
					return 1;
				//Wall
				case TileID.Basic_Wall:
					return 8;
				case TileID.Ruby_Wall:
				case TileID.Emerald_Wall:
				case TileID.Sapphire_Wall:
					return 12;
				//Machine
				case TileID.Inventory_Block:
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				case TileID.Block_Crafter:
				case TileID.Color_Mixer:
				case TileID.Color_Adder:
					return 4;
				//Signal Machine
				case TileID.Signal_Wire:
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
				case TileID.Signal_Delayer:
				case TileID.Signal_Random_Filter:
					return 1;
				case TileID.Signal_Patcher:
				case TileID.Random_Tick_Signal_Generater:
				case TileID.Block_Update_Detector:
				case TileID.Signal_Clock:
				case TileID.Block_Destroyer:
				case TileID.Block_Pusher:
				case TileID.Block_Puller:
				case TileID.Block_Swaper:
				case TileID.Block_Lasher:
				case TileID.Block_Thrower:
				case TileID.Block_Transporter:
					return 4;
				//Signal Byte Getter|Setter,Wireless Signal Transmitter
				case TileID.Signal_Wire_Block:
				case TileID.Signal_Byte_Pointer:
				case TileID.Signal_Byte_CD_Pointer:
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
				case TileID.Signal_Byte_Copyer:
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
				case TileID.Signal_Byte_Operator_XOR:
				case TileID.Wireless_Signal_Transmitter:
				case TileID.Wireless_Signal_Charger:
					return 2
					break
				//Other
				case TileID.Barrier:
					return 4096;
				case TileID.Colored_Block:
				case TileID.Arrow_Block:
				case TileID.Pushable_Block:
				case TileID.Signal_Lamp:
				case TileID.Signal_Byte_Screen:
				case TileID.Signal_Byte_Storage:
				case TileID.Signal_Byte_Trigger:
					return 3;
			}
			//Custom Ids
			if(TileInformation.hasInformationByID(id))
			{
				return TileInformation.getInformationByID(id).defaultMaxHard
			}
			return 0;
		}
		
		public static function getDisplayLevelByID(id:TileID):TileDisplayLevel
		{
			return TileAttributes.fromID(id).displayLevel
		}
		
		protected static function getDisplayLevelByInternalID(Id:TileID):TileDisplayLevel
		{
			switch(Id)
			{
				case TileID.Void:
				case TileID.Signal_Wire:
				case TileID.Signal_Wire_Block:
				case TileID.Signal_Diode:
				case TileID.Signal_Decelerator:
				case TileID.Signal_Delayer:
				case TileID.Signal_Random_Filter:
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
				case TileID.Signal_Byte_Copyer:
				case TileID.Signal_Byte_Operator_AND:
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_XOR:
				case TileID.Signal_Error_Mark:
					return TileDisplayLevel.BACK
				default:
					return TileDisplayLevel.NULL
			}
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
		public var replaceDropAs:TileID
		public var resizeByData:Boolean
		public var ignoreDataInCraftRecipe:Boolean
		public var ignoreRotInCraftRecipe:Boolean
		public var defaultMaxHard:uint
		public var displayLevel:TileDisplayLevel
		public var hasByteSignal:Boolean
		public var hasByteGetterLink:Boolean
		public var hasByteSetterLink:Boolean

		//============Init TileTag============//
		public function TileAttributes(id:TileID=null):void
		{
			//Class Init
			if(!TileAttributes._inited) TileAttributes.classInit()
			//Instance Init
			if(!_enableNewAttributeCreate)
			{
				throw new Error("invalid type signin!")
			}
			loadDefaultAttributes()
			if(TileSystem.isAllowID(id))
			{
				LoadByTileId(id)
			}
		}
		
		//============Load Functions============//
		protected function LoadByTileId(id:TileID,Data:int=0):void
		{
			loadDefaultAttributes()
			//Special Variables
			this.defaultMaxHard=getHardnessByInternalID(id)
			if(this.displayLevel==TileDisplayLevel.NULL) this.displayLevel=getDisplayLevelByInternalID(id)
			//Internal Ids
			switch(id)
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
				//Colored_Block
				case TileID.Colored_Block:
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
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
					allowRandomTick=true
					canGet=false
					break
				//Signal Error Mark
				case TileID.Signal_Error_Mark:
					technical=true
					canGet=false
					canPass=true
					canPlaceBy=true
					canBeMove=false
					break
				//Basic Wall
				case TileID.Basic_Wall:
					canBeLink=15
					break
				//Special Wall
				case TileID.Ruby_Wall:
				case TileID.Emerald_Wall:
				case TileID.Sapphire_Wall:
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
					hasByteSignal=true
					hasByteGetterLink=true
					break
				//Signal Wire
				case TileID.Signal_Wire:
					canPass=true
					canBeLink=15
					resetDataOnDestroy=true
					ignoreRotInCraftRecipe=true
					ignoreDataInCraftRecipe=true
					break
				//Signal Wire Block
				case TileID.Signal_Wire_Block:
					canUse=true
					canBeLink=0
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
				//Signal Byte Getter
				case TileID.Signal_Byte_Getter:
					canBeLink=General.booleansToBinary(true,true,false,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Signal Byte Setter
				case TileID.Signal_Byte_Setter:
					canBeLink=General.booleansToBinary(false,true,true,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Signal Byte Copyer
				case TileID.Signal_Byte_Copyer:
					canBeLink=General.booleansToBinary(false,true,false,true)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Signal Byte Operators
				case TileID.Signal_Byte_Operator_NOT:
					canBeLink=General.booleansToBinary(false,true,true,true)
					canRotate=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					break
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
				case TileID.Signal_Byte_Operator_XOR:
					canBeLink=General.booleansToBinary(false,false,true,false)
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					ignoreDataInCraftRecipe=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Basic Machine
				case TileID.Color_Mixer:
				case TileID.Color_Adder:
				case TileID.Block_Crafter:
				case TileID.Signal_Patcher:
					canUse=true
				//Block Update Detector
				case TileID.Block_Update_Detector:
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
				//Signal Clock
				case TileID.Signal_Clock:
					resetDataOnDestroy=true
					needTickRun=true
					canBeLink=15
					canUse=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Wireless Signal Transmitter & Wireless_Signal_Charger
				case TileID.Wireless_Signal_Transmitter:
				case TileID.Wireless_Signal_Charger:
					canRotate=true
					canBeLink=15
					pushable=true
					break
				//Signal Lamp,Signal Byte Storage
				case TileID.Signal_Lamp:
				case TileID.Signal_Byte_Trigger:
					canBeLink=15
				case TileID.Signal_Byte_Storage:
				case TileID.Signal_Byte_Screen:
					canUse=true
					resetDataOnDestroy=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					resetDataOnDestroy=true
					break
				//Block Destroyer,Block Pusher & Block Puller
				case TileID.Block_Destroyer:
				case TileID.Block_Pusher:
				case TileID.Block_Puller:
				case TileID.Block_Swaper:
				case TileID.Block_Lasher:
				case TileID.Block_Thrower:
				case TileID.Block_Transporter:
					canUse=true
					canRotate=true
					canBeLink=General.booleansToBinary(false,true,true,true)
					resetDataOnDestroy=true
					break
				//Signal Byte Pointer
				case TileID.Signal_Byte_Pointer:
					pushable=true
					canRotate=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
				//Signal Byte CD Pointer
				case TileID.Signal_Byte_CD_Pointer:
					canBeLink=15
					canRotate=true
					canUse=true
					resetDataOnDestroy=true
					hasByteSignal=true
					hasByteGetterLink=true
					hasByteSetterLink=true
					break
			}
			//Custom Ids
			if(TileInformation.hasInformationByID(id))
			{
				this.copyFrom(TileInformation.getInformationByID(id).attributes)
			}
		}
		
		public function loadDefaultAttributes():void
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
			ignoreDataInCraftRecipe=false
			ignoreRotInCraftRecipe=false
			defaultMaxHard=1
			displayLevel=TileDisplayLevel.NULL
			hasByteSignal=false
			hasByteGetterLink=false
			hasByteSetterLink=false
		}
		
		public function loadAsItem():void
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
			ignoreDataInCraftRecipe=false
			ignoreRotInCraftRecipe=false
			defaultMaxHard=0
			displayLevel=TileDisplayLevel.BACK
			hasByteSignal=false
			hasByteGetterLink=false
			hasByteSetterLink=false
		}
		
		//============Main Functions============//
		public function isEqual(tag2:TileAttributes):Boolean
		{
			return this===tag2
		}
	}
}