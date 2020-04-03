package 
{
	import Entity
	import TileSystem
	import EntitySystem
	import flash.errors.IllegalOperationError;
	
	public class Mobile extends Entity
	{
		//============Consts============//
		public static const Facing_Up:int=0
		public static const Facing_Down:int=2
		public static const Facing_Left:int=3
		public static const Facing_Right:int=1
		
		//========Dynamic Variables========//
		//Move
		protected var moveRot:int=0
		public var moveType:String="Default";
		public var moveDistence:uint=TileSystem.globalTileSize;
		public var moveTick:uint=320;
		public var moveDelay:uint=320;
		public var moveLoop:uint=125;
		
		//Health
		protected var Health:uint;
		protected var MaxHealth:uint;
		
		//--------Set Mobile--------//
		public function Mobile(Host:Game,
							   X:Number,
							   Y:Number,
							   sizeX:uint=TileSystem.globalTileSize,
							   sizeY:uint=TileSystem.globalTileSize):void
		{
			super(Host,X,Y,sizeX,sizeY)
			this.moveDistence=(xSize+ySize)/2;
		}

		//--------Move Functions--------//
		public function get Rot():int
		{
			return this.moveRot%4
		}
		
		public function set Rot(rot:int):void
		{
			this.setRot(rot)
		}
		
		protected function setRot(rot:int):void
		{
			this.moveRot=rot
			this.rotation=rot*90-90
		}
		
		public function MoveByDir(dir:uint,dis:uint=1,setP:Boolean=true):void
		{
			//Detect Mobile Id
			if(!EntitySystem.isAllowMobileID(this.EntityType))
			{
				throw new IllegalOperationError("Invalid MobileType:"+this.EntityType)
			}
			if(setP)
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