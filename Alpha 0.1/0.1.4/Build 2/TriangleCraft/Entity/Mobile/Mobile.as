package TriangleCraft.Entity.Mobile
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Inventory.IhasInventory
	import TriangleCraft.Entity.Mobile.*
	import TriangleCraft.Entity.Entity
	import TriangleCraft.Entity.EntityID
	import TriangleCraft.Tile.TileSystem
	import TriangleCraft.Common.*
	use namespace intc
	
	//Flash
	import flash.errors.IllegalOperationError;
	
	//Class
	public class Mobile extends Entity
	{
		//============Instance Variables============//
		//Move
		protected var _rot:int=0
		intc var moveType:String="Default";
		intc var moveDistence:uint=TileSystem.globalTileSize;
		
		//Health
		intc var _health:uint;
		intc var _maxHealth:uint;
		
		//Ability
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
		
		//-----Getters And Setters-----//
		public function get hasInventory():Boolean
		{
			return this is IhasInventory
		}

		//--------Move Functions--------//
		public function get Rot():int
		{
			return this._rot%4
		}
		
		public function set Rot(rot:int):void
		{
			this._rot=rot
			this.rotation=_rot*90
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
			MoveBy(MobileRot.toPos(dir,dis)[0],MobileRot.toPos(dir,dis)[1]);
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
				this._health=tcMath.NumberBetween(health,0,this.MaxHealth);
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
	}
}