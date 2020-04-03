package TriangleCraft
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
		
		public static function random1():int
		{
			return random(2)*2-1
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
		
		public static function NumTo1(x:Number):int
		{
			if(x>0) return 1
			if(x<0) return -1
			return 0
		}
		
		public static function isBetween(x:Number,n1:Number,n2:Number,
										 WithL:Boolean=false,
										 WithM:Boolean=false):Boolean
		{
			var m:Number=Math.max(n1,n2)
			var l:Number=Math.min(n1,n2)
			if(WithL&&WithM)
			{
				return x>=l&&x<=m
			}
			else if(WithL)
			{
				return x>=l&&x<m
			}
			else if(WithM)
			{
				return x>l&&x<=m
			}
			return x>l&&x<m
		}

		public static function RandomByWeight(A:Array):uint
		{
			if(A.length>=1)
			{
				var All=0;
				var i;
				for(i in A)
				{
					if(!isNaN(Number(A[i])))
					{
						All+=Number(A[i]);
					}
				}
				if(A.length==1)
				{
					return 1;
				}
				else
				{
					var R=Math.random()*All;
					for(i=0;i<A.length;i++)
					{
						var N=Number(A[i]);
						var rs=0;
						for(var l=0;l<i;l++)
						{
							rs+=Number(A[l]);
						}
						//trace(R+"|"+(rs+N)+">R>="+rs+","+(i+1))
						if(R>=rs&&R<rs+N)
						{
							return i+1;
						}
					}
				}
			}
			return random(A.length)+1;
		}
		
		public static function RandomByWeight2(...A):uint
		{
			return RandomByWeight(A)
		}

		public static function getAverage(a:Array):Number
		{
			var sub:Number=0;
			for(var i=0;i<a.length;i++)
			{
				sub+=Number(a[i]);
			}
			return sub/a.length;
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
			return Math.min(m,Math.max(l,x))
		}

		public static function getPrime(X:Number):Array
		{
			var returnArr:Array=[];
			var t;
			for(var i:uint=2;i<=Math.ceil(Math.abs(X));i++)
			{
				var Push:Boolean=true;
				for(t in returnArr)
				{
					if(i%returnArr[t]==0)
					{
						Push=false;
					}
				}
				if(Push)
				{
					returnArr.push(i);
				}
			}
			return returnArr;
		}

		public static function getPrimeAt(X:Number):uint
		{
			var returnUin:uint=2;
			var Arr:Array=[];
			var t;
			for(var i:uint=1;Arr.length<=X;i+=10)
			{
				Arr=getPrime(i);
			}
			if(Arr.length>=X)
			{
				returnUin=Arr[X];
			}
			return returnUin;
		}

		public static function isPrime(X:Number):Boolean
		{
			if(Math.abs(X)<2)
			{
				return false;
			}
			var ps:Array=getPrime((X+1));
			var i;
			for(i in ps)
			{
				if(ps[i]==X)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function NumberToPercent(x:Number,floatCount:uint=0):String
		{
			if(floatCount>0)
			{
				var pow:uint=Math.pow(10,floatCount)
				var returnNum:Number=Math.floor(x*pow*100)/pow
				return returnNum+"%"
			}
			return Math.round(x*100)+"%"
		}
		
		public static function NTP(x:Number,floatCount:uint=0):String
		{
			return NumberToPercent(x,floatCount)
		}
		
		public static function randomBoolean(P:Number=1):Boolean
		{
			if(Math.random()<=P)return true
			return false
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
			for (var i:uint=0;i<arr.length;i++)
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

		public static function IinA(Input:*,Arr:Array):int
		{
			if(isEmptyArray(Arr))
			{
				return -1
			}
			for (var ts:uint=0;ts<Arr.length;ts++)
			{
				if(Input is Array)
				{
					if(IsiA(Arr[ts],Input))
					{
						return ts;
					}
				}
				else if(Arr[ts]==Input)
				{
					return ts;
				}
			}
			return -1;
		}
		
		public static function IsiA(Input:*,Arr:Array):Boolean
		{
			return Boolean(IinA(Input,Arr)>=0)
		}
		
		public static function SinA(Input:*,Arr:Array,Count:uint=0):uint
		{
			if(isEmptyArray(Arr))
			{
				return 0
			}
			var tempCount:uint=Count
			for (var ts:int=Arr.length-1;ts>=0;ts--)
			{
				if(tempCount>0||Count==0)
				{
					if(Input is Array)
					{
						if(IsiA(Arr[ts],Input))
						{
							Arr.splice(ts,1)
							if(tempCount>0) tempCount--
						}
					}
					else if(Arr[ts]==Input)
					{
						Arr.splice(ts,1)
						if(tempCount>0) tempCount--
					}
				}
				else
				{
					break
				}
			}
			return Count-tempCount
		}
		
		public static function isEmptyArray(A:Array):Boolean
		{
			if(A==null||A.length<1)
			{
				return true
			}
			return false
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
			if(Variable==undefined||
			   Variable is Boolean||
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