package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public interface IhasSelectableInventory extends IhasInventory
	{
		//==========Interface Methods==========//
		//----Getters And Setters----//
		//get
		function get InventorySelect():uint
		function get SelectedItem():InventoryItem
		function get isSelectItem():Boolean
		//set
		function set InventorySelect(num:uint):void
		//----Main Methods----//
		function changeInventorySelect(num:int,emableLeft:Boolean=false,emableRight:Boolean=false):void
	}
}