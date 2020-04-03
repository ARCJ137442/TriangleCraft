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
		private static var DestroySprites_Static:Array;
		
		//============<[DYNAMIC]>============//
		//------------<VAR>------------//
		private var splitNum:uint=5
		private var splitDis:uint=defaultSplitDis;
		private var rotV:uint=defaultRotV;
		private var DestroySprites:Array;
		private var graphicPoints:Array=new Array();
		private var graphicRots:Array=new Array();
		
		//================<[FUNCTIONS]>================//
		public function TileDestroyStage(spawnNum:uint=10)
		{
			splitNum=spawnNum
			resetStage();
		}
		//----------DRAW----------//
		private function destroyStageDraw(C:uint):Array
		{
			for (var j=0;j<splitCount;j++,graphicPoints.push(new Point()),graphicRots.push(0))
			var s:Shape=new Shape();
			var rs:Array=new Array();
			s.graphics.clear();
			s.graphics.lineStyle(1.5,0x888888);
			for (var i:uint=0; i<splitCount; i++)
			{
				var px:Number=graphicPoints[i].x;
				var py:Number=graphicPoints[i].y;
				var Rot=(i*360/splitCount+(Math.random()-Math.random())*rotV/2)*Math.PI/180;
				if (px+Math.cos(Rot)*splitDis>borderX||py+Math.sin(Rot)*splitDis<-borderY)
				{
					Rot+=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				else if (px+Math.cos(Rot)*splitDis<-borderX||py+Math.sin(Rot)*splitDis>borderY)
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
			for (var u:uint=0; u<C; u++)
			{
				rs.push(CopyShape(s));
				stageSplit(s,graphicPoints,graphicRots);
			}
			return rs;
		}

		private function stageSplit(s:Shape,points:Array,rots:Array):void
		{
			for (var i=0; i<splitCount; i++)
			{
				var px=points[i].x;
				var py=points[i].y;
				var Rot=rots[i]+(Math.random()-Math.random())*rotV*Math.PI/180;
				if (px+Math.cos(Rot)*splitDis>borderX||py+Math.sin(Rot)*splitDis<-borderY)
				{
					Rot+=Math.PI/2+(Math.random()-Math.random())*rotV*Math.PI/360;
				}
				else if (px+Math.cos(Rot)*splitDis<-borderX||py+Math.sin(Rot)*splitDis>borderY)
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
				if(TileDestroyStage.DestroySprites_Static==null)
				{
					DestroySprites_Static=destroyStageDraw(uint(this.splitNum))
				}
				this.DestroySprites=CopyShapes(DestroySprites_Static)
			}
			else
			{
				splitDis=defaultSplitDis
				rotV=defaultRotV
				graphicPoints=new Array();
				graphicRots=new Array();
				DestroySprites=destroyStageDraw(uint(this.splitNum))
			}
		}

		public function showStage(frame:uint):void
		{
			//Clear Children
			for (var i=0; i<this.numChildren; i++)
			{
				this.removeChildAt(0);
			}
			//Clear Graphics
			this.graphics.clear();
			//Show Stage;
			if (this.DestroySprites[frame-1]!=null&&frame>0)
			{
				this.addChild(this.DestroySprites[frame-1]);
			}
		}
		
		private function CopyShapes(Shapes:Array):Array
		{
			var returnArr:Array=new Array()
			for(var i in Shapes)
			{
				var shape:Shape=Shapes[i] as Shape
				if(shape!=null)
				{
					returnArr[i]=CopyShape(shape)
				}
			}
			return returnArr
		}
		
		private function CopyShape(shape:Shape):Shape
		{
			var tempShape:Shape=new Shape();
			tempShape.graphics.copyFrom(shape.graphics);
			return tempShape
		}
	}
}