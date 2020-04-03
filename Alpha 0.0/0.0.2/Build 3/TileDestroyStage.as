package 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.display.Sprite;
	public class TileDestroyStage extends Sprite
	{
		//----------STATIC CONST----------//
		static const borderX:uint=50;
		static const borderY:uint=50;
		static const rotV2:uint=20;
		static const splitCount:uint=5;
		static const splitDisV:uint=100;
		//----------PUBLIC VAR----------//
		public var splitDis:uint=8;
		public var rotV:uint=60;
		public var DestroySprites:Array;
		public var graphicPoints:Array=new Array();
		public var graphicRots:Array=new Array();
		//================FUNCTIONS================//
		public function TileDestroyStage(spawnNum:uint=10)
		{
			DestroySprites=destroyStageDraw(spawnNum);
		}
		//----------DRAW----------//
		function destroyStageDraw(C:uint):Array
		{
			for (var j=0; j<splitCount; j++,graphicPoints.push(new Point()),graphicRots.push(0))
			{
				var s:Sprite=new Sprite();
			}
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
				var cs:Sprite=new Sprite();
				var gr:Graphics=Sprite(s).graphics;
				cs.graphics.copyFrom(gr);
				rs.push(cs);
				stageSplit(s,graphicPoints,graphicRots);
			}
			return rs;
		}

		function stageSplit(s:Sprite,points:Array,rots:Array):void
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

		function showStage(frame:uint):void
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
	}
}