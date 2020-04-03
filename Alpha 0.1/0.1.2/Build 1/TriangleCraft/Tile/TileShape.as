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
				default:
				return null
			}
		}
		
		//========Instance Variables========//
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
							 this.ShapeVirus)/*,
							 this.ShapeCustom*/
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
				return
			}
			var setted:Boolean=false
			//Shapes
			for(var i:uint=0;!setted&&i<this.Shapes.length;i++)
			{
				var shape:Shape_Common=this.Shapes[i]
				if(shape.hasCurrent(Id,Data))
				{
					this.ActiveChild=shape
					shape.setCurrentframe(Id,Data)
					setted=true
				}
			}
			//Custom
			if(!setted&&Shape_Custom.hasCurrent(Id,Data))
			{
				this.ActiveChild=this.ShapeCustom
				this.ShapeCustom.setCurrent(Id,Data)
				trace("set Custom")
				return
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