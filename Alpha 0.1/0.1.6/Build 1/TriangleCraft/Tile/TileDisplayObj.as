package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	

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
		protected var _rot:uint=0;
		protected var _hard:int=0;
		protected var _maxHard:int=1;
		protected var _scale:Number=1;

		//--------Set Tile--------//
		public function TileDisplayObj(displayFrom:String,X:int=0,Y:int=0,
									   id:String=TileID.Void,data:uint=0,rot:int=0,
									   sizeX:uint=TileSystem.globalTileSize,
									   sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Pos
			this.x=X;
			this.y=Y;
			this.xSize=sizeX;
			this.ySize=sizeY;
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
			this.changeTile(id,data,rot);
		}
		
		public function setByItem(item:InventoryItem):void
		{
			changeTile(item.id,item.data)
		}

		public function changeTile(id:String,data:uint=0,rot:int=0,hard:uint=0,maxHard:uint=0):void
		{
			if(TileSystem.isAllowID(id))
			{
				if(this._id!=id) this._id=id;
				if(this._data!=data) this._data=data;
				if(this.rot!=rot) this.rot=rot
				this.maxHard=(maxHard>0)?maxHard:TileSystem.getHardnessFromID(this.id);
				this.hard=(hard>0)?hard:this.maxHard;
				setDisplay();
			}
		}
		
		//--------Getters And Setters--------//
		public function get tileX():int
		{
			return Math.floor(this.x/TileSystem.globalTileSize);
		}

		public function get tileY():int
		{
			return Math.floor(this.y/TileSystem.globalTileSize);
		}
		
		public function get id():String
		{
			return this._id
		}
		
		public function set id(id:String):void
		{
			this._id=id
			setDisplay();
		}
		
		public function get data():int
		{
			return this._data
		}
		
		public function set data(data:int):void
		{
			this._data=data
			setDisplay();
		}
		
		public function get attributes():TileAttributes
		{
			return TileAttributes.fromID(this.id)
		}
		
		public function get rot():uint
		{
			return this._rot
		}
		
		public function set rot(rot:uint):void
		{
			this._rot=rot%4
			this.rotation=this._rot*90;
		}
		
		public function get hard():uint
		{
			return this._hard
		}
		
		public function set hard(hard:uint):void
		{
			this._hard=Math.min(hard,this._maxHard)
			//setDestroyStage
			var destroyPercent:Number=(this._maxHard-this._hard)/this._maxHard;
			var stageFrame:uint=Math.ceil(destroyPercent*destroyStageCount);
			this.destroyStage.showStage(stageFrame);
		}
		
		public function get maxHard():uint
		{
			return this._maxHard
		}
		
		public function set maxHard(hard:uint):void
		{
			this._maxHard=hard
			this.hard=Math.min(this.hard,this._maxHard)
		}
		
		public function get scale():Number
		{
			return this._scale
		}
		
		public function set scale(scale:Number):void
		{
			this.scaleY=this.scaleX=this._scale=Math.max(scale,0);
		}

		//--------Attribute Functions--------//
		public function resetHardness():void
		{
			if(this.hard!=TileSystem.getHardnessFromID(this.id))
			this.maxHard=this.hard=TileSystem.getHardnessFromID(this.id);
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
				if(this.attributes!=null&&this.attributes.technical&&this.displayFrom==TileDisplayFrom.IN_ENTITY)
				{
					this.Shape.visible=true
					this.Shape.setDisplay(TileID.Technical,this.data,this.displayFrom)
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
			if(TileSystem.needColor(id))
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
			if(this.attributes!=null&&this.attributes.resizeByData)
			{
				this.scale=1/Math.max((Data+2)*4/10,1)
			}
			else this.scale=1
		}

		public function removeSelf():void
		{
			this.parent.removeChild(this)
		}

		//========Detect Functions========//
		public function get hasAllowID():Boolean
		{
			return TileSystem.isAllowID(this.id)
		}

		//==========Transform Function==========//
		public function get invItem():InventoryItem
		{
			return new InventoryItem(this.id,1,this.data)
		}

		public function get tile():Tile
		{
			return new Tile(this.displayFrom,null,
							this.x,this.y,
							this.id,this.data,0,
							TileSystem.Level_NA,
							this.xSize,this.ySize)
		}
	}
}