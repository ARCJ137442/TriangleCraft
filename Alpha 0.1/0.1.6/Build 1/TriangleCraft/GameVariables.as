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
	
	
	public class GameVariables
	{
		//========Static Variables========//
		//----WorldSpawn----//
		public static const WorldSpawnModes:Vector.<String>=new <String>["Infinity","Random","Mini","Small","Medium","Large","Long","Deep","Giant","Super Giant"]
		public static const DefaultTileSpawnChance:Number=1/10
		//Virus
		public static const VirusModes:Vector.<String>=new <String>["NoVirus","Default","VirusStrom"]
		public static const DefaultMaxVirusCount:uint=5
		public static const DefaultVirusSpawnProbability:uint=256//==1/x==//
		
		//----Physics----//
		public static const Fraction_Default:Number=1/64
		
		//----Game Rule----//
		public static const d_generateTiles:Boolean=true
		public static const d_blockDropItems:Boolean=true
		
		//========Instance Variables========//
		//----WorldSpawn----//
		//Part 1:WorldSpawn
		protected var _worldSpawnMode:String
		protected var _tileSpawnChance:Number
		public var WorldWidth:uint
		public var WorldHeight:uint
		
		//Part 2
		public var WorldSpawnSeed:int
		public var WorldRealSeed:*
		
		//----Virus----//
		protected var _virusMode:String
		public var MaxVirusCount:uint=DefaultMaxVirusCount
		public var VirusSpawnProbability:uint=DefaultVirusSpawnProbability
		
		//----Player----//
		public var PlayerRandomSpawnRange=20
		public var defaultPlayerGameMode:String=PlayerGameMode._defaultMode
		
		//----Physics----//
		public var Fraction:Number=GameVariables.Fraction_Default
		
		//----Game Rule----//
		public var generateTiles:Boolean=d_generateTiles
		public var blockDropItems:Boolean=d_blockDropItems
		
		//================Init GameVariables================//
		public function GameVariables():void
		{
			//======Constructor Code======//
			//set Default
			this.WorldSeed=0
			this.WorldSpawnMode="Medium"
			this.VirusMode="Default"
		}
		
		//====================Static Functions====================//
		public static function get RandomVariables():GameVariables
		{
			var variables:GameVariables=new GameVariables()
			variables.WorldSeed=tcMath.random(int.MAX_VALUE);
			variables.WorldSpawnMode=String(GameVariables.WorldSpawnModes[1+tcMath.random(GameVariables.WorldSpawnModes.length-3)])//No Spawn Giants
			variables.TileSpawnChance=GameVariables.DefaultTileSpawnChance+(Math.random()-Math.random())*GameVariables.DefaultTileSpawnChance
			variables.VirusMode=String(GameVariables.VirusModes[tcMath.random(GameVariables.VirusModes.length)])
			variables.defaultPlayerGameMode=PlayerGameMode._randomWithoutNull
			return variables
		}
		
		public static function get presetVariables_Test():GameVariables
		{
			var variables:GameVariables=new GameVariables()
			variables.WorldSeed=0xC418+0xFade;
			variables.WorldSpawnMode="small"
			variables.TileSpawnChance=1/16
			variables.MaxVirusCount=16
			variables.VirusSpawnProbability=0x10c
			variables.PlayerRandomSpawnRange=0
			variables.defaultPlayerGameMode=PlayerGameMode.ADMIN
			return variables
		}
		
		public static function get presetVariables_N():GameVariables//Signal Test
		{
			var variables:GameVariables=new GameVariables()
			variables.WorldSeed=0xAc+0xBa+0xBe+0xCa+0xCd+0xCe+0xCf+0xFe;
			variables.WorldSpawnMode="medium"
			variables.TileSpawnChance=1/16
			variables.MaxVirusCount=4
			variables.generateTiles=false
			variables.VirusSpawnProbability=0x1f
			variables.PlayerRandomSpawnRange=0
			variables.defaultPlayerGameMode=PlayerGameMode.ADMIN
			return variables
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
			switch(Mode.toLowerCase())
			{
			case "mini"://21*21
				w=10,h=10
				break
			case "small"://31*31
				w=15,h=15
				break
			case "medium"://41*41
				w=20,h=20
				break
			case "bigger"://51*51
				w=25,h=25
				break
			case "large"://61*61
				w=30,h=30
				break
			case "giant"://81*81
				w=40,h=40
				break
			case "super giant"://101*101
				w=50,h=50
				break
			case "long"://101*21
				w=50,h=10
				break
			case "deep"://21*101
				w=10,h=50
				break
			case "infinity"://***
				w=16,h=16
				break
			//Random
			default://21*21~121*121
				w=10+tcMath.random(30),h=10+tcMath.random(30)
				break
			}
			this.WorldWidth=w
			this.WorldHeight=h
			this._worldSpawnMode=Mode.charAt(0).toUpperCase()+Mode.slice(1)
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
		
		public function get TileSpawnChance():Number 
		{
			return this._tileSpawnChance
		}
		
		public function set TileSpawnChance(value:Number):void 
		{
			this._tileSpawnChance=tcMath.NumberBetween(value,0,1)
		}
	}
}