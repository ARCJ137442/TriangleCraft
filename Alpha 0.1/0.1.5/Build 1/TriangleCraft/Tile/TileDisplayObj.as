package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	use namespace intc

	//Flash
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.errors.IllegalOperationError;

	//Class
	public class TileDisplayObj extends Sprite
	{
		//================Static Consts================//
		protected static const destroyStageCount:uint=10;
		
		//================Dynamic Variables================//
		//==========Graphics==========//
		protected var displayFrom:String
		protected var xSize:uint=TileSystem.globalTileSize;
		protected var ySize:uint=TileSystem.globalTileSize;
		protected var destroyStage:TileDestroyStage;
		protected var Shape:TileShape;
		
		//==========Attributes==========//
		protected var _id:String=TileID.Void;
		protected var _data:int=0;
		protected var _tag:TileTag=new TileTag()
		protected var _rot:uint=0;
		protected var _hard:int=0;
		protected var _maxHard:int=1;
		protected var _scale:Number=1;

		//--------Set Tile--------//
		public function TileDisplayObj(displayFrom:String,X:int=0,Y:int=0,
									   id:String=TileID.Void,data:uint=0,
									   tag:TileTag=null,rot:int=0,
									   sizeX:uint=TileSystem.globalTileSize,
									   sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Pos
			this.x=X;
			this.y=Y;
			this.xSize=sizeX;
			this.ySize=sizeY;
			//Set Tag
			this.Tag=tag
			//Set Display From
			this.displayFrom=displayFrom
			//--==Add Childrens==--//
			this.Shape=new TileShape();
			Shape.scaleX=this.xSize/100;
			Shape.scaleY=this.ySize/100;
			this.destroyStage=new TileDestroyStage(destroyStageCount);
			this.destroyStage.scaleX=this.xSize/100;
			this.destroyStage.scaleY=this.ySize/100;
			this.destroyStage.blendMode="invert";
			addChild(Shape);
			addChild(destroyStage);
			//change
			this.changeTile(id,data,tag,rot);
		}
		
		public function setByItem(item:InventoryItem):void
		{
			changeTile(item.Id,item.Data,item.Tag,item.Rot)
		}

		public function changeTile(id:String,data:uint=0,tag:TileTag=null,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			if(TileSystem.isAllowID(id))
			{
				this._id=id;
				this._data=data;
				this.Tag=tag
				this.Rot=rot
				this.MaxHard=(maxHard>0)?maxHard:TileSystem.getHardnessFromID(this.ID);
				this.Hard=(hard>0)?hard:this.MaxHard;
				setDisplay();
			}
		}
		
		//--------Getters And Setters--------//
		intc function get TileX():int
		{
			return Math.floor(this.x/TileSystem.globalTileSize);
		}

		intc function get TileY():int
		{
			return Math.floor(this.y/TileSystem.globalTileSize);
		}
		
		public function get ID():String
		{
			return this._id
		}
		
		public function set ID(id:String):void
		{
			this._id=id
			setDisplay();
		}
		
		public function get Data():int
		{
			return this._data
		}
		
		public function set Data(data:int):void
		{
			this._data=data
			setDisplay();
		}
		
		public function get Tag():TileTag
		{
			return this._tag
		}
		
		public function set Tag(tag:TileTag):void
		{
			this._tag=(tag==null)?TileTag.getTagFromID(this.ID):tag.getCopy();
		}
		
		public function get Rot():uint
		{
			return this._rot
		}
		
		public function set Rot(rot:uint):void
		{
			this._rot=rot%4
			this.rotation=this._rot*90;
		}
		
		public function get Hard():uint
		{
			return this._hard
		}
		
		public function set Hard(hard:uint):void
		{
			this._hard=Math.min(hard,this._maxHard)
			//setDestroyStage
			var destroyPercent:Number=(this._maxHard-this._hard)/this._maxHard;
			var stageFrame:uint=Math.ceil(destroyPercent*destroyStageCount);
			this.destroyStage.showStage(stageFrame);
		}
		
		public function get MaxHard():uint
		{
			return this._maxHard
		}
		
		public function set MaxHard(hard:uint):void
		{
			this._maxHard=hard
			this.Hard=Math.min(this.Hard,this._maxHard)
		}
		
		public function get Scale():Number
		{
			return this._scale
		}
		
		public function set Scale(scale:Number):void
		{
			this._scale=Math.max(scale,0)
			this.scaleY=this.scaleX=this._scale;
		}

		//--------Attribute Functions--------//
		public function resetHardness():void
		{
			this.Hard=TileSystem.getHardnessFromID(this.ID);
			this.MaxHard=this.Hard;
		}
		
		public function returnHardness():void
		{
			this._hard=this._maxHard
		}

		protected function clearDestroyStage():void
		{
			//setDestroyStage
			this.destroyStage.showStage(0);
		}

		//--------Display Functions--------//;
		public function setDisplay():void
		{
			if(hasAllowID)
			{
				//Color Block With Random Color
				if(_data<-1&&this._id==TileID.Colored_Block)
				{
					_data=tcMath.random(0xffffff);
				}
				//Display
				if(this.Tag.technical&&this.displayFrom==TileDisplayFrom.IN_ENTITY)
				{
					this.Shape.visible=true
					this.Shape.setDisplay(TileID.Technical,this.Data,this.displayFrom)
				}
				else if(TileSystem.needColor(this._id))
				{
					clearColor()
					this.Shape.visible=false
					showColor(this._data)
				}
				else
				{
					this.Shape.visible=true
					this.Shape.setDisplay(this._id,this._data,this.displayFrom)
					clearColor()
				}
				//Scale
				setScale(this._id,this._data)
			}
			else
			{
				clearColor()
				this.Shape.visible=true
				this.Shape.setDisplay(TileID.Unknown,this._data,this.displayFrom)
			}
		}

		protected function showColor(color:uint=0x888888,A:Number=100):void
		{
			if(TileSystem.needColor(ID))
			{
				if(A<=0) return
				this.graphics.beginFill(color,A/100)
				this.graphics.drawRect(-xSize/2,-ySize/2,xSize,ySize)
				this.graphics.endFill()
				//trace(this.R.alpha,this.G.alpha,this.B.alpha,this.Black.alpha)
			}
		}

		protected function clearColor():void
		{
			this.graphics.clear()
		}

		protected function setScale(Id:String,Data:int):void
		{
			if(this.Tag.resizeByData)
			{
				this.Scale=1/Math.max((Data+2)*4/10,1)
			}
			else this.Scale=1
		}

		public function removeSelf():void
		{
			this.parent.removeChild(this)
		}

		//========Detect Functions========//
		public function get hasAllowID():Boolean
		{
			return TileSystem.isAllowID(this.ID)
		}

		//==========Transform Function==========//
		public function get invItem():InventoryItem
		{
			return new InventoryItem(this.ID,1,this.Data,this.Tag,this.Rot)
		}

		public function get tile():Tile
		{
			return new Tile(this.displayFrom,null,
							this.x,this.y,
							this.ID,this.Data,this.Tag,
							this.Rot,TileSystem.Level_NA,
							this.xSize,this.ySize)
		}
	}
}