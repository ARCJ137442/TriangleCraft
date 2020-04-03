package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Tile.Shapes.*;
	
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.display.Sprite
	import flash.display.DisplayObject;
	
	internal class TileShape extends Sprite
	{
		//========Static Variables========//
		public static function hasCurrentClass(Name:String):Boolean
		{
			return (getClassByName(Name)!=null)
		}
		
		public static function getClassByName(Name:String):Class
		{
			switch(Name)
			{
				case "Common":
				return TriangleCraft.Tile.Shapes.Shape_Common
				case "Custom":
				return TriangleCraft.Tile.Shapes.Shape_Custom
				case "Machine":
				return TriangleCraft.Tile.Shapes.Shape_Machine
				case "Wall":
				return TriangleCraft.Tile.Shapes.Shape_Wall
				case "Other":
				return TriangleCraft.Tile.Shapes.Shape_Other
				case "Virus":
				return TriangleCraft.Tile.Shapes.Shape_Virus
				case "Signal":
				return TriangleCraft.Tile.Shapes.Shape_Signal
				case "Error":
				return TriangleCraft.Tile.Shapes.Shape_Error
				default:
				return null
			}
		}
		
		//========Instance Variables========//
		protected var ShapeMachine:Shape_Machine=new Shape_Machine()
		protected var ShapeWall:Shape_Wall=new Shape_Wall()
		protected var ShapeOther:Shape_Other=new Shape_Other()
		protected var ShapeVirus:Shape_Virus=new Shape_Virus()
		protected var ShapeSignal:Shape_Signal=new Shape_Signal()
		protected var ShapeError:Shape_Error=new Shape_Error()
		
		protected var ShapeCustom:Shape_Custom=new Shape_Custom()
		
		private function get Shapes():Vector.<Shape_Common>
		{
			return new <Shape_Common>[this.ShapeMachine,
									  this.ShapeWall,
									  this.ShapeOther,
									  this.ShapeVirus,
									  this.ShapeSignal,
									  this.ShapeError]/*,
									  this.ShapeCustom*/
		}
		
		public function TileShape(Id:String=TileID.Void,Data:int=0):void
		{
			this.setDisplay(Id,Data)
		}
		
		public function setDisplay(Id:String,Data:int=0,displayFrom:String=null):void
		{
			//Technical
			if(TileTag.getTagFromID(Id).technical&&displayFrom==TileDisplayFrom.IN_ENTITY)
			{
				this.ActiveChild=this.ShapeError
				this.ShapeError.setCurrentFrame(TileID.Unknown,0)
				return
			}
			//Void
			if(Id==TileID.Void)
			{
				this.visible=false
				this.ActiveChild=null
				return
			}
			//Shapes
			for each(var shape:Shape_Common in this.Shapes)
			{
				if(shape.hasCurrent(Id,Data))
				{
					this.ActiveChild=shape
					shape.setCurrentFrame(Id,Data)
					return
				}
			}
			//Custom
			if(Shape_Custom.hasCurrent(Id,Data))
			{
				this.ActiveChild=this.ShapeCustom
				this.ShapeCustom.setCurrent(Id,Data)
				//trace("set Custom")
				return
			}
			//No Current
			this.ActiveChild=this.ShapeError
			this.ShapeError.setCurrentFrame(TileID.NoCurrent,0)
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