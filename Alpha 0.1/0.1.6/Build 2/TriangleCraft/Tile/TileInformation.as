package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	
	public class TileInformation
	{
		//========Static Variables========//
		public static var _AllTileInformation:Vector.<TileInformation>=new Vector.<TriangleCraft.Tile.TileInformation>
		
		//========Static Functions========//
		protected static function get isEmptyInformations():Boolean
		{
			return (TileInformation._AllTileInformation==null||
					TileInformation._AllTileInformation.length<1)
		}
		
		public static function get DefaultInformation():TileInformation
		{
			return new TileInformation(null,new TileDisplaySettings(),TileAttributes.DEFAULT)
		}
		
		public static function get TileInformationCount():uint
		{
			if(isEmptyInformations) return 0
			else return TileInformation._AllTileInformation.length
		}
		
		public static function get AllTileInformation():Vector.<TileInformation>
		{
			return TileInformation._AllTileInformation
		}
		
		public static function hasInformationByID(Id:TileID):Boolean
		{
			if(isEmptyInformations) return false
			for each(var i in TileInformation._AllTileInformation)
			{
				if(i as TileInformation!=null)
				{
					if((i as TileInformation).tileID==Id)
					{
						return true
					}
				}
			}
			return false
		}
		
		public static function getInformationByID(Id:TileID):TileInformation
		{
			if(isEmptyInformations)
			{
				return TileInformation.DefaultInformation
			}
			for each(var i in TileInformation._AllTileInformation)
			{
				if(i as TileInformation!=null)
				{
					if((i as TileInformation).tileID==Id)
					{
						return i
					}
				}
			}
			return TileInformation.DefaultInformation
		}
		
		public static function addInformation(Information:TileInformation):void
		{
			if(Information!=null&&TileInformation.hasInformationByID(Information._tileID))
			{
				TileInformation._AllTileInformation.push(Information)
			}
		}
		
		public static function addInformations(...Informations):void
		{
			if(General.isEmptyArray(Informations)) return
			for(var i:uint=0;i<Informations.length;i++)
			{
				var Information:TileInformation=Informations[i] as TileInformation
				TileInformation.addInformation(Information)
			}
		}
		
		//========Instance Variables========//
		protected var _tileID:TileID
		protected var _isCustom:Boolean
		protected var _attributes:TileAttributes
		protected var _displaySettings:TileDisplaySettings
		protected var _defaultRot:int
		protected var _defaultMaxHard:uint
		protected var _defaultLevel:TileDisplayLevel
		protected var _defaultDropItems:ItemInventory
		protected var _defaultInventory:ItemInventory
		
		//========Instance Getter And Setter========//
		public function get tileID():TileID
		{
			return this._tileID;
		}
		
		public function get isCustom():Boolean
		{
			return this._isCustom;
		}
		
		public function get attributes():TileAttributes
		{
			return this._attributes;
		}
		
		public function get displaySettings():TileDisplaySettings
		{
			return this._displaySettings;
		}
		
		public function get defaultRot():int
		{
			return this._defaultRot;
		}
		
		public function get defaultMaxHard():uint
		{
			return this._defaultMaxHard;
		}
		
		public function get defaultLevel():TileDisplayLevel
		{
			return this._defaultLevel;
		}
		
		public function get defaultDropItems():ItemInventory
		{
			return this._defaultDropItems;
		}
		
		public function get defaultInventory():ItemInventory
		{
			return this._defaultInventory;
		}
		
		//========Instance Functions========//
		public function TileInformation(name:String,
										displaySettings:TileDisplaySettings,
										attributes:TileAttributes)
		{
			this._tileID=new TileID(name)
			this._attributes=attributes
			this._isCustom=true
			this._defaultRot=0
			this._defaultLevel=TileDisplayLevel.TOP
			this._defaultDropItems=null
			this._defaultInventory=null
			this._displaySettings=displaySettings
		}
	}
}