package TriangleCraft.Common
{
	public class Color
	{
		//====RGB >> HEX====//
		public static function RGBtoHEX(RGB:Array ):int
		{
			if (RGB==null||
				RGB.length!=3||     
				RGB[0]<0||RGB[0]>255||    
				RGB[1]<0||RGB[1]>255||    
				RGB[2]<0||RGB[2]>255 )
			{
				return 0xFFFFFF;
			}
			return RGB[0]<<16|RGB[1]<<8|RGB[2];
		}

		//====HEX >> RGB====//
		public static function HEXtoRGB(I:uint):Array
		{
			var r:uint=(I>>16);
			var g:uint=(I-(r<<16))>>8;
			var b:uint=I-(r<<16)-(g<<8);
			return [r,g,b];
		}
		
		//====RGB >> HSV====//
		public static function RGBtoHSV(RGB:Array):Array
		{
			//Define Variables
			var R=RGB[0]
			var G=RGB[1]
			var B=RGB[2]
			if (RGB==null||
				RGB.length!=3||
				R<0||R>255||
				G<0||G>255||
				B<0||B>255)
			{
				return [0,0,100];
			}
			//Get Report
			var Max:uint=Math.max(R,G,B)
			var Min:uint=Math.min(R,G,B)
			var Maxin:uint=Max-Min
			var H,S,V:uint
			//Set Hue
			if(Max==Min)
			{
				H=0
			}
			else if(Max==R&&G>=B)
			{
				H=60*(G-B)/Maxin+0
			}
			else if(Max==R&&G<B)
			{
				H=60*(G-B)/Maxin+360
			}
			else if(Max==G)
			{
				H=60*(B-R)/Maxin+120
			}
			else if(Max==B)
			{
				H=60*(R-G)/Maxin+240
			}
			//Set Saturation
			if(Max==0)
			{
				S=0
			}
			else
			{
				S=Maxin/Max*100
			}
			//Set Brightness
			V=Max
			//Lash Report
			if(S>100) S/=2.55
			if(V>100) V/=2.55
			return [Math.round(H),Math.round(S),Math.round(V)]
		}
		
		//====HSV >> RGB====//
		public static function HSVtoRGB(HSV:Array):Array
		{
			var H:Number=HSV[0]
			var S:Number=HSV[1]
			var V:Number=HSV[2]
			var i:uint=Math.floor(H/60)
			var f:Number=H/60-i
			var p:Number=V/100*(1-S/100)
			var q:Number=V/100*(1-f*S/100)
			var t:Number=V/100*(1-(1-f)*S/100)
			var R,G,B:Number
			switch(i)
			{
				case 0:
				R=V/100
				G=t
				B=p
				break
				case 1:
				R=q
				G=V/100
				B=p
				break
				case 2:
				R=p
				G=V/100
				B=t
				break
				case 3:
				R=p
				G=q
				B=V/100
				break
				case 4:
				R=t
				G=p
				B=V/100
				break
				case 5:
				R=V/100
				G=p
				B=q
				break
			}
			R*=255
			G*=255
			B*=255
			return [Math.round(R),Math.round(G),Math.round(B)]
		}
		
		//====HEX >> HSV====//
		public static function HEXtoHSV(I:uint)
		{
			var RGB:Array=HEXtoRGB(I)
			return RGBtoHSV(RGB)
		}
		
		//====HSV >> HEX====//
		public static function HSVtoHEX(HEX:Array)
		{
			var RGB:Array=HSVtoRGB(HEX)
			return RGBtoHEX(RGB)
		}
	}
}