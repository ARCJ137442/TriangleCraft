package 
{
	public class PlayerAbility
	{
		//========Dynamic Variables========//
		public var CanDestroy:Boolean
		public var CanPlace:Boolean
		public var InstantDestroy:Boolean
		
		//--------Set PlayerAbility--------//
		public function PlayerAbility(CanDestroy:Boolean=true,
									  CanPlace:Boolean=true,
									  InstantDestroy:Boolean=false):void
		{
			this.CanDestroy=CanDestroy
			this.CanPlace=CanPlace
			this.InstantDestroy=InstantDestroy
		}
		
		//============Dynamic Functions============//
		public function LoadDefault():void
		{
			this.CanDestroy=true
			this.CanPlace=true
			this.InstantDestroy=false
		}
	}
}