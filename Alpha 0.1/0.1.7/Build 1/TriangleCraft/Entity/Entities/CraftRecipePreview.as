package TriangleCraft.Entity.Entities
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Resource.*;
	import TriangleCraft.Game;
	import TriangleCraft.Inventory.CraftRecipe;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;

	//Flash
	import flash.display.*;
	
	public class CraftRecipePreview extends Entity
	{
		//============Static Variables============//
		public static const UPDATE_MAX_DISTANCE:uint=2
		
		//============Instance Variables============//
		protected var _recipe:CraftRecipe
		protected var _inputItems:Vector.<InventoryItem>
		protected var base:DisplayObject
		protected var tileSprite:Sprite=new Sprite()

		//============Init CraftRecipePreview============//
		public function CraftRecipePreview(Host:Game,X:int,Y:int,
										   recipe:CraftRecipe=null,
										   inputItems:Vector.<InventoryItem>=null):void 
		{
			this._entityType=EntityType.CraftRecipePreview
			super(Host,X*TileSystem.globalTileSize,Y*TileSystem.globalTileSize);
			this.hasCollision=false
			this.setRecipe(recipe,inputItems)
			//Add Childs
			if(this.base!=null)this.addChild(this.base)
			this.addChild(this.tileSprite)
		}

		//============Instance Functions============//
		//Getters And Setters
		public function get recipe():CraftRecipe 
		{
			return this._recipe
		}

		public function get inputItems():Vector.<InventoryItem>
		{
			return this._inputItems
		}

		public function setRecipe(recipe:CraftRecipe,
								  inputItems:Vector.<InventoryItem>):void 
		{
			if(!this._isActive) return
			this._recipe=recipe
			this._inputItems=inputItems
			setDisplay()
		}

		//Main Methods
		protected function setDisplay():void
		{
			if(!this._isActive||this._recipe==null||this._inputItems==null)
			{
				this.removeAllTile()
				return
			}
			//Init Variables
			var rx:uint=(CraftRecipe.ITEM_SLOT_WIDTH-1)/2
			var ry:uint=(CraftRecipe.ITEM_SLOT_HEIGHT-1)/2
			var canCraft:Boolean=this._recipe.testCanCraft(this.inputItems)
			var craftPercent:Number=this._recipe.getCraftPercent(this.inputItems)
			var vx:int,vy:int,cx:int,cy:int
			var i:uint,item:InventoryItem//,equals:Boolean
			//Deal Input
			for(i=0;i<this._recipe.inputItemCount;i++)
			{
				vx=i%CraftRecipe.ITEM_SLOT_WIDTH
				vy=(i-vx)/CraftRecipe.ITEM_SLOT_HEIGHT
				cx=vx+CraftRecipe.SLOT_OFFSET_X-rx,cy=vy+CraftRecipe.SLOT_OFFSET_Y-ry
				item=this._recipe.getInputItem(i)
				if(item==null) continue
				//equals=item.isEqual(this._inputItems[i],this._recipe.ignoreCount,this._recipe.ignoreData,this._recipe.ignoreRot)
				setTile(cx,cy,item.id,item.data,0,0.4)
			}
			//Deal Output
			var outputAlpha:Number=0.2+0.6*craftPercent
			for(i=0;i<this._recipe.outputItemCount;i++)
			{
				vx=i%CraftRecipe.ITEM_SLOT_WIDTH
				vy=(i-vx)/CraftRecipe.ITEM_SLOT_HEIGHT
				cx=vx-CraftRecipe.SLOT_OFFSET_X-rx,cy=vy-CraftRecipe.SLOT_OFFSET_Y-ry
				item=this._recipe.getOutputItem(i)
				setTile(cx,cy,item.id,item.data,0,outputAlpha)
			}
		}

		protected function setNewTile(x:int,y:int,id:TileID,data:int=0,rot:uint=0,alpha:Number=1):void
		{
			var tile:TileDisplayObj=new TileDisplayObj(
					TileDisplayFrom.IN_GAME,
					x*TileSystem.globalTileSize,
					y*TileSystem.globalTileSize,
					id,data,rot)
			tile.alpha=alpha
			this.tileSprite.addChild(tile)
		}

		protected function setTile(x:int,y:int,id:TileID,data:int=0,rot:uint=0,alpha:Number=1):void
		{
			if(!this.isTile(x,y)) this.setNewTile(x,y,id,data,rot,alpha)
			this.getTileObject(x,y).changeTile(id,data,rot)
			this.getTileObject(x,y).alpha=alpha
		}

		protected function getTileObject(x:int,y:int):TileDisplayObj
		{
			for(var i:uint=0;i<this.tileSprite.numChildren;i++)
			{
				var child:TileDisplayObj=this.tileSprite.getChildAt(i) as TileDisplayObj
				if(child!=null&&child.tileX==x&&child.tileY==y) return child
			}
			return null
		}

		protected function isTile(x:int,y:int):Boolean
		{
			return getTileObject(x,y)!=null
		}

		protected function removeAllTile():void
		{
			var tempNum:uint=this.tileSprite.numChildren
			for(var i:uint=0;i<tempNum;i++)
			this.tileSprite.removeChildAt(0)
		}

		public override function deleteSelf():void
		{
			this.removeAllTile()
			var tempNum:uint=this.numChildren
			for(var i:uint=0;i<tempNum;i++)this.removeChildAt(0)
			this._recipe=null
			super.deleteSelf()
		}
	}
}