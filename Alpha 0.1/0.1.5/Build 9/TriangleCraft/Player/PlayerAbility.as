package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Player.Player
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Class
	internal dynamic class PlayerAbility
	{
		//========Static Variables========//
		intc static function get DEFAULT():PlayerAbility
		{
			return new PlayerAbility()
		}
		
		intc static function get EMPTY():PlayerAbility
		{
			var pa:PlayerAbility=new PlayerAbility()
			pa.loadEmpty()
			return pa
		}
		
		intc static function get FULL():PlayerAbility
		{
			var pa:PlayerAbility=new PlayerAbility()
			pa.loadFull()
			return pa
		}
		
		//========Dynamic Variables========//
		public var canDestroy:Boolean
		public var canPlace:Boolean
		public var canUseBlock:Boolean
		public var canUseItem:Boolean
		public var canDestroyAll:Boolean
		public var canPushBlock:Boolean
		public var canExtendBorder:Boolean
		
		public var InstantDestroy:Boolean
		public var InfinityItem:Boolean
		
		//--------Init PlayerAbility--------//
		public function PlayerAbility():void
		{
			this.loadDefault()
		}
		
		//============Dynamic Functions============//
		intc function loadDefault():void
		{
			this.canDestroy=true
			this.canPlace=true
			this.canUseBlock=true
			this.canUseItem=true
			this.canDestroyAll=false
			this.canPushBlock=true
			this.canExtendBorder=false
			
			this.InstantDestroy=false
			this.InfinityItem=false
		}
		
		intc function loadEmpty():void
		{
			this.canDestroy=false
			this.canPlace=false
			this.canUseBlock=false
			this.canUseItem=false
			this.canDestroyAll=false
			this.canPushBlock=false
			this.canExtendBorder=false
			
			this.InstantDestroy=false
			this.InfinityItem=false
		}
		
		intc function loadFull():void
		{
			this.canDestroy=true
			this.canPlace=true
			this.canUseBlock=true
			this.canUseItem=true
			this.canDestroyAll=true
			this.canPushBlock=true
			this.canExtendBorder=true
			
			this.InstantDestroy=true
			this.InfinityItem=true
		}
	}
}