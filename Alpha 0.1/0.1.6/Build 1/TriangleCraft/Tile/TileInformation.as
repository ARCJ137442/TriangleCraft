package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	
	
	public class TileInformation
	{
		//========Static Variables========//
		public static var _AllTileInfornation:Array=new Array()
		
		//========Static Functions========//
		public static function get DefaultInfornation():TileInformation
		{
			return new TileInformation(null,new TileDisplaySettings())
		}
		
		public static function get TileInfornationCount():uint
		{
			if(General.isEmptyArray(TileInformation._AllTileInfornation)) return 0
			else return TileInformation._AllTileInfornation.length
		}
		
		public static function get AllTileInfornation():Array
		{
			return TileInformation._AllTileInfornation
		}
		
		public static function hasInfornationByID(Id:String):Boolean
		{
			if(General.isEmptyArray(TileInformation._AllTileInfornation)) return false
			for each(var i in TileInformation._AllTileInfornation)
			{
				if(i as TileInformation!=null)
				{
					if((i as TileInformation).tileName==Id)
					{
						return true
					}
				}
			}
			return false
		}
		
		public static function getInfornationByID(Id:String):TileInformation
		{
			if(General.isEmptyArray(TileInformation._AllTileInfornation))
			{
				return TileInformation.DefaultInfornation
			}
			for each(var i in TileInformation._AllTileInfornation)
			{
				if(i as TileInformation!=null)
				{
					if((i as TileInformation).tileName==Id)
					{
						return i
					}
				}
			}
			return TileInformation.DefaultInfornation
		}
		
		public static function addInfornation(Infornation:TileInformation):void
		{
			if(Infornation!=null&&TileInformation.hasInfornationByID(Infornation.tileName))
			{
				TileInformation._AllTileInfornation.push(Infornation)
			}
		}
		
		public static function addInfornations(...Infornations):void
		{
			if(General.isEmptyArray(Infornations)) return
			for(var i:uint=0;i<Infornations.length;i++)
			{
				var Infornation:TileInformation=Infornations[i] as TileInformation
				TileInformation.addInfornation(Infornation)
			}
		}
		
		//========Instance Variables========//
		public var tileName:String
		public var isCustom:Boolean
		public var isItem:Boolean
		public var displaySettings:TileDisplaySettings
		public var defaultTag:TileAttributes
		public var defaultRot:int
		public var defaultMaxHard:uint
		public var defaultLevel:String
		public var defaultDropItems:ItemInventory
		public var defaultInventory:ItemInventory
		
		public var defaultTickRunFunction:Function
		
		//========Instance Functions========//
		public function TileInformation(name:String,displaySettings:TileDisplaySettings,item:Boolean=false)
		{
			//Constructor Code
			this.LoadDefaultByID(name)
			this.displaySettings=displaySettings
			this.isItem=item
		}
		
		public function LoadDefaultByID(ID:String):void
		{
			this.tileName=ID
			this.isCustom=true
			this.isItem=false
			this.displaySettings=TileDisplaySettings.DefaultSettings
			this.defaultTag=TileAttributes.DefaultTag
			this.defaultRot=0
			this.defaultMaxHard=0
			this.defaultLevel=TileSystem.Level_Top
			this.defaultDropItems=new ItemInventory(new InventoryItem(ID,1))
			this.defaultInventory=new ItemInventory()
			this.defaultTickRunFunction=null
		}
	}
}