package TriangleCraft.Tile
{
	//Flash
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	internal class TileDestroyStage extends Sprite
	{
		//============<[STATIC]>============//
		//-----------<CONST>-----------//
		public static const UseStaticStage:Boolean=false
		private static const borderX:uint=50;
		private static const borderY:uint=50;
		private static const defaultRotV:uint=60
		private static const rotV2:uint=20;
		private static const splitCount:uint=5;
		private static const defaultSplitDis:uint=8
		private static const splitDisV:uint=100;
		
		//------------<VAR>------------//
		private static var DestroyShapes_Static:Vector.<Shape>;
		
		//============<[INSTANCE]>============//
		//------------<VAR>------------//
		private var splitNum:uint=5
		private var splitDis:uint=defaultSplitDis;
		private var rotV:uint=defaultRotV;
		private var DestroyShapes:Vector.<Shape>;
		private var graphicPoints:Vector.<Point>=new Vector.<Point>();
		private var graphicRots:Vector.<Number>=new Vector.<Number>();
		
		//================<[FUNCTIONS]>================//
		public function TileDestroyStage(spawnNum:uint=10)
		{
			splitNum=spawnNum
			resetStage();
		}
		//----------DRAW----------//
		private function destroyStageDraw(C:uint):Vector.<Shape>
		{
			for(var j=0;j<splitCount;j++,graphicPoints.push(new Point()),graphicRots.push(0))
			var s:Shape=new Shape();
			s.graphics.lineStyle(1.5,0x000000);
			for(var i:uint=0;i<splitCount;i++)
			{
				var px:Number=graphicPoints[i].x;
				var py:Number=graphicPoints[i].y;
				var Rot=(i*360/splitCount+(Math.random()-Math.random())*rotV/2)*Math.PI/180;
				if(px+Math.cos(Rot)*splitDis>borderX||py+Math.sin(Rot)*splitDis<-borderY)
				{
					Rot+=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				else if(px+Math.cos(Rot)*splitDis<-borderX||py+Math.sin(Rot)*splitDis>borderY)
				{
					Rot-=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				var mX:Number=Math.min(Math.max(px+Math.cos(Rot)*splitDis,-borderX),borderX);
				var mY:Number=Math.min(Math.max(py+Math.sin(Rot)*splitDis,-borderY),borderY);
				s.graphics.moveTo(px,py);
				s.graphics.lineTo(mX,mY);
				graphicPoints[i].x=mX;
				graphicPoints[i].y=mY;
				graphicRots[i]=Rot;
			}
			splitDis*=splitDisV/100;
			rotV+=rotV2;
			var rs:Vector.<Shape>=new Vector.<Shape>();
			for(var u:uint=0;u<C;u++)
			{
				rs.push(CopyShape(s));
				stageSplit(s,graphicPoints,graphicRots);
			}
			return rs;
		}

		private function stageSplit(s:Shape,points:Vector.<Point>,rots:Vector.<Number>):void
		{
			for(var i=0;i<splitCount;i++)
			{
				var px=points[i].x;
				var py=points[i].y;
				var Rot=rots[i]+(Math.random()-Math.random())*rotV*Math.PI/180;
				if(px+Math.cos(Rot)*splitDis>borderX||py+Math.sin(Rot)*splitDis<-borderY)
				{
					Rot+=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				else if(px+Math.cos(Rot)*splitDis<-borderX||py+Math.sin(Rot)*splitDis>borderY)
				{
					Rot-=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				var mX=Math.min(Math.max(px+Math.cos(Rot)*splitDis,-borderX),borderX);
				var mY=Math.min(Math.max(py+Math.sin(Rot)*splitDis,-borderY),borderY);
				s.graphics.moveTo(px,py);
				s.graphics.lineTo(mX,mY);
				graphicPoints[i].x=mX;
				graphicPoints[i].y=mY;
			}
			splitDis*=splitDisV/100;
			rotV+=rotV2;
		}
		
		public function resetStage():void
		{
			if(TileDestroyStage.UseStaticStage)
			{
				if(TileDestroyStage.DestroyShapes_Static==null)
				{
					DestroyShapes_Static=destroyStageDraw(uint(this.splitNum))
				}
				this.DestroyShapes=CopyShapes(DestroyShapes_Static)
			}
			else
			{
				splitDis=defaultSplitDis
				rotV=defaultRotV
				graphicPoints=new Vector.<Point>();
				graphicRots=new Vector.<Number>();
				DestroyShapes=destroyStageDraw(uint(this.splitNum))
			}
		}

		public function showStage(frame:uint):void
		{
			//Clear Children
			for(var i=0;i<this.numChildren;i++) this.removeChildAt(0);
			//Clear Graphics
			//this.graphics.clear();
			//Show Stage;
			if(frame>0&&this.DestroyShapes[frame-1] as Shape!=null)
			{
				this.addChild(this.DestroyShapes[frame-1]);
			}
		}
		
		private function CopyShapes(Shapes:Vector.<Shape>):Vector.<Shape>
		{
			var returnVec:Vector.<Shape>=new Vector.<Shape>(Shapes.length)
			for(var i in Shapes)
			{
				var shape:Shape=Shapes[i] as Shape
				if(shape!=null)
				{
					returnVec[i]=CopyShape(shape)
				}
			}
			return returnVec
		}
		
		private function CopyShape(shape:Shape):Shape
		{
			var tempShape:Shape=new Shape();
			tempShape.graphics.copyFrom(shape.graphics);
			return tempShape
		}
	}
}