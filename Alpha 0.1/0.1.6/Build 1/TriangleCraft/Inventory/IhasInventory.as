package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	

	public interface IhasInventory
	{
		//==========Interface Methods==========//
		//----Getters And Setters----//
		//get
		function get inventory():ItemList
		function get allItemCount():uint
		function get allItemTypeCount():uint
		//set
		//----Main Methods----//
		function addItem(id:String,count:uint=1,data:int=0):void
		function removeItem(id:String,count:uint=1,data:int=0):void
		function hasItemIn(id:String,count:uint=1,data:int=0):Boolean
	}
}