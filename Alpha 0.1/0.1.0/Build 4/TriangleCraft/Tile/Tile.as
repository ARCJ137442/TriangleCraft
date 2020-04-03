package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.General;
	import TriangleCraft.InventoryItem;
	import TriangleCraft.Tile.*;

	//Flash
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.errors.IllegalOperationError;

	//Class
	public class Tile extends Sprite
	{
		//================Static Consts================//
		protected static const destroyStages:uint=10;
		public static const Rot_Up:int=3
		public static const Rot_Down:int=1
		public static const Rot_Left:int=2
		public static const Rot_Right:int=0
		
		//==========Import From System==========//
		public static const Void:String=TileID.Void
		public static const Colored_Block:String=TileID.Colored_Block
		public static const Color_Mixer:String=TileID.Color_Mixer
		public static const Block_Crafter:String=TileID.Block_Crafter
		public static const Basic_Wall:String=TileID.Basic_Wall
		public static const Block_Spawner:String=TileID.Block_Spawner
		public static const XX_Virus:String=TileID.XX_Virus
		public static const XX_Virus_Red:String=TileID.XX_Virus_Red
		public static const XX_Virus_Blue:String=TileID.XX_Virus_Blue
		public static const Arrow_Block:String=TileID.Arrow_Block
		public static const Barrier:String=TileID.Barrier
		public static const Crystal_Wall:String=TileID.Crystal_Wall
		public static const Walls_Spawner:String=TileID.Walls_Spawner
		
		//================Dynamic Variables================//
		//==========Graphics==========//
		public var Level:String=TileSystem.Level_NA;
		private var xSize:uint=TileSystem.globalTileSize;
		private var ySize:uint=TileSystem.globalTileSize;
		public var Color:uint=0x888888;
		public var Alpha:uint=100;
		private var destroyStage:TileDestroyStage;
		private var Shape:TileShape;
		
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
							 id:String=Void,data:uint=0,tag:TileTag=null,Rot:int=0,
							 Level:String=TileSystem.Level_NA,
							 sizeX:uint=TileSystem.globalTileSize,
							 sizeY:uint=TileSystem.globalTileSize):void
		{
			//Detect Level
			if(!TileSystem.isAllowLevel(Level))
			{
				throw new IllegalOperationError("Invalid Level!")
			}
			//Set Variables
			this.x=X;
			this.y=Y;
			this.ID=id;
			this.Data=data;
			if(Tag!=null)
			{
				this.Tag=Tag;
			}
			this.Rot=Rot
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
		
		public static function getByItem(item:InventoryItem,X:int=0,Y:int=0,
										 Level:String=TileSystem.Level_NA):Tile
		{
			return new Tile(X,Y,item.Id,item.Data,item.Tag,item.Rot,Level)
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
				IDefine(ID,Data,Tag,Rot);
				SetDisplay();
			}
		}

		//--------Define Functions--------//
		private function IDefine(Id:String,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			if(TileSystem.isAllowID(Id))
			{
				//Set Tag
				setTag(Tag)
				//Set Rot
				this.Rot=Rot%4
				//Set DropItems
				switch(Id)
				{
					case null://None
					this.DropItems=[new InventoryItem(Id,1,Data,Tag.getCopy(),Rot)]
					break
				}
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
					case Void:
						this.visible=false
						this.Shape.visible=false
						return
					case Colored_Block://Colored Block
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
				//Color
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
				if(this.Tag["canRotate"])
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
	}
}