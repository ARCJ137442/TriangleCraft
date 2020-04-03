package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	//Class
	public class Entity extends Sprite
	{
		//=========Static Consts=========//
		public static const AllNotMobileID:Array=[EntityID.Item]
		public static const AllMobileID:Array=[EntityID.Player]
		
		public static const AllEntityID:Array=AllMobileID.concat(AllNotMobileID)
		public static const TotalEntityCount:uint=AllEntityID.length
		
		//=========Static Variables=========//
		private static var NowId:uint=0
		
		//========Dynamic Variables========//
		intc var UUID:int=-1
		intc var EntityType:String
		intc var xSize:uint;
		intc var ySize:uint;
		intc var hasCollision:Boolean=true;
		
		protected var Host:Game
		protected var TickRunFunction:Function;
		protected var _isActive:Boolean
		
		//==========Static Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(General.IsiA(Id,AllEntityID))
			{
				return true
			}
			trace("Not Allow Entity ID:"+Id)
			return false
		}
		
		public static function isAllowMobileID(Id:String):Boolean
		{
			if(General.IsiA(Id,Entity.AllMobileID))
			{
				return true
			}
			trace("Not Allow Mobile ID:"+Id)
			return false
		}
		
		public static function isAllowNotMobileID(Id:String):Boolean
		{
			if(General.IsiA(Id,Entity.AllNotMobileID))
			{
				return true
			}
			trace("Not Allow NotMobile ID:"+Id)
			return false
		}

		//============Init Entity============//
		public function Entity(
	 	   Host:Game,
		   X:Number,
		   Y:Number,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize)
		{
			//Test EntityId
			if(!Entity.isAllowID(this.EntityType))
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
			//Set Active
			this.isActive=true
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
		
		public function get isActive():Boolean
		{
			return this._isActive
		}
		
		public function set isActive(value:Boolean):void
		{
			this._isActive=value
		}

		//============Pos Functions============//
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
			switch(this.rotation)
			{
				case 0:
					return 1;
					break;
				case 90:
					return 2;
					break;
				case 180:
					return 3;
					break;
				case -90:
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
		
		//============--Remove Function============--//
		public function deleteSelf():void
		{
			this.parent.removeChild(this)
		}
		
		//============Tick Run Functions============//
		public function get hasTickFunction():Boolean
		{
			return (this.TickRunFunction!=null)
		}
		
		public function set TickFunction(Func:Function):void
		{
			this.TickRunFunction=Func
		}
		
		public function get TickFunction():Function
		{
			return this.TickRunFunction
		}
		
		public function runTickFunction():void
		{
			if(this._isActive&&this.hasTickFunction)
			{
				this.TickFunction(this)
			}
		}
	}
}