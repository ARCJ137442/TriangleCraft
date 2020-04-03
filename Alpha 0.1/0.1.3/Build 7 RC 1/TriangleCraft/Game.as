package TriangleCraft
{
	//TriangleCraft:Import All
	import TriangleCraft.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.GUI.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Structure.*;
	import TriangleCraft.Structure.Structures.*;
	import TriangleCraft.Common.*;
	use namespace intc

	//Flash
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;

	//Class
	public class Game extends Sprite
	{
		//================STATIC VARIABLES================//
		//About This Game
		public static const GAME_NAME:String="Triangle Craft";
		public static const VERSION:String="Alpha 0.1.3 build 7 RC_1";

		//Tile System
		intc static const TILE_SIZE:uint=TileSystem.globalTileSize;
		intc static const DISPLAY_WIDTH:uint=672;
		intc static const DISPLAY_HEIGHT:uint=672;
		intc static const MIDDLE_DISPLAY_X:uint=DISPLAY_WIDTH /2
		intc static const MIDDLE_DISPLAY_Y:uint=DISPLAY_HEIGHT /2

		//World
		intc static const ALLOW_INFINITY_WORLD:Boolean=false;
		intc static const FPS:uint=100
		intc static const FPSDir:uint=Math.pow(10,2)
		intc static const FPSUPS:uint=4

		//Display
		intc static const ZOOM_STEP:Number=1/10

		//Player
		intc static const LIMIT_PLAYER_COUNT:uint=4;

		//DebugText
		intc static const MAIN_FONT_FORMET:TextFormat=new TextFormat("TriangleCraft.Common.MainFont",16,0x000000,false,false,null,null,null,"left");
		intc static const MAIN_FONT_FORMET2:TextFormat=new TextFormat("TriangleCraft.Common.MainFont",16,0x000000,false,false,null,null,null,"right");

		//================INSTANCE VARIABLES=================//
		//Game About
		intc const isTriangleCraft:Boolean=true;
		intc var variables:GameVariables;

		//Game Loading
		private var loadingScreen:LoadScreen=new LoadScreen();
		private var gameLoadingTimer:Timer=new Timer(1);
		private var _loadingEvent:Function;
		private var _loadCompleteEvent:Function;
		private var loadTileX:int;
		private var loadTileY:int;
		private var tileLoadingSpeed:uint=10;

		//Display
		intc var zoomScaleX:Number=1;
		intc var zoomScaleY:Number=1;
		intc var borderWidth:uint=3;
		intc var borderHeight:uint=3;

		//World Spawn
		private var V1:int,V2:int,V3:int,V4:int,V5:int;
		private var E1:Boolean,E2:Boolean,E3:Boolean,E4:Boolean,E5:Boolean;
		private var virusCount:uint=0;
		private var totalLoadTiles:uint=0;
		private var structures:Vector.<IStructure>

		//Display Containers
		private var World_Sprite:Sprite=new Sprite();
		private var Tile_Sprite_Top:Sprite=new Sprite();
		private var Tile_Sprite_Back:Sprite=new Sprite();
		private var Players_Sprite:Sprite=new Sprite();
		private var Entities_Sprite:Sprite=new Sprite();
		private var DebugText_Sprite:Sprite=new Sprite();

		//World System
		private var WorldTickTimer:Timer=new Timer(1000/FPS,Infinity);
		private var FPSUpdateTickTimer:Timer=new Timer(1000/FPSUPS,Infinity);
		private var gameFramePerSecond:Number=0;
		private var LastFPSUpdateTime:uint;
		private var LastTime:uint;
		private var LastKey:uint=0;

		//Tile System
		private var tileGrid:TileGrid=new TileGrid();
		private var tickRunTiles:Vector.<TickRunTileInformations>=new Vector.<TickRunTileInformations>

		//Entities
		private var PlayerList:Vector.<Player>=new Vector.<Player>;
		private var EntityList:Vector.<Entity>=new Vector.<Entity>;

		//DebugText
		private var DebugText:TextField=new TextField();
		private var DebugText2:TextField=new TextField();

		//Craft Recipes
		private var Craft_Recipes:Vector.<CraftRecipe>=new Vector.<CraftRecipe>;

		//Game Rule
		private var randomTickSpeed:uint=1
		private var maxWirelessSignalTransmissionDistance:uint=16

		//Random Tick
		private var randomTick:uint=0
		private var randomTime:Number=1000/32//Static 32 Random Tick Per A Secord

		//Update Memory
		private var tileUpdateMemory:Vector.<Point>=new Vector.<Point>

		//=================STATIC FUNCTIONS=================//
		public static function get VERSION_STAGE():String
		{
			return Game.VERSION.split(" ")[0]
		}

		public static function get VERSION_MAJOR():String
		{
			return Game.VERSION.split(" ")[1]
		}

		public static function get VERSION_BUILD():String
		{
			//[2] is "build"
			return Game.VERSION.split(" ")[3]
		}

		public static function get VERSION_OTHER():String
		{
			return Game.VERSION.split(" ").slice(4).join(" ")
		}

		intc static function getStageRect(displayObj:DisplayObject):Rectangle
		{
			var disOffX:Number=(Game.DISPLAY_WIDTH-displayObj.stage.stageWidth)/2
			var disOffY:Number=(Game.DISPLAY_HEIGHT-displayObj.stage.stageHeight)/2
			var returnRect:Rectangle=new Rectangle(disOffX,disOffY,displayObj.stage.stageWidth,displayObj.stage.stageHeight)
			return returnRect
		}

		intc static function initText(...texts):void
		{
			for each(var t in texts)
			{
				var text:TextField=t as TextField
				if(text!=null)
				{
					text.selectable=false
					text.background=false
				}
			}
		}
		
		intc static function snapToGrid(x:Number):int
		{
			return Math.floor(x/Game.TILE_SIZE)
		}
		
		intc static function realTimeToLocalTime(time:Number):uint
		{
			//Conver By Secord
			return Game.FPS*time
		}
		
		//======================================================//
		//============Math Functions Copy By General============//
		//======================================================//
		intc static function random(x:Number):uint
		{
			return General.random(x)
		}
		
		intc static function randomBoolean(trueWeight:uint,falseWeight:uint):Boolean
		{
			return General.randomBoolean(trueWeight,falseWeight)
		}

		//==================================================//
		//================Game Load Function================//
		//==================================================//
		public function Game(Variables:GameVariables=null):void
		{
			addEventListener(Event.ADDED_TO_STAGE,onGameInit);
		}

		private function onGameInit(E:Event=null):void
		{
			//removeEventListener
			removeEventListener(Event.ADDED_TO_STAGE,onGameInit)
			//Trace Version trace("Version is",Game.versionStage,Game.versionMajor,Game.versionBuild);
			//Init
			initWorldVariables();
			//Init II
			initGameDisplay();
			initAllTile();
			initDefaultRecipes();
			initLoadingScreen();
			//Load Tiles
			startLoadTiles(this.onTileLoading,this.onGameLoadComplete,"Loading World...")
		}
		
		private function startLoadTiles(loadingEvent:Function,
										loadCompleteEvent:Function,
										titleText:String="Loading...",
										elementText:String="Load Tiles: "):void
		{
			//Reset Timer
			this.gameLoadingTimer.reset()
			if(this.gameLoadingTimer.hasEventListener(TimerEvent.TIMER))
			{
				this.gameLoadingTimer.removeEventListener(TimerEvent.TIMER,this._loadingEvent)
			}
			if(this.gameLoadingTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
			{
				this.gameLoadingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._loadCompleteEvent)
			}
			//Set Variables
			this.totalLoadTiles=0
			this.loadTileX=-this.WorldWidth
			this.loadTileY=-this.WorldHeight
			this.totalLoadTiles=0
			this._loadingEvent=loadingEvent
			this._loadCompleteEvent=loadCompleteEvent
			this.tileLoadingSpeed=General.NumberBetween(this.ShouldLoadTiles/128,32,512)
			//Set Text
			this.loadingScreen.title=titleText
			this.loadingScreen.element=elementText
			this.loadingScreen.show()
			//Add Event Listener
			this.gameLoadingTimer.addEventListener(TimerEvent.TIMER,this._loadingEvent)
			//Start
			this.gameLoadingTimer.start()
		}
		
		private function onTileLoading(E:TimerEvent):void
		{
			for(var i:uint=0;i<this.tileLoadingSpeed;i++)
			{
				if(this.loadTileX<=this.WorldWidth)
				{
					//Load Tile And Do Other Things
					var tile:InventoryItem=getTileBySeed(this.loadTileX,this.loadTileY);
					var ID:String=tile.Id;
					var Data:int=tile.Data;
					var Tag:TileTag=tile.Tag;
					var Rot:int=tile.Rot;
					setNewTile(this.loadTileX,this.loadTileY,ID,Data,Tag,Rot);
					this.totalLoadTiles++;
					this.loadingScreen.percent=Number(this.totalLoadTiles/this.ShouldLoadTiles)
					this.loadTileX++
					//Summon Structure
					var str:IStructure=detectStructure(this.loadTileX,this.loadTileY)
					if(str!=null) this.structures.push(str)
					//trace("running")
					continue
				}
				//Else
				this.loadTileX=-this.WorldWidth
				if(this.loadTileY<this.WorldHeight)
				{
					//trace("change")
					this.loadTileY++
					continue
				}
				//Else
				//Game's Tiles is Loaded,Load Complete
				//trace("stop")
				this.gameLoadingTimer.stop()
				this._loadCompleteEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE))
				return
			}
		}
		
		private function onGameLoadComplete(E:TimerEvent=null):void
		{
			//Generate Structures
			generateStructures(this.structures)
			//Spawn Player
			var P1:Player=spawnPlayer(PlayerCount+1,0,0);
			randomspawnPlayer(P1)
			movePosToPlayer(P1.ID)
			//Set DebugText
			this.UpdateDebugText();
			this.ResizeDebugText();
			//Set Variable
			this.isActive=true
			
			//Close LoadingScreen
			//startLoadTiles(this.onTileLoading,this.onGameLoadComplete,"Loading World...")
			this.loadingScreen.deShow()
		}
		
		public function set isActive(boo:Boolean):void
		{
			if(boo)
			{
				//addEventListener
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				this.stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);
				this.stage.addEventListener(Event.RESIZE,onStageResize)
				this.WorldTickTimer.addEventListener(TimerEvent.TIMER,EnterWorldTick)
				this.FPSUpdateTickTimer.addEventListener(TimerEvent.TIMER,onFPSUpdate)
				Key.Listens=this.stage
				//getTimer
				this.LastTime=getTimer()
				this.LastFPSUpdateTime=getTimer()
				//Start Timer
				this.WorldTickTimer.start()
				this.FPSUpdateTickTimer.start()
			}
			else
			{
				//removeEventListener
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				this.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUp);
				this.stage.removeEventListener(Event.RESIZE,onStageResize)
				this.WorldTickTimer.removeEventListener(TimerEvent.TIMER,EnterWorldTick)
				this.FPSUpdateTickTimer.removeEventListener(TimerEvent.TIMER,onFPSUpdate)
				Key.Listens=null
				//Start Timer
				this.WorldTickTimer.stop()
				this.FPSUpdateTickTimer.stop()
			}
		}
		
		private function initWorldVariables():void
		{
			//Load A Random GameVariables
			this.variables=GameVariables.RandomVariables
			//Set Structures To Empty
			this.structures=new Vector.<IStructure>
			//About World Spawn
			V1=uint(String(WorldSpawnSeed).charAt(WorldSpawnSeed%String(WorldSpawnSeed).length)+WorldSpawnSeed%10);//1~99
			V2=Math.ceil(WorldSpawnSeed/100)%11+5;//5~15
			V3=General.getPrimeAt(WorldSpawnSeed%10+1);//2~29
			V4=WorldSpawnSeed%(WorldSpawnSeed%64+1)+1;//1~64
			V5=Math.pow(WorldSpawnSeed%10+10,(V1+V2+V3+V4)%4+1);//0~10000
			setWorldSpawnConditions()
			
			//Game Rules
			this.virusCount=0
			this.randomTickSpeed=General.NumberBetween(uint(ShouldLoadTiles/512),1,65536)
		}
		
		private function initAllTile():void
		{
			/*var dis:TileDisplaySettings=new TileDisplaySettings("file:///C:/Title.png")
			var inf:TileInfornation=new TileInfornation("example",dis)
			inf.defaultMaxHard=10
			ModAPI.addNewTile(inf)
			//trace(TileSystem.AllCustomBlockID)
			addCraftRecipe("vvv","vvv","vvv",[],
						   "vvv","vbv","vvv",["b","example",0,null,0])*/
		}

		private function initDefaultRecipes():void
		{
			//Colored Block White
			addCraftRecipe("www","wvw","www",["w",TileID.Colored_Block,0x888888,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vbv","bbb","vbv",["b",TileID.Colored_Block,0xffffff,null,0])
			//Color Mixer
			addCraftRecipe("gbg","bbb","gbg",["g",TileID.Colored_Block,0x888888,null,0,
											  "b",TileID.Colored_Block,0x000000,null,0],
						   "vvv","vav","vvv",["a",TileID.Color_Mixer,0,null,0])
			//Block Crafter
			addCraftRecipe("ggg","bgb","ggg",["g",TileID.Colored_Block,0x888888,null,0,
											  "b",TileID.Colored_Block,0x000000,null,0],
						   "vvv","vav","vvv",["a",TileID.Block_Crafter,0,null,0])
			//Bacic Wall
			addCraftRecipe("bbb","bgb","bbb",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0],
						   "gag","aaa","gag",["a",TileID.Basic_Wall,0,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0])
			//Block Spawner
			addCraftRecipe("bgb","ggg","bgb",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0],
						   "vvv","vav","vvv",["a",TileID.Block_Spawner,0,null,0])
			//Arrow Block
			addCraftRecipe("bbv","ggb","bbv",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0],
						   "vvv","vav","vvv",["a",TileID.Arrow_Block,0,null,0])
			//Barrier
			addCraftRecipe("www","www","www",["w",TileID.Basic_Wall,0,null,0],
						   "vvv","vbv","vvv",["b",TileID.Barrier,0,null,0])
			//Crystal Wall
			addCraftRecipe("ccc","cwc","ccc",["w",TileID.Basic_Wall,0,null,0,
											  "c",TileID.Colored_Block,0x00ffff,null,0],
						   "vwv","vwv","vwv",["w",TileID.Crystal_Wall,0,null,0])
			//Walls Spawner
			addCraftRecipe("bwb","wsw","bwb",["b",TileID.Colored_Block,0x000000,null,0,
											  "w",TileID.Basic_Wall,0,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vav","vvv",["a",TileID.Walls_Spawner,0,null,0])
			//XX Virus
			addCraftRecipe("bgb","gsg","bgb",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus,0,null,0])
			//XX Virus Red
			addCraftRecipe("vvv","vrv","vvv",["r",TileID.Colored_Block,0xff0000,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Red,0,null,0])
			//XX Virus Blue
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x0000ff,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Blue,0,null,0])
			//XX Virus Yellow
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0xffff00,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Yellow,0,null,0])
			//XX Virus Green
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x00ff00,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Green,0,null,0])
			//XX Virus White
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0xffffff,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_White,0,null,0])
			//XX Virus Black
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x000000,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Black,0,null,0])
			//XX Virus Purple
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x804080,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Purple,0,null,0])
			//Pushable Block
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x0000ff,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,0,null,0])
			//Inventory Block
			addCraftRecipe("www","wvw","www",["w",TileID.Basic_Wall,0,null,0],
						   "vvv","vbv","vvv",["b",TileID.Inventory_Block,0,null,0])
			//Signal Wire
			addCraftRecipe("vbv","bbb","vbv",["b",TileID.Colored_Block,0x000000,null,0],
						   "lll","lvl","lll",["l",TileID.Signal_Wire,0,null,0])
			//Signal Diode
			addCraftRecipe("vwv","waw","vwv",["w",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Diode,0,null,0],
						   true,true,true,true,true)
			//Signal Patcher
			addCraftRecipe("wbw","bcb","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "c",TileID.Crystal_Wall,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Patcher,0,null,0],
						   true,true,true)
			//Random Tick Signal Generater
			addCraftRecipe("wbw","bsb","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Random_Tick_Signal_Generater,0,null,0],
						   true,true,true)
			//Wireless Signal Transmitter
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Signal_Diode,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Wireless_Signal_Transmitter,0,null,0],
						   true,true,true)
			//Signal Lamp
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Color_Mixer,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Lamp,0,null,0],
						   true,true,true)
			//Block Destroyer
			addCraftRecipe("wbd","bad","wbd",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "d",TileID.Signal_Diode,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Block_Destroyer,0,null,0],
						   true,true,true)
		}
		
		private function initGameDisplay():void
		{
			//World
			this.addChild(this.World_Sprite)
			this.World_Sprite.addChild(this.Tile_Sprite_Back)
			this.World_Sprite.addChild(this.Entities_Sprite)
			this.World_Sprite.addChild(this.Players_Sprite)
			this.World_Sprite.addChild(this.Tile_Sprite_Top)
			//DebugText
			this.addChild(this.DebugText_Sprite)
			Game.initText(this.DebugText,this.DebugText2)
			this.DebugText.defaultTextFormat=MAIN_FONT_FORMET;
			this.DebugText2.defaultTextFormat=MAIN_FONT_FORMET2;
			this.DebugText_Sprite.addChild(this.DebugText)
			this.DebugText_Sprite.addChild(this.DebugText2)
		}
		
		private function initLoadingScreen():void
		{
			this.addChild(this.loadingScreen)
		}
		
		public function addCraftRecipe(PatternTop:String,PatternMiddle:String,PatternDown:String,
									   PatternCurrent:Array,
									   OutputTop:String,OutputMiddle:String,OutputDown:String,
									   OutputCurrent:Array,
									   returnAsItem:Boolean=true,
									   ignoreCount:Boolean=true,
									   ignoreData:Boolean=false,
									   ignoreTag:Boolean=false,
									   ignoreRot:Boolean=false)
		{
			Craft_Recipes.push(new CraftRecipe(PatternTop,PatternMiddle,PatternDown,PatternCurrent,
											   OutputTop,OutputMiddle,OutputDown,OutputCurrent,
											   returnAsItem,ignoreCount,ignoreData,
											   ignoreTag,ignoreRot))
		}

		//===============================================//
		//================World Functions================//
		//===============================================//
		//====WorldVariables Getters====//
		//====WorldSpawn====//
		private function get WorldSpawnMode():String
		{
			return this.variables.WorldSpawnMode
		}
		
		private function get WorldWidth():uint
		{
			return this.variables.WorldWidth
		}
		
		private function get WorldHeight():uint
		{
			return this.variables.WorldHeight
		}
		
		private function get ShouldLoadTiles():uint
		{
			return (this.WorldWidth*2+1)*(this.WorldHeight*2+1)
		}
		
		private function get StructureGenerateCount():uint
		{
			return this.structures!=null?this.structures.length:0
		}
		
		private function get WorldSeed():String
		{
			return this.variables.WorldSeed
		}
		
		private function get WorldSpawnSeed():int
		{
			return this.variables.WorldSpawnSeed
		}
		
		private function get WorldSpawnConditions():uint
		{
			return this.variables.WorldSpawnConditions
		}
		
		//====Virus====//
		private function get VirusMode():String
		{
			return this.variables.VirusMode
		}
		
		private function get MaxVirusCount():uint
		{
			return this.variables.MaxVirusCount
		}
		
		private function get VirusSpawnProbability():uint
		{
			return this.variables.VirusSpawnProbability
		}
		
		//====Player====//
		private function get PlayerRandomSpawnRange():uint
		{
			return this.variables.PlayerRandomSpawnRange
		}
		
		private function get defaultPlayerGameMode():String
		{
			return this.variables.defaultPlayerGameMode
		}
		
		//====Physics====//
		public function get Fraction():Number
		{
			return this.variables.Fraction
		}
		
		//Random Spawn Player
		private function randomspawnPlayer(player:Player):void
		{
			//ResetPos
			player.MoveTo(0,0)
			var MaxCount:uint=1024
			var count:uint=1
			while(count<MaxCount)
			{
				var ranX:int=General.random1()*random(this.PlayerRandomSpawnRange)
				var ranY:int=General.random1()*random(this.PlayerRandomSpawnRange)
				if(isTile(ranX,ranY)&&getTileTag(ranX,ranY).canPass)
				{
					player.MoveTo(ranX,ranY)
				}
				count++
			}
			//Set RandomRot
			player.Rot=MobileRot.randomRot()
		}
		
		private function setWorldSpawnConditions():void
		{
			var ba:Vector.<Boolean>=General.binaryToBooleans(this.WorldSpawnConditions,GameVariables.MaxConditionCount)
			this.E1=Boolean(ba[0])
			this.E2=Boolean(ba[1])
			this.E3=Boolean(ba[2])
			this.E4=Boolean(ba[3])
			this.E5=Boolean(ba[4])
		}

		//World Tile Spawner
		private function getTileBySeed(X:int=0,Y:int=0):InventoryItem
		{
			var Id:String=TileID.Void;
			var Data:int=0;
			//Barrier Test
			var Condition_Barrier:Boolean=(Math.abs(X)==this.WorldWidth||Math.abs(Y)==this.WorldHeight)
			if(Condition_Barrier)
			{
				return new InventoryItem(TileID.Barrier)
			}
			//Spawn Colored_Block
			var F1:int=General.NumTo1(V1+V2+V3+V4)*Math.abs(Math.floor(V1*V4+Math.abs(X)*V4+V2*Math.abs(Y)))%100+1;//1~100
			var F2:int=Math.floor(V1*V3+V2*V4+Math.abs(X)*Math.abs(Y))%V3+1;//1~30
			var F3:int=Math.floor(V5%4096)*Math.floor(Math.abs(V5+V3*X-V4*Y))%4096//0~16777216
			
			var Condition_1:Boolean,Condition_2:Boolean,Condition_3:Boolean,Condition_4:Boolean,Condition_5:Boolean
			Condition_1=E1&&(Math.abs(X*Y+(V1+V2))%F2==Math.min(F1,F2)%10)
			Condition_2=E2&&(X%2+Y%2==(V1*V2)%(F1%F2))
			Condition_3=E3&&(Math.floor(Math.abs(X+V5+Y-V5))%Math.min(Math.abs(V4*X-V2*Y-X*Y*V5),10)==V5%V4+Math.max(F1,F2)%Math.min(F1,F2))
			Condition_4=E4&&(General.isPrime(Math.abs(X*Y+F1+F2-V4)%800)&&General.isPrime(Math.abs(X*Y-F1-F2+V4)%800))
			Condition_5=E5&&(Math.abs(V5*X+F1)%16==Math.abs(V5*Y+F1)%32)
			var Conditions:Boolean=(Condition_1||Condition_2||
									Condition_3||Condition_4||
									Condition_5)
			if(!detectEntity(X,Y)&&Conditions)
			{
				//Spawn Virus By 1/512
				var Condition_Virus:Boolean=(Math.abs(V1+V2+V3+V4+F1+F2+F3+X*Y)%VirusSpawnProbability==(V1+V2+V3+V4)%VirusSpawnProbability)
				if(Condition_Virus&&virusCount<MaxVirusCount)
				{
					//trace("Spawn A Virus on",X,Y)
					virusCount++
					var virusType:uint=Math.abs(F1+X-Y)%8
					switch(virusType)
					{
						case 1:
						case 2:
						return new InventoryItem(TileID.XX_Virus_Red)
						break
						case 3:
						case 4:
						return new InventoryItem(TileID.XX_Virus_Blue)
						break
						case 5:
						return new InventoryItem(TileID.XX_Virus_Yellow)
						break
						case 6:
						return new InventoryItem(TileID.XX_Virus_Green)
						break
						default:
						return new InventoryItem(TileID.XX_Virus)
						break
					}
				}
				//Spawn Colored Blocks
				Id=TileID.Colored_Block;
				switch((F1+F2+F3)%5)
				{
						//Black
					case 0:
						Data=0x000000;
						break;
						//Gray
					case 1:
						Data=0x888888;
						break;
						//RGB
					case 2:
						Data=0xff0000;
						break;
					case 3:
						Data=0x00ff00;
						break;
					case 4:
						Data=0x0000ff;
						break;
						//CPY
					case 5:
						Data=0xffff00;
						break;
					case 6:
						Data=0xff00ff;
						break;
					case 7:
						Data=0x00ffff;
						break;
						//Random By Seed
					default:
						Data=F3;
						break;
				}
			}
			return new InventoryItem(Id,1,Data);
		}
		
		//-=-=-=-=-=Structure Functions=-=-=-=-=-//
		intc function detectStructure(x:int,y:int):IStructure
		{
			//Structure_1:Walls With A Walls Spawner
			var Structure_1_Condition=((Math.abs((x-y)*(y-x))+Math.abs(V1*V3+V4*V2))%(Math.abs(x*y)+Math.abs(y*V1+V2*V3+2048))==Math.abs(x*y)%V1)
			if(Structure_1_Condition)
			{
				var Structure_1_Size=5+(Math.abs(x+y)+V1+V2+V3)%6
				return new Structure_1(x,y,Structure_1_Size,this.WorldSpawnSeed)
			}
			//Structure_2:Colored Blocks With Some Block Spawner
			var Structure_2_Condition=((Math.abs((x+y)*(y+x))+Math.abs(V1*V2+V3*V4))%(Math.abs(x*y)+Math.abs(y*V2+V3*V4+2048))==Math.abs(x+y)%V1)
			if(Structure_2_Condition)
			{
				var Structure_2_Size=2+(this.WorldSpawnSeed-Math.abs(x*y))%5
				return new Structure_2(x,y,Structure_2_Size,this.WorldSpawnSeed)
			}
			return null
		}
		
		intc function generateStructures(strs:Vector.<IStructure>):void
		{
			for each(var str:IStructure in strs)
			{
				generateStructure(str)
			}
		}
		
		//Generate A Structure
		intc function generateStructure(str:IStructure):void
		{
			var str_x:int=str.x
			var str_y:int=str.y
			for each(var i in str.blocks.tileData)
			{
				if(i!=null&&i is Tile)
				{
					var tile:Tile=i as Tile
					if(isTile(str_x+tile.x,str_y+tile.y))
					{
						if(getTileTag(str_x+tile.x,str_y+tile.y).canPlaceBy||getTileTag(str_x+tile.x,str_y+tile.y).canDestroy)
						{
							setTile(str_x+tile.x,str_y+tile.y,tile.ID,tile.Data,tile.Tag,tile.Rot)
						}
					}
				}
			}
		}

		//-=-=-=-=-=Structure Functions=-=-=-=-=-//
		private function ResetWorld():void
		{
			//Set Variables
			this.isActive=false
			//deShow Entities_Sprite
			this.Players_Sprite.visible=false
			this.Entities_Sprite.visible=false
			//Reset Tiles:Remove All Tile Sprite
			startRemoveAllTile(this.onTileRemoveing,this.onTileRemoveComplete,"Reset World...","Remove Tiles: ")
		}
		
		private function startRemoveAllTile(loadingEvent:Function,
											loadCompleteEvent:Function,
											titleText:String="Loading...",
											elementText:String="Load Tiles: "):void
		{
			//Reset Timer
			this.gameLoadingTimer.reset()
			if(this.gameLoadingTimer.hasEventListener(TimerEvent.TIMER))
			{
				this.gameLoadingTimer.removeEventListener(TimerEvent.TIMER,this._loadingEvent)
			}
			if(this.gameLoadingTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
			{
				this.gameLoadingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._loadCompleteEvent)
			}
			//Set Variables
			this._loadingEvent=loadingEvent
			this._loadCompleteEvent=loadCompleteEvent
			this.tileLoadingSpeed=Math.max(Math.ceil(this.ShouldLoadTiles/128),64)
			//Set Text
			this.loadingScreen.title=titleText
			this.loadingScreen.element=elementText
			this.loadingScreen.show()
			//Set Carema
			this.stageMoveTo(0,0,false)
			//Add Event Listener
			this.gameLoadingTimer.addEventListener(TimerEvent.TIMER,this._loadingEvent)
			//Start
			this.gameLoadingTimer.start()
		}
		
		private function onTileRemoveing(E:TimerEvent=null):void
		{
			var i:Object
			for(var c:uint=0;c<this.tileLoadingSpeed;c++)
			{
				//Delete
				this.tileGrid.clearRandomTile()
				this.loadingScreen.percent=1-this.totalObjTileCount/this.ShouldLoadTiles
				//trace(this.totalObjTileCount)
				if(this.totalObjTileCount<=0)
				{
					//Reset Complete,The End
					this.gameLoadingTimer.stop()
					this._loadCompleteEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE))
					return
				}
			}
		}
		
		private function onTileRemoveComplete(E:TimerEvent=null):void
		{
			//trace(250)
			//Reset World Variables
			initWorldVariables();
			//Set Revealed
			this.UpdateDebugText()
			//Respawn Tiles
			this.removeAllTile()
			startLoadTiles(this.onTileLoading,this.onWorldResetComplete,"Reset World...","Reload Tiles: ")
		}
		
		private function onWorldResetComplete(E:TimerEvent=null):void
		{
			//trace("sb")
			generateStructures(this.structures)
			//Show Sprites
			this.Players_Sprite.visible=true
			this.Entities_Sprite.visible=true
			//Reset Player
			for(var i:uint=0;i<PlayerCount;i++)
			{
				var player:Player=PlayerList[i];
				player.resetInventory()
				player.gameMode=this.defaultPlayerGameMode;
			}
			//Reset Not-Player Entity
			for(var e:uint=0;e<EntityCount;e++)
			{
				var Ent:Entity=EntityList[e]
				if(!Ent is Player)
				{
					Ent.deleteSelf()
					removeEntity(Ent)
				}
			}
			//Random Spawn Player
			for(var p:uint=1;p<=PlayerCount;p++)
			{
				randomspawnPlayer(this.getPx(p))
			}
			//Reset Stage
			movePosToPlayer(random(PlayerCount)+1)
			//Show Text
			this.UpdateDebugText();
			//deShow LoadingScreen
			this.isActive=true
			this.loadingScreen.deShow()
		}
		
		private function spawnTiles():void
		{
			for(var X:int=-WorldWidth;X<=WorldWidth;X++)
			{
				for(var Y:int=-WorldHeight;Y<=WorldHeight;Y++)
				{
					var tile:InventoryItem=getTileBySeed(X,Y);
					var ID:String=tile.Id;
					var Data:int=tile.Data;
					var Tag:TileTag=tile.Tag;
					var Rot:int=tile.Rot;
					setNewTile(X,Y,ID,Data,Tag,Rot);
					totalLoadTiles++;
				}
			}
		}

		//--------Player Functions--------//
		intc function spawnPlayer(ID:uint,X:int=0,Y:int=0,color:Number=NaN):Player
		{
			//Spawn New Player
			var player:Player=new Player(this,X*TILE_SIZE,Y*TILE_SIZE,ID,color);
			player.gameMode=this.defaultPlayerGameMode
			PlayerList.push(player);
			regEntity(player)
			//Add Player To Display;
			Players_Sprite.addChild(player);
			return player;
		}

		intc function spawnPx(ID:uint):void
		{
			if(ID>0)
			{
				var Px=spawnPlayer(PlayerCount+1,0,0);
				this.Players_Sprite.setChildIndex(Px,0);
				this.randomspawnPlayer(Px)
				this.movePosToPlayer(ID)
				this.UpdateDebugText(2);
			}
		}

		intc function getPx(ID:uint):Player
		{
			if(ID>0&&ID<=PlayerCount)
			{
				return (PlayerList[ID-1] as Player);
			}
			return null;
		}

		//=================================================//
		//================Display Functions================//
		//=================================================//
		//Getters
		intc function get ZoomX():Number
		{
			return General.$(this.zoomScaleX)
		}
		
		intc function get ZoomY():Number
		{
			return General.$(this.zoomScaleY)
		}
		
		private function get TileDisplaySizeX():Number
		{
			return Game.TILE_SIZE*this.ZoomX
		}
		
		private function get TileDisplaySizeY():Number
		{
			return Game.TILE_SIZE*this.ZoomY
		}
		
		private function get TileDisplayWidth():Number
		{
			return this.stage.stageWidth/TileDisplaySizeX
		}
		
		private function get TileDisplayHeight():Number
		{
			return this.stage.stageHeight/TileDisplaySizeY
		}
		
		private function get displayOffsetX():Number
		{
			return Game.getStageRect(this).topLeft.x
		}
		
		private function get displayOffsetY():Number
		{
			return Game.getStageRect(this).topLeft.y
		}
		
		private function get TileDisplayOffsetX():Number
		{
			return displayOffsetX/TileDisplaySizeX
		}
		
		private function get TileDisplayOffsetY():Number
		{
			return displayOffsetY/TileDisplaySizeY
		}
		
		private function get TileDisplayRadiusX():Number
		{
			return (TileDisplayWidth-1)/2
		}
		
		private function get TileDisplayRadiusY():Number
		{
			return (TileDisplayHeight-1)/2
		}
		
		private function get displayX():Number
		{
			return (this.x+this.World_Sprite.x)/this.TileDisplaySizeX
		}
		
		private function get displayY():Number
		{
			return (this.y+this.World_Sprite.y)/this.TileDisplaySizeY
		}
		
		private function get worldDisplayX():Number
		{
			return this.World_Sprite.x/this.TileDisplaySizeX
		}
		
		private function get worldDisplayY():Number
		{
			return this.World_Sprite.y/this.TileDisplaySizeY
		}
		
		//----====Main Functions====----//
		private function borderTest(player:Player):void
		{
			var rX:Number=player.getX()+this.displayX;
			var rY:Number=player.getY()+this.displayY;
			var Rot:int=(player.Rot+2)%4
			if(General.isBetween(rX,TileDisplayOffsetX,borderWidth+TileDisplayOffsetX)&&player.Rot==MobileRot.LEFT||
			   General.isBetween(rX,TileDisplayWidth-borderWidth+TileDisplayOffsetX,TileDisplayWidth+TileDisplayOffsetX)&&player.Rot==MobileRot.RIGHT||
			   General.isBetween(rY,TileDisplayOffsetY,borderHeight+TileDisplayOffsetY)&&player.Rot==MobileRot.UP||
			   General.isBetween(rY,TileDisplayHeight-borderHeight+TileDisplayOffsetY,TileDisplayHeight+TileDisplayOffsetY)&&player.Rot==MobileRot.DOWN)
			{
				var xd:int=MobileRot.toPos(Rot,1)[0]
				var yd:int=MobileRot.toPos(Rot,1)[1]
				stageMoveTo(this.worldDisplayX+xd,this.worldDisplayY+yd);
			}
		}
		
		private function movePosToPlayer(ID:uint):void
		{
			var playerPoint:Point=new Point(this.getPx(ID).x,this.getPx(ID).y)
			var lp:Point=this.World_Sprite.localToGlobal(playerPoint)
			var moveX:Number=this.World_Sprite.x+MIDDLE_DISPLAY_X-lp.x
			var moveY:Number=this.World_Sprite.y+MIDDLE_DISPLAY_Y-lp.y
			stageMoveTo(moveX,moveY,false);
		}

		private function stageMoveTo(X:Number,Y:Number,sizeBuff:Boolean=true):void
		{
			if(sizeBuff)
			{
				this.World_Sprite.x=X*this.TileDisplaySizeX;
				this.World_Sprite.y=Y*this.TileDisplaySizeY;
			}
			else
			{
				this.World_Sprite.x=X;
				this.World_Sprite.y=Y;
			}
		}
		
		private function setZoom(Mode:String,Num1:Number=NaN,Num2:Number=NaN,...Parameters):void
		{
			switch(Mode)
			{
				case "In":
				ZoomIn()
				return
				case "On":
				ZoomOn()
				return
				case "Set":
				if(!isNaN(Num1)&&!isNaN(Num2))
				{
					ZoomSet(Num1,Num2)
				}
				return
			}
		}
		
		private function ZoomIn():void
		{
			ZoomInX()
			ZoomInY()
		}
		
		private function ZoomInX():void
		{
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				this.zoomScaleX+=ZOOM_STEP//(this.TileDisplayRadiusX+1)/this.TileDisplayRadiusX
			}
			while(this.zoomScaleX>-1&&this.zoomScaleX<1)
			ZoomUpdate()
		}
		
		private function ZoomInY():void
		{
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				this.zoomScaleY+=ZOOM_STEP//(this.TileDisplayRadiusY+1)/this.TileDisplayRadiusY
			}
			while(this.zoomScaleY>-1&&this.zoomScaleY<1)
			ZoomUpdate()
		}
		
		private function ZoomOn():void
		{
			ZoomOnX()
			ZoomOnY()
		}
		
		private function ZoomOnX():void
		{
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				this.zoomScaleX-=ZOOM_STEP//(this.TileDisplayRadiusX-1)/this.TileDisplayRadiusX
			}
			while(this.zoomScaleX>-1&&this.zoomScaleX<1)
			ZoomUpdate()
		}
		
		private function ZoomOnY():void
		{
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				this.zoomScaleY-=ZOOM_STEP//(this.TileDisplayRadiusY-1)/this.TileDisplayRadiusY
			}
			while(this.zoomScaleY>-1&&this.zoomScaleY<1)
			ZoomUpdate()
		}
		
		private function ZoomUpdate():void
		{
			ZoomSet(General.$(this.zoomScaleX),General.$(this.zoomScaleY))
		}
		
		private function ZoomSet(Num1:Number,Num2:Number=NaN):void
		{
			if(!isNaN(Num1))
			{
				var point0:Point=new Point(MIDDLE_DISPLAY_X,MIDDLE_DISPLAY_Y)
				var point:Point=this.World_Sprite.globalToLocal(point0)
				this.World_Sprite.scaleX=Num1
				if(isNaN(Num2))//One Scale
				{
					this.World_Sprite.scaleY=Num1
				}
				else//Two Scale
				{
					this.World_Sprite.scaleY=Num2
					//this.ZoomScaleY=Num2
				}
				//this.ZoomScaleX=this.World_Sprite.scaleX
				//this.ZoomScaleY=this.World_Sprite.scaleY
				var lp:Point=this.World_Sprite.localToGlobal(point)
				var lp2:Point=point0
				this.World_Sprite.x+=lp2.x-lp.x
				this.World_Sprite.y+=lp2.y-lp.y
				//Update Debug Text
				this.UpdateDebugText(1)
			}
		}

		//==================================================//
		//================Listener Functions================//
		//==================================================//
		private function keyDown(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey
			var alt:Boolean=E.altKey
			var shift:Boolean=E.shiftKey
			LastKey=Code;
			this.UpdateDebugText(1);
			// altKey ctrlKey shiftKey //
			//End Game
			if(ctrl&&Code==27)
			{
				fscommand("quit")
				return;
			}
			//Trun Debug Text Visible By F1
			if(Code==112)//F1
			{
				if(!ctrl&&!shift)
				{
					this.UpdateDebugText(-3)
				}
				else
				{
					if(ctrl)
					{
						this.UpdateDebugText(-1)
					}
					if(shift)
					{
						this.UpdateDebugText(-2)
					}
				}
			}
			//Rescale By F2 or Shift+F2
			if(Code==113)//F2
			{
				if(shift)
				{
					setZoom("On")
				}
				else
				{
					setZoom("In")
				}
			}
			//Give A Item By Ctrl+Num
			if(ctrl&&!shift&&Code>48&&Code<58&&Code-48<=TileSystem.TotalTileCount)
			{
				PlayerList[0].addItem(TileSystem.AllTileID[Code-48],1,0,TileTag.getTagFromID(TileSystem.AllTileID[Code-48]));
				return;
			}
			//Spawn New Player By Ctrl+Shift+1~4
			if(ctrl&&shift&&Code>48&&Code<58&&Code-49==PlayerCount&&Code-48<=LIMIT_PLAYER_COUNT)
			{
				spawnPx(Code-48);
				return;
			}
			//Set Pos To Player By Shift+Id
			if(!ctrl&&shift&&Code>48&&Code<58&&Code-48<=PlayerCount)
			{
				movePosToPlayer(Code-48);
				return;
			}
			//Reset World By Ctrl+Shift+R
			if(ctrl&&shift&&Code==82)
			{
				ResetWorld();
				return;
			}
			//Player Contol
			if(PlayerCount>0)
			{
				for(var i=0;i<PlayerCount;i++)
				{
					var player:Player=PlayerList[i];
					var Rot:uint;
					var Distance:int=player.moveDistence;
					//Set Rot
					switch(Code)
					{
						//Move
						case player.ContolKey_Up:
							player.isKeyDown=true;
							if(!player.isPrass_Up)
							{
								player.PrassUp=true;
								player.MoveUp();
							}
							break;
						case player.ContolKey_Down:
							player.isKeyDown=true;
							if(!player.isPrass_Down)
							{
								player.PrassDown=true;
								player.MoveDown();
							}
							break;
						case player.ContolKey_Left:
							player.isKeyDown=true;
							if(!player.isPrass_Left)
							{
								player.PrassLeft=true;
								player.MoveLeft();
							}
							break;
						case player.ContolKey_Right:
							player.isKeyDown=true;
							if(!player.isPrass_Right)
							{
								player.PrassRight=true;
								player.MoveRight();
							}
							break;
						//Use
						case player.ContolKey_Use:
							player.isKeyDown=true;
							if(!player.isPrass_Use)
							{
								player.PrassUse=true;
								player.Use();
							}
							break;
						//Select
						case player.ContolKey_Select_Left:
							player.isKeyDown=true;
							if(!player.isPrass_Select_Left)
							{
								player.PrassLeftSelect=true;
								player.SelectLeft();
							}
							break;
						case player.ContolKey_Select_Right:
							player.isKeyDown=true;
							if(!player.isPrass_Select_Right)
							{
								player.PrassRightSelect=true;
								player.SelectRight();
							}
							break;
					}
				}
			}
		}

		private function keyUp(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			//Player Contol
			if((PlayerCount>0))
			{
				for(var i=0;i<PlayerCount;i++)
				{
					var player:Player=PlayerList[i];
					//Set Rot
					switch(Code)
					{
						case player.ContolKey_Up:
							player.PrassUp=false;
							break;
						case player.ContolKey_Down:
							player.PrassDown=false;
							break;
						case player.ContolKey_Left:
							player.PrassLeft=false;
							break;
						case player.ContolKey_Right:
							player.PrassRight=false;
							break;
						case player.ContolKey_Use:
							player.PrassUse=false;
							break;
						case player.ContolKey_Select_Left:
							player.PrassLeftSelect=false;
							break;
						case player.ContolKey_Select_Right:
							player.PrassRightSelect=false;
							break;
					}
					if(
					!player.isPrass_Up&&
					!player.isPrass_Down&&
					!player.isPrass_Left&&
					!player.isPrass_Right&&
					!player.isPrass_Use&&
					!player.isPrass_Select_Left&&
					!player.isPrass_Select_Right)
					{
						player.isKeyDown=false;
					}
				}
			}
		}

		private function EnterWorldTick(E:TimerEvent):void
		{
			//Time Functions
			var TimeDistance:uint=getTimer()-LastTime;
			//Update FPS
			gameFramePerSecond=Math.round(1000/TimeDistance*FPSDir)/FPSDir;
			//=====Random Tick=====//
			if(randomTickSpeed>0&&randomTime>0)
			{
				if(randomTick+TimeDistance>=randomTime)
				{
					randomTick=0
					for(var d=0;d<randomTickSpeed;d++)
					{
						var ranX=random(WorldWidth*2+1)-WorldWidth
						var ranY=random(WorldHeight*2+1)-WorldHeight
						onRandomTick(ranX,ranY,getTileID(ranX,ranY),
									 getTileData(ranX,ranY),getTileTag(ranX,ranY),
									 getTileRot(ranX,ranY),getTileHard(ranX,ranY))
					}
				}
				else
				{
					randomTick+=TimeDistance
				}
			}
			//=====Entity TickRun=====//
			for each(var entity:Entity in this.EntityList)
			{
				if(entity!=null)
				{
					if(entity.hasTickFunction)
					{
						entity.runTickFunction()
					}
				}
			}
			//Reset Timer
			LastTime+=TimeDistance;
		}
		
		intc function onStageResize(E:Event=null):void
		{
			this.ResizeDebugText()
		}
		
		private function ResizeDebugText():void
		{
			//====Rescale Debug Text====//
			if(this.DebugText.visible)
			{
				this.DebugText.width=this.DebugText.textWidth+10
				this.DebugText.height=this.DebugText.textHeight+10
				this.DebugText.x=this.displayOffsetX-this.x
				this.DebugText.y=this.displayOffsetY-this.y
			}
			if(this.DebugText2.visible)
			{
				this.DebugText2.width=this.DebugText2.textWidth+10
				this.DebugText2.height=this.DebugText2.textHeight+10
				this.DebugText2.x=(stage.stageWidth+Game.DISPLAY_WIDTH)/2-this.DebugText2.width-this.x
				this.DebugText2.y=this.displayOffsetY-this.y
			}
			this.UpdateDebugText(2,false)
		}
		
		//================================================//
		//================Player Functions================//
		//================================================//
		intc function PlayerMove(player:Player,Rot:uint,Distance:uint):void
		{
			if(player!=null)
			{
				player.Rot=Rot;
				if(Key.shiftKey) return
				var pX:int=player.getX();
				var pY:int=player.getY();
				var mX:int=player.getX()+MobileRot.toPos(Rot,Distance/TILE_SIZE)[0];
				var mY:int=player.getY()+MobileRot.toPos(Rot,Distance/TILE_SIZE)[1];
				if(testMove(player,mX,mY,pX,pY))
				{
					//Border Test
					borderTest(player)
					//Real Move
					player.MoveByDir(Rot,Distance,false);
					this.UpdateDebugText(2);
				}
				//Push
				else if(isTile(mX,mY)&&getTileTag(mX,mY).pushable&&player.Ability.canPushBlock)
				{
					//Test Push
					var moveX:int=mX+MobileRot.toPos(Rot)[0]
					var moveY:int=mY+MobileRot.toPos(Rot)[1]
					if(isTile(moveX,moveY))
					{
						//TestPush
						if(getTileTag(moveX,moveY).canPass)
						{
							cloneTile(mX,mY,moveX,moveY,"Move&Destroy",getTileHard(mX,mY))
							//Test Again
							if(testMove(player,mX,mY,pX,pY))
							{
								//Border Test
								borderTest(player)
								//Real Move
								player.MoveByDir(Rot,Distance,false);
								this.UpdateDebugText(2);
							}
							//Set After Push
							mX=moveX
							mY=moveY
						}
					}
					onPlayerPushBlock(player,mX,mY,Rot,getTileID(mX,mY),getTileData(mX,mY),getTileTag(mX,mY),getTileRot(mX,mY),getTileHard(mX,mY))
				}
				//Use
				if(isTile(mX,mY)&&getTileTag(mX,mY).canUse&&player.Ability.canUseBlock)
				{
					onPlayerUseBlock(player,mX,mY,Rot,getTileID(mX,mY),getTileData(mX,mY),getTileTag(mX,mY),getTileRot(mX,mY),getTileHard(mX,mY));
				}
			}
		}

		intc function PlayerUse(player:Player,Distance:uint):void
		{
			if(player!=null)
			{
				var Rot=player.getRot();
				var frontX:int=player.getX()+MobileRot.toPos(Rot,Distance/TILE_SIZE)[0];
				var frontY:int=player.getY()+MobileRot.toPos(Rot,Distance/TILE_SIZE)[1];
				var block:Tile=getTileObject(frontX,frontY);
				var blockID:String=getTileID(frontX,frontY);
				var blockData:int=getTileData(frontX,frontY);
				var blockTag:TileTag=getTileTag(frontX,frontY);
				var blockHard:uint=getTileHard(frontX,frontY);
				var blockMaxHard:uint=getTileMaxHard(frontX,frontY);
				var blockRot:int=getTileRot(frontX,frontY);
				var blockDropItems:ItemList=getTileDropItems(frontX,frontY);
				var Destroy:Boolean=true;
				var Place:Boolean=true;
				//Destroy Block
				if(player.Ability.canDestroy&&Destroy||player.Ability.canDestroyAll&&Destroy)
				{
					if(isTile(frontX,frontY))
					{
						if(blockTag.canDestroy||blockID!=TileID.Void&&player.Ability.canDestroyAll)
						{
							if(blockHard>1&&!player.Ability.InstantDestroy)
							{
								destroyBlock(frontX,frontY);
								onPlayerDestroyingBlock(player,frontX,frontY,Rot,blockID,blockData,blockTag,blockRot,blockHard);
							}
							else
							{
								if(!player.isSelectItem||
									player.isSelectItem&&!blockTag.canPlaceBy)
								{
									//Give Items
									if(blockTag.canGet&&!blockTag.technical)
									{
										dropItem(frontX,frontY);
									}
								Place=false;
								}
								//Real Destroy
								setVoid(frontX,frontY);
								//Set Hook
								onPlayerDestroyBlock(player,frontX,frontY,Rot,blockID,blockData,blockTag,blockRot,blockHard);
							}
						}
					}
				}
				//Place Block
				if(player.isSelectItem&&player.Ability.canPlace&&Place)
				{
					var PlaceId:String=player.SelectedItem.Id;
					var PlaceData:int=player.SelectedItem.Data;
					var PlaceTag:TileTag=player.SelectedItem.Tag;
					var PlaceRot:int=PlaceTag.canRotate?MobileRot.toTileRot(player.Rot):0
					//trace(player.SelectedItem.Tag.canPlace,block.Tag.canPlaceBy)
					if(!detectEntity(frontX,frontY)&&block!=null)
					{
						if(player.SelectedItem.Count>0&&
						   PlaceTag.canPlace&&
						   blockTag.canPlaceBy)
						{
							//RemoveItem
							if(!player.Ability.InfinityItem)
							{
								player.removeItem(PlaceId,1,player.SelectedItem.Data,PlaceTag,PlaceRot);
							}
							//Real Place
							setTile(frontX,frontY,PlaceId,PlaceData,PlaceTag,PlaceRot);
							this.UpdateDebugText(2);
							//Set Hook
							onPlayerPlaceBlock(player,frontX,frontY,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot,TileSystem.getHardnessFromID(PlaceId));
						}
						else if(player.SelectedItem.Count>0&&player.Ability.canUseItem)
						{
							//Use Item
							onPlayerUseItem(player,frontX,frontY,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot,TileSystem.getHardnessFromID(PlaceId));
						}
					}
				}
			}
		}

		private function get PlayerCount():uint
		{
			if(PlayerList.length>0)
			{
				return PlayerList.length;
			}
			return 0;
		}

		//================================================//
		//================Entity Functions================//
		//================================================//
		intc function get EntityCount():uint
		{
			if(EntityList.length>0)
			{
				return EntityList.length;
			}
			return 0;
		}

		intc function regEntity(Ent:Entity):void
		{
			this.EntityList.push(Ent)
		}
		
		intc function getEntityIndex(entity:Entity):int
		{
			for(var index in this.EntityList)
			{
				var entity2:Entity=this.EntityList[index]
				if(entity2!=null&&entity.UUID==entity2.UUID)
				{
					return int(index)
				}
			}
			return -1
		}
		
		intc function removeEntity(entity:Entity):void
		{
			if(getEntityIndex(entity)>0)
			{
				this.EntityList.splice(getEntityIndex(entity),1)
			}
		}
		
		private function testMove(Mob:Mobile,tx:int,ty:int,sx:int=0,sy:int=0):Boolean
		{
			var canMove:Boolean=true;
			var isDefineStartPos:Boolean=(arguments.length>3)
			//trace("Tile:",getTileObject(tx,ty).canPass);
			//Test Border
			if(!isTile(tx,ty))
			{
				return false;
			}
			//Test Blocks
			switch(Mob.moveType)
			{
				default:
					if(getTileID(tx,ty)!=TileID.Void&&!getTileTag(tx,ty).canPass)
					{
						canMove=false;
					}
					break;
			}
			//Test Entities
			if(detectEntity(tx,ty))
			{
				canMove=false;
			}
			return canMove;
		}

		private function testEntity(X:int,Y:int):Entity
		{
			for(var i=0;i<this.EntityList.length;i++)
			{
				var ent=this.EntityList[i];
				if(ent!=null)
				{
					if(X==ent.getX()&&Y==ent.getY())
					{
						return ent;
					}
				}
			}
			return null;
		}
		
		intc function detectEntity(X:int,Y:int):Boolean
		{
			if(testEntity(X,Y)!=null&&(testEntity(X,Y) as Entity).hasCollision)
			{
				return true
			}
			return false
		}
		
		intc function summonItem(X:Number,Y:Number,
								 Id:String=TileID.Colored_Block,
								 Count:uint=1,Data:int=0,
								 Tag:TileTag=null,Rot:int=0,
								 xd:Number=NaN,yd:Number=NaN,vr:Number=NaN):TriangleCraft.Entity.Item
		{
			var item:Item=new TriangleCraft.Entity.Item(this,X*TILE_SIZE,
														Y*TILE_SIZE,
														Id,Count,Data,Tag,Rot,xd,yd,vr)
			
			this.Entities_Sprite.addChild(item)
			this.Entities_Sprite.setChildIndex(item,0)
			regEntity(item)
			return item
		}
		
		intc function detectItem(item:TriangleCraft.Entity.Item):void
		{
			//Set Variables
			var itemX:int=snapToGrid(item.x+TILE_SIZE/2)
			var itemY:int=snapToGrid(item.y+TILE_SIZE/2)
			//Dtetct Collision<Unfinished>
			/*
			var lX:int=snapToGrid(item.lastX)
			var lY:int=snapToGrid(item.lastY)
			var nX:int=snapToGrid(item.x)
			var nY:int=snapToGrid(item.y)
			
			var lL:int=snapToGrid(item.lastX-item.Radius)
			var lR:int=snapToGrid(item.lastX+item.Radius)
			var lU:int=snapToGrid(item.lastY-item.Radius)
			var lD:int=snapToGrid(item.lastY+item.Radius)
			var nL:int=snapToGrid(item.x-item.Radius)
			var nR:int=snapToGrid(item.x+item.Radius)
			var nU:int=snapToGrid(item.y-item.Radius)
			var nD:int=snapToGrid(item.y+item.Radius)
			//trace(lL,lR,lU,lD,nL,nR,nU,nD)
			
			var liL:Boolean=getTileTag(lL,lY).canPass
			var liR:Boolean=getTileTag(lR,lY).canPass
			var liU:Boolean=getTileTag(lX,lU).canPass
			var liD:Boolean=getTileTag(lX,lD).canPass
			
			var niL:Boolean=getTileTag(nL,nY).canPass
			var niR:Boolean=getTileTag(nR,nY).canPass
			var niU:Boolean=getTileTag(nX,nU).canPass
			var niD:Boolean=getTileTag(nX,nD).canPass
			//trace(liL,liR,liU,liD,niL,niR,niU,niD)
			
			//Left Right
			if(liL&&!niL||liR&&!niR)
			{
				item.reboundX()
			}
			//Up Down
			if(liU&&!niU||liD&&!niD)
			{
				item.reboundY()
			}
			*/
			//========Detect Pickup========//
			if(item.pickupTime<=0)
			{
				//Detect Players
				for each(var player:Player in this.PlayerList)
				{
					//Detect Distance
					if(General.getDistance(item.x,item.y,player.x,player.y)<item.Radius+player.Radius)
					{
						item.pickupTime=16777216
						player.addItem(item.Id,item.Count,item.Data,item.Tag,item.Rot)
						item.scaleAndMove(player.x,player.y,0,0.1)
					}
				}
				//Detect can-pickup-items Blocks
				if(isTile(itemX,itemY))
				{
					var tile:Tile=getTileObject(itemX,itemY)
					var tileTag:TileTag=tile.Tag
					if(tileTag.hasInventory&&tileTag.canPickupItems)
					{
						item.pickupTime=16777216
						tile.addItem(item.Id,item.Count,item.Data,item.Tag,item.Rot)
						item.scaleAndMove(tile.x,
										tile.y,0,0.1)
					}
				}
			}
		}
		
		private function dropItem(X:int,Y:int):void
		{
			//Set Variables
			var blockItem:InventoryItem=getTileObject(X,Y).invItem
			var blockID:String=getTileID(X,Y);
			var blockData:int=getTileData(X,Y);
			var blockTag:TileTag=getTileTag(X,Y);
			var blockHard:uint=getTileHard(X,Y);
			var blockMaxHard:uint=getTileMaxHard(X,Y);
			var blockRot:int=blockTag.canRotate?getTileRot(X,Y):0;
			var blockDropItems:ItemList=getTileDropItems(X,Y);
			var spawnedItem:Item
			//Drop Items
			if(blockDropItems==null)
			{
				spawnedItem=summonItem(X,Y,blockID,1,blockData,blockTag,0)
				spawnedItem.pickupTime=Game.realTimeToLocalTime(0.05)
				return
			}
			for(var i:uint=0;i<blockDropItems.typeCount;i++)
			{
				var giveItem:InventoryItem=blockDropItems.getItemAt(i)
				var giveId:String=giveItem.Id
				var giveCount:int=giveItem.Count
				var giveData:int=giveItem.Data
				var giveTag:TileTag=giveItem.Tag
				var giveRot:int=giveItem.Rot
				if(giveTag.technical) continue
				if(giveItem.isEqual(blockItem)&&
				   blockTag.resetDataOnDestroy)
				{
					giveData=0
				}
				for(var j:uint=0;j<giveCount;j++)
				{
					spawnedItem=summonItem(X,Y,giveId,giveCount,giveData,giveTag,giveRot);
					spawnedItem.pickupTime=Game.realTimeToLocalTime(0.05)
				}
			}
		}

		//==============================================//
		//================Tile Functions================//
		//==============================================//
		private function setNewTile(X:int=0,Y:int=0,Id:String=TileID.Void,
									Data:int=0,Tag:TileTag=null,Rot:int=0,
									Level:String=TileSystem.Level_Top):Tile
		{
			var tile=new Tile(TileDisplayFrom.IN_GAME,this,X*TILE_SIZE,Y*TILE_SIZE,Id,Data,Tag,Rot,Level);
			this.tileGrid.setTileAt(X,Y,tile,false)
			addTileByLevel(tile)
			return tile;
		}
		
		private function addTileByLevel(tile:Tile):void
		{
			switch(tile.level)
			{
				case TileSystem.Level_Back:
				//trace("addTileByLevel:",TileSystem.Level_Back)
				this.Tile_Sprite_Back.addChild(tile)
				break
				default:
				//trace("addTileByLevel:",TileSystem.Level_Top)
				this.Tile_Sprite_Top.addChild(tile)
				break
			}
		}
		
		private function removeTileByLevel(tile:Tile):void
		{
			switch(tile.level)
			{
				case TileSystem.Level_Back:
				this.Tile_Sprite_Back.removeChild(tile)
				break
				default:
				this.Tile_Sprite_Top.removeChild(tile)
				break
			}
		}
		
		private function removeTile(X:int,Y:int):void
		{
			this.tileGrid.clearTileAt(x,y)
		}
		
		private function removeAllTile():void
		{
			this.tileGrid.clearAllTile()
		}
		
		private function get totalObjTileCount():uint
		{
			return this.tileGrid.allTileCount
		}
		
		//Getters
		intc function getTileObject(X:int,Y:int):Tile
		{
			return this.tileGrid.getTileAt(X,Y)
		}

		intc function isTile(X:int,Y:int):Boolean
		{
			return this.tileGrid.hasTileAt(X,Y)
		}

		intc function isVoid(X:int,Y:int):Boolean
		{
			return !isTile(X,Y)||getTileID(X,Y)==TileID.Void
		}

		intc function getTileID(X:int,Y:int):String
		{
			return isTile(X,Y)?getTileObject(X,Y).ID:null;
		}

		intc function getTileData(X:int,Y:int):int
		{
			return isTile(X,Y)?getTileObject(X,Y).Data:-1;
		}

		intc function getTileTag(X:int,Y:int):TileTag
		{
			return isTile(X,Y)?getTileObject(X,Y).Tag:null;
		}
		
		intc function getTileRot(X:int,Y:int):int
		{
			return isTile(X,Y)?getTileObject(X,Y).Rot:0;
		}
		
		intc function getTileHard(X:int,Y:int):uint
		{
			return isTile(X,Y)?getTileObject(X,Y).Hard:0;
		}
		
		intc function getTileMaxHard(X:int,Y:int):uint
		{
			return isTile(X,Y)?getTileObject(X,Y).MaxHard:0;
		}
		
		intc function getTileDropItems(X:int,Y:int):ItemList
		{
			return isTile(X,Y)?getTileObject(X,Y).DropItems:null;
		}
		
		intc function getTileSignal(X:int,Y:int):uint
		{
			return isTile(X,Y)?getTileObject(X,Y).signalStrenth:null;
		}
		
		//Setters
		intc function setVoid(X:int,Y:int):void
		{
			if(isTile(X,Y))
			{
				setTile(X,Y,TileID.Void,0)
			}
		}
		
		intc function setTileHard(X:int,Y:int,Hard:uint):void
		{
			if(isTile(X,Y))
			{
				var block:Tile=getTileObject(X,Y)
				block.Hard=Hard
			}
		}
		
		intc function setTileRot(X:int,Y:int,Rot:int):void
		{
			if(isTile(X,Y))
			{
				var block=getTileObject(X,Y)
				block.setRotation(Math.min(3,Math.max(Rot%4,-3)))
			}
		}

		intc function setTile(X:int,Y:int,Id:String,Data:int=0,
							  Tag:TileTag=null,Rot:int=0,Hard:uint=0):void
		{
			if(isTile(X,Y))
			{
				var tile:Tile=getTileObject(X,Y);
				var tileOldID:String=tile.ID
				var tileOldData:int=tile.Data
				var tileOldTag:TileTag=tile.Tag
				var tileOldRot:int=tile.Rot
				var tileOldHard:uint=tile.Hard
				var tileOldMaxHard:uint=tile.MaxHard
				if(TileSystem.getHardnessFromID(Id)!=0&&Hard==0)
				{
					tile.changeTile(Id,Data,Tag,Rot);
					tile.returnHardness()
					onTileUpdate(X,Y,tile.ID,tile.Data,tile.Tag,tile.Rot,tile.MaxHard,
								 tileOldID,tileOldData,tileOldTag,tileOldRot,tileOldHard)
				}
				else
				{
					tile.changeTile(Id,Data,Tag,Rot,Hard);
					onTileUpdate(X,Y,tile.ID,tile.Data,tile.Tag,tile.Rot,tile.Hard,
								 tileOldID,tileOldData,tileOldTag,tileOldRot,tileOldHard)
				}
				if(Id!=tileOldID) addTileByLevel(tile)
			}
		}
		
		intc function setTileAsItem(X:int,Y:int,item:*):Boolean
		{
			if(item==null||item==undefined)
			{
				this.setVoid(X,Y)
				return false
			}
			var id:String,data:int,tag:TileTag,rot:int
			if(item is TriangleCraft.Inventory.InventoryItem)
			{
				id=(item as TriangleCraft.Inventory.InventoryItem).Id
				data=(item as TriangleCraft.Inventory.InventoryItem).Data
				tag=(item as TriangleCraft.Inventory.InventoryItem).Tag
				rot=(item as TriangleCraft.Inventory.InventoryItem).Rot
			}
			else if(item is TriangleCraft.Entity.Item)
			{
				id=(item as TriangleCraft.Entity.Item).Id
				data=(item as TriangleCraft.Entity.Item).Data
				tag=(item as TriangleCraft.Entity.Item).Tag
				rot=(item as TriangleCraft.Entity.Item).Rot
			}
			else if(item is TriangleCraft.Tile.TileDisplayObj)
			{
				id=(item as TriangleCraft.Tile.TileDisplayObj).ID
				data=(item as TriangleCraft.Tile.TileDisplayObj).Data
				tag=(item as TriangleCraft.Tile.TileDisplayObj).Tag
				rot=(item as TriangleCraft.Tile.TileDisplayObj).Rot
			}
			else return false
			this.setTile(X,Y,id,data,tag,rot)
			return true
		}
		
		//--------Pro Block Functions--------//
		intc function destroyBlock(X:int,Y:int,destroyHard:uint=1):void
		{
			if(isTile(X,Y)&&destroyHard>0)
			{
				var block:Tile=getTileObject(X,Y)
				if(block.Tag.canDestroy)
				{
					if(getTileHard(X,Y)>destroyHard)
					{
						block.Hard-=destroyHard
					}
					else
					{
						setVoid(X,Y)
					}
				}
			}
		}
		
		intc function cloneTile(x1:int,y1:int,x2:int,y2:int,Mode:String="Replace",Hardness:uint=0):void
		{
			//Detect Pos
			if(!isTile(x1,y1)||!isTile(x2,y2)) return
			//Set Variables
			var oBlock:Tile=getTileObject(x1,y1)
			var oId:String=oBlock.ID
			var oData:int=oBlock.Data
			var oTag:TileTag=oBlock.Tag
			var oRot:int=oBlock.Rot
			var oHard:uint=oBlock.Hard
			var oInventory:ItemList=oBlock.Inventory
			var oDropItems:ItemList=oBlock.DropItems
			var tBlock:Tile=getTileObject(x2,y2)
			var tId:String=tBlock.ID
			var tData:int=tBlock.Data
			var tTag:TileTag=tBlock.Tag
			var tRot:int=tBlock.Rot
			var tHard:uint=tBlock.Hard
			var tInventory:ItemList=tBlock.Inventory
			var tDropItems:ItemList=tBlock.DropItems
			//Clone
			if(General.hasSpellInString("keep",Mode)&&!tTag.canPlaceBy) return
			if(General.hasSpellInString("move",Mode)) setVoid(x1,y1)
			if(General.hasSpellInString("swap",Mode)&&!tTag.canPlaceBy) setTile(x1,y1,tId,tData,tTag,tRot,tHard)
			if(General.hasSpellInString("destroy",Mode)&&!tTag.technical) dropItem(x2,y2)
			setTile(x2,y2,oId,oData,oTag,oRot,oHard)
			//Clone Inventory
			if(oBlock.Tag.hasInventory) tInventory.resetToInventory(oInventory)
			if(General.hasSpellInString("swap",Mode)&&tBlock.Tag.hasInventory) oInventory.resetToInventory(tInventory)
			//Clone DropItems
			tDropItems.resetToInventory(oDropItems)
		}

		//Tile TickRun Functions
		intc function regTickRunTile(x:int,y:int,
									 disableOnIdChange:Boolean=true,
									 disableOnDataChange:Boolean=false):void
		{
			if(hasTickRunTile(x,y)) return
			this.tickRunTiles.push(new TickRunTileInformations(this,x,y,
								   disableOnIdChange,
								   disableOnDataChange))
		}

		intc function hasTickRunTile(x:int,y:int):Boolean
		{
			return getTickRunTileIndex(x,y)>-1
		}

		intc function remTickRunTile(x:int,y:int):void
		{
			if(hasTickRunTile(x,y))
			this.tickRunTiles.splice(getTickRunTileIndex(x,y),1)
		}

		intc function getTickRunTileIndex(x:int,y:int):int
		{
			var p:Point=new Point(x,y)
			for(var i:uint=0;i<this.tickRunTiles.length;i++)
			{
				if(this.tickRunTiles[i].point.equals(p))
				return i
			}
			return -1
		}

		intc function getTickRunTileDisableOnIdChange(x:int,y:int):Boolean
		{
			return this.tickRunTiles[getTickRunTileIndex(x,y)].disableOnIdChange
		}

		intc function getTickRunTileDisableOnDataChange(x:int,y:int):Boolean
		{
			return this.tickRunTiles[getTickRunTileIndex(x,y)].disableOnDataChange
		}

		//Explode
		intc function createExplode(x:int,y:int,radius:uint,
									itemDropChance:Number=1,
									destroyStrenthMax:Number=1,
									destroyStrenthMin:Number=0):void
		{
			trace("createExplode:"+arguments)
			var cx:int,cy:int
			var v1:Number
			var strenth:uint
			var realRadius:Number=radius*Math.SQRT2
			var tag:TileTag
			for(var xd:int=-realRadius;xd<=realRadius;xd++)
			{
				for(var yd:int=-realRadius;yd<=realRadius;yd++)
				{
					if(!isTile(cx,cy)) continue
					cx=x+xd,cy=y+yd
					tag=getTileTag(cx,cy)
					v1=General.NumberBetween(realRadius-General.getDistance(x,y,cx,cy),0,1)//Should In 0~1
					strenth=Math.round(destroyStrenthMin+v1*(destroyStrenthMax-destroyStrenthMin))
					if(tag.canDestroy)
					{
						if(getTileHard(cx,cy)>strenth)
						{
							destroyBlock(cx+xd,cy+yd,strenth)
						}
						else if(!tag.technical&&tag.canGet&&General.randomBoolean2(itemDropChance*(1-v1)))
						{
							dropItem(cx,cy)
						}
					}
				}
			}
		}

		//==============================================//
		//================Hook Functions================//
		//==============================================//
		private function onTileUpdate(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint,
									  oldId:String,oldData:int,oldTag:TileTag,oldRot:int,oldHard:uint):void
		{
			//========Set Variables========//
			var changedId:Boolean=Id!=oldId
			var changedData:Boolean=Data!=oldData
			//=======Call======//
			for(var xd:int=-1;xd<=1;xd++)
			{
				for(var yd:int=-1;yd<=1;yd++)
				{
					if(xd==0&&yd==0||Math.abs(xd)!=Math.abs(yd))
					{
						var x2:int=X+xd
						var y2:int=Y+yd
						if(isTile(x2,y2))
						{
							onNearbyTileUpdate(x2,y2,getTileID(x2,y2),getTileData(x2,y2),getTileTag(x2,y2),getTileRot(x2,y2),getTileHard(x2,y2),
											   X,Y,Id,Data,Tag,Rot,Hard,
											   oldId,oldData,oldTag,oldRot,oldHard)
						}
					}
				}
			}
			//======Disable From Tick Run Tile======//
			if(hasTickRunTile(X,Y))
			{
				if(!Tag.needTickRun||
				  changedId&&getTickRunTileDisableOnIdChange(X,Y)||
				  changedData&&getTickRunTileDisableOnDataChange(X,Y))
				{
					this.remTickRunTile(X,Y)
				}
			}
			//======Set Tick Run Tile======//
			else if(Tag.needTickRun)
			{
				this.regTickRunTile(X,Y)
			}
		}
		
		private function onNearbyTileUpdate(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint,
											nearbyX:int,nearbyY:int,nearbyId:String,nearbyData:int,nearbyTag:TileTag,nearbyRot:int,nearbyHard:uint,
											oldNearbyId:String,oldNearbyData:int,oldNearbyTag:TileTag,oldNearbyRot:int,oldNearbyHard:uint):void
		{
			//Set Variables
			var tile:Tile=getTileObject(X,Y)
			var linkCount:uint=0
			var shouldData:int=0
			switch(Id)
			{
				//Signal_Wire:Link Blocks
				case TileID.Signal_Wire:
				case TileID.Signal_Wire_Active:
					var hasLinkUp:Boolean=hasLink(X,Y,TileRot.UP)
					var hasLinkDown:Boolean=hasLink(X,Y,TileRot.DOWN)
					var hasLinkLeft:Boolean=hasLink(X,Y,TileRot.LEFT)
					var hasLinkRight:Boolean=hasLink(X,Y,TileRot.RIGHT)
					linkCount=uint(hasLinkUp)+uint(hasLinkDown)+uint(hasLinkLeft)+uint(hasLinkRight)
					var shouldRot:uint=TileRot.RIGHT
					switch(linkCount)
					{
						case 0:
							break
						case 1:
							shouldData=1
							if(hasLinkUp) shouldRot=TileRot.UP
							else if(hasLinkDown) shouldRot=TileRot.DOWN
							else if(hasLinkLeft) shouldRot=TileRot.LEFT
							else shouldRot=TileRot.RIGHT
							break
						case 2:
							if(hasLinkUp!=hasLinkDown)
							{
								shouldData=2
								if(hasLinkUp) shouldRot=hasLinkRight?TileRot.RIGHT:TileRot.UP
								else if(hasLinkDown) shouldRot=hasLinkRight?TileRot.DOWN:TileRot.LEFT
							}
							else
							{
								shouldData=3
								if(hasLinkUp&&hasLinkDown) shouldRot=TileRot.DOWN
								else if(hasLinkLeft) shouldRot=TileRot.RIGHT
							}
							break
						case 3:
							shouldData=4
							if(!hasLinkUp) shouldRot=TileRot.DOWN
							else if(!hasLinkDown) shouldRot=TileRot.UP
							else if(!hasLinkLeft) shouldRot=TileRot.RIGHT
							else shouldRot=TileRot.LEFT
							break
						case 4:
							shouldData=5
							break
					}
					tile.changeTile(Id,shouldData,Tag,shouldRot,Hard)
					break;
				//Signal Diode:Link Blocks
				case TileID.Signal_Diode:
				case TileID.Signal_Diode_Active:
					var hasLinkFront:Boolean=hasLink(X,Y,Rot-TileRot.RIGHT)
					var hasLinkBack:Boolean=hasLink(X,Y,Rot-TileRot.LEFT)
					linkCount=uint(hasLinkFront)+uint(hasLinkBack)
					switch(linkCount)
					{
						case 1:
							if(hasLinkFront) shouldData=1
							else shouldData=2
							break
						case 2:
							shouldData=3
							break
					}
					tile.changeTile(Id,shouldData,Tag,Rot,Hard)
					break;
				//Block Update Detector:Detect Block Update
				case TileID.Block_Update_Detector:
					patchSignal(X,Y,1,new <Point>[new Point(nearbyX,nearbyY)])
					break;
			}
		}
		
		private function onPlayerDestroyBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
			//summonItem(X*TILE_SIZE,Y*TILE_SIZE,Id,1,Data,Tag,Rot)
		}
		
		private function onPlayerDestroyingBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
			//summonItem(X*TILE_SIZE,Y*TILE_SIZE,Id,1,Data,Tag,Rot)
		}

		private function onPlayerPlaceBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}
		
		private function onPlayerUseItem(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}

		private function onPlayerUseBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			var block:Tile=getTileObject(X,Y)
			switch(Id)
			{
				//Color Mixer:Mix Color
				case TileID.Color_Mixer:
					colorMixerMixColor(X,Y)
					break;
					//Block Crafter:Craft Blocks
				case TileID.Block_Crafter:
					blockCrafterCraftBlocks(X,Y)
					break;
				//Inventory Block:Input Or Output Items
				case TileID.Inventory_Block:
					if(P.hasInventory)
					{
						switch(Pos)
						{
							//Upload
							case MobileRot.UP:
								inventoryBlockTransPortItem(X,Y,P,"up")
								break
							//Download
							case MobileRot.DOWN:
								inventoryBlockTransPortItem(X,Y,P,"down")
							break
							case MobileRot.LEFT:
							break
							case MobileRot.RIGHT:
							break
						}
					}
					break;
				//Signal Patcher:Patch Signal
				case TileID.Signal_Patcher:
					patchSignal(X,Y,1)
					patchSignal(X,Y,0)
					break;
				case TileID.Signal_Lamp:
					signalLampTrunLight(X,Y,(Data+1)%7)
					break;
				case TileID.Block_Destroyer:
					blockDestroyerDestroyBlock(X,Y,P.getX(),P.getY())
					break;
			}
		}
		
		private function onPlayerPushBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}

		private function onRandomTick(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			if(Tag==null||!Tag.allowRandomTick) return
			var cx:int
			var cy:int
			var xd:int
			var yd:int
			var blockID:String
			var i:uint
			switch(Id)
			{
				//Block Spawner & Walls Spawner
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				for(xd=-2;xd<=2;xd++)
				{
					for(yd=-2;yd<=2;yd++)
					{
						if(xd==0&&yd==0) break;
						cx=X+xd
						cy=Y+yd
						blockID=getTileID(cx,cy)
						if(!isTile(cx,cy)||detectEntity(cx,cy)) break
						if(getTileTag(cx,cy)==null) break
						if(getTileTag(cx,cy).canPlaceBy||
						   TileSystem.isVirus(blockID))//&&getTileData(X+Xl,Y+Yl)>0
						{
							var r:uint=10
							var r2:uint=5
							if(Id==TileID.Block_Spawner&&
							   randomBoolean(1,r2-1))
							{
								spawnRandomColoredBlock(cx,cy)
								return
							}
							else if(Id==TileID.Walls_Spawner&&
									randomBoolean(1,r2*3-1))
							{
								spawnRandomColoredBlock(cx,cy)
								if(randomBoolean(1,4-1))
								{
									setTile(cx,cy,TileID.Crystal_Wall)
								}
								else
								{
									setTile(cx,cy,TileID.Basic_Wall)
								}
								return
							}
						}
					}
				}
				break
				//XX Virus
				case TileID.XX_Virus:
				var successlyInfluence:Boolean=false
				for(var c:uint=1+random(3)+random(2)*(1+random(2));c>0;c--)
				{
					//Repair Self
					if(getTileHard(X,Y)<getTileMaxHard(X,Y))
					{
						setTileHard(X,Y,getTileHard(X,Y)+1)
						return
					}
					//Grow
					if(Data>0)
					{
						setTile(X,Y,Id,Data-1)
						return
					}
					//Influence
					var rd:uint=1+random(2)*(random(4)+1)
					cx=X+random(rd)-random(rd)
					cy=Y+random(rd)-random(rd)
					if(isTile(cx,cy)&&
					   getTileID(cx,cy)!=Id&&
					   !detectEntity(cx,cy))
					{
						successlyInfluence=true
						if(General.getDistance2(X-cx,Y-cy)>=1.125&&
						   getTileTag(cx,cy).canPlaceBy)
						{
							setTile(cx,cy,Id,Data+2+random(2)*(random(2)+1))
						}
						else
						{
							if(getTileHard(cx,cy)>1)
							{
								destroyBlock(cx,cy)
							}
							else if(randomBoolean(1,3-1))
							{
								cloneTile(X,Y,cx,cy)
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
							}
							else if(getTileTag(cx,cy).canPlaceBy)
							{
								setTile(cx,cy,Id,Data+2+random(2)*(random(2)+1))
							}
						}
					}
				}
				if(!successlyInfluence&&random(5)==0)
				{
					setVoid(X,Y)
				}
				break
				//XX Virus Red
				case TileID.XX_Virus_Red:
				for(xd=-1;xd<=1;xd++)
				{
					for(yd=-1;yd<=1;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						if(Math.abs(xd)==Math.abs(yd)) continue;
						blockID=getTileID(cx,cy)
						//Influence
						if(blockID==Id) continue;
						if(blockID!=TileID.Void||
						   detectEntity(cx,cy)||
						   blockID==TileID.Void&&random(128)==0)
						{
							//trace(cx,cy,blockID,getTileHard(cx,cy),getTileMaxHard(cx,cy))
							if(getTileHard(cx,cy)>1)
							{
								destroyBlock(cx,cy)
							}
							else
							{
								cloneTile(X,Y,cx,cy)
							}
						}
					}
				}
				break
				//XX Virus Blue
				case TileID.XX_Virus_Blue:
				for(var C:uint=0;C<9;C++)
				{
					xd=General.random1()
					yd=General.random1()
					cx=X+xd
					cy=Y+yd
					if(!isTile(cx,cy)) continue;
					if(xd==0&&yd==0) continue;
					blockID=getTileID(cx,cy)
					//Recover
					if(blockID==TileID.XX_Virus_Blue)
					{
						if(getTileHard(cx,cy)<getTileMaxHard(cx,cy))
						{
							setTileHard(cx,cy,getTileHard(cx,cy)+1)
						}
					}
					else if(getTileTag(cx,cy).canPlaceBy&&!detectEntity(cx,cy))
					{
						cloneTile(X,Y,cx,cy,"move")
						setTileHard(X,Y,1)
						return
					}
					else
					{
						for(i=0;i<2+random(3);i++)
						{
							if(getTileHard(cx,cy)>1)
							{
								destroyBlock(cx,cy)
							}
							else if(getTileID(cx,cy)==TileID.Colored_Block)
							{
								cloneTile(X,Y,cx,cy)
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
							}
							else
							{
								setVoid(cx,cy)
							}
						}
						return
					}
				}
				break
				//XX Virus Yellow
				case TileID.XX_Virus_Yellow:
				xd=random(3)-1
				yd=random(3)-1
				cx=X+xd
				cy=Y+yd
				if(!isTile(cx,cy)) break;
				if(xd==0&&yd==0) break;
				if(blockID==Id) break;
				if(getTileTag(cx,cy).canPlaceBy)
				{
					cloneTile(X,Y,cx,cy)
				}
				else if(getTileTag(cx,cy).canBeMove)
				{
					cloneTile(X,Y,cx,cy,"swap")
				}
				break
				//XX Virus Green
				case TileID.XX_Virus_Green:
				for(xd=-1;xd<=1;xd++)
				{
					for(yd=-1;yd<=1;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						if(Math.abs(xd)==Math.abs(yd)) continue;
						blockID=getTileID(cx,cy)
						if(blockID==Id) continue;
						if(getTileTag(cx,cy).canBeMove)
						{
							cloneTile(cx,cy,X,Y,"move")
							continue;
						}
					}
				}
				for(xd=-1;xd<=1;xd++)
				{
					for(yd=-1;yd<=1;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						if(Math.abs(xd)==Math.abs(yd)) continue;
						blockID=getTileID(cx,cy)
						//Influence
						if(blockID==Id) continue;
						if(getTileTag(cx,cy).canPlaceBy)
						{
							cloneTile(X,Y,cx,cy)
							continue;
						}
					}
				}
				break
				//XX Virus White
				case TileID.XX_Virus_White:
				if(Hard>0)
				{
					this.destroyBlock(X,Y)
					break
				}
				for(xd=-2;xd<=2;xd++)
				{
					for(yd=-2;yd<=2;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						blockID=getTileID(cx,cy)
						if(blockID==Id) continue;
						//Influence
						if(isVoid(cx,cy)&&Math.abs(xd)==2&&Math.abs(yd)==2&&
						   General.randomBoolean())
						{
							if(getTileTag(cx,cy).canPlaceBy)
							{
								setTile(cx,cy,TileID.XX_Virus_White)
							}
						}
						//Transform
						else if(Math.abs(xd)==2||Math.abs(yd)==2)
						{
							if(blockID==TileID.Colored_Block)
							{
								switch(getTileData(cx,cy))
								{
									case 0x888888:
									setTile(cx,cy,TileID.XX_Virus)
									break
									case 0xff0000:
									setTile(cx,cy,TileID.XX_Virus_Red)
									break
									case 0x00ff00:
									setTile(cx,cy,TileID.XX_Virus_Green)
									break
									case 0x0000ff:
									setTile(cx,cy,TileID.XX_Virus_Blue)
									break
									case 0xffff00:
									setTile(cx,cy,TileID.XX_Virus_Yellow)
									break
									case 0x000000:
									setTile(cx,cy,TileID.XX_Virus_Black)
									break
									case 0xffffff:
									setTile(cx,cy,TileID.XX_Virus_White)
									break
								}
							}
						}
					}
				}
				break
				//XX Virus Black
				case TileID.XX_Virus_Black:
				//Influence
				for(xd=-1;xd<=1;xd++)
				{
					for(yd=-1;yd<=1;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						if(Math.abs(xd)==Math.abs(yd)) continue;
						blockID=getTileID(cx,cy)
						if(getTileTag(cx,cy).canPlaceBy)
						{
							cloneTile(X,Y,cx,cy)
						}
						else if(getTileMaxHard(cx,cy)<getTileMaxHard(X,Y))
						{
							if(getTileHard(cx,cy)>4)
							{
								destroyBlock(cx,cy,5)
							}
							else
							{
								cloneTile(X,Y,cx,cy)
							}
						}
					}
				}
				//Move
				for(xd=-1;xd<=1;xd++)
				{
					for(yd=-1;yd<=1;yd++)
					{
						cx=X+xd
						cy=Y+yd
						if(!isTile(cx,cy)) continue;
						if(Math.abs(xd)==Math.abs(yd)) continue;
						blockID=getTileID(cx,cy)
						if(!getTileTag(cx,cy).canPlaceBy&&getTileTag(X-xd,Y-yd).canPlaceBy)
						{
							cloneTile(X,Y,X-xd,Y-yd,"move")
							break
						}
					}
				}
				break
				//XX Virus Purple
				case TileID.XX_Virus_Purple:
				for(i=0;i<64&&isTile(cx,cy)&&blockID!=Id;i++)
				{
					cx=X+random(20)*General.random1()
					cy=Y+random(20)*General.random1()
					blockID=getTileID(cx,cy)
				}
				if(TileSystem.isVirus(blockID))
				{
					cloneTile(X,Y,cx,cy,"destroy")
					createExplode(cx,cy,4,0.1,2,1)
				}
				else
				{
					cloneTile(X,Y,cx,cy,"move&destroy")
				}
				break
				//Crystal Wall
				case TileID.Crystal_Wall:
				if(isTile(X,Y))
				{
					if(getTileHard(X,Y)<getTileMaxHard(X,Y))
					{
						setTileHard(X,Y,getTileHard(X,Y)+1)
						return
					}
					else
					{
						//Repair Other
						for(xd=-1;xd<=1;xd++)
						{
							for(yd=-1;yd<=1;yd++)
							{
								cx=X+xd
								cy=Y+yd
								if(xd*yd==0&&isTile(cx,cy))
								{
									var TI:String=getTileID(cx,cy)
									if(TI==TileID.Crystal_Wall||
									   TI==TileID.Basic_Wall||
									   TI==TileID.Block_Crafter||
									   TI==TileID.Color_Mixer||
									   TI==TileID.Arrow_Block)
									{
										if(getTileHard(cx,cy)<getTileMaxHard(cx,cy))
										{
											setTileHard(cx,cy,getTileHard(cx,cy)+1)
										}
									}
								}
								
							}
						}
					}
				}
				break
				//Random Tick Signal Generater
				case TileID.Random_Tick_Signal_Generater:
				patchSignal(X,Y,1)
				patchSignal(X,Y,0)
				break
			}
		}
		
		//======================================//
		//============Block Methodss============//
		//======================================//
		//Color Mixer
		private function colorMixerMixColor(X:int,Y:int):void
		{
			var MixBlocks:Vector.<Tile>=getCanMixBlocks(X,Y);
			var BlockColors:Vector.<uint>=new Vector.<uint>;
			for each(var tile:Tile in MixBlocks)
			{
				BlockColors.push(tile.Data)
			}
			var colorCount:uint=BlockColors.length
			//====HSV====//
			var BlockColorsH:Vector.<Number>=new Vector.<Number>;
			var BlockColorsS:Vector.<Number>=new Vector.<Number>;
			var BlockColorsV:Vector.<Number>=new Vector.<Number>;
			for each(var color:uint in BlockColors)
			{
				//trace(color,Color.HEXtoHSV(color))
				BlockColorsH.push(Color.HEXtoHSV(color)[0]);
				BlockColorsS.push(Color.HEXtoHSV(color)[1]);
				BlockColorsV.push(Color.HEXtoHSV(color)[2]);
			}
			var notNaNColorCount:uint=BlockColorsH.filter(function(N:Number,i:uint,V:Vector.<Number>):Boolean{return !isNaN(N)},null).length
			var notRedColors:Vector.<Number>=BlockColorsH.filter(function(N:Number,i:uint,V:Vector.<Number>):Boolean{return (!isNaN(N)&&N%360!=0)},null)
			var redColorCount:uint=BlockColorsH.filter(function(N:Number,i:uint,V:Vector.<Number>):Boolean{return (!isNaN(N)&&N%360==0)},null).length
			var sumNotRedColorH:uint=General.getSum2(notRedColors);
			var averageNotRedColorH:uint=sumNotRedColorH/(notNaNColorCount-redColorCount)
			var redH:uint=averageNotRedColorH<=180?0:360
			var AverageColorH:Number=(sumNotRedColorH+redColorCount*redH)/notNaNColorCount
			var AverageColorS:Number=General.getAverage2(BlockColorsS);
			var AverageColorV:Number=General.getAverage2(BlockColorsV);
			var AverageColor:uint=Color.HSVtoHEX(AverageColorH,AverageColorS,AverageColorV);
			for each(var t:Tile in MixBlocks)
			{
				var tX=t.TileX;
				var tY=t.TileY;
				var tI=t.ID;
				var tT=t.Tag;
				setTile(tX,tY,tI,AverageColor,tT);
			}
		}
		
		private function getCanMixBlocks(X,Y,pastVec:Vector.<String>=null):Vector.<Tile>
		{
			var returnVec:Vector.<Tile>=new Vector.<Tile>;
			if(!isTile(X,Y)) return returnVec
			var nowBlock:Tile=getTileObject(X,Y);
			var Str:String=String(X)+"_"+String(Y);
			var memoryVec:Vector.<String>=pastVec!=null?pastVec:new Vector.<String>;
			if(memoryVec.indexOf(Str)>=0)return returnVec;
			memoryVec.push(Str);
			switch(nowBlock.ID)
			{
				case TileID.Colored_Block:
					returnVec.push(nowBlock);
				break;
				case TileID.Color_Mixer:
					returnVec=returnVec.concat(getCanMixBlocks(X+1,Y,memoryVec));
					returnVec=returnVec.concat(getCanMixBlocks(X-1,Y,memoryVec));
					returnVec=returnVec.concat(getCanMixBlocks(X,Y+1,memoryVec));
					returnVec=returnVec.concat(getCanMixBlocks(X,Y-1,memoryVec));
				break;
			}
			return returnVec;
		}
		
		//Block Crafter
		private function blockCrafterCraftBlocks(X:int,Y:int):void
		{
			var Slot:Vector.<InventoryItem>=new Vector.<InventoryItem>;
			var canCraft:Boolean=true
			var offsetX:int=-2,offsetY:int=0;
			//Set Var
			var inputX:int,inputY:int,returnX:int,returnY:int
			for(var Yp:int=-1;Yp<=1&&canCraft;Yp++)
			{
				for(var Xp:int=-1;Xp<=1&&canCraft;Xp++)
				{
					//Set XY
					inputX=X+offsetX+Xp
					inputY=Y+offsetY+Yp
					//Detect
					if(!isTile(inputX,inputY))
					{
						canCraft=false
						continue;
					}
					//Push Tile
					var SlotObj:Tile=getTileObject(inputX,inputY)
					Slot.push(SlotObj.invItem)
				}
			}
			if(!canCraft) return
			for each(var CR:CraftRecipe in Craft_Recipes)
			{
				canCraft=testCanCraft(Slot,CR)
				if(!canCraft) continue
				var successfulCraft:Boolean=false
				for(Yp=-1;Yp<=1;Yp++)
				{
					for(Xp=-1;Xp<=1;Xp++)
					{
						//Set XY
						inputX=X+offsetX+Xp
						inputY=Y+offsetY+Yp
						returnX=X-offsetX+Xp
						returnY=Y-offsetY+Yp
						//Return And Place Block
						var returnLoc:uint=(Yp+1)*3+(Xp+1)
						var returnId:String=CR.getOutputID(returnLoc);
						var returnCount:uint=CR.getOutputCount(returnLoc);
						var returnData:int=CR.getOutputData(returnLoc);
						var returnTag:TileTag=CR.getOutputTag(returnLoc);
						var returnRot:int=CR.getOutputRot(returnLoc);
						if(TileSystem.isAllowID(returnId))
						{
							//Test Return Type
							if(CR.returnAsItem)
							{
								//Clear Input
								setVoid(inputX,inputY);
								//SpawnItem
								if(returnId!=TileID.Void)
								{
									var returnItem:Item=summonItem(X+0.5,Y,returnId,returnCount,returnData,
																   returnTag,returnRot,TILE_SIZE*1.5)
									returnItem.pickupTime=Game.realTimeToLocalTime(0.05)
								}
								//Set Craft
								successfulCraft=true
							}
							else
							{
								//Detect Output Tiles
								if(!isTile(returnX,returnY))
								{
									canCraft=false
								}
								var OutId:String=getTileID(returnX,returnY);
								var OutData:uint=getTileData(returnX,returnY);
								var OutTag:TileTag=getTileTag(returnX,returnY);
								if(!OutTag.canPlaceBy||detectEntity(returnX,returnY))
								{
									canCraft=false
								}
								//Set Output Tile
								if(canCraft)
								{
									//Clean Input And Output
									setVoid(inputX,inputY);
									setVoid(returnX,returnY)
									setTile(returnX,returnY,returnId,returnData,returnTag,returnRot);
									//Set Craft
									successfulCraft=true
								}
							}
						}
					}
				}
				if(successfulCraft) return
			}
		}

		private function testCanCraft(Input:Vector.<InventoryItem>,Pattern:CraftRecipe):Boolean
		{
			return Pattern.testCanCraft(Input)
		}
		
		//Block Spawner
		private function spawnRandomColoredBlock(X:int,Y:int)
		{
			var _data:int=0x000000
			switch(random(8)-1)
			{
				case -1:
				_data=0x000000
				break
				case 8:
				_data=0x888888
				break
				case 1:
				_data=0xff0000
				break
				case 2:
				_data=0x00ff00
				break
				case 3:
				_data=0x0000ff
				break
				case 4:
				_data=0xffff00
				break
				case 5:
				_data=0xff00ff
				break
				case 6:
				_data=0x00ffff
				break
			}
			setTile(X,Y,TileID.Colored_Block,_data)
		}
		
		//Inventory Block
		private function inventoryBlockTransPortItem(X:int,Y:int,IL:IhasInventory,Mode:String):void
		{
			//Set Give Item
			var block:Tile=getTileObject(X,Y)
			var giveItem:InventoryItem
			//Give To ItemList
			switch(Mode.toLowerCase())
			{
				case "up":
				giveItem=IL.Inventory is ItemInventory?(IL.Inventory as ItemInventory).selectItem:IL.Inventory.lastItem
				if(giveItem!=null)
				{
					IL.Inventory.giveItemto(block.Inventory,giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
					if(IL is Player)
					{
						(IL as Player).UpdateItemRevealed()
					}
					block.initDropItem()
				}
				break;
				case "down":
				//Not Give,Spawn Item
				giveItem=block.Inventory.lastItem
				if(giveItem!=null)
				{
					block.Inventory.removeItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
					var returnItem:Item=summonItem(X,Y+0.5,giveItem.Id,1,giveItem.Data,
												   giveItem.Tag,giveItem.Rot,NaN,TILE_SIZE*1.5)
					returnItem.pickupTime=Game.realTimeToLocalTime(0.2)
					block.initDropItem()
				}
				break;
			}
		}
		
		//Signal Lamp
		private function signalLampTrunLight(x:int,y:int,data:int=-1):void
		{
			if(!isTile(x,y)||getTileID(x,y)!=TileID.Signal_Lamp) return
			var tempData:int=0
			if(data>0) tempData=data
			if(data==-1)
			{
				switch(getTileData(x,y))
				{
					case 0://Off
					tempData=General.randomBetween(1,7)
					break
					default:
					tempData=0
					break
				}
			}
			else if(data==-2) tempData=General.randomBetween(0,7)
			setTile(x,y,TileID.Signal_Lamp,tempData,getTileTag(x,y),getTileRot(x,y),getTileHard(x,y))
		}

		//Block Destroyer
		private function blockDestroyerDestroyBlock(x:int,y:int,pushX:int,pushY:int):void 
		{
			if(!isTile(x,y)) return
			var rot:uint=getTileRot(x,y)
			var vx:int=TileRot.toPos(rot)[0],vy:int=TileRot.toPos(rot)[1]
			var cx:int=x+vx,cy:int=y+vy
			if(getTileHard(cx,cy)>1)
			{
				destroyBlock(cx,cy)
			}
			/*else if(x-pushX==vx&&y-pushY==vy)//Back Push
			{
				cloneTile(x,y,cx,cy,"move&destroy")
			}*/
			else if(!getTileTag(cx,cy).technical)
			{
				dropItem(cx,cy)
				setVoid(cx,cy)
			}
		}
		
		//=============================================//
		//================Signal System================//
		//=============================================//
		intc function hasLink(x:int,y:int,rot:uint=TileRot.RIGHT):Boolean
		{
			var vx:int=x+TileRot.toPos(rot,1)[0],vy:int=y+TileRot.toPos(rot,1)[1]
			return isTile(vx,vy)?(General.binaryToBooleans(getTileTag(x,y).canBeLink,4)[(rot-getTileRot(x,y)+6)%4]&&
								  General.binaryToBooleans(getTileTag(vx,vy).canBeLink,4)[(rot-getTileRot(vx,vy)+6)%4]):false
		}
		
		intc function hasInMemory(memory:Vector.<Point>,x:*,y:*=null):Boolean
		{
			//Test Type
			var testPoint:Point
			if(x is int&&y is int)testPoint=new Point(x,y)
			else if(x is flash.geom.Point)testPoint=x
			else if(y is flash.geom.Point)testPoint=y
			else return false
			//Test Memory//
			if(memory==null||memory.length<1)return false
			return memory.some(function(p2:Point,index:uint,vec:Vector.<Point>):Boolean
										{
											return testPoint.equals(p2)
										})
		}
		
		intc function getLinkedPoses(x:int,y:int):Vector.<Point>
		{
			var returnVec:Vector.<Point>=new Vector.<Point>
			if(!isTile(x,y)) return returnVec
			//Check Link
			for(var i:uint=0;i<=4;i++)
			{
				var cx:int=x+TileRot.toPos(i,1)[0],cy:int=y+TileRot.toPos(i,1)[1]
				if(!isTile(cx,cy)) continue;
				if(hasLink(x,y,i))
				{
					returnVec.push(new Point(cx,cy))
				}
			}
			return returnVec
		}
		
		intc function getLinkedBlocks(x:int,y:int):Vector.<Tile>
		{
			var returnVec:Vector.<Tile>=new Vector.<Tile>
			if(!isTile(x,y)) return returnVec
			//Check Link
			for(var i:uint=0;i<=4;i++)
			{
				var cx:int=x+TileRot.toPos(i,1)[0],cy:int=y+TileRot.toPos(i,1)[1]
				if(!isTile(cx,cy)) continue;
				if(hasLink(x,y,i))
				{
					returnVec.push(getTileObject(cx,cy))
				}
			}
			return returnVec
		}
		
		intc function patchSignal(x:int,y:int,strenth:uint,memory:Vector.<Point>=null):void
		{
			//Conditions
			if(!isTile(x,y)) return
			//Set Variables
			var linkedPoses:Vector.<Point>=getLinkedPoses(x,y)
			var memoryBlocks:Vector.<Point>=memory==null?new Vector.<Point>:memory
			//Add Self To Memory
			memoryBlocks.push(new Point(x,y))
			//Patch
			patchLoop:for each(var p:Point in linkedPoses)
			{
				trace("signal patched to",x+","+p.y,"tileID="+getTileID(x,p.y),"mem:",hasInMemory(memoryBlocks,p))
				//Filter
				if(!isTile(x,p.y)||hasInMemory(memoryBlocks,p)) continue patchLoop
				//Set In Memory
				memoryBlocks.push(new Point(x,p.y))
				//Real Signal
				onSignalUpdate(x,p.y,x,y,strenth,memoryBlocks)
			}
		}

		intc function patchWirelessSignal(x:int,y:int,strenth:uint,rot:uint,memory:Vector.<Point>=null):void
		{
			//Set Variables
			var vx:int=TileRot.toPos(rot)[0],vy:int=TileRot.toPos(rot)[1]
			var cx:int=x,cy:int=y
			var memoryBlocks:Vector.<Point>=memory==null?new Vector.<Point>:memory
			for(var i:uint=0;i<maxWirelessSignalTransmissionDistance;i++)
			{
				//Set Variables
				cx+=vx
				cy+=vy
				if(!isTile(cx,cy)) continue
				trace("patchWirelessSignal:",vx,vy,cx,cy,getTileID(cx,cy),getTileRot(cx,cy),(rot+2)%4)
				if(!getTileTag(cx,cy).canPass)
				{
					if(getTileID(cx,cy)==TileID.Wireless_Signal_Transmitter)
					{
						if(getTileRot(cx,cy)==(rot+2)%4)//Opposite
						{
							patchSignal(cx,cy,strenth,memoryBlocks)
							break
						}
						else
						{
							patchWirelessSignal(cx,cy,strenth,getTileRot(cx,cy),memoryBlocks)
							break
						}
					}
				}
			}
		}

		intc function onSignalUpdate(x:int,y:int,lastX:int,lastY:int,newStrenth:uint,memory:Vector.<Point>):void
		{
			var block:Tile=getTileObject(x,y)
			//Transform
			switch(block.ID)
			{
				case TileID.Signal_Wire:
					if(newStrenth>0) block.ID=TileID.Signal_Wire_Active
					break
				case TileID.Signal_Wire_Active:
					if(newStrenth==0) block.ID=TileID.Signal_Wire
					break
				case TileID.Signal_Diode:
					if(newStrenth>0) block.ID=TileID.Signal_Diode_Active
					break
				case TileID.Signal_Diode_Active:
					if(newStrenth==0) block.ID=TileID.Signal_Diode
					break
			}
			//Trinsmisson
			switch(block.ID)
			{
				//Transmitter
				case TileID.Signal_Wire:
				case TileID.Signal_Wire_Active:
					patchSignal(x,y,newStrenth,memory)
					break;
				case TileID.Signal_Diode:
				case TileID.Signal_Diode_Active:
					if(new Point(x-lastX,y-lastY).equals(TileRot.toPosPoint(getTileRot(x,y))))
					{
						patchSignal(x,y,newStrenth,memory)
					}
				case TileID.Wireless_Signal_Transmitter:
					patchWirelessSignal(x,y,newStrenth,block.Rot,memory)
					break;
			}
			var tileSignalX:uint=newStrenth-getTileSignal(x,y)
			if(tileSignalX>0) onSignalToUpper(x,y,lastX,lastY,newStrenth,memory)
			if(tileSignalX<0) onSignalToLower(x,y,lastX,lastY,newStrenth,memory)
			block.signalStrenth=newStrenth
		}

		intc function onSignalToUpper(x:int,y:int,lastX:int,lastY:int,newStrenth:uint,memory:Vector.<Point>):void
		{
			var block:Tile=getTileObject(x,y)
			switch(block.ID)
			{
				//Use-Signal Machine
				case TileID.Color_Mixer:
					colorMixerMixColor(x,y)
					break;
				case TileID.Block_Crafter:
					blockCrafterCraftBlocks(x,y)
					break;
				case TileID.Inventory_Block:
					inventoryBlockTransPortItem(x,y,null,"down")
					break;
				case TileID.Signal_Lamp:
					signalLampTrunLight(x,y)
					break;
				case TileID.Block_Destroyer:
					blockDestroyerDestroyBlock(x,y,lastX,lastY)
					break
			}
		}

		intc function onSignalToLower(x:int,y:int,lastX:int,lastY:int,newStrenth:uint,memory:Vector.<Point>):void
		{
			
		}

		//================================================//
		//============Other Instance Functions============//
		//================================================//
		public function get gameFPS():uint
		{
			return this.gameFramePerSecond;
		}
		
		private function onFPSUpdate(E:TimerEvent):void
		{
			this.UpdateDebugText(1);
		}
		
		intc function UpdateDebugText(textNum:int=0,Resize:Boolean=true):void
		{
			if(textNum<0)
			{
				switch(textNum)
				{
					case -1:
					this.DebugText.visible=!this.DebugText.visible
					break
					case -2:
					this.DebugText2.visible=!this.DebugText2.visible
					break
					case -3:
					this.DebugText.visible=!this.DebugText.visible
					this.DebugText2.visible=!this.DebugText2.visible
					break
					case -4:
					this.DebugText.visible=true
					this.DebugText2.visible=true
					break
					case -5:
					this.DebugText.visible=false
					this.DebugText2.visible=false
					break
				}
			}
			else
			{
				if(this.DebugText.visible)
				{
					if(textNum==1||textNum<1)
					{
						var DTT:String="";
						DTT+=GAME_NAME+" "+VERSION;
						DTT+="\n"+gameFPS+" FPS";
						DTT+="\n\nWorldSpawnMode="+WorldSpawnMode;
						DTT+="\nWorldSeed="+WorldSeed+"\nWorldSpawnConditions="+WorldSpawnConditions.toString(2);
						DTT+="\nV1="+V1+",V2="+V2+",V3="+V3+",V4="+V4;
						DTT+="\nWorldWidth="+(WorldWidth*2+1)+",WorldHeight="+(WorldHeight*2+1);
						DTT+="\n"+General.NTP(totalLoadTiles/ShouldLoadTiles)+" tiles loaded";
						DTT+="\ndefaultPlayerGameMode="+defaultPlayerGameMode+"\nVirusMode="+VirusMode;
						DTT+="\n"+virusCount+" virus generated in this world";
						DTT+="\n"+StructureGenerateCount+" structure generated in this world"
						DTT+="\n\nLastKeyCode="+LastKey;
						DTT+="\nstageWidth="+stage.stageWidth+",stageHeight="+stage.stageHeight
						DTT+="\nZoomX="+General.NTP(General.$(this.zoomScaleX),2)+",ZoomY="+General.NTP(General.$(this.zoomScaleY),2);
						this.DebugText.text=DTT;
					}
				}
				if(this.DebugText2.visible)
				{
					if(textNum==2||textNum<1)
					{
							var DT2T:String="";
						for(var i=1;i<=PlayerCount;i++)
						{
							var P:Player=this.PlayerList[i-1] as Player;
							if(P!=null)
							{
								if(PlayerCount>1)
								{
									DT2T+="<Player id="+i+">\n";
								}
								DT2T+=P.traceSelectedItem(false,false);
								DT2T+="\nX="+P.getX()+" Y="+P.getY();
								DT2T+="\nTotal Item Count="+P.AllItemCount;
								if(PlayerCount>1)
								{
									DT2T+="\n<Player>";
								}
								if(i<PlayerCount)
								{
									DT2T+="\n\n";
								}
							}
						}
						this.DebugText2.text=DT2T;
					}
				}
			}
			if(Resize) this.ResizeDebugText()
		}

		intc function CleanDebugText(textNum:uint=0):void
		{
			if(textNum==1||textNum<1)
			{
				this.DebugText.text="";
			}
			if(textNum==2||textNum<1)
			{
				this.DebugText2.text="";
			}
		}
	}
}

/*===================================
==========Class:Load Screen==========
===================================*/

//TriangleCraft
import TriangleCraft.Game;
import TriangleCraft.Common.*
use namespace intc

//Flash
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.Event;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Graphics;

class LoadScreen extends Sprite
{
	//==========Static Variables==========//
	private static const BACKGROUND_COLOR:uint=0xbbbbbb
	private static const BACKGROUND_ALPHA:Number=50/100
	
	private static const DEFAULT_TEXT:String="TriangleCraft.Common.MainFont"
	private static const DEFAULT_TEXT_SIZE_TITLE:uint=64
	private static const DEFAULT_TEXT_SIZE_PERCENT:uint=32
	private static const DEFAULT_TEXT_COLOR_TITLE:uint=0x666666
	private static const DEFAULT_TEXT_COLOR_PERCENT:uint=0x666666
	private static const DEFAULT_TEXT_FORMAT_TITLE:TextFormat=new TextFormat(DEFAULT_TEXT,
																			 DEFAULT_TEXT_SIZE_TITLE,
																			 DEFAULT_TEXT_COLOR_TITLE,
																			 true,false,false,null,null,
																			 TextFormatAlign.CENTER)
	private static const DEFAULT_TEXT_FORMAT_PERCENT:TextFormat=new TextFormat(DEFAULT_TEXT,
																			   DEFAULT_TEXT_SIZE_PERCENT,
																			   DEFAULT_TEXT_COLOR_PERCENT,
																			   false,false,false,null,null,
																			   TextFormatAlign.CENTER)
	
	
	//==========Instance Variables==========//
	private var titleText:TextField
	private var percentText:TextField
	private var _shape:Shape
	private var _autoSize:Boolean=true
	private var _loadElement:String=new String()
	
	//Init
	public function LoadScreen()
	{
		this.addEventListener(Event.ADDED_TO_STAGE,init)
	}
	
	private function init(Eve:Event=null):void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE,init)
		this.titleText=new TextField()
		this.percentText=new TextField()
		this._shape=new Shape()
		
		Game.initText(this.titleText,this.percentText)
		this.titleText.defaultTextFormat=DEFAULT_TEXT_FORMAT_TITLE
		this.percentText.defaultTextFormat=DEFAULT_TEXT_FORMAT_PERCENT
		this.title="Loading..."
		this.percent=0
		
		addChilds()
		onStageResize()
		this.show()
	}
	
	private function addChilds():void
	{
		this.addChild(this._shape)
		this.addChild(this.percentText)
		this.addChild(this.titleText)
	}
	
	//Display Getters
	private function get stageRect():Rectangle
	{
		return Game.getStageRect(this)
	}
	
	private function get topLeftX():Number
	{
		return this.globalToLocal(this.stageRect.topLeft).x
	}
	
	private function get topLeftY():Number
	{
		return this.globalToLocal(this.stageRect.topLeft).y
	}
	
	private function get TITLE_TOP():Number
	{
		return this.topLeftY+this.stage.stageHeight/5
	}
	
	private function get TEXT_DISTANCE():Number
	{
		return 32
	}
	
	//Draw
	private function drawBackGround():void
	{
		var grap:Graphics=this._shape.graphics
		var drawX:Number=this._shape.x+topLeftX
		var drawY:Number=this._shape.y+topLeftY
		grap.clear()
		grap.lineStyle(0,LoadScreen.BACKGROUND_COLOR,0)
		grap.beginFill(LoadScreen.BACKGROUND_COLOR,LoadScreen.BACKGROUND_ALPHA)
		grap.drawRect(drawX,drawY,this.stage.stageWidth,this.stage.stageHeight)
		grap.endFill()
	}
	
	//Text
	public function get title():String
	{
		return this.titleText.text
	}
	public function set title(t:String):void
	{
		this.titleText.text=t
	}
	
	public function set percent(p:Number):void
	{
		this.percentText.text=_loadElement+General.NTP(p)
	}
	
	public function get element():String
	{
		return this._loadElement
	}
	
	public function set element(ele:String):void
	{
		this._loadElement=ele
	}
	
	private function initTextPos():void
	{
		this.titleText.x=this.topLeftX
		this.titleText.y=TITLE_TOP
		this.titleText.width=this.stage.stageWidth
		this.titleText.height=this.titleText.textHeight+10
		
		this.percentText.width=this.stage.stageWidth
		this.percentText.height=this.percentText.textHeight+6
		this.percentText.x=this.topLeftX
		this.percentText.y=TITLE_TOP+this.titleText.height+TEXT_DISTANCE
	}
	
	//AutoSize
	public function get autoSize():Boolean
	{
		return this._autoSize
	}
	
	public function set autoSize(boo:Boolean):void
	{
		this._autoSize=boo
		if(boo) this.stage.addEventListener(Event.RESIZE,this.onStageResize)
		else this.stage.removeEventListener(Event.RESIZE,this.onStageResize)
	}
	
	//OnResize
	private function onStageResize(E:Event=null):void
	{
		this.drawBackGround()
		this.initTextPos()
		if(this.parent is TriangleCraft.Game)
		{
			(this.parent as TriangleCraft.Game).onStageResize(null)
		}
	}
	
	//show and deShow
	public function show():void
	{
		this.autoSize=true
		this.visible=true
		onStageResize()
	}
	public function deShow():void
	{
		this.autoSize=false
		this.visible=false
	}
}

class TickRunTileInformations
{
	protected var _host:Game
	protected var _x:int
	protected var _y:int
	protected var _disableOnIdChange:Boolean=true
	protected var _disableOnDataChange:Boolean=false

	public function TickRunTileInformations(host:Game,x:int,y:int,
											disableOnIdChange:Boolean,
											disableOnDataChange:Boolean):void
	{
		this.host=host
		this.x=x
		this.y=y
		this.disableOnIdChange=disableOnIdChange
		this.disableOnDataChange=disableOnDataChange
	}
	
	public function get host():Game
	{
		return _host;
	}
	
	public function set host(value:Game):void
	{
		this._host=value;
	}
	
	public function get x():int 
	{
		return _x;
	}
	
	public function set x(value:int):void
	{
		this._x=value;
	}
	
	public function get y():int 
	{
		return _y;
	}
	
	public function set y(value:int):void
	{
		this._y=value;
	}
	
	public function get point():Point
	{
		return new Point(this._x,this._y)
	}
	
	public function set point(value:Point):void
	{
		this._x=value.x
		this._y=value.y
	}
	
	public function get disableOnIdChange():Boolean
	{
		return _disableOnIdChange;
	}
	
	public function set disableOnIdChange(value:Boolean):void
	{
		this._disableOnIdChange=value;
	}
	
	public function get disableOnDataChange():Boolean
	{
		return _disableOnDataChange;
	}
	
	public function set disableOnDataChange(value:Boolean):void
	{
		this._disableOnDataChange=value;
	}
}