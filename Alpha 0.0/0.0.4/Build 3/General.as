package 
{
	import flash.utils.ByteArray;
	import flash.display.DisplayObject;

	public class General
	{
		//==============Math Functions==============//
		public static function random(x:Number,allowFloat:Boolean=false):uint
		{
			if(allowFloat)
			{
				return Math.random()*Math.abs(x);
			}
			return Math.floor(Math.random()*Math.abs(x));
		}
		
		public static function randomBetween(x:Number,y:Number,
											 allowFloat:Boolean=false):uint
		{
			var h:Number=Math.max(x,y)
			var l:Number=Math.min(x,y)
			if(allowFloat)
			{
				return l+Math.random()*Math.abs(h-l);
			}
			return Math.floor(l+Math.random()*Math.abs(h-l));
		}
		
		public static function getDistance(x1:Number,y1:Number,
										   x2:Number,y2:Number):Number
		{
			return getDistance2(x1-x2,y1-y2)
		}
		
		public static function getDistance2(x:Number,y:Number):Number
		{
			return Math.sqrt(x*x+y*y)
		}
		
		public static function NumberBetween(x:Number,n1:Number,n2:Number):Number
		{
			var l:Number=Math.min(n1,n2)
			var m:Number=Math.max(n1,n2)
			return Math.min(n2,Math.max(n1,x))
		}
		
		//============Code Functions============//
		public static function isGame(Obj:DisplayObject):Boolean
		{
			if(Obj.hasOwnProperty("isTriangleCraft")) return true
			return false
		}
		
		public static function getPropertyInObject(arr:Array,pro:String):Array
		{
			var ra:Array=new Array()
			for (var i=0;i<arr.length;i++)
			{
				if(arr[i].hasOwnProperty(pro))
				{
					ra.push(arr[i][pro]);
				}
			}
			return ra;
		}
		
		public static function copyObject(object:Object):Object
		{
			var tempObject:ByteArray=new ByteArray()
			tempObject.writeObject(object)
			tempObject.position=0
			return tempObject.readObject() as Object
		}

		public static function IinA(i:*,a:Array):int
		{
			if(a==null||a.length<1)
			{
				return -1
			}
			for (var ts=0;ts<a.length;ts++)
			{
				if(a[ts]==i)
				{
					return ts;
				}
			}
			return -1;
		}

		public static function isEqualArray(A:Array,B:Array):Boolean
		{
			if(A.length!=B.length)
			{
				return false;
			}
			else
			{
				for (var i=0;i<A.length;i++)
				{
					if(A[i]!=B[i]&&A[i]!=null&&B[i]!=null)
					{
						return false;
					}
				}
				return true;
			}
		}
		
		public static function isEqualObject(A:Object,B:Object,
											 IgnoreUnique:Boolean=false,
											 IgnoreVariable:Boolean=false,
											 DontDetectB:Boolean=false):Boolean
		{
			for(var i in A)
			{
				var fa:*=A[i]
				if(B.hasOwnProperty(i)||IgnoreUnique)
				{
					var fb:*=B[i]
					if(!IgnoreVariable)
					{
						if(isPrimitive(fa)==isComplex(fb))
						{
							return false
						}
						else if(isPrimitive(fa))
						{
							if(fa!=fb)
							{
								return false
							}
						}
						else
						{
							if(!isEqualObject(fa,fb))
							{
								return false
							}
						}
					}
				}
				else
				{
					return false
				}
			}
			if(!DontDetectB)
			{
				if(!isEqualObject(B,A,IgnoreUnique,IgnoreVariable,true))
				{
					return false
				}
			}
			return true
		}
		
		public static function isPrimitive(Variable:*):Boolean
		{
			if(Variable is Boolean||
			   Variable is int||
			   Variable is null||
			   Variable is Number||
			   Variable is String||
			   Variable is uint/*||
			   Variable is void*/)
			{
				return true
			}
			return false
		}
		
		public static function isComplex(Variable:*):Boolean
		{
			return !isPrimitive(Variable)
		}
	}
}