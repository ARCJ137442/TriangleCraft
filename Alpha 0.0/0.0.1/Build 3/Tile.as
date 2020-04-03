package 
{
	import flash.display.MovieClip;
	import TileDestroyStage

	public class Tile extends MovieClip
	{
		//Static Consts
		public static const TotalTileCount:uint=3
		static const destroyStages:uint=10
		//Graphics
		private var xSize:uint=32;
		private var ySize:uint=32;
		public var TileColor:uint=0x888888;
		private var destroyStage:TileDestroyStage
		private var Shape:MovieClip
		//Attributes
		public var Alpha:uint=100;
		public var TileID:int=0;
		public var TileData:int=0;
		public var TileTag:Object={canPass:false,canGet:true,canDestroy:true,canPlace:true,canPlaceBy:false,canUse:false,canRotate:false};
		public var TileHard:int=0;
		public var TileMaxHard:int=1;

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
			this.Shape=new TileShape()
			Shape.scaleX=this.xSize/100
			Shape.scaleY=this.ySize/100
			this.destroyStage=new TileDestroyStage(destroyStages)
			destroyStage.scaleX=this.xSize/100
			destroyStage.scaleY=this.ySize/100
			destroyStage.blendMode="invert"
			addChild(Shape)
			setChildIndex(Shape,this.numChildren-1)
			addChild(destroyStage)
			setChildIndex(destroyStage,this.numChildren-1)
			//Set Size
			SetSize();
			//Set Color
			IDefine(Id,Data);
			if (TileID>0)
			{
				showColor(TileColor,Alpha);
			}
		}

		public function changeTile(Id:int,Data:uint=0,Tag:Object=null):void
		{
			this.TileID=Id;
			this.TileData=Data;
			IDefine(TileID,TileData,Tag);
			SetSize();
			if (Tag!=null)
			{
				this.TileTag=Tag;
			}
		}

		//--------Define Functions--------//
		private function IDefine(Id:int,Data:int=0,Tag:Object=null):Boolean
		{
			var Color_Old=TileColor;
			switch (Id)
			{
				case 3 ://Block Crafter
					this.gotoAndStop("Sprite_Blocks");
					TileColor=0x888888;
					Alpha=100;
					break;
				case 2 ://Color Mixer
					this.gotoAndStop("Sprite_Blocks");
					TileColor=0x888888;
					Alpha=100;
					break;
				case 1 ://Colored Block
					this.gotoAndStop("Colored_Block");
					Alpha=100;
					if (Data==-1)
					{
						TileColor=0x888888;
					}
					else if (Data<-1)
					{
						TileColor=Math.floor(Math.random()*0xffffff);
						TileData=TileColor;
					}
					else
					{
						TileColor=Data;
					}
					break;
				case 0 ://Null
					this.gotoAndStop("Colored_Block");
					TileColor=0x000000;
					Alpha=0;
					break;
			}
			this.Shape.gotoAndStop(Id);
			this.TileTag=getTagFromID(Id);
			resetHardness();
			if (Id<2)
			{
				showColor(TileColor,Alpha);
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
				case 3 ://Block Crafter
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=true;
					Tag.canRotate=false
					break;
				case 2 ://Color Mixer
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=true;
					Tag.canRotate=false
					break;
				case 1 ://Colored Block
					Tag.canPass=false;
					Tag.canGet=true;
					Tag.canPlace=true;
					Tag.canPlaceBy=false;
					Tag.canDestroy=true;
					Tag.canUse=false;
					Tag.canRotate=false
					break;
				case 0 ://Null
					Tag.canPass=true;
					Tag.canGet=false;
					Tag.canPlace=false;
					Tag.canPlaceBy=true;
					Tag.canDestroy=false;
					Tag.canUse=false;
					Tag.canRotate=false
					break;
			}
			return Tag;
		}

		public static function getHardnessFromID(Id):uint
		{
			switch (Id)
			{
				case 3 ://Block Crafter
					return 5;
					break;
				case 2 ://Color Mixer
					return 5;
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
			this.TileHard=num
			//setDestroyStage
			var destroyPercent:Number=(this.TileMaxHard-this.TileHard)/this.TileMaxHard
			var stageFrame:uint=Math.ceil(destroyPercent*destroyStages)
			this.destroyStage.showStage(stageFrame)
		}

		public function resetHardness():void
		{
			this.TileHard=getHardnessFromID(this.TileID);
			this.TileMaxHard=this.TileHard;
		}
		
		public function clearDestroyStage()
		{
			//setDestroyStage
			this.destroyStage.showStage(0)
		}

		//--------Display Functions--------//
		private function showColor(color:uint=0x888888,A:Number=100):void
		{
			var RGB=trunRGB(color);
			this.R.alpha=RGB[0]/25500*A;
			this.G.alpha=RGB[1]/25500*A;
			this.B.alpha=RGB[2]/25500*A;
			this.Black.alpha=A;
			//trace(this.R.alpha,this.G.alpha,this.B.alpha,this.Black.alpha)
		}

		public function SetSize()
		{
			if (this.TileID>=2)
			{
				if (this.currentFrame!=this.TileID)
				{
					this.gotoAndStop(this.TileID);
					this.Shape.gotoAndStop(this.TileID);
				}
				this.Shape.width=xSize;
				this.Shape.height=ySize;
			}
			else if (this.TileID<2&&this.currentFrame<2)
			{
				this.R.x=- xSize/2;
				this.R.y=- ySize/2;
				this.G.x=- xSize/2;
				this.G.y=- ySize/2;
				this.B.x=- xSize/2;
				this.B.y=- ySize/2;
				this.Black.x=- xSize/2;
				this.Black.y=-ySize/2
				;
				this.R.width=xSize;
				this.R.height=ySize;
				this.G.width=xSize;
				this.G.height=ySize;
				this.B.width=xSize;
				this.B.height=ySize;
				this.Black.width=xSize;
				this.Black.height=ySize;
			}
		}
		
		public function setRotation(rot:int)
		{
			this.rotation=rot*90
		}

		public static function trunRGB(I:uint):Array
		{
			var r:int=(I>>16);
			var g:int=(I-(r<<16))>>8;
			var b:int=I-(r<<16)-(g<<8);

			//trace("Color = " + I.toString(16));
			//trace("R = " + r);
			//trace("G = " + g);
			//trace("B = " + b);
			return [r,g,b];
		}
	}
}