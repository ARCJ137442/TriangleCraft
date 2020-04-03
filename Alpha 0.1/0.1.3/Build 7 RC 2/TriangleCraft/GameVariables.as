package TriangleCraft
{
	//TriangleCraft:Import All
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.Tile.*;
	use namespace intc
	import TriangleCraft.Common.*;
	
	public class GameVariables
	{
		//========Static Variables========//
		//----WorldSpawn----//
		public static const WorldSpawnModes:Vector.<String>=new <String>["Infinity","Random","Mini","Small","Medium","Large","Long","Deep","Giant","Super Giant"]
		public static const MaxConditionCount:uint=5
		//Virus
		public static const VirusModes:Vector.<String>=new <String>["NoVirus","Default","VirusStrom"]
		public static const DefaultMaxVirusCount:uint=5
		public static const DefaultVirusSpawnProbability:uint=256//==1/x==//
		
		//----Physics----//
		public static const Fraction_Default:Number=1/64
		
		//========Instance Variables========//
		//----WorldSpawn----//
		//Part 1:WorldSpawn
		protected var _worldSpawnMode:String
		public var WorldWidth:uint
		public var WorldHeight:uint
		
		//Part 2
		public var WorldSpawnSeed:int
		public var WorldRealSeed:*
		public var WorldSpawnConditions:uint=General.booleansToBinary(true,true,true,true,true)
		
		//----Virus----//
		protected var _virusMode:String
		public var MaxVirusCount:uint=DefaultMaxVirusCount
		public var VirusSpawnProbability:uint=DefaultVirusSpawnProbability
		
		//----Player----//
		public var PlayerRandomSpawnRange=20
		public var defaultPlayerGameMode:String=PlayerGameMode._defaultMode
		
		//----Physics----//
		public var Fraction:Number=GameVariables.Fraction_Default
		
		//================Init GameVariables================//
		public function GameVariables():void
		{
			//======Constructor Code======//
			//set Default
			this.WorldSeed=0
			this.WorldSpawnMode="Medium"
			this.VirusMode="Default"
			this.WorldSpawnConditions=GameVariables.DefaultSpawnConditions
		}
		
		//====================Static Functions====================//
		public static function get RandomVariables():GameVariables
		{
			var variables:GameVariables=new GameVariables()
			variables.WorldSeed=tcMath.random(int.MAX_VALUE);
			variables.WorldSpawnMode=String(GameVariables.WorldSpawnModes[1+tcMath.random(GameVariables.WorldSpawnModes.length-3)])//No Spawn Giants
			variables.VirusMode=String(GameVariables.VirusModes[tcMath.random(GameVariables.VirusModes.length)])
			variables.WorldSpawnConditions=GameVariables.RandomSpawnConditions
			variables.defaultPlayerGameMode=variables.WorldSpawnConditions==0?PlayerGameMode.ADMIN:PlayerGameMode._randomWithoutNull
			return variables
		}
		
		//Get A Random Spawn Conditions
		public static function get RandomSpawnConditions():uint
		{
			if (General.randomBoolean(1,4))
			{
				return General.randomBoolean(1,1)?GameVariables.MaxSpawnConditions:GameVariables.MinSpawnConditions
			}
			return tcMath.random(Math.pow(2,GameVariables.MaxConditionCount));
		}
		
		//Get Default Spawn Conditions
		public static function get DefaultSpawnConditions():uint
		{
			return GameVariables.MaxSpawnConditions;
		}
		
		public static function get MaxSpawnConditions():uint
		{
			return Math.pow(2,GameVariables.MaxConditionCount);
		}
		
		public static function get MinSpawnConditions():uint
		{
			return 0
		}
		
		//====================Instance Functions====================//
		//Get WorldSeed
		public function get WorldSeed():String
		{
			return String(this.WorldRealSeed)
		}
		
		//Set WorldSeed
		public function set WorldSeed(Seed:*):void
		{
			this.WorldRealSeed=Seed
			if (Seed is uint)
			{
				this.WorldSpawnSeed=Seed
				return
			}
			if (Seed is int)
			{
				this.WorldSpawnSeed=Seed+uint.MAX_VALUE/2
				return
			}
			if (Seed is Number)
			{
				this.WorldSpawnSeed=uint(String(Seed).split(".").join(""))
				return
			}
			else
			{
				this.WorldSpawnSeed=(Seed as Object).toString()
			}
			if (Seed is String)
			{
				var str:String=String(Seed as String)
				var tempSeed:uint
				for (var i:uint=0;i<str.length;i++)
				{
					tempSeed += i*str.charCodeAt(i)
				}
				this.WorldSpawnSeed=tempSeed
			}
		}
		
		//Get Spawn Mode
		public function get WorldSpawnMode():String
		{
			return this._worldSpawnMode
		}
		
		//Set Spawn Mode
		public function set WorldSpawnMode(Mode:String):void
		{
			var w:uint,h:uint
			switch (Mode)
			{
			case "Mini"://21*21
				w=10,h=10
				break
			case "Small"://41*41
				w=20,h=20
				break
			case "Medium"://61*61
				w=30,h=30
				break
			case "Large"://81*81
				w=40,h=40
				break
			case "Giant"://101*101
				w=50,h=50
				break
			case "Super Giant"://121*121
				w=60,h=60
				break
			case "Long"://97*33
				w=48,h=16
				break
			case "Deep"://33*97
				w=16,h=48
				break
			case "Infinity"://***
				w=16,h=16
				break
			//Random
			default://21*21~121*121
				w=10+tcMath.random(60),h=10+tcMath.random(60)
				break
			}
			this.WorldWidth=w
			this.WorldHeight=h
			this._worldSpawnMode=Mode
		}
		
		//Get Virus Mode
		public function get VirusMode():String
		{
			return this._virusMode
		}
		
		//Set Virus
		public function set VirusMode(Mode:String):void
		{
			this._virusMode=Mode
			switch (VirusMode)
			{
			case "NoVirus": 
				MaxVirusCount=0
				VirusSpawnProbability=0
				break
			case "VirusStrom": 
				MaxVirusCount=20
				VirusSpawnProbability=32
				break
			default: 
				MaxVirusCount=DefaultMaxVirusCount
				VirusSpawnProbability=DefaultVirusSpawnProbability
				break
			}
		}
		
		public function get worldSpawnMode():String
		{
			return _worldSpawnMode;
		}
		
		public function set worldSpawnMode(value:String):void
		{
			_worldSpawnMode=value;
		}
	}
}