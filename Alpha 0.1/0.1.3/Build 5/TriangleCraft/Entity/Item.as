﻿package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.Game;
	import TriangleCraft.Tile.TileDisplayObj;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;

	//Class
	public class Item extends Entity
	{
		//============Static Variables============//
		protected static const Size:uint=TileSystem.globalTileSize*(8/16)
		protected static const DPS:uint=32
		protected static const Delay:uint=1000/DPS
		public static const MaxLifeTime:uint=Game.FPS*60*5//5 Minines
		
		//============Instance Variables============//
		public var item:InventoryItem=new InventoryItem()
		public var tile:TileDisplayObj
		public var pickupTime:uint=0
		public var lifeTime:uint=0
		protected var xd:Number,yd:Number,vr:Number
		protected var lastx:Number,lasty:Number,lastr:Number
		protected var LastTime:uint
		protected var targetX:Number,targetY:Number
		protected var targetScale:Number,targetTime:Number,sd:Number
		protected var TargetTimer:Timer
		
		//============Init Entity.Item============//
		public function Item(Host:Game,
							 X:Number=0,Y:Number=0,
							 Id:String=TileID.Colored_Block,
							 Count:uint=1,Data:int=0,Tag:TileTag=null,
							 Rot:int=0,
							 xd:Number=NaN,yd:Number=NaN,vr:Number=NaN):void
		{
			//Define
			this.EntityType=EntityID.Item
			super(Host,X,Y,Size,Size)
			this.hasCollision=false
			LastTime=getTimer()
			this.TickFunction=this.onMove
			//setMove
			this.rotation=General.random(360)
			if(isNaN(xd)||isNaN(yd))
			{
				var dir:Number=General.random(360)*Math.PI/180
				var dis:Number=General.randomBetween(TileSystem.globalTileSize,TileSystem.globalTileSize*2,true)
				if(isNaN(xd)) this.xd=Math.cos(dir)*dis else this.xd=xd
				if(isNaN(yd)) this.yd=Math.sin(dir)*dis else this.yd=yd
			}
			if(isNaN(vr)) this.vr=General.randomBetween(90,270)/Game.FPS else this.vr=vr
			this.xd/=TileSystem.globalTileSize
			this.yd/=TileSystem.globalTileSize
			//setItem
			this.item=new InventoryItem(Id,Count,Data,Tag,Rot)
			//setDisplay
			this.tile=new TileDisplayObj(TileDisplayFrom.IN_ENTITY,0,0,Id,Data,Tag,Rot,Size,Size)
			this.addChild(tile)
		}
		
		//==========SET==========//
		public function setItem(id:String=null,count:uint=0,data:int=0,tag:TileTag=null,rot:int=0):void
		{
			var runId:String=id,runCount:uint=count,runData:int=data,runTag:TileTag=tag,runRot:int=rot
			if(id==null) runId=this.Id
			if(count==0) runCount=this.Count
			this.item.setItem(runId,runCount,runData,runTag,runRot)
			this.tile.changeTile(runId,runData,runTag,runRot)
		}
		
		//==========MOVE==========//
		protected function onMove(Ent:Entity=null):void
		{
			//Move
			this.x+=xd
			this.y+=yd
			this.rotation+=vr
			//Detect
			Host.detectItem(this)
			//Set And Memory
			this.lastx=this.x
			this.lasty=this.y
			this.lastr=this.rotation
			this.xd*=1-Host.Fraction
			this.yd*=1-Host.Fraction
			this.vr*=1-Host.Fraction
			//LifeTime & PickupTime
			if(lifeTime<Item.MaxLifeTime) lifeTime++ else this.LifeComplete()
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
				Host.removeEntity(this)
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
		public function LifeComplete():void
		{
			this.deleteSelf()
			Host.removeEntity(this)
		}
		
		public override function deleteSelf():void
		{
			if(this.TargetTimer.running)stopTargetMove()
			this.visible=false
			this.isActive=false
			this.item=null
			this.tile=null
			if(this.parent!=null)this.parent.removeChild(this)
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
		
		public function get Id():String
		{
			return this.item.Id
		}
		
		public function get Count():uint
		{
			return this.item.Count
		}
		
		public function get Data():int
		{
			return this.item.Data
		}
		
		public function get Tag():TileTag
		{
			return this.item.Tag
		}
		
		public function get Rot():int
		{
			return this.item.Rot%4
		}
	}
}