package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
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
		public static const AllNotMobileID:Vector.<String>=new <String>[EntityType.Item,
																		EntityType.CraftRecipePreview]
		public static const AllMobileID:Vector.<String>=new <String>[EntityType.Player]
		
		//=========Static Variables=========//
		private static var NowId:uint=0
		
		//=========Static Functions=========//
		public static function get AllEntityID():Vector.<String>
		{
			return AllMobileID.concat(AllNotMobileID)
		}
		
		public static function get TotalEntityCount():uint
		{
			return AllEntityID.length
		}
		
		//========Instance Variables========//
		intc var xSize:uint;
		intc var ySize:uint;
		intc var hasCollision:Boolean=true;
		
		protected var _uuid:int=-1;
		protected var _entityType:String
		protected var _host:Game
		protected var TickRunFunction:Function;
		protected var _isActive:Boolean
		
		//==========Static Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(AllEntityID.indexOf(Id)>=0)
			{
				return true
			}
			trace("Not Allow Entity ID:"+Id)
			return false
		}
		
		public static function isAllowMobileID(Id:String):Boolean
		{
			if(AllMobileID.indexOf(Id)>=0)
			{
				return true
			}
			trace("Not Allow Mobile ID:"+Id)
			return false
		}
		
		public static function isAllowNotMobileID(Id:String):Boolean
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
	 	   Host:Game,
		   X:Number,
		   Y:Number,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize)
		{
			//Test EntityId
			if(!Entity.isAllowID(this._entityType))
			{
				throw new IllegalOperationError("Invalid EntityType:"+this._entityType)
			}
			//Set Pos
			this.x=X;
			this.y=Y;
			this.xSize=sizeX
			this.ySize=sizeY
			//Set Host
			this._host=Host
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
			return this.rotation/90+MobileRot.RIGHT
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
			return (this.TickRunFunction!=null)
		}
		
		public function set TickFunction(Func:Function):void
		{
			this.TickRunFunction=Func
		}
		
		public function get entityType():String
		{
			return this._entityType
		}
		
		public function get UUID():int 
		{
			return this._uuid
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