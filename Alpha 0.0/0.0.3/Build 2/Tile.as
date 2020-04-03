package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import TileDestroyStage;
	import TileSystem;
	import TileTag;
	import General

	public class Tile extends Sprite
	{
		//==========Static Consts==========//
		protected static const destroyStages:uint=10;
		
		//==========Import From System==========//
		public static const Void:String=TileSystem.Void
		public static const Colored_Block:String=TileSystem.Colored_Block
		public static const Color_Mixer:String=TileSystem.Color_Mixer
		public static const Block_Crafter:String=TileSystem.Block_Crafter
		public static const Basic_Wall:String=TileSystem.Basic_Wall
		public static const Block_Spawner:String=TileSystem.Block_Spawner
		public static const XX_Virus:String=TileSystem.XX_Virus
		public static const Arrow_Block:String=TileSystem.Arrow_Block
		
		//==========Graphics==========//
		private var xSize:uint=32;
		private var ySize:uint=32;
		public var Color:uint=0x888888;
		public var Alpha:uint=100;
		private var destroyStage:TileDestroyStage;
		private var Shape:MovieClip;
		
		//==========Attributes==========//
		public var ID:String=null;
		public var Data:int=0;
		public var Tag:Object=new TileTag();
		public var Hard:int=0;
		public var MaxHard:int=1;
		public var Scale:uint=1;
		public var Rot:int=0
		public var DropItems:Array=new Array()
		public var Inventory:Array=new Array()

		//--------Set Tile--------//
		public function Tile(X:int=0,Y:int=0,
		 sizeX:uint=32,sizeY:uint=32,
		 id:String=Void,data:uint=0,tag:TileTag=null)
		{
			//Set Variables
			this.x=X;
			this.y=Y;
			this.ID=id;
			this.Data=data;
			if(Tag!=null)
			{
				this.Tag=Tag;
			}
			this.xSize=sizeX;
			this.ySize=sizeY;
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
			IDefine(id,data);
			//Set Display
			SetDisplay();
		}

		public function changeTile(Id:String,Data:uint=0,Tag:Object=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				this.ID=Id;
				this.Data=Data;
				IDefine(ID,Data,Tag,Rot);
				SetDisplay();
				if(Tag!=null)
				{
					this.Tag=Tag;
				}
			}
		}

		//--------Define Functions--------//
		private function IDefine(Id:String,Data:int=0,Tag:Object=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				var Color_Old=Color;
				//Set Tag
				if(Tag==null)
				{
					this.Tag=TileTag.getTagFromID(Id);
				}
				else
				{
					this.Tag=General.copyObject(Tag);
				}
				//Set Attributes
				switch(Id)
				{
					case Colored_Block://Colored Block
						Alpha=100;
						if(Data==-1)
						{
							Color=0x888888;
						}
						else if(Data<-1)
						{
							Color=Game.random(0xffffff);
							Data=Color;
						}
						else
						{
							Color=Data;
						}
						break;
					case Void:
						Color=0x000000;
						Alpha=0;
						//this.destroyStage.resetStage()//For A Batter Game Run Speed
						break;
					default://Other
						Color=0x888888;
						Alpha=100;
						break;
				}
				//SetScaleByData
				switch(Id)
				{
					case XX_Virus://XX Virus
					Scale=(Data+1)*5
					break
					default://Other
					Scale=1
					break
				}
				//SetRot
				Rot=Rot
				//Set DropItems
				switch(Id)
				{
					case null://None
					this.DropItems=[[Id,1,Data,General.copyObject(this.Tag),Rot]]
					break
				}
				//Set Scale
				this.scaleX=1/Math.max(Scale/10,1);
				this.scaleY=this.scaleX;
				//Set Rot
				if(this.Tag["canRotate"])
				{
					this.rotation=(Rot-1)*90
				}
				//Set Display
				resetHardness();
			}
		}

		//--------Attribute Functions--------//
		public function setHardness(num:uint)
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
			this.Hard=getHardnessFromID(this.ID);
			this.MaxHard=this.Hard;
		}

		public function clearDestroyStage()
		{
			//setDestroyStage
			this.destroyStage.showStage(0);
		}

		//--------Display Functions--------//;
		private function showColor(color:uint=0x888888,A:Number=100):void
		{
			if(needColor(ID))
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
		
		private function clearColor():void
		{
			this.graphics.clear()
		}

		public function SetDisplay():void
		{
			//trace(hasAllowID(),needColor(ID))
			if(hasAllowID())
			{
				if(!needColor(ID))
				{
					this.visible=true
					this.Shape.visible=true
					if(this.Shape.currentFrame!=getFrameByID(this.ID))
					{
						this.Shape.gotoAndStop(getFrameByID(this.ID));
					}
					this.Shape.width=xSize;
					this.Shape.height=ySize;
					clearColor()
					//trace(this.Shape.currentFrame,getFrameByID(this.ID),this.Shape.visible)
				}
				else
				{
					this.Shape.visible=false
					showColor(Color,Alpha)
				}
				setChildIndex(Shape,this.numChildren-1);
				setChildIndex(destroyStage,this.numChildren-1);
			}
		}

		public function setRotation(rot:int)
		{
			this.rotation=rot*90;
		}
		
		//==========Static Functions==========//
		public static function getHardnessFromID(Id:String):uint
		{
			switch (Id)
			{
				case TileSystem.Arrow_Block:
					return 3;
					break;
				case TileSystem.XX_Virus:
					return 1+Game.random(2);
					break;
				case TileSystem.Block_Spawner:
					return 4;
					break;
				case TileSystem.Basic_Wall:
					return 8;
					break;
				case TileSystem.Block_Crafter:
					return 4;
					break;
				case TileSystem.Color_Mixer:
					return 4;
					break;
				case TileSystem.Colored_Block:
					return 3;
					break;
				case TileSystem.Void:
					return 0;
					break;
			}
			return 0;
		}
		
		protected static function getFrameByID(Id:String):uint
		{
			if(TileSystem.isAllowID(Id)&&!needColor(Id))
			{
				switch(Id)
				{
					case TileSystem.Color_Mixer:
					return 1
					break
					case TileSystem.Block_Crafter:
					return 2
					break
					case TileSystem.Basic_Wall:
					return 3
					break
					case TileSystem.Block_Spawner:
					return 4
					break
					case TileSystem.XX_Virus:
					return 5
					break
					case TileSystem.Arrow_Block:
					return 6
					break
				}
			}
			return 0
		}
		
		protected static function needColor(Id:String):Boolean
		{
			if(TileSystem.isAllowID(Id))
			{
				if(Id==Void||Id==Colored_Block)
				{
					return true
				}
			}
			return false
		}
		
		public function hasAllowID():Boolean
		{
			return TileSystem.isAllowID(this.ID)
		}
	}
}