package TriangleCraft.Tile.Shapes
{
	//Flash
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileSystem
	use namespace intc
	
	public class Shape_Common extends MovieClip
	{
		//============Static Variables============//
		protected static const splitString:String=" "
		
		//============Instance Variables============//
		protected var currents:Dictionary=new Dictionary()
		
		//============Static Functions============//
		protected static function getIndex(id:String,data:int):String
		{
			return String(id+splitString+data)
		}
		
		public function Shape_Common():void
		{
			stop()
		}
		
		//=====frame Functions=====//
		public function get frame():uint
		{
			return this.currentFrame
		}
		
		public function set frame(f:uint):void
		{
			this.gotoAndStop(f)
		}
		
		//=====Current Functions=====//
		protected function setCurrent(frame:uint,id:String,data:int=0):void
		{
			if(frame>0&&!this.hasCurrent(id,data,false))
			{
				this.currents[getIndex(id,data)]=frame
			}
		}
		
		protected function addCurrent(id:String,data:int=0):void
		{
			var frame:uint=1
			while(hasCurrentOnFrame(frame)) frame++
			this.setCurrent(frame,id,data)
		}
		
		protected function getCurrentFrame(id:String,data:int=0,reloadData:Boolean=true):uint
		{
			if(hasCurrent(id,data,false)) return this.currents[getIndex(id,data)]
			else if(hasCurrent(id,data,true)) return this.currents[getIndex(id,0)]
			return 0
		}
		
		public function hasCurrent(id:String,data:uint=0,reloadData:Boolean=true):Boolean
		{
			return Boolean(getIndex(id,data) in this.currents)||reloadData&&Boolean(getIndex(id,0) in this.currents)
		}
		
		public function hasCurrentOnFrame(frame:uint):Boolean
		{
			for each(var current:* in this.currents)
			{
				if(current==frame) return true
			}
			return false
		}
		
		public function setCurrentFrame(id:String,data:int=0,reloadData:Boolean=true):void
		{
			if(this.hasCurrent(id,data,reloadData))
			{
				this.frame=this.getCurrentFrame(id,data,reloadData)
			}
		}
	}
}