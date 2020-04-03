package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Player.Player
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Class
	internal class PlayerAbility
	{
		//========Static Variables========//
		intc static function get DEFAULT():PlayerAbility
		{
			return new PlayerAbility()
		}
		
		//========Dynamic Variables========//
		public var CanDestroy:Boolean
		public var CanPlace:Boolean
		public var InstantDestroy:Boolean
		public var CanUseBlock:Boolean
		public var CanUseItem:Boolean
		
		//--------Set PlayerAbility--------//
		public function PlayerAbility(CanDestroy:Boolean=true,
									  CanPlace:Boolean=true,
									  InstantDestroy:Boolean=false,
									  CanUseBlock:Boolean=true,
									  CanUseItem:Boolean=true):void
		{
			this.LoadDefault()
			this.CanDestroy=CanDestroy
			this.CanPlace=CanPlace
			this.InstantDestroy=InstantDestroy
			this.CanUseBlock=CanUseBlock
			this.CanUseItem=CanUseItem
		}
		
		//============Dynamic Functions============//
		intc function LoadDefault():void
		{
			this.CanDestroy=true
			this.CanPlace=true
			this.InstantDestroy=false
			this.CanUseBlock=true
			this.CanUseItem=true
		}
	}
}