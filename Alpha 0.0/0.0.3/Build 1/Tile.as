package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import TileDestroyStage;
	import General

	public class Tile extends Sprite
	{
		//Static Consts
		public static const TotalTileCount:uint=7;
		static const destroyStages:uint=10;
		//Graphics
		private var xSize:uint=32;
		private var ySize:uint=32;
		public var TileColor:uint=0x888888;
		public var TileAlpha:uint=100;
		private var destroyStage:TileDestroyStage;
		private var Shape:MovieClip;
		//Attributes
		public var TileID:int=0;
		public var TileData:int=0;
		public var TileTag:Object={canPass:false,canGet:true,canDestroy:true,canPlace:true,canPlaceBy:false,canUse:false,canRotate:false,allowRandomTick:false};
		public var TileHard:int=0;
		public var TileMaxHard:int=1;
		public var TileScale:uint=1;
		public var TileRot:int=0
		public var TileDropItems:Array=new Array()
		public var TileInventory:Array=new Array()

		//--------Set Tile--------//
		public function Tile(X:int=0,Y:int=0,
		 sizeX:uint=32,sizeY:uint=32,
		 Id:int=0,Data:uint=0,Tag:Object=null)
		{
			//Set Variables
			this.x=X;
			this.y=Y;
			this.TileID=Id;
			this.TileData=Data;
			if (Tag!=null)
			{
				this.TileTag=Tag;
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
			//Set Size
			SetSize();
			//Set Color
			IDefine(Id,Data);
			if (TileID==1)//Only Able On Colored_Block
			{
				showColor(TileColor,TileAlpha);
			}
		}

		public function changeTile(Id:int,Data:uint=0,Tag:Object=null,Rot:int=0):void
		{
			this.TileID=Id;
			this.TileData=Data;
			IDefine(TileID,TileData,Tag,Rot);
			SetSize();
			if (Tag!=null)
			{
				this.TileTag=Tag;
			}
		}

		//--------Define Functions--------//
		private function IDefine(Id:int,Data:int=0,Tag:Object=null,Rot:int=0):Boolean
		{
			var Color_Old=TileColor;
			//Set Tag
			if (Tag==null)
			{
				this.TileTag=getTagFromID(Id);
			}
			else
			{
				this.TileTag=General.copyObject(Tag);
			}
			//Set Attributes
			switch(Id)
			{
				case 1 ://Colored Block
					TileAlpha=100;
					if (Data==-1)
					{
						TileColor=0x888888;
					}
					else if (Data<-1)
					{
						TileColor=Game.random(0xffffff);
						TileData=TileColor;
					}
					else
					{
						TileColor=Data;
					}
					break;
				case 0 ://Null
					TileColor=0x000000;
					TileAlpha=0;
					//this.destroyStage.resetStage()//For A Batter Game Run Speed
					break;
				default ://Other
					TileColor=0x888888;
					TileAlpha=100;
					break;
			}
			//SetScaleByData
			switch(Id)
			{
				case 6://XX Virus
				TileScale=(Data+1)*5
				break
				default://Other
				TileScale=1
				break
			}
			//SetRot
			TileRot=Rot
			//Set DropItems
			switch(Id)
			{
				case -1://None
				this.TileDropItems=[[Id,1,Data,General.copyObject(this.TileTag),Rot]]
				break
			}
			//Set Scale
			this.scaleX=1/Math.max(TileScale/10,1);
			this.scaleY=this.scaleX;
			//Set Rot
			if(this.TileTag["canRotate"])
			{
				this.rotation=(TileRot-1)*90
			}
			//Set Display
			this.Shape.gotoAndStop(Id);
			setChildIndex(Shape,this.numChildren-1);
			setChildIndex(destroyStage,this.numChildren-1);
			resetHardness();
			if (Id<2)
			{
				showColor(TileColor,TileAlpha);
			}
			else
			{
				this.visible=true
				this.graphics.clear()
			}
			if (TileColor!=Color_Old)
			{
				return true;
			}
			return false;
		}

		public static function getTagFromID(Id:int):Object
		{
			var Tag:Object=new Object  ;
			switch (Id)
			{
				case 7 ://Arrow Block
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=true;
					Tag.allowRandomTick=false;
					break;
				case 6 ://XX Virus
					Tag.canPass=false;
					Tag.canGet=false;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=false;
					Tag.allowRandomTick=true;
					break;
				case 5 ://Block Spawner
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=false;
					Tag.allowRandomTick=true;
					break;
				case 4 ://Basic Wall
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=false;
					Tag.allowRandomTick=false;
					break;
				case 3 ://Block Crafter
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=true;
					Tag.canRotate=false;//true
					Tag.allowRandomTick=false;
					break;
				case 2 ://Color Mixer
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=true;
					Tag.canRotate=false;
					Tag.allowRandomTick=false;
					break;
				case 1 ://Colored Block
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=false;
					Tag.allowRandomTick=false;
					break;
				case 0 ://Null
					Tag.canPass=true;
					Tag.canGet=false;
					Tag.canPlace=false;
					Tag.canPlaceBy=true;
					Tag.canDestroy=false;
					Tag.canUse=false;
					Tag.canRotate=false;
					Tag.allowRandomTick=false;
					break;
			}
			return Tag;
		}

		public static function getHardnessFromID(Id):uint
		{
			switch (Id)
			{
				case 7 ://Arrow Block
					return 3;
					break;
				case 6 ://XX Virus
					return 1+Game.random(2);
					break;
				case 5 ://Block Spawner
					return 4;
					break;
				case 4 ://Basic Wall
					return 8;
					break;
				case 3 ://Block Crafter
					return 4;
					break;
				case 2 ://Color Mixer
					return 4;
					break;
				case 1 ://Colored Block
					return 3;
					break;
				case 0 ://Null
					return 0;
					break;
			}
			return 0;
		}

		//--------Attribute Functions--------//
		public function setHardness(num:uint)
		{
			//setHardness
			this.TileHard=num;
			//setDestroyStage
			var destroyPercent:Number=(this.TileMaxHard-this.TileHard)/this.TileMaxHard;
			var stageFrame:uint=Math.ceil(destroyPercent*destroyStages);
			this.destroyStage.showStage(stageFrame);
		}

		public function resetHardness():void
		{
			this.TileHard=getHardnessFromID(this.TileID);
			this.TileMaxHard=this.TileHard;
		}

		public function clearDestroyStage()
		{
			//setDestroyStage
			this.destroyStage.showStage(0);
		}

		//--------Display Functions--------//;
		private function showColor(color:uint=0x888888,A:Number=100):void
		{
			if(A>0)
			{
				this.visible=true
				this.graphics.clear()
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

		public function SetSize()
		{
			if(this.TileID>=2)
			{
				if (this.Shape.currentFrame!=this.TileID)
				{
					this.Shape.gotoAndStop(this.TileID);
				}
				this.Shape.width=xSize;
				this.Shape.height=ySize;
			}
			else
			{
				showColor(TileColor,TileAlpha)
			}
		}

		public function setRotation(rot:int)
		{
			this.rotation=rot*90;
		}
	}
}