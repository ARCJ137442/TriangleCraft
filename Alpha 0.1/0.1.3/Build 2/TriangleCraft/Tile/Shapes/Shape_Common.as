package TriangleCraft.Tile.Shapes
{
	//Flash
	import flash.display.MovieClip
	
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileSystem
	use namespace intc
	
	public class Shape_Common extends MovieClip
	{
		//Dynamic Variables
		protected var currentList:Array=new Array()
		
		public function Shape_Common():void
		{
			stop()
		}
		
		//=====Frame Functions=====//
		public function get Frame():uint
		{
			return this.currentFrame
		}
		
		public function set Frame(f:uint):void
		{
			this.gotoAndStop(f)
		}
		
		//=====Current Functions=====//
		protected function addCurrent(Frame:uint,Id:String,Data:int=0):void
		{
			if(Frame>0&&!this.hasCurrent(Id,Data,false))
			{
				if(TileSystem.isAllowID(Id))
				{
					this.currentList.push(Frame,Id,Data)
				}
			}
		}
		
		protected function getCurrentFrame(Id:String,Data:int=0,ReloadData:Boolean=true):uint
		{
			if(General.isEmptyArray(this.currentList))
			{
				return 0
			}
			var i:uint
			for(i=0;i<this.currentList.length;i++)
			{
				//if(Id==TileID.Link_Line)trace(String(this.currentList[i]),Id,int(this.currentList[i+1]),Data)
				if(String(this.currentList[i])==Id&&
				   int(this.currentList[i+1])==Data)
				{
					return uint(this.currentList[i-1])
				}
			}
			if(ReloadData)
			{
				for(i=0;i<this.currentList.length;i++)
				{
					if(String(this.currentList[i])==Id)
					{
						return uint(this.currentList[i-1])
					}
				}
			}
			return 0
		}
		
		public function hasCurrent(Id:String,Data:uint=0,ReloadData:Boolean=true):Boolean
		{
			return (getCurrentFrame(Id,Data,ReloadData)>0)
		}
		
		public function setCurrentframe(Id:String,Data:int=0,ReloadData:Boolean=true):void
		{
			if(this.hasCurrent(Id,Data,ReloadData))
			{
				this.Frame=this.getCurrentFrame(Id,Data,ReloadData)
			}
		}
	}
}