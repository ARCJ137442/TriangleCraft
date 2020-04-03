package 
{
	import flash.utils.ByteArray
	public class General
	{
		//============Code Functions============//
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
		
		public static function copyObject(object:Object)
		{
			var tempObject:ByteArray=new ByteArray()
			tempObject.writeObject(object)
			tempObject.position=0
			return tempObject.readObject() as Object
		}

		public static function IinA(i:*,a:Array):int
		{
			for (var ts=0;ts<a.length;ts++)
			{
				if (a[ts]==i)
				{
					return ts;
				}
			}
			return -1;
		}

		public static function isCurrentArray(A:Array,B:Array)
		{
			if (A.length!=B.length)
			{
				return false;
			}
			else
			{
				for (var i=0;i<A.length;i++)
				{
					if (A[i]!=B[i]&&A[i]!=null&&B[i]!=null)
					{
						return false;
					}
				}
				return true;
			}
		}
	}
}