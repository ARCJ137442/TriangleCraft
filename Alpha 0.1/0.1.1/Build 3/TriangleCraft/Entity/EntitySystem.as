package TriangleCraft.Entity
{
	//TriangleCraft
	import TriangleCraft.General;
	import TriangleCraft.Entity.Mobile.Mobile;
	
	//Class
	public class EntitySystem
	{
		//==========Idefined==========//
		public static const Player:String="Player"
		public static const Item:String="Item"
		
		public static const AllMobileID:Array=[Player]
		public static const AllNotMobileID:Array=[Item]
		
		public static const AllEntityID:Array=AllMobileID.concat(AllNotMobileID)
		public static const TotalEntityCount:uint=AllEntityID.length
		
		//==========Functions===========//
		public static function isAllowEntityID(Id:String):Boolean
		{
			if(General.IinA(Id,AllEntityID)>=0)
			{
				return true
			}
			trace("Not Allow Entity ID:"+Id)
			return false
		}
		
		public static function isAllowMobileID(Id:String):Boolean
		{
			if(General.IinA(Id,AllMobileID)>=0)
			{
				return true
			}
			trace("Not Allow Mobile ID:"+Id)
			return false
		}
		
		public static function isAllowNotMobileID(Id:String):Boolean
		{
			if(General.IinA(Id,AllNotMobileID)>=0)
			{
				return true
			}
			trace("Not Allow NotMobile ID:"+Id)
			return false
		}
		
		public static function getMaxHealthByMobile(Mob:Mobile):uint
		{
			switch(Mob.EntityType)
			{
				case EntitySystem.Player:
				return 20
				break
				default:
				return 20
				break
			}
		}
	}
}