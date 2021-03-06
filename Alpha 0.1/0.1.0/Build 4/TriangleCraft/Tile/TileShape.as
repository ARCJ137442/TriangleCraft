﻿package TriangleCraft.Tile
{
	//Flash
	import flash.display.Sprite
	import TriangleCraft.Tile.Shapes.*
	import flash.display.DisplayObject;
	
	public class TileShape extends Sprite
	{
		//Dynamic Variables
		protected var ShapeMachine:Shape_Machine=new Shape_Machine()
		protected var ShapeWall:Shape_Wall=new Shape_Wall()
		protected var ShapeOther:Shape_Other=new Shape_Other()
		protected var ShapeVirus:Shape_Virus=new Shape_Virus()
		protected var ShapeCustom:Shape_Custom=new Shape_Custom()
		
		private function get Shapes():Array
		{
			return new Array(this.ShapeMachine,
							 this.ShapeWall,
							 this.ShapeOther,
							 this.ShapeVirus,
							 this.ShapeCustom)
		}
		
		public function TileShape(Id:String=TileID.Void,Data:int=0):void
		{
			this.setDisplay(Id,Data)
		}
		
		public function setDisplay(Id:String,Data:int=0):void
		{
			if(Id==TileID.Void)
			{
				this.visible=false
				this.ActiveChild=null
			}
			var shape:Shape_Common
			for each(shape in this.Shapes)
			{
				if(shape.hasCurrent(Id,Data))
				{
					this.ActiveChild=shape
					shape.setCurrentframe(Id,Data)
				}
			}
		}
		
		protected function set ActiveChild(Child:DisplayObject):void
		{
			//Display
			if(Child!=null&&!this.contains(Child))
			{
				this.addChild(Child)
			}
			//Remove
			for(var i:uint=0;i<this.numChildren;i++)
			{
				if(Child==null||i!=this.getChildIndex(Child))
				{
					if(this.contains(this.getChildAt(i)))
					{
						this.removeChild(this.getChildAt(i))
					}
				}
			}
		}
	}
}