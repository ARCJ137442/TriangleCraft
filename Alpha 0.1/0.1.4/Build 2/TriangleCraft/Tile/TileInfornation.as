package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class TileInfornation
	{
		//========Static Variables========//
		intc static var _AllTileInfornation:Array=new Array()
		
		//========Static Functions========//
		public static function get DefaultInfornation():TileInfornation
		{
			return new TileInfornation(null,new TileDisplaySettings())
		}
		
		intc static function get TileInfornationCount():uint
		{
			if(General.isEmptyArray(TileInfornation._AllTileInfornation)) return 0
			else return TileInfornation._AllTileInfornation.length
		}
		
		intc static function get AllTileInfornation():Array
		{
			return TileInfornation._AllTileInfornation
		}
		
		intc static function hasInfornationByID(Id:String):Boolean
		{
			if(General.isEmptyArray(TileInfornation._AllTileInfornation)) return false
			for each(var i in TileInfornation._AllTileInfornation)
			{
				if(i as TileInfornation!=null)
				{
					if((i as TileInfornation).tileName==Id)
					{
						return true
					}
				}
			}
			return false
		}
		
		intc static function getInfornationByID(Id:String):TileInfornation
		{
			if(General.isEmptyArray(TileInfornation._AllTileInfornation))
			{
				return TileInfornation.DefaultInfornation
			}
			for each(var i in TileInfornation._AllTileInfornation)
			{
				if(i as TileInfornation!=null)
				{
					if((i as TileInfornation).tileName==Id)
					{
						return i
					}
				}
			}
			return TileInfornation.DefaultInfornation
		}
		
		intc static function addInfornation(Infornation:TileInfornation):void
		{
			if(Infornation!=null&&TileInfornation.hasInfornationByID(Infornation.tileName))
			{
				TileInfornation._AllTileInfornation.push(Infornation)
			}
		}
		
		intc static function addInfornations(...Infornations):void
		{
			if(General.isEmptyArray(Infornations)) return
			for(var i:uint=0;i<Infornations.length;i++)
			{
				var Infornation:TileInfornation=Infornations[i] as TileInfornation
				TileInfornation.addInfornation(Infornation)
			}
		}
		
		//========Instance Variables========//
		intc var tileName:String
		intc var isCustom:Boolean
		intc var isItem:Boolean
		intc var displaySettings:TileDisplaySettings
		intc var defaultTag:TileTag
		intc var defaultRot:int
		intc var defaultMaxHard:uint
		intc var defaultLevel:String
		intc var defaultDropItems:ItemInventory
		intc var defaultInventory:ItemInventory
		
		intc var defaultTickRunFunction:Function
		
		//========Instance Functions========//
		public function TileInfornation(name:String,displaySettings:TileDisplaySettings,item:Boolean=false)
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
			this.defaultTag=TileTag.DefaultTag
			this.defaultRot=0
			this.defaultMaxHard=0
			this.defaultLevel=TileSystem.Level_Top
			this.defaultDropItems=new ItemInventory(new InventoryItem(ID,1))
			this.defaultInventory=new ItemInventory()
			this.defaultTickRunFunction=null
		}
	}
}