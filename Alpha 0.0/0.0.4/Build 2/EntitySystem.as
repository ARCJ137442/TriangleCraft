package 
{
	import General;
	public class EntitySystem
	{
		function EntitySystem(Sys:EntitySystem)
		{
			
		}
		//==========Idefined==========//
		public static const Player:String="Player"
		public static const Item:String="Item"
		
		public static const AllEntityID:Array=[Player,
											   Item]
		public static const TotalEntityCount:uint=AllEntityID.length
		
		//==========Functions===========//
		public static function isAllowID(Id:String):Boolean
		{
			if(General.IinA(Id,AllEntityID)>=0)
			{
				return true
			}
			trace("Not Allow ID:"+Id)
			return false
		}
	}
}