package 
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Tile.Shapes.*;
	import TriangleCraft.Common.*;
	
	
	public class ModAPI
	{
		//=====Constructor Function=====//
		public function ModAPI()
		{
			
		}
		
		//==========ModAPI Functions===========//
		public static function addNewTile(infornation:TileInformation):void
		{
			//Add New TileID
			if(!TileSystem.isAllowID(infornation.tileID))
			{
				TileSystem.AllCustomBlockID.push(infornation.tileID)
			}
			//Add To Shape_Custom
			Shape_Custom.addCurrent(infornation.displaySettings.externalUrl,infornation.tileID,0)
			//Add To Infornations
			TileInformation.addInfornation(infornation)
		}
	}
}