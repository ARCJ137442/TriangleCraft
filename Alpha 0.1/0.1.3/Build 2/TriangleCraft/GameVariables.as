package TriangleCraft
{
	//TriangleCraft:Import All
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class GameVariables
	{
		//========Static Variables========//
		//----WorldSpawn----//
		public static const WorldSpawnModes:Array=["Infinity","Random","Mini",
											   "Small","Medium","Large",
											   "Giant","Long","Deep",
											   "Super Giant"]
		public static const MaxConditionCount:uint=5
		//Virus
		public static const VirusModes:Array=["NoVirus","Default","VirusStrom"]
		public static const DefaultMaxVirusCount:uint=3
		public static const DefaultVirusSpawnProbability:uint=512//==1/x==//
		
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
		public var WorldSpawnConditions:Array
		
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
			var Variables:GameVariables=new GameVariables()
			Variables.WorldSeed=General.random(int.MAX_VALUE);
			Variables.WorldSpawnMode=String(GameVariables.WorldSpawnModes[1+General.random(GameVariables.WorldSpawnModes.length-1)])
			Variables.VirusMode=String(GameVariables.WorldSpawnModes[General.random(GameVariables.VirusModes.length)])
			Variables.WorldSpawnConditions=GameVariables.RandomSpawnConditions
			Variables.defaultPlayerGameMode=PlayerGameMode._randomWithoutNull
			return Variables
		}
		
		//Booleans To Spawn Conditions
		public static function BooleansToSpawnConditions(...Booleans):Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i<GameVariables.MaxConditionCount;i++)
			{
				if(Boolean(Booleans[i]))
				{
					returnArr.push(i+1)
				}
			}
			return returnArr;
		}
		
		//Get A Random Spawn Conditions
		public static function get RandomSpawnConditions():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i<GameVariables.MaxConditionCount;i++)
			{
				if(General.randomBoolean(3/5))
				{
					returnArr.push(i+1)
				}
			}
			if(General.isEmptyArray(returnArr))
			{
				returnArr.push(General.random(GameVariables.MaxConditionCount)+1)
			}
			return returnArr;
		}
		
		//Get Default Spawn Conditions
		public static function get DefaultSpawnConditions():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i<GameVariables.MaxConditionCount;i++)
			{
				returnArr.push(i+1)
			}
			return returnArr;
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
			if(Seed is uint)
			{
				this.WorldSpawnSeed=Seed
				return
			}
			if(Seed is int)
			{
				this.WorldSpawnSeed=Seed+uint.MAX_VALUE/2
				return
			}
			if(Seed is Number)
			{
				this.WorldSpawnSeed=uint(String(Seed).split(".").join(""))
				return
			}
			else
			{
				this.WorldSpawnSeed=(Seed as Object).toString()
			}
			if(Seed is String)
			{
				var str:String=String(Seed as String)
				var tempSeed:uint
				for(var i:uint=0;i<str.length;i++)
				{
					tempSeed+=i*str.charCodeAt(i)
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
			var w,h:uint
			switch(Mode)
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
				w=10+General.random(60),h=10+General.random(60)
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
			this._virusMode=String(VirusModes[General.random(VirusModes.length)])
			switch(VirusMode)
			{
				case "NoVirus":
				MaxVirusCount=0
				VirusSpawnProbability=0
				break
				case "VirusStrom":
				MaxVirusCount=10
				VirusSpawnProbability=16
				break
				default:
				MaxVirusCount=DefaultMaxVirusCount
				VirusSpawnProbability=DefaultVirusSpawnProbability
				break
			}
		}
	}
}