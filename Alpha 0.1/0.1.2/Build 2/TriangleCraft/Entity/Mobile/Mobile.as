package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Entity.Entity
	import TriangleCraft.Entity.EntityID
	import TriangleCraft.Tile.TileSystem
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.errors.IllegalOperationError;
	
	//Class
	public class Mobile extends Entity
	{
		//=========Static Consts=========//
		public static const Facing_Up:int=0
		public static const Facing_Down:int=2
		public static const Facing_Left:int=3
		public static const Facing_Right:int=1
		
		//========Dynamic Variables========//
		//Move
		protected var moveRot:int=0
		intc var moveType:String="Default";
		intc var moveDistence:uint=TileSystem.globalTileSize;
		
		//Health
		intc var _health:uint;
		intc var _maxHealth:uint;
		
		//Ability
		intc var hasInventory:Boolean=false
		intc var invincible:Boolean=false
		
		//Hook
		intc var HurtFunction:Function
		intc var DeathFunction:Function
		intc var HealFunction:Function
		
		//--------Init Mobile--------//
		public function Mobile(Host:Game,
							   X:Number,
							   Y:Number,
							   sizeX:uint=TileSystem.globalTileSize,
							   sizeY:uint=TileSystem.globalTileSize):void
		{
			super(Host,X,Y,sizeX,sizeY)
			init()
		}
		
		private function init():void
		{
			this.moveDistence=(this.xSize+this.ySize)/2;
		}

		//--------Static Functions--------//
		public static function getPos(dir:uint,dis:uint=1):Array
		{
			switch(Math.abs(dir%4))
			{
				case Mobile.Facing_Right:
					return [dis,0];
					break;
				case Mobile.Facing_Down:
					return [0,dis];
					break;
				case Mobile.Facing_Left:
					return [-dis,0];
					break;
				case Mobile.Facing_Up:
					return [0,-dis];
					break;
			}
			return [0,0];
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
			if(!Entity.isAllowMobileID(this.EntityType))
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
		intc function get Health():uint
		{
			return this.Health;
		}

		intc function get MaxHealth():uint
		{
			return this.MaxHealth;
		}

		intc function get HealthPercent():uint
		{
			return this.Health/this.MaxHealth;
		}
		
		intc function get hasHurtHook():Boolean
		{
			return (this.HurtFunction!=null)
		}
		
		intc function get hasDeathHook():Boolean
		{
			return (this.DeathFunction!=null)
		}

		//Set
		intc function set Health(health:uint):void
		{
			if(health>=this._health||health<this._health&&!this.invincible)
			{
				this._health=General.NumberBetween(health,0,this.MaxHealth);
			}
		}

		intc function set MaxHealth(health:uint):void
		{
			if(health>=this._maxHealth||health<this._maxHealth&&!this.invincible)
			{
				this._maxHealth=Math.max(health,0);
			}
		}

		intc function addHealth(health:uint):void
		{
			this.Health+=health;
		}

		intc function addMaxHealth(health:uint):void
		{
			this.MaxHealth+=health;
		}
		
		//Hook
		intc function Damage(damage:uint=1):void
		{
			if(!this.invincible)
			{
				this.Health-=damage
				if(this.Health-damage<=0&&this.hasDeathHook)
				this.DeathFunction(damage)
				else if(this.hasHurtHook)
				this.HurtFunction(damage)
			}
		}
		
		intc function Heal(health:uint=1,addToMaxHealth:Boolean=false):void
		{
			//Add Health
			this.Health+=health
			if(addToMaxHealth&&this.Health+health>this.MaxHealth)
			this.MaxHealth=this.Health+health
			//Set Hook
			this.HealFunction(health)
		}
		
		//==============Static Functions==============//
		public static function MoblieRotToTileRot(rot:int):int
		{
			return rot-1
		}
		public static function MRTR(rot:int):int
		{
			return MoblieRotToTileRot(rot)
		}
	}
}