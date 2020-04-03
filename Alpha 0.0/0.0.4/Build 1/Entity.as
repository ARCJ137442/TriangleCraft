package 
{
	import Color;
	import TileSystem;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError
	import flash.events.Event;

	public class Entity extends MovieClip
	{
		public var xSize:uint=TileSystem.globalTileSize;
		public var ySize:uint=TileSystem.globalTileSize;
		public var moveType:String="Default";
		public var moveDistence:uint=TileSystem.globalTileSize;
		public var moveTick:uint=320;
		public var moveDelay:uint=320;
		public var moveLoop:uint=125;
		public var Health:uint;
		public var MaxHealth:uint;
		public var hasCollision:Boolean=true;
		
		protected var Host:DisplayObjectContainer

		//--------Set Entity--------//
		public function Entity(
		   X:Number,
		   Y:Number,
		   sizeX:int=-1,
		   sizeY:int=-1,
		   Host:Game=null)
		{
			this.x=X;
			this.y=Y;
			if(sizeX>0) this.xSize=sizeX;
			if(sizeY>0) this.ySize=sizeY;
			this.moveDistence=(xSize+ySize)/2;
			//Set Host
			this.Host=Host
			this.addEventListener(Event.ADDED_TO_STAGE,init)
		}
		
		protected function init(E:Event):void
		{
			//Set And Detect Host
			if(Host==null)
			{
				var isHost:Boolean=false
				var tempHost=this.parent
				var detectCount:uint=10
				do
				{
					if(tempHost!=null)
					{
						if(tempHost.hasOwnProperty("isTriangleCraft"))
						{
							if(tempHost["isTriangleCraft"])
							{
								isHost=true
								break
							}
						}
						detectCount--
						tempHost=tempHost.parent
					}
					else break
				}
				while(detectCount>0)
				if(isHost)
				{
					this.Host=this.parent
				}
				else
				{
					throw new IllegalOperationError("Invalid parent object!");
				}
			}
		}
		
		public function get host():DisplayObjectContainer
		{
			return this.Host
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

		//--------Move Functions--------//
		public function setX(X:int):void
		{
			this.x=X*this.xSize;
		}

		public function setY(Y:int):void
		{
			this.y=Y*this.ySize;
		}

		public function MoveTo(X:int,Y:int):void
		{
			setX(X);
			setY(Y);
		}

		public function MoveBy(X:int,Y:int):void
		{
			this.x+=X;
			this.y+=Y;
		}

		public function MoveByDir(dir:uint,dis:uint=1,setP:Boolean=true):void
		{
			if (setP)
			{
				setPos(dir);
			}
			MoveBy(getPos(dir,dis)[0],getPos(dir,dis)[1]);
		}

		//--------Health Functions--------//
		//Get
		public function getHealth():uint
		{
			return this.Health;
		}

		public function getMaxHealth():uint
		{
			return this.MaxHealth;
		}

		public function getHealthPercent():uint
		{
			return this.Health/this.MaxHealth;
		}

		//Set
		public function setHealth(Health:uint):void
		{
			this.Health=Health;
		}

		public function setMaxHealth(MaxHealth:uint):void
		{
			this.MaxHealth=MaxHealth;
		}

		public function addHealth(Health:uint):void
		{
			this.Health+=Health;
		}

		public function addMaxHealth(MaxHealth:uint):void
		{
			this.MaxHealth+=MaxHealth;
		}
	}
}