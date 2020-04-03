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

	public class Item extends Entity
	{
		protected static const Size:uint=TileSystem.globalTileSize*(7/16)
		protected static const DPS:uint=32
		protected static const Delay:uint=1000/DPS
		
		public var item:InventoryItem=new InventoryItem()
		public var tile:Tile=new Tile()
		public var MoveTimer:Timer=new Timer(Delay,Infinity)
		protected var xd:Number,yd:Number,vr:Number
		protected var LastTime:uint
		
		public function Item(X:Number=0,Y:Number=0,
							 Id:String=TileSystem.Colored_Block,
							 Count:uint=1,Data:int=0,Tag:TileTag=null,
							 Rot:int=0):void
		{
			//Define
			super(X,Y)
			LastTime=getTimer()
			MoveTimer.addEventListener(TimerEvent.TIMER,onMove)
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
		}
		
		public function startMove():void
		{
			MoveTimer.start()
		}
		
		public function stopMove():void
		{
			MoveTimer.stop()
		}
		
		//==========MOVE==========//
		private function onMove():void
		{
			var TimeDistance:uint=getTimer()-LastTime
			//Move
			this.x+=xd
			this.y+=yd
			this.rotation+=vr
			//Set
			this.xd*=1-Game.Fraction
			this.yd*=1-Game.Fraction
		}
	}
}