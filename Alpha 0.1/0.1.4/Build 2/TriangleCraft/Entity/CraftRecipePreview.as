package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Entity.Entity;
	import TriangleCraft.Resource.*;
	import TriangleCraft.Game;
	import TriangleCraft.CraftRecipe;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.display.*;
	
	public class CraftRecipePreview extends Entity
	{
		//============Instance Variables============//
		protected var _recipe:CraftRecipe
		protected var base:DisplayObject
		protected var tileSprite:Sprite=new Sprite()
		
		//
		public function CraftRecipePreview(Host:Game,X:int,Y:int,recipe:CraftRecipe=null):void 
		{
			this.EntityType=EntityID.CraftRecipePreview
			super(Host,X*TileSystem.globalTileSize,Y*TileSystem.globalTileSize);
			this.recipe=recipe
		}
		
		//============Instance Functions============//
		//Getters And Setters
		public function get recipe():CraftRecipe 
		{
			return this._recipe
		}
		
		public function set recipe(value:CraftRecipe):void 
		{
			this._recipe=value
			if(value!=null)
			{
				setDisplay()
			}
		}
		
		//Main Methods
		protected function setDisplay():void
		{
			if(this._recipe!=null)
			{
				
			}
		}
		
		protected function setNewTile(x:int,y:int,id:String,data:int=0,rot:uint=0):void
		{
			var tile:TileDisplayObj=new TileDisplayObj(
			TileDisplayFrom.IN_ENTITY,x*TileSystem.globalTileSize,y*TileSystem.globalTileSize,
			id,data,null,rot)
			this.tileSprite.addChild(tile)
		}
		
		protected function setTile(x:int,y:int,id:String,data:int=0,rot:uint=0):void
		{
			this.getTileObject(x,y).changeTile(id,data,null,rot)
		}
		
		protected function getTileObject(x:int,y:int):TileDisplayObj
		{
			for(var i:uint=0;i<this.tileSprite.numChildren;i++)
			{
				var child:TileDisplayObj=this.tileSprite.getChildAt(i) as TileDisplayObj
				if(child!=null)
				{
					if(child.TileX==x&&child.TileY==y) return child
				}
			}
			return null
		}
		
		protected function isTile(x:int,y:int):Boolean
		{
			return getTileObject(x,y)!=null
		}
	}
}