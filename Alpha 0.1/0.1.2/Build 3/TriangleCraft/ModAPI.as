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
	use namespace intc
	
	public class ModAPI
	{
		//=====Constructor Function=====//
		public function ModAPI()
		{
			
		}
		
		//==========ModAPI Functions===========//
		intc static function addNewTile(infornation:TileInfornation):void
		{
			//Add New TileID
			if(!TileSystem.isAllowID(infornation.tileName))
			{
				TileSystem.AllCustomBlockID.push(infornation.tileName)
			}
			//Add To Shape_Custom
			Shape_Custom.addCurrent(infornation.displaySettings.externalUrl,infornation.tileName,0)
			//Add To Infornations
			TileInfornation.addInfornation(infornation)
		}
	}
}