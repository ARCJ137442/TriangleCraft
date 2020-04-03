package TriangleCraft
{
	import TriangleCraft.General
	import TriangleCraft.Game
	
	public class GameVariables
	{
		//========Static Const========//
		//----WorldSpawn----//
		public static const WorldSizes:Array=["Infinity","Random","Mini",
											   "Small","Medium","Large",
											   "Giant","Long","Deep",
											   "Super Giant"]
		public static const MaxConditionCount:uint=5
		//Virus
		public static const VirusModes:Array=["NoVirus","Default","VirusStrom"]
		public static const DefaultMaxVirusCount:uint=3
		public static const DefaultVirusSpawnProbability:uint=512//==1/x==//
		
		//----Physics----//
		public static const Fraction:Number=1/Game.FPS
		
		//========Variables========//
		//----WorldSpawn----//
		//Part 1
		public var WorldSize:String
		public var WorldWidth:uint
		public var WorldHeight:uint
		//Part 2
		public var WorldSpawnSeed:int
		public var WorldRealSeed:*
		public var WorldSpawnConditions:Array
		//Virus
		public var VirusMode:String
		public var MaxVirusCount:uint=DefaultMaxVirusCount
		public var VirusSpawnProbability:uint=DefaultVirusSpawnProbability
		public var PlayerRandomSpawnRange=20
		
		//----Physics----//
		public var Fraction:Number=1/Game.FPS
		
		//================Set GameVariables================//
		public function GameVariables():void
		{
			//======Constructor Code======//
			//set Default
			WorldSeed=0
			setWorldSize()
			setVirusMode()
			this.WorldSpawnConditions=GameVariables.DefaultSpawnConditions
		}
		
		public static function get RandomVariables():GameVariables
		{
			var Variables:GameVariables=new GameVariables()
			Variables.WorldSeed=General.random(int.MAX_VALUE);
			Variables.setWorldSize(String(GameVariables.WorldSizes[1+General.random(GameVariables.WorldSizes.length-1)]))
			Variables.setVirusMode(String(GameVariables.WorldSizes[General.random(GameVariables.VirusModes.length)]))
			
			return Variables
		}
		
		//====================Functions====================//
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
		
		//Set Size
		public function setWorldSize(Size:String="Medium"):void
		{
			var w,h:uint
			switch(Size)
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
			this.WorldSize=Size
		}
		
		//Set Virus
		public function setVirusMode(Mode:String="Default"):void
		{
			VirusMode=String(VirusModes[General.random(VirusModes.length)])
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
		
		//Get A Random Spawn Conditions
		public function getRandomSpawnConditions():Array
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
				returnArr=GameVariables.DefaultSpawnConditions
			}
			return returnArr;
		}
		
		//Booleans To Spawn Conditions
		public function BooleansToSpawnConditions(...Booleans):Array
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
		
		//Get Default Spawn Conditions
		private static function getDefaultSpawnConditions():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i<GameVariables.MaxConditionCount;i++)
			{
				returnArr.push(i+1)
			}
			return returnArr;
		}
		
		public static function get DefaultSpawnConditions():Array
		{
			return GameVariables.getDefaultSpawnConditions()
		}
	}
}