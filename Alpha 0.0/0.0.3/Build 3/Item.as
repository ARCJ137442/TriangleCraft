package 
{
	import General;
	import Entity;
	import Game;
	import Tile;
	import TileSystem;
	import InventoryItem;
	import flash.errors.IllegalOperationError
	import flash.utils.Timer;

	public class Item extends Entity
	{
		protected static const Size:uint=TileSystem.globalTileSize*(7/16)
		
		public var It:InventoryItem=new InventoryItem()
		public var MoveTimer:Timer
		private var Host:Game
		private var Delay:uint
		
		public function Item(Host:Game,X:Number=0,Y:Number=0,
							 Id:String=TileSystem.Colored_Block,
							 Count:uint=1,Data:int=0,Tag):void
		{
			//Detect Host
			if(Host is null)
			{
				if(this.parent is Game)
				{
					this.Host=this.parent
				}
				else
				{
					throw new IllegalOperationError("Error:Invalid parent object!");
				}
			}
			else
			{
				this.Host=Host
			}
			//Define
			super(X,Y)
			MoveTimer=new Timer(Delay,Infinity)
		}
		
		public function startMove():void
		{
			
		}
		
		public function stopMove():void
		{
			
		}
	}
}