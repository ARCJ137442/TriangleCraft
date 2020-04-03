package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import TileDestroyStage;
	import TileSystem;
	import TileTag;
	import General;

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
		public static const XX_Virus_Red:String=TileSystem.XX_Virus_Red
		public static const XX_Virus_Blue:String=TileSystem.XX_Virus_Blue
		public static const Arrow_Block:String=TileSystem.Arrow_Block
		
		//==========Graphics==========//
		private var xSize:uint=TileSystem.globalTileSize;
		private var ySize:uint=TileSystem.globalTileSize;
		public var Color:uint=0x888888;
		public var Alpha:uint=100;
		private var destroyStage:TileDestroyStage;
		private var Shape:MovieClip;
		
		//==========Attributes==========//
		public var ID:String=null;
		public var Data:int=0;
		public var Tag:TileTag=new TileTag();
		public var Hard:int=0;
		public var MaxHard:int=1;
		public var Scale:uint=1;
		public var Rot:int=0
		public var DropItems:Array=new Array()
		public var Inventory:Array=new Array()

		//--------Set Tile--------//
		public function Tile(X:int=0,Y:int=0,
		 sizeX:uint=TileSystem.globalTileSize,sizeY:uint=TileSystem.globalTileSize,
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

		public function changeTile(Id:String,Data:uint=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				this.ID=Id;
				this.Data=Data;
				IDefine(ID,Data,Tag,Rot);
				SetDisplay();
			}
		}

		//--------Define Functions--------//
		private function IDefine(Id:String,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				var Color_Old=Color;
				//Set Tag
				setTag(Tag)
				//Set DropItems
				switch(Id)
				{
					case null://None
					this.DropItems=[new InventoryItem(Id,1,Data,Tag.getCopy(),Rot)]
					break
				}
				//Set Rot
				Rot=Rot
				if(this.Tag["canRotate"])
				{
					this.rotation=(Rot-1)*90
				}
				//Set Display
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
				//Color
				if(!TileSystem.needColor(ID))
				{
					this.visible=true
					this.Shape.visible=true
					if(this.Shape.currentFrame!=TileSystem.getFrameByID(this.ID))
					{
						this.Shape.setFrame(TileSystem.getFrameByID(this.ID));
					}
					this.Shape.width=xSize;
					this.Shape.height=ySize;
					clearColor()
				}
				else
				{
					this.Shape.visible=false
					showColor(Color,Alpha)
				}
				setChildIndex(Shape,this.numChildren-1);
				setChildIndex(destroyStage,this.numChildren-1);
				//Scale
				setScale(this.ID,this.Data)
			}
		}

		private function showColor(color:uint=0x888888,A:Number=100):void
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
		
		private function clearColor():void
		{
			this.graphics.clear()
		}
		
		private function setScale(Id:String,Data:int):void
		{
			if(hasAllowID)
			{
				//Set Scale
				switch(Id)
				{
					case XX_Virus://XX Virus
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
		
		//========Detect Functions========//
		public function get hasAllowID():Boolean
		{
			return TileSystem.isAllowID(this.ID)
		}
	}
}