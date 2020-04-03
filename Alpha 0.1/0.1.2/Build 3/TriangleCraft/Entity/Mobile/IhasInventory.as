package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	use namespace intc

	public interface IhasInventory
	{
		//==========Interface Methods==========//
		//----Getters And Setters----//
		//get
		function get Inventory():ItemInventory
		function get AllItemCount():uint
		function get AllItemTypeCount():uint
		function get InventorySelect():uint
		function get SelectedItem():InventoryItem
		function get isSelectItem():Boolean
		//set
		function set InventorySelect(Num:uint):void
		//----Main Methods----//
		function addItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		function removeItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		function hasItemIn(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):Boolean
		//function changeInventorySelect(num:int,emableLeft:Boolean=false,emableRight:Boolean=false):void
	}
}