package TriangleCraft.Entity.Entities
{
	//TriangleCraft
	import TriangleCraft.Entity.*;
	import TriangleCraft.Game;
	import TriangleCraft.Tile.TileDisplayObj;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	
	//Flash
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;

	//Class
	public class EntityItem extends Entity
	{
		//============Static Variables============//
		protected static const SIZE:uint=TileSystem.globalTileSize*(8/16)
		protected static const DPS:uint=32
		protected static const DELAY:uint=1000/DPS
		public static const MAX_LIFE_TIME:uint=Game.FPS*60*5//5 Minines
		
		//============Instance Variables============//
		protected var _item:InventoryItem
		protected var _tile:TileDisplayObj
		protected var xd:Number,yd:Number,vr:Number
		protected var lastx:Number,lasty:Number,lastr:Number
		protected var LastTime:uint
		protected var targetX:Number,targetY:Number
		protected var targetScale:Number,targetTime:Number,sd:Number
		protected var TargetTimer:Timer
		
		public var pickupTime:uint=0
		public var lifeTime:uint=0
		
		//============Init Entity.Item============//
		public function EntityItem(host:Game,
								   x:Number,y:Number,
								   id:TileID,count:uint=1,data:int=0,
								   xd:Number=NaN,yd:Number=NaN,vr:Number=NaN):void
		{
			//Define
			this._entityType=EntityType.EntityItem
			super(host,x,y,SIZE,SIZE)
			this.hasCollision=false
			LastTime=getTimer()
			this.tickFunction=this.onMove
			//setMove
			this.rotation=tcMath.random(360)
			if(isNaN(xd)||isNaN(yd))
			{
				var dir:Number=tcMath.random(360)*Math.PI/180
				var dis:Number=tcMath.randomBetween(TileSystem.globalTileSize,TileSystem.globalTileSize*2,true)
				if(isNaN(xd)) this.xd=Math.cos(dir)*dis else this.xd=xd
				if(isNaN(yd)) this.yd=Math.sin(dir)*dis else this.yd=yd
			}
			if(isNaN(vr)) this.vr=tcMath.randomBetween(90,270)/Game.FPS else this.vr=vr
			this.xd/=TileSystem.globalTileSize
			this.yd/=TileSystem.globalTileSize
			//setItem
			this._item=new InventoryItem(id,count,data)
			//setDisplay
			this._tile=new TileDisplayObj(TileDisplayFrom.IN_ENTITY,0,0,id,data,0,SIZE,SIZE)
			this.addChild(this._tile)
		}
		
		//==========SET==========//
		public function setItem(id:TileID=null,count:uint=0,data:int=0):void
		{
			var runId:TileID=id,runCount:uint=count,runData:int=data
			if(id==null) runId=this.id
			if(count==0) runCount=this.count
			this._item.setItem(runId,runCount,runData)
			this._tile.changeTile(runId,runData)
		}
		
		//==========MOVE==========//
		protected function onMove(Ent:Entity=null):void
		{
			//Move
			this.x+=xd
			this.y+=yd
			this.rotation+=vr
			//Detect
			_host.detectItem(this)
			//Set And Memory
			this.lastx=this.x
			this.lasty=this.y
			this.lastr=this.rotation
			this.xd*=1-_host.Fraction
			this.yd*=1-_host.Fraction
			this.vr*=1-_host.Fraction
			//LifeTime & PickupTime
			if(lifeTime<EntityItem.MAX_LIFE_TIME) lifeTime++ else this.lifeComplete()
			if(pickupTime>0) pickupTime--
		}
		
		public function reboundX():void
		{
			this.xd=-this.xd
		}
		
		public function reboundY():void
		{
			this.yd=-this.yd
		}
		
		public function scaleAndMove(MoveX:Number,MoveY:Number,
									 Scale:Number=1,Time:Number=0.25):void
		{
			this.targetX=MoveX
			this.targetY=MoveY
			this.targetScale=Scale
			this.targetTime=Time
			this.startTargetMove()
		}
		
		protected function startTargetMove():void
		{
			this.TargetTimer=new Timer(1,this.targetTime*100)
			this.TargetTimer.addEventListener(TimerEvent.TIMER,targetMove)
			this.TargetTimer.addEventListener(TimerEvent.TIMER_COMPLETE,stopTargetMove)
			this.xd=(this.targetX-this.x)/this.targetTime/100
			this.yd=(this.targetY-this.y)/this.targetTime/100
			this.sd=(this.targetScale-this.scaleX)/this.targetTime/100
			this.TargetTimer.start()
		}
		
		protected function stopTargetMove(E:TimerEvent=null):void
		{
			this.TargetTimer.stop()
			this.TargetTimer.removeEventListener(TimerEvent.TIMER,targetMove)
			this.TargetTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,stopTargetMove)
			if(this.targetScale==0)
			{
				this.deleteSelf()
				_host.removeEntity(this)
			}
		}
		
		protected function targetMove(E:TimerEvent=null):void
		{
			this.x+=this.xd
			this.y+=this.yd
			this.scaleX+=sd
			this.scaleY+=sd
		}
		
		//===========Delete Functions==========//
		public function lifeComplete():void
		{
			this.deleteSelf()
			_host.removeEntity(this)
		}
		
		public override function deleteSelf():void
		{
			if(this.TargetTimer==null) return
			if(this.TargetTimer.running) stopTargetMove()
			this.isActive=false
			this._item=null
			this._tile=null
			super.deleteSelf()
		}
		
		//==========Getter Functions==========//
		public function get lastX():Number
		{
			return this.lastx
		}
		
		public function get lastY():Number
		{
			return this.lasty
		}
		
		public function get lastR():Number
		{
			return this.lastr
		}
		
		public function get Item():InventoryItem
		{
			return this._item
		}
		
		public function get id():TileID
		{
			return this._item.id
		}
		
		public function get count():uint
		{
			return this._item.count
		}
		
		public function get data():int
		{
			return this._item.data
		}
		
		public function get attributes():TileAttributes
		{
			return TileAttributes.fromID(id)
		}
	}
}