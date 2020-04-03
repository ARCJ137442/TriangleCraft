package 
{
	import General;
	import Entity;
	import Game;
	import Tile;
	import TileSystem;
	import InventoryItem;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;

	public class Item extends Entity
	{
		protected static const Size:uint=TileSystem.globalTileSize*(8/16)
		protected static const DPS:uint=32
		protected static const Delay:uint=1000/DPS
		
		public var item:InventoryItem=new InventoryItem()
		public var tile:Tile=new Tile()
		public var MoveTimer:Timer=new Timer(Delay,Infinity)
		protected var xd:Number,yd:Number,vr:Number
		protected var lastx:Number,lasty:Number,lastr:Number
		protected var LastTime:uint
		
		public function Item(Host:Game,
							 X:Number=0,Y:Number=0,
							 Id:String=TileSystem.Colored_Block,
							 Count:uint=1,Data:int=0,Tag:TileTag=null,
							 Rot:int=0):void
		{
			//Define
			super(Host,X,Y,Size,Size)
			this.EntityType=EntitySystem.Item
			this.hasCollision=false
			LastTime=getTimer()
			//setMove
			var dir:Number=General.random(360)*Math.PI/180
			var dis:Number=General.randomBetween(TileSystem.globalTileSize,TileSystem.globalTileSize*2,true)/DPS
			this.xd=Math.cos(dir)*dis
			this.yd=Math.sin(dir)*dis
			this.vr=General.randomBetween(45,90)/DPS
			//setItem
			this.item=new InventoryItem(Id,Count,Data,Tag,Rot)
			//setDisplay
			this.tile=new Tile(0,0,Size,Size,Id,Data,Tag)
			this.addChild(tile)
			//start
			startMove()
		}
		
		public function startMove():void
		{
			MoveTimer.start()
			MoveTimer.addEventListener(TimerEvent.TIMER,onMove)
		}
		
		public function stopMove():void
		{
			MoveTimer.stop()
			MoveTimer.removeEventListener(TimerEvent.TIMER,onMove)
		}
		
		//==========MOVE==========//
		private function onMove(E:Event):void
		{
			var TimeDistance:uint=getTimer()-LastTime
			//Move
			this.x+=xd*TimeDistance/DPS
			this.y+=yd*TimeDistance/DPS
			this.rotation+=vr*TimeDistance/DPS
			//Detect
			Host.detectItem(this)
			//Set And Memory
			this.lastx=this.x
			this.lasty=this.y
			this.lastr=this.rotation
			this.xd*=1-Game.Fraction
			this.yd*=1-Game.Fraction
			this.vr*=1-Game.Fraction
			LastTime+=TimeDistance
		}
		
		public function reboundX():void
		{
			this.xd=-this.xd
		}
		
		public function reboundY():void
		{
			this.yd=-this.yd
		}
		
		//===========Delete Functions==========//
		public override function deleteSelf():void
		{
			stopMove()
			this.item=null
			this.tile=null
			this.MoveTimer=null
			this.parent.removeChild(this)
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
	}
}