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
		protected static const destroyStages:uint=10;
		
		//================Dynamic Variables================//
		//==========Graphics==========//
		protected var xSize:uint=TileSystem.globalTileSize;
		protected var ySize:uint=TileSystem.globalTileSize;
		protected var Color:uint=0x888888;
		protected var Alpha:uint=100;
		protected var destroyStage:TileDestroyStage;
		protected var Shape:TileShape;
		
		//==========Attributes==========//
		public var ID:String=TileID.Void;
		public var Data:int=0;
		public var Hard:int=0;
		public var MaxHard:int=1;
		public var Scale:uint=1;
		public var Tag:TileTag=new TileTag()
		public var Rot:int=0;

		//--------Set Tile--------//
		public function TileDisplayObj(X:int=0,Y:int=0,
									   id:String=TileID.Void,data:uint=0,
									   tag:TileTag=null,rot:int=0,
									   sizeX:uint=TileSystem.globalTileSize,
									   sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set Variables
			this.x=X;
			this.y=Y;
			this.ID=id;
			this.Data=data;
			this.Rot=rot
			this.xSize=sizeX;
			this.ySize=sizeY;
			//Set Tag
			setTag(tag)
			//--==Add Children==--//
			this.Shape=new TileShape();
			Shape.scaleX=this.xSize/100;
			Shape.scaleY=this.ySize/100;
			this.destroyStage=new TileDestroyStage(destroyStages);
			destroyStage.scaleX=this.xSize/100;
			destroyStage.scaleY=this.ySize/100;
			destroyStage.blendMode="invert";
			addChild(Shape);
			setChildIndex(Shape,this.numChildren-1);
			addChild(destroyStage);
			setChildIndex(destroyStage,this.numChildren-1);
			//Set Define
			Define(id,data,tag,rot);
			//Set Display
			SetDisplay();
		}
		
		public function setByItem(item:InventoryItem):void
		{
			changeTile(item.Id,item.Data,item.Tag,item.Rot)
		}

		public function changeTile(Id:String,Data:uint=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				this.ID=Id;
				this.Data=Data;
				Define(ID,Data,Tag,Rot);
				SetDisplay();
			}
		}

		//--------Define Functions--------//
		protected function Define(id:String,data:int=0,tag:TileTag=null,rot:int=0):void
		{
			if(TileSystem.isAllowID(id))
			{
				//Set Tag
				setTag(tag)
				//Set Rot
				this.Rot=Rot%4
				//Set Hardness
				resetHardness();
			}
		}

		//--------Attribute Functions--------//
		public function setTag(InputTag:TileTag):void
		{
			if(InputTag==null)
			{
				this.Tag=TileTag.getTagFromID(this.ID);
			}
			else
			{
				this.Tag=InputTag.getCopy();
			}
		}
		
		public function setHardness(num:uint):void
		{
			//setHardness
			this.Hard=num;
			//setDestroyStage
			var destroyPercent:Number=(this.MaxHard-this.Hard)/this.MaxHard;
			var stageFrame:uint=Math.ceil(destroyPercent*destroyStages);
			this.destroyStage.showStage(stageFrame);
		}

		public function resetHardness():void
		{
			this.Hard=TileSystem.getHardnessFromID(this.ID);
			this.MaxHard=this.Hard;
		}

		public function clearDestroyStage():void
		{
			//setDestroyStage
			this.destroyStage.showStage(0);
		}

		//--------Display Functions--------//;
		public function SetDisplay():void
		{
			//trace(hasAllowID,TileSystem.needColor(ID))
			if(hasAllowID)
			{
				//Display
				switch(this.ID)
				{
					case TileID.Void:
						this.visible=false
						this.Shape.visible=false
						return
					case TileID.Colored_Block://Colored Block
						Alpha=100;
						if(Data==-1)
						{
							Color=0x888888;
						}
						else if(Data<-1)
						{
							Color=General.random(0xffffff);
							Data=Color;
						}
						else
						{
							Color=Data;
						}
						break;
						//this.destroyStage.resetStage()//For A Batter Game Run Speed
					default://Other
						Color=0x888888;
						Alpha=100;
						break;
				}
				this.visible=true
				if(!TileSystem.needColor(ID))
				{
					this.Shape.visible=true
					this.Shape.setDisplay(this.ID,this.Data)
					this.Shape.width=xSize;
					this.Shape.height=ySize;
					clearColor()
				}
				else
				{
					this.Shape.visible=false
					showColor(Color,Alpha)
				}
				//Rotation
				if(this.Tag.canRotate)
				{
					setRotation(this.Rot)
				}
				//Scale
				setScale(this.ID,this.Data)
				//ChildIndex
				setChildIndex(Shape,this.numChildren-1);
				setChildIndex(destroyStage,this.numChildren-1);
			}
		}

		protected function showColor(color:uint=0x888888,A:Number=100):void
		{
			if(TileSystem.needColor(ID))
			{
				if(A>0)
				{
					this.visible=true
					clearColor()
					this.graphics.beginFill(color,A/100)
					this.graphics.drawRect(-xSize/2,-ySize/2,xSize,ySize)
					this.graphics.endFill()
					//trace(this.R.alpha,this.G.alpha,this.B.alpha,this.Black.alpha)
				}
				else
				{
					this.visible=false
				}
			}
		}
		
		protected function clearColor():void
		{
			this.graphics.clear()
		}
		
		protected function setScale(Id:String,Data:int):void
		{
			if(hasAllowID)
			{
				//Set Scale
				switch(Id)
				{
					case TileID.XX_Virus://XX Virus
					Scale=(Data+2)*4
					break
					default://Other
					Scale=1
					break
				}
				this.scaleX=1/Math.max(Scale/10,1);
				this.scaleY=this.scaleX;
			}
		}

		public function setRotation(rot:int):void
		{
			this.rotation=rot*90;
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
			return new Tile(null,
							this.x,this.y,
							this.ID,this.Data,this.Tag,
							this.Rot,TileSystem.Level_NA,
							this.xSize,this.ySize)
		}
	}
}