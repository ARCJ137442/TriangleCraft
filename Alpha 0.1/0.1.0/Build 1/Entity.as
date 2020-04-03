package 
{
	import Color;
	import TileSystem;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;

	public class Entity extends MovieClip
	{
		//=========Static Variables=========//
		private static var NowId:uint=0
		
		//========Dynamic Variables========//
		public var UUID:int=-1
		public var EntityType:String
		public var xSize:uint;
		public var ySize:uint;
		public var hasCollision:Boolean=true;
		
		protected var Host:Game

		//--------Set Entity--------//
		public function Entity(
	 	   Host:Game,
		   X:Number,
		   Y:Number,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize)
		{
			//Test EntityId
			if(!EntitySystem.isAllowEntityID(this.EntityType))
			{
				throw new IllegalOperationError("Invalid EntityType:"+this.EntityType)
			}
			//Set Pos
			this.x=X;
			this.y=Y;
			this.xSize=sizeX
			this.ySize=sizeY
			//Set Host
			this.Host=Host
			//Set ID
			this.UUID=NowId
			NowId++
		}
		
		public function get host():Game
		{
			return this.Host
		}
		
		public function get Radius():uint
		{
			return this.Diameter/2
		}
		
		public function get Diameter():uint
		{
			return (this.xSize+this.ySize)/2
		}

		//--------Static Functions--------//
		public static function getPos(dir:uint,dis:uint=1):Array
		{
			switch ((dir-1)%4+1)
			{
				case 1 :
					return [dis,0];
					break;
				case 2 :
					return [0,dis];
					break;
				case 3 :
					return [-dis,0];
					break;
				case 4 :
					return [0,-dis];
					break;
			}
			return [0,0];
		}

		//--------Pos Functions--------//
		public function getX():int
		{
			return Math.floor(this.x/this.xSize);
		}

		public function getY():int
		{
			return Math.floor(this.y/this.ySize);
		}

		public function getRot():uint
		{
			switch (this.rotation)
			{
				case 0 :
					return 1;
					break;
				case 90 :
					return 2;
					break;
				case 180 :
					return 3;
					break;
				case -90 :
					return 4;
					break;
			}
			return 0;
		}

		public function setPos(dir:uint):void
		{
			this.rotation=dir*90-90;
		}
		
		public function setX(X:Number):void
		{
			this.x=X*TileSystem.globalTileSize;
		}

		public function setY(Y:Number):void
		{
			this.y=Y*TileSystem.globalTileSize;
		}

		public function MoveTo(X:Number,Y:Number):void
		{
			setX(X);
			setY(Y);
		}

		public function MoveBy(X:Number,Y:Number):void
		{
			this.x+=X;
			this.y+=Y;
		}
		
		//----------Remove Function----------//
		public function deleteSelf():void
		{
			this.parent.removeChild(this)
		}
	}
}