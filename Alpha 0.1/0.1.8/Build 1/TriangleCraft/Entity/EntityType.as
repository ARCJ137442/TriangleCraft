package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Entities.CraftRecipePreview;
	import TriangleCraft.Player.*;
	
	
	public class EntityType
	{
		//Entity Types
		public static const Player:EntityType=new EntityType("Player")
		public static const EntityItem:EntityType=new EntityType("EntityItem")
		public static const CraftRecipePreview:EntityType=new EntityType("CraftRecipePreview")
		
		//============Static Functions============//
		
		//============Instance Variables============//
		protected var _name:String
		
		//============Init Class============//
		public function EntityType(name:String):void 
		{
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		//============Instance Functions============//
		public function toString():String
		{
			return this.name
		}
	}
}