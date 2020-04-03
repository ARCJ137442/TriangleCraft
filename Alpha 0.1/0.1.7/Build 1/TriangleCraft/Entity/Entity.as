package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.General.MobileRot;
	import TriangleCraft.Game;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Entities.Mobile.*;
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Common.*;
	
	
	//Flash
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	//Class
	public class Entity extends Sprite
	{
		//=========Static Consts=========//
		public static const AllNotMobileID:Vector.<EntityType>=new <EntityType>[EntityType.EntityItem,
																				EntityType.CraftRecipePreview]
		public static const AllMobileID:Vector.<EntityType>=new <EntityType>[EntityType.Player]
		
		//=========Static Variables=========//
		private static var NowId:uint=0
		
		//=========Static Functions=========//
		public static function get AllEntityID():Vector.<EntityType>
		{
			return AllMobileID.concat(AllNotMobileID)
		}
		
		public static function get TotalEntityCount():uint
		{
			return AllEntityID.length
		}
		
		//========Instance Variables========//
		public var xSize:uint;
		public var ySize:uint;
		public var hasCollision:Boolean=true;
		
		protected var _uuid:int=-1;
		protected var _entityType:EntityType
		protected var _host:Game
		protected var _tickRunFunction:Function;
		protected var _isActive:Boolean
		
		//==========Static Functions===========//
		public static function isAllowType(Id:EntityType):Boolean
		{
			if(AllEntityID.indexOf(Id)>=0)
			{
				return true
			}
			trace("Not Allow Entity ID:"+Id)
			return false
		}
		
		public static function isAllowMobileType(Id:EntityType):Boolean
		{
			if(AllMobileID.indexOf(Id)>=0)
			{
				return true
			}
			trace("Not Allow Mobile ID:"+Id)
			return false
		}
		
		public static function isAllowNotMobileID(Id:EntityType):Boolean
		{
			if(AllNotMobileID.indexOf(Id)>=0)
			{
				return true
			}
			trace("Not Allow NotMobile ID:"+Id)
			return false
		}

		//============Init Entity============//
		public function Entity(
	 	   host:Game,
		   x:Number,
		   y:Number,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize)
		{
			//Test EntityId
			if(!Entity.isAllowType(this._entityType))
			{
				throw new IllegalOperationError("Invalid EntityType:"+this._entityType)
			}
			//Set Pos
			this.x=x;
			this.y=y;
			this.xSize=sizeX
			this.ySize=sizeY
			//Set Host
			this._host=host
			//Set ID
			this._uuid=NowId
			NowId++
			//Set Active
			this.isActive=true
		}
		
		public function get host():Game
		{
			return this._host
		}
		
		public function get radius():uint
		{
			return this.diameter/2
		}
		
		public function get diameter():uint
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
		public function getX():Number
		{
			return this.x/TileSystem.globalTileSize;
		}

		public function getY():Number
		{
			return this.y/TileSystem.globalTileSize;
		}
		
		public function getGridX():int
		{
			return Math.floor(this.getX());
		}

		public function getGridY():int
		{
			return Math.floor(this.getY());
		}

		public function getRot():uint
		{
			return this.rotation/90+MobileRot.ROT_RIGHT
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

		public function moveTo(X:Number,Y:Number):void
		{
			setX(X);
			setY(Y);
		}

		public function moveBy(X:Number,Y:Number):void
		{
			this.x+=X;
			this.y+=Y;
		}
		
		//============--Remove Function============--//
		public function deleteSelf():void
		{
			this.visible=false
			if(this.parent!=null)
			{
				this.parent.removeChild(this)
				//parent.removeChildAt(this.parent.getChildIndex(this.parent.getChildByName(this.name)));
			}
		}
		
		//============Tick Run Functions============//
		public function get hasTickFunction():Boolean
		{
			return (this._tickRunFunction!=null)
		}
		
		public function set tickFunction(Func:Function):void
		{
			this._tickRunFunction=Func
		}
		
		public function get entityType():EntityType
		{
			return this._entityType
		}
		
		public function get UUID():int 
		{
			return this._uuid
		}
		
		public function get tickFunction():Function
		{
			return this._tickRunFunction
		}
		
		public function runTickFunction():void
		{
			if(this._isActive&&this.hasTickFunction)
			{
				this.tickFunction(this)
			}
		}
	}
}