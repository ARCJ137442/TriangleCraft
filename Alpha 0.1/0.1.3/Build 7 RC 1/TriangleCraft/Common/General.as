package TriangleCraft.Common
{
	//TriangleCraft
	use namespace intc
	
	//Flash
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import flash.display.DisplayObject;

	public class General
	{
		//==============Static Variables==============//
		private static var PrimeList:Vector.<uint>=new <uint>[2]
		
		//==============Math Methods==============//
		public static function $(x:Number):Number
		{
			return x>0?x:1/(-x)
		}
		
		public static function $i(x:Number,y:Number=NaN):Number
		{
			if(isNaN(y)) y=x<1?-1:1
			return y<0?-1/(x):x
		}
		
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
			return Math.floor(l+Math.random()*h-l);
		}
		
		public static function NumTo1(x:Number):int
		{
			return x==0?0:(x>0?1:-1)
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

		public static function getSum(A:Array):Number
		{
			var sum:Number=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getSum3(...numbers):Number
		{
			var sum:Number=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
				}
			}
			return sum;
		}

		public static function getAverage(A:Array):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in A)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage2(V:Vector.<Number>):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i:Number in V)
			{
				if(!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}

		public static function getAverage3(...numbers):Number
		{
			var sum:Number=0;
			var count:uint=0;
			for each(var i in numbers)
			{
				if(i is Number&&!isNaN(i))
				{
					sum+=i;
					count++
				}
			}
			return sum/count;
		}
		
		public static function removeEmptyInArray(A:Array):void
		{
			for(var i:uint=Math.max(A.length-1,0);i>=0;i--)
			{
				if(A[i]==null||
				   isNaN(A[i]))
				{
					A.splice(i,1)
				}
			}
		}
		
		public static function removeEmptyInNumberVector(V:Vector.<Number>):void
		{
			for(var i:uint=Math.max(V.length-1,0);i>=0;i--)
			{
				if(isNaN(V[i]))
				{
					V.splice(i,1)
				}
			}
		}
		
		public static function removeEmptyIn(...List):void
		{
			for each(var i in List)
			{
				if(i is Array)
				{
					removeEmptyInArray(i)
				}
				if(i is Vector.<Number>)
				{
					removeEmptyInNumberVector(i)
				}
			}
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
		
		public static function NumberBetween(x:Number,
											 num1:Number=Number.NEGATIVE_INFINITY,
											 num2:Number=Number.POSITIVE_INFINITY):Number
		{
			return Math.min(Math.max(num1,num2),Math.max(Math.min(num1,num2),x))
		}

		public static function getPrimes(X:Number):Vector.<uint>
		{
			if(X>General.LastPrime)
			{
				General.LastPrime=X
				return General.PrimeList
			}
			else
			{
				for(var i:uint=0;i<General.PrimeList.length;i++)
				{
					if(General.PrimeList[i]>X)
					{
						return General.PrimeList.slice(0,i)
					}
				}
				return new Vector.<uint>()
			}
		}

		public static function getPrimeAt(X:Number):uint
		{
			var Vec:Vector.<uint>=new Vector.<uint>();
			var t;
			for(var i:uint=General.LastPrime;Vec.length<X;i+=10)
			{
				Vec=getPrimes(i);
			}
			if(Vec.length>=X)
			{
				return Vec[X-1];
			}
			return 2
		}

		public static function isPrime(X:Number):Boolean
		{
			if(Math.abs(X)<2)
			{
				return false;
			}
			if(X>General.LastPrime)
			{
				General.LastPrime=X
			}
			return General.PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										  {
											  return X%p!=0&&X!=p
										  })
		}
		
		private static function get LastPrime():uint
		{
			return uint(General.PrimeList[General.PrimeList.length-1])
		}
		
		private static function set LastPrime(Num:uint):void
		{
			for(var n:uint=General.LastPrime;n<=Num;n++)
			{
				if(General.PrimeList.every(function(p:uint,i:uint,v:Vector.<uint>):Boolean
										   {
											   return (n%p!=0&&n!=p)
										   }))
				{
					General.PrimeList.push(n);
				}
			}
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
		
		public static function randomBoolean(trueWeight:uint=1,falseWeight:uint=1):Boolean
		{
			return random(trueWeight)+random(falseWeight)>=(trueWeight+falseWeight)/2
		}
		
		public static function randomBoolean2(chance:Number=0.5):Boolean
		{
			return (Math.random()<=chance)
		}
		
		public static function binaryToBooleans(bin:uint,length:uint=0):Vector.<Boolean>
		{
			var l:uint=Math.max(bin.toString(2).length,length)
			var V:Vector.<Boolean>=new Vector.<Boolean>(l,true)
			for(var i:uint=0;i<l;i++)
			{
				V[i]=Boolean(bin>>i&1)
			}
			return V
		}
		
		public static function booleansToBinary(...boo):uint
		{
			var args:Vector.<Boolean>=new Vector.<Boolean>
			for (var i:uint=0;i<boo.length;i++)
			{
				if(boo[i] is Boolean) args[i]=boo[i]
			}
			return booleansToBinary2(args);
		}
		
		public static function booleansToBinary2(boo:Vector.<Boolean>):uint
		{
			var l:uint=boo.length
			var uin:uint=0
			for (var i:int=l-1;i>=0;i--)
			{
				uin|=uint(boo[i])<<i
			}
			return uin;
		}
		
		//============String Methods============//
		public static function hasSpellInString(spell:String,string:String):Boolean
		{
			return (string.toLowerCase().indexOf(spell)>=0)
		}

		//============Code Methods============//
		public static function isTriangleCraft(Obj:DisplayObject):Boolean
		{
			if("isTriangleCraft" in Obj) return true
			return false
		}
		
		public static function returnRandom(...Paras):*
		{
			return Paras[random(Paras.length)]
		}
		
		public static function returnRandom2(Paras:*):*
		{
			if(Paras is Array||Paras is Vector)
			{
				return Paras[random(Paras.length)]
			}
			else
			{
				return returnRandom3(Paras)
			}
		}
		
		public static function returnRandom3(Paras:*):*
		{
			var Arr:Array=new Array
			for each(var tempVar:* in Paras)
			{
				Arr.push(tempVar)
			}
			return
		}
		
		public static function getPropertyInObject(arr:Array,pro:String):Array
		{
			var ra:Array=new Array()
			for (var i:uint=0;i<arr.length;i++)
			{
				if(pro in arr[i])
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
		
		public static function IsiA(Input:*,Arr:*):Boolean
		{
			if(Arr is Array||Arr is Vector)
			return (Arr.indexOf(Input)>=0)
			else return (Input in Arr)
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
			return (A==null||A.length<1)
		}

		public static function isEmptyString(S:String):Boolean
		{
			return (S==null||S.length<1)
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