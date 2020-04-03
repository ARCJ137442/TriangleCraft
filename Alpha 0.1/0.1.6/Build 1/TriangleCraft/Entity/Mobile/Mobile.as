package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Inventory.*
	import TriangleCraft.Entity.Mobile.*
	import TriangleCraft.Entity.*
	import TriangleCraft.Tile.*
	import TriangleCraft.Common.*
	
	
	//Flash
	import flash.errors.IllegalOperationError;
	
	//Class
	public class Mobile extends Entity
	{
		//============Instance Variables============//
		//Move
		protected var _rot:int=0
		
		//Health
		public var _health:uint;
		public var _maxHealth:uint;
		
		//Ability
		public var invincible:Boolean=false
		public var moveType:String="Default";
		public var moveDistence:uint=TileSystem.globalTileSize;
		
		//Hook
		public var HurtFunction:Function
		public var DeathFunction:Function
		public var HealFunction:Function
		
		//--------Init Mobile--------//
		public function Mobile(Host:Game,X:Number,Y:Number,
							   sizeX:uint=TileSystem.globalTileSize,
							   sizeY:uint=TileSystem.globalTileSize):void
		{
			super(Host,X,Y,sizeX,sizeY)
		}
		
		//-----Getters And Setters-----//
		public function get hasInventory():Boolean
		{
			return this is IhasInventory
		}

		//--------Move Functions--------//
		public function get rot():int
		{
			return this._rot%4
		}
		
		public function set rot(rot:int):void
		{
			this._rot=rot
			this.rotation=_rot*90
		}
		
		public function moveByDir(dir:uint,dis:uint=1,setP:Boolean=true):void
		{
			//Detect Mobile Id
			if(!Entity.isAllowMobileID(this._entityType))
			{
				throw new IllegalOperationError("Invalid MobileType:"+this._entityType)
			}
			if(setP)
			{
				setPos(dir);
			}
			moveBy(MobileRot.toPos(dir,dis)[0],MobileRot.toPos(dir,dis)[1]);
		}

		//--------Health Functions--------//
		//Get
		public function get health():uint
		{
			return this._health;
		}

		public function get maxHealth():uint
		{
			return this._maxHealth;
		}

		public function get healthPercent():uint
		{
			return this._health/this._maxHealth;
		}
		
		public function get hasHurtHook():Boolean
		{
			return (this.HurtFunction!=null)
		}
		
		public function get hasDeathHook():Boolean
		{
			return (this.DeathFunction!=null)
		}

		//Set
		public function set health(health:uint):void
		{
			if(health>=this._health||health<this._health&&!this.invincible)
			{
				this._health=tcMath.NumberBetween(health,0,this._maxHealth);
			}
		}

		public function set maxHealth(health:uint):void
		{
			if(health>=this._maxHealth||health<this._maxHealth&&!this.invincible)
			{
				this._maxHealth=Math.max(health,0);
			}
		}

		public function addHealth(health:uint):void
		{
			this._health+=health;
		}

		public function addMaxHealth(health:uint):void
		{
			this._maxHealth+=health;
		}
		
		//Hook
		public function damage(damage:uint=1):void
		{
			if(!this.invincible)
			{
				this._health-=damage
				if(this._health-damage<=0&&this.hasDeathHook)
				this.DeathFunction(damage)
				else if(this.hasHurtHook)
				this.HurtFunction(damage)
			}
		}
		
		public function heal(health:uint=1,addToMaxHealth:Boolean=false):void
		{
			//Add Health
			this._health+=health
			if(addToMaxHealth&&this._health+health>this._maxHealth)
			this._maxHealth=this._health+health
			//Set Hook
			this.HealFunction(health)
		}
	}
}