package TriangleCraft
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Entities.Mobile.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	
	public class ModAPI
	{
		//=====Constructor Function=====//
		public function ModAPI()
		{
			
		}
		
		//==========ModAPI Functions===========//
		public static function addNewTile(information:TileInformation):void
		{
			//Add New TileID
			if(!TileSystem.isAllowID(information.tileID))
			{
				TileSystem.AllCustomBlockID.push(information.tileID)
			}
			//Add To Shape_Custom
			TileCustomShape.addCurrent(information.displaySettings.externalUrl,information.tileID,0)
			//Add To Informations
			TileInformation.addInformation(information)
		}
	}
}