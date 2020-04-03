package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	use namespace intc

	public interface IhasInventory
	{
		//==========Interface Methods==========//
		//----Getters And Setters----//
		//get
		function get Inventory():ItemList
		function get AllItemCount():uint
		function get AllItemTypeCount():uint
		//set
		//----Main Methods----//
		function addItem(id:String,count:uint=1,data:int=0,tag:TileTag=null,rot:int=0):void
		function removeItem(id:String,count:uint=1,data:int=0,tag:TileTag=null,rot:int=0):void
		function hasItemIn(id:String,count:uint=1,data:int=0,tag:TileTag=null,rot:int=0):Boolean
	}
}