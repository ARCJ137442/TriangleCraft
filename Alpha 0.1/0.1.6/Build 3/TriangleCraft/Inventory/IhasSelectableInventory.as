package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	
	
	public interface IhasSelectableInventory extends IhasInventory
	{
		//==========Interface Methods==========//
		//----Getters And Setters----//
		//get
		function get inventorySelect():uint
		function get selectedItem():InventoryItem
		function get isSelectItem():Boolean
		//set
		function set inventorySelect(num:uint):void
		//----Main Methods----//
		function changeInventorySelect(num:int,emableLeft:Boolean=false,emableRight:Boolean=false):void
	}
}