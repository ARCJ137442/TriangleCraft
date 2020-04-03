package TriangleCraft
{
	//TriangleCraft:Import All
	import TriangleCraft.*;
	import TriangleCraft.Inventory.CraftRecipe;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Player.*;
	import TriangleCraft.Entity.*;
	import TriangleCraft.Entity.Mobile.*;
	import TriangleCraft.Tile.*;
	import TriangleCraft.Structure.*;
	import TriangleCraft.Structure.Structures.*;
	import TriangleCraft.Common.*;
	use namespace intc

	//Flash
	import flash.display.*;
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
		public static const VERSION:String="Alpha 0.1.5 build 6";

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
		protected var _active:Boolean=true

		//Game Loading
		protected var loadingScreen:LoadScreen=new LoadScreen();
		protected var gameLoadingTimer:Timer=new Timer(1);
		protected var _loadingEvent:Function;
		protected var _loadCompleteEvent:Function;
		protected var loadTileX:int;
		protected var loadTileY:int;
		protected var cacheInt:int;
		protected var loadRandomGenerator:RandomGenerator
		protected var tileLoadingSpeed:uint=10;
		protected var nextGameVariables:GameVariables

		//Display
		intc var zoomScaleX:Number=1;
		intc var zoomScaleY:Number=1;
		intc var borderWidth:uint=3;
		intc var borderHeight:uint=3;

		//World Spawn
		protected var V1:int,V2:int,V3:int,V4:int,V5:int;
		protected var virusCount:uint=0;
		protected var totalLoadTiles:uint=0;
		protected var structures:Vector.<IStructure>

		//Display Containers
		protected var World_Sprite:Sprite=new Sprite();
		protected var Tile_Sprite_Top:Sprite=new Sprite();
		protected var Tile_Sprite_Back:Sprite=new Sprite();
		protected var Players_Sprite:Sprite=new Sprite();
		protected var Entities_Sprite:Sprite=new Sprite();
		protected var DebugText_Sprite:Sprite=new Sprite();

		//World System
		protected var WorldTickTimer:Timer=new Timer(1000/FPS,Infinity);
		protected var FPSUpdateTickTimer:Timer=new Timer(1000/FPSUPS,Infinity);
		protected var gameFramePerSecond:Number=0;
		protected var LastFPSUpdateTime:uint;
		protected var LastTime:uint;
		protected var LastKey:uint=0;

		//Tile System
		protected var tileGrid:TileGrid=new TileGrid();
		protected var tickRunTiles:Vector.<TickRunTileInformations>=new Vector.<TickRunTileInformations>

		//Entities
		protected var PlayerList:Vector.<Player>=new Vector.<Player>;
		protected var EntityList:Vector.<Entity>=new Vector.<Entity>;

		//DebugText
		protected var DebugText:TextField=new TextField();
		protected var DebugText2:TextField=new TextField();
		protected var onlyShowBasicDebugText:Boolean=false

		//Craft Recipes
		protected var Craft_Recipes:Vector.<CraftRecipe>=new Vector.<CraftRecipe>;

		//Game Rule
		intc var randomTickSpeed:uint=1
		intc var maxWirelessSignalTransmissionDistance:uint=16
		intc var blockPusherAndPullerMaxContolDistance:uint=16

		//Random Tick
		protected var randomTick:uint=0
		protected var randomTime:Number=1000/32//Static 32 Random Tick Per A Secord

		//Update Memory
		protected var tileUpdateCount:uint=0
		protected var tileUpdateMemory:Vector.<Point>=new Vector.<Point>

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
			return tcMath.random(x)
		}
		
		intc static function randomBoolean(trueWeight:uint,falseWeight:uint):Boolean
		{
			return General.randomBoolean(trueWeight,falseWeight)
		}
		
		intc static function randomBoolean2(chance:Number):Boolean
		{
			return General.randomBoolean2(chance)
		}

		//==================================================//
		//================Game Load Function================//
		//==================================================//
		public function Game(Variables:GameVariables=null):void
		{
			addEventListener(Event.ADDED_TO_STAGE,onGameInit);
		}

		protected function onGameInit(E:Event=null):void
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
		
		protected function startLoadTiles(loadingEvent:Function,
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
			this.loadTileX=0
			this.loadTileY=-this.WorldHeight
			this.loadRandomGenerator=new RandomGenerator(uint(this.WorldSpawnSeed),(int.MAX_VALUE+1)/8,new <Number>[2,V1+V2,V3+V4])
			this.totalLoadTiles=0
			this._loadingEvent=loadingEvent
			this._loadCompleteEvent=loadCompleteEvent
			this.tileLoadingSpeed=tcMath.NumberBetween(this.ShouldLoadTiles/100,32,512)
			//Set Text
			this.loadingScreen.title=titleText
			this.loadingScreen.element=elementText
			this.loadingScreen.show()
			//Add Event Listener
			this.gameLoadingTimer.addEventListener(TimerEvent.TIMER,this._loadingEvent)
			//Start
			this.gameLoadingTimer.start()
		}
		
		protected function onTileLoading(E:TimerEvent):void
		{
			for(var i:uint=0;i<this.tileLoadingSpeed;i++)
			{
				if(Math.abs(this.loadTileX)<=this.WorldWidth)
				{
					//Load Tile And Do Other Things
					if(needBarrier(this.loadTileX,this.loadTileY))
					{
						setNewTile(this.loadTileX,this.loadTileY,TileID.Barrier)
					}
					else if(variables.generateTiles)
					{
						var tile:InventoryItem=getTileByRandom(this.loadTileX,this.loadTileY,this.loadRandomGenerator);
						var ID:String=tile.Id;
						var Data:int=tile.Data;
						var Tag:TileTag=tile.Tag;
						var Rot:int=tile.Rot;
						setNewTile(this.loadTileX,this.loadTileY,ID,Data,Tag,Rot);
					}
					else
					{
						setNewTile(this.loadTileX,this.loadTileY,TileID.Void)
					}
					this.totalLoadTiles++;
					this.loadingScreen.percent=Number(this.totalLoadTiles/this.ShouldLoadTiles)
					this.loadTileX+=this.loadTileX<0?-1:1
					//Summon Structure
					var str:IStructure=detectStructure(this.loadTileX,this.loadTileY)
					if(str!=null) this.structures.push(str)
					//trace("running")
					continue
				}
				//Else if
				if(this.loadTileX>this.WorldWidth)
				{
					this.loadTileX=-1
					this.loadRandomGenerator=getRandomGenerator(this.loadTileX,this.loadTileY)
					continue
				}
				//Else if
				if(this.loadTileY<this.WorldHeight)
				{
					this.loadTileX=this.loadTileX<0?0:-1
					//trace("change")
					this.loadTileY++
					this.loadRandomGenerator=getRandomGenerator(this.loadTileX,this.loadTileY)
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
		
		protected function getRandomGenerator(x:int,y:int):RandomGenerator
		{
			var rMode:uint=uint((int.MAX_VALUE+1)/8+y*8-V1*V2+V3*V4)
			var rBuff:Vector.<Number>=new <Number>[2,V1+Math.abs(V2-y+x),V3+Math.abs(V4+y-x)]
			var rSeed:uint=uint(this.WorldSpawnSeed+x-y+V1+V2-V3-V4)%rMode
			return new RandomGenerator(rSeed,rMode,rBuff)
		}
		
		protected function onGameLoadComplete(E:TimerEvent=null):void
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
			this.nextGameVariables=null
			//Close LoadingScreen
			//startLoadTiles(this.onTileLoading,this.onGameLoadComplete,"Loading World...")
			this.loadingScreen.deShow()
		}
		
		public function get isActive():Boolean
		{
			return this._active
		}
		
		public function set isActive(boo:Boolean):void
		{
			this._active=boo
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
		
		protected function initWorldVariables():void
		{
			//Load A GameVariables
			this.variables=nextGameVariables!=null?nextGameVariables:GameVariables.RandomVariables
			//Set Structures To Empty
			this.structures=new Vector.<IStructure>
			//About World Spawn
			V1=uint(String(WorldSpawnSeed).charAt(WorldSpawnSeed%String(WorldSpawnSeed).length)+WorldSpawnSeed%10);//1~99
			V2=Math.ceil(WorldSpawnSeed/100)%11+5;//5~15
			V3=tcMath.getPrimeAt(WorldSpawnSeed%10+1);//2~29
			V4=WorldSpawnSeed%(WorldSpawnSeed%64+1)+1;//1~64
			V5=Math.pow(WorldSpawnSeed%10+10,(V1+V2+V3+V4)%4+1);//0~10000
			
			//Game Rules
			this.virusCount=0
			this.randomTickSpeed=tcMath.NumberBetween(uint(ShouldLoadTiles/512),1,65536)
		}
		
		protected function initAllTile():void
		{
			/*var dis:TileDisplaySettings=new TileDisplaySettings("file:///C:/Title.png")
			var inf:TileInfornation=new TileInfornation("example",dis)
			inf.defaultMaxHard=10
			ModAPI.addNewTile(inf)
			//trace(TileSystem.AllCustomBlockID)
			addCraftRecipe("vvv","vvv","vvv",[],
						   "vvv","vbv","vvv",["b","example",0,null,0])*/
		}

		protected function initDefaultRecipes():void
		{
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
			//Crystal Wall
			addCraftRecipe("ccc","cwc","ccc",["w",TileID.Basic_Wall,0,null,0,
											  "c",TileID.Colored_Block,0x00ffff,null,0],
						   "vwv","vwv","vwv",["w",TileID.Crystal_Wall,0,null,0])
			//Block Spawner
			addCraftRecipe("bgb","ggg","bgb",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0],
						   "vvv","vav","vvv",["a",TileID.Block_Spawner,0,null,0])
			//Walls Spawner
			addCraftRecipe("bwb","wsw","bwb",["b",TileID.Colored_Block,0x000000,null,0,
											  "w",TileID.Basic_Wall,0,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vav","vvv",["a",TileID.Walls_Spawner,0,null,0])
			//Arrow Block
			addCraftRecipe("bbv","ggb","bbv",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0],
						   "vvv","aaa","vvv",["a",TileID.Arrow_Block,0,null,0])
			//Pushable Block Black
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x000000,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,0,null,0])
			//Pushable Block Red
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0xff0000,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,1,null,0])
			//Pushable Block Yellow
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0xffff00,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,2,null,0])
			//Pushable Block Green
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x00ff00,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,3,null,0])
			//Pushable Block Cyan
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x00ffff,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,4,null,0])
			//Pushable Block Blue
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x0000ff,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,5,null,0])
			//Pushable Block Pink
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0xff00ff,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,6,null,0])
			//Barrier
			addCraftRecipe("www","www","www",["w",TileID.Basic_Wall,0,null,0],
						   "vvv","vbv","vvv",["b",TileID.Barrier,0,null,0])
			//Inventory Block
			addCraftRecipe("www","wvw","www",["w",TileID.Basic_Wall,0,null,0],
						   "vvv","vbv","vvv",["b",TileID.Inventory_Block,0,null,0])
			//XX Virus
			addCraftRecipe("bgb","gsg","bgb",["b",TileID.Colored_Block,0x000000,null,0,
											  "g",TileID.Colored_Block,0x888888,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus,0,null,0])
			//XX Virus Red
			addCraftRecipe("vvv","vrv","vvv",["r",TileID.Colored_Block,0xff0000,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Red,0,null,0])
			//XX Virus Green
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x00ff00,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Green,0,null,0])
			//XX Virus Blue
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x0000ff,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Blue,0,null,0])
			//XX Virus Cyan
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x00ffff,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Cyan,0,null,0])
			//XX Virus Purple
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0xff00ff,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Purple,0,null,0])
			//XX Virus Yellow
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0xffff00,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Yellow,0,null,0])
			//XX Virus Black
			addCraftRecipe("vvv","vbv","vvv",["b",TileID.Colored_Block,0x000000,null,0,
											  "v",TileID.XX_Virus,0,null,0],
						   "vvv","vvv","vvv",["v",TileID.XX_Virus_Black,0,null,0])
			//Signal Wire
			addCraftRecipe("vbv","bbb","vbv",["b",TileID.Colored_Block,0x000000,null,0],
						   "lll","lvl","lll",["l",TileID.Signal_Wire,0,null,0])
			//Signal Diode
			addCraftRecipe("vvv","waw","vvv",["w",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Diode,0,null,0],
						   true,true,false,true,false)
			//Signal Decelerator
			addCraftRecipe("vvv","dbd","vvv",["d",TileID.Signal_Diode,0,null,0,
											  "b",TileID.Colored_Block,0x00ff00,null,0],
						   "vsv","vvv","vsv",["s",TileID.Signal_Decelerator,0,null,0],
						   true,true,false,true,false)
			//Signal Delayer
			addCraftRecipe("vvv","dbd","vvv",["d",TileID.Signal_Diode,0,null,0,
											  "b",TileID.Colored_Block,0x0000ff,null,0],
						   "vsv","vvv","vsv",["s",TileID.Signal_Delayer,0,null,0],
						   true,true,false,true,false)
			//Signal Byte Getter
			addCraftRecipe("vwv","paw","vwv",["w",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "p",TileID.Block_Update_Detector,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Byte_Getter,0,null,0],
						   true,true,false,true,false)
			//Signal Byte Setter
			addCraftRecipe("vwv","paw","vwv",["w",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "p",TileID.Signal_Patcher,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Byte_Setter,0,null,0],
						   true,true,false,true,false)
			//Signal Patcher
			addCraftRecipe("wbw","bcb","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "c",TileID.Crystal_Wall,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Signal_Patcher,0,null,0],
						   true,true,false,true,true)
			//Random Tick Signal Generater
			addCraftRecipe("wbw","bsb","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "s",TileID.Block_Spawner,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Random_Tick_Signal_Generater,0,null,0],
						   true,true,false,true,true)
			//Wireless Signal Transmitter
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Signal_Diode,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Wireless_Signal_Transmitter,0,null,0],
						   true,true,false,true,true)
			//Wireless Signal Charger
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Crystal_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Signal_Diode,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Wireless_Signal_Charger,0,null,0],
						   true,true,false,true,true)
			//Signal Lamp
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Color_Mixer,0,null,0],
						   "svs","vvv","svs",["s",TileID.Signal_Lamp,0,null,0],
						   true,true,false,true,true)
			//Signal Byte Storage
			addCraftRecipe("wbw","bab","wbw",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Colored_Block,0x000000,null,0],
						   "svs","vvv","svs",["s",TileID.Signal_Byte_Storage,0,null,0],
						   true,true,false,true,true)
			//Block Destroyer
			addCraftRecipe("wbd","bad","wbd",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "d",TileID.Signal_Diode,0,null,0],
						   "vvv","vsv","vvv",["s",TileID.Block_Destroyer,0,null,0],
						   true,true,false,true)
			//Block Pusher
			addCraftRecipe("wbd","bad","wbd",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "d",TileID.Colored_Block,0x0000ff,null,0],
						   "vvv","vsv","vvv",["s",TileID.Block_Pusher,0,null,0],
						   true,true,false,true)
			//Block Puller
			addCraftRecipe("wbd","bad","wbd",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "d",TileID.Colored_Block,0x00ff00,null,0],
						   "vvv","vsv","vvv",["s",TileID.Block_Puller,0,null,0],
						   true,true,false,true)
			//Block Swaper
			addCraftRecipe("wbd","bad","wbd",["w",TileID.Basic_Wall,0,null,0,
											  "b",TileID.Signal_Wire,0,null,0,
											  "a",TileID.Arrow_Block,0,null,0,
											  "d",TileID.Colored_Block,0xff0000,null,0],
						   "vvv","vsv","vvv",["s",TileID.Block_Swaper,0,null,0],
						   true,true,false,true)
		}
		
		protected function initGameDisplay():void
		{
			//Scale
			stage.scaleMode=StageScaleMode.NO_SCALE
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
		
		protected function initLoadingScreen():void
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
		intc function get WorldSpawnMode():String
		{
			return this.variables.WorldSpawnMode
		}
		
		intc function get TileSpawnChance():Number
		{
			return this.variables.TileSpawnChance
		}
		
		intc function get WorldWidth():uint
		{
			return this.variables.WorldWidth
		}
		
		intc function get WorldHeight():uint
		{
			return this.variables.WorldHeight
		}
		
		intc function get ShouldLoadTiles():uint
		{
			return (this.WorldWidth*2+1)*(this.WorldHeight*2+1)
		}
		
		intc function get StructureGenerateCount():uint
		{
			return this.structures!=null?this.structures.length:0
		}
		
		intc function get WorldSeed():String
		{
			return this.variables.WorldSeed
		}
		
		intc function get WorldSpawnSeed():int
		{
			return this.variables.WorldSpawnSeed
		}
		
		//====Virus====//
		intc function get VirusMode():String
		{
			return this.variables.VirusMode
		}
		
		intc function get MaxVirusCount():uint
		{
			return this.variables.MaxVirusCount
		}
		
		intc function get VirusSpawnProbability():uint
		{
			return this.variables.VirusSpawnProbability
		}
		
		//====Player====//
		intc function get PlayerRandomSpawnRange():uint
		{
			return this.variables.PlayerRandomSpawnRange
		}
		
		intc function get defaultPlayerGameMode():String
		{
			return this.variables.defaultPlayerGameMode
		}
		
		//====Physics====//
		intc function get Fraction():Number
		{
			return this.variables.Fraction
		}
		
		//Random Spawn Player
		protected function randomspawnPlayer(player:Player):void
		{
			//ResetPos
			player.MoveTo(0,0)
			var MaxCount:uint=1024
			var count:uint=1
			while(count<MaxCount)
			{
				var ranX:int=tcMath.random1()*random(this.PlayerRandomSpawnRange)
				var ranY:int=tcMath.random1()*random(this.PlayerRandomSpawnRange)
				if(isTile(ranX,ranY)&&getTileTag(ranX,ranY).canPass)
				{
					player.MoveTo(ranX,ranY)
				}
				count++
			}
			//Set RandomRot
			player.Rot=MobileRot.randomRot()
		}

		//World Tile Spawner
		protected function getTileByRandom(X:int,Y:int,randomG:RandomGenerator):InventoryItem
		{
			//Set Variables
			var Id:String=TileID.Void;
			var Data:int=0;
			//Detect
			if(randomG==null) return new InventoryItem(Id,1,Data);
			var rand:Number=randomG.random()
			//Spawn Colored_Block
			var F1:int=tcMath.NumTo1(V1+V2+V3+V4)*Math.abs(V1-V2*rand+V3*rand)%100+1;//1~100
			var F2:int=Math.abs(Math.floor((V1+V3+V2+V4)*rand))%V3+1;//1~30
			var F3:int=Math.floor(rand*0xffffff)//0x0~0xffffff
			
			var Condition_Block:Boolean=rand<this.TileSpawnChance
			if(Condition_Block)
			{
				//Spawn Virus By 1/512
				var Condition_Virus:Boolean=(Math.abs(V1+V2+V3+V4+F1+F2+F3+X*Y)%VirusSpawnProbability==(V1+V2+V3+V4)%VirusSpawnProbability)
				if(Condition_Virus&&virusCount<MaxVirusCount)
				{
					//trace("Spawn A Virus on",X,Y)
					virusCount++
					var virusType:uint=Math.abs(F1+X-Y)%12-1
					switch(virusType)
					{
						case 1:
						case 2:
						return new InventoryItem(TileID.XX_Virus_Red)
						case 3:
						case 4:
						return new InventoryItem(TileID.XX_Virus_Blue)
						case 5:
						case 6:
						return new InventoryItem(TileID.XX_Virus_Green)
						case 7:
						return new InventoryItem(TileID.XX_Virus_Cyan)
						case 8:
						return new InventoryItem(TileID.XX_Virus_Yellow)
						case 9:
						return new InventoryItem(TileID.XX_Virus_Purple)
						case 10:
						return new InventoryItem(TileID.XX_Virus_Black)
						default:
						return new InventoryItem(TileID.XX_Virus)
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
		
		protected function needBarrier(X:int,Y:int):Boolean
		{
			return (Math.abs(X)==this.WorldWidth||Math.abs(Y)==this.WorldHeight)
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
		protected function ResetWorld():void
		{
			//Set Variables
			this.isActive=false
			//deShow Entities_Sprite
			this.Players_Sprite.visible=false
			this.Entities_Sprite.visible=false
			//Reset Tiles:Remove All Tile Sprite
			startRemoveAllTile(this.onTileRemoveing,this.onTileRemoveComplete,"Reset World...","Remove Tiles: ")
		}
		
		protected function startRemoveAllTile(loadingEvent:Function,
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
			this.tileLoadingSpeed=Math.max(Math.ceil(this.ShouldLoadTiles/100),64)
			this.cacheInt=this.totalObjTileCount
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
		
		protected function onTileRemoveing(E:TimerEvent=null):void
		{
			var i:Object
			for(var c:uint=0;c<this.tileLoadingSpeed;c++)
			{
				//Delete
				this.tileGrid.clearRandomTile()
				this.loadingScreen.percent=1-this.totalObjTileCount/this.cacheInt
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
		
		protected function onTileRemoveComplete(E:TimerEvent=null):void
		{
			//Reset World Variables
			initWorldVariables();
			//Set Revealed
			this.UpdateDebugText()
			//Respawn Tiles
			this.removeAllTile()
			startLoadTiles(this.onTileLoading,this.onWorldResetComplete,"Reset World...","Reload Tiles: ")
		}
		
		protected function onWorldResetComplete(E:TimerEvent=null):void
		{
			//Reset Variables
			this.nextGameVariables=null
			this.cacheInt=0
			//Reset Player
			for each(var player:Player in this.PlayerList)
			{
				if(player==null) continue
				player.resetInventory()
				player.gameMode=this.defaultPlayerGameMode;
			}
			//Reset Not-Player Entity
			removeAllNotPlayerEntity()
			//Random Spawn Player
			for(var p:uint=1;p<=PlayerCount;p++)
			{
				randomspawnPlayer(this.getPx(p))
			}
			//trace("sb")
			generateStructures(this.structures)
			//Show Sprites
			this.Players_Sprite.visible=true
			this.Entities_Sprite.visible=true
			//Reset Stage
			movePosToPlayer(random(PlayerCount)+1)
			//Show Text
			this.UpdateDebugText();
			//deShow LoadingScreen
			this.isActive=true
			this.loadingScreen.deShow()
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
			return tcMath.$(this.zoomScaleX)
		}
		
		intc function get ZoomY():Number
		{
			return tcMath.$(this.zoomScaleY)
		}
		
		protected function get TileDisplaySizeX():Number
		{
			return Game.TILE_SIZE*this.ZoomX
		}
		
		protected function get TileDisplaySizeY():Number
		{
			return Game.TILE_SIZE*this.ZoomY
		}
		
		protected function get TileDisplayWidth():Number
		{
			return this.stage.stageWidth/TileDisplaySizeX
		}
		
		protected function get TileDisplayHeight():Number
		{
			return this.stage.stageHeight/TileDisplaySizeY
		}
		
		protected function get displayOffsetX():Number
		{
			return Game.getStageRect(this).topLeft.x
		}
		
		protected function get displayOffsetY():Number
		{
			return Game.getStageRect(this).topLeft.y
		}
		
		protected function get TileDisplayOffsetX():Number
		{
			return displayOffsetX/TileDisplaySizeX
		}
		
		protected function get TileDisplayOffsetY():Number
		{
			return displayOffsetY/TileDisplaySizeY
		}
		
		protected function get TileDisplayRadiusX():Number
		{
			return (TileDisplayWidth-1)/2
		}
		
		protected function get TileDisplayRadiusY():Number
		{
			return (TileDisplayHeight-1)/2
		}
		
		protected function get displayX():Number
		{
			return (this.x+this.World_Sprite.x)/this.TileDisplaySizeX
		}
		
		protected function get displayY():Number
		{
			return (this.y+this.World_Sprite.y)/this.TileDisplaySizeY
		}
		
		protected function get worldDisplayX():Number
		{
			return this.World_Sprite.x/this.TileDisplaySizeX
		}
		
		protected function get worldDisplayY():Number
		{
			return this.World_Sprite.y/this.TileDisplaySizeY
		}
		
		//----====Main Functions====----//
		protected function borderTest(player:Player):void
		{
			var rX:Number=player.getX()+this.displayX;
			var rY:Number=player.getY()+this.displayY;
			var Rot:int=(player.Rot+2)%4
			if(tcMath.isBetween(rX,TileDisplayOffsetX,borderWidth+TileDisplayOffsetX)&&player.Rot==MobileRot.LEFT||
			   tcMath.isBetween(rX,TileDisplayWidth-borderWidth+TileDisplayOffsetX,TileDisplayWidth+TileDisplayOffsetX)&&player.Rot==MobileRot.RIGHT||
			   tcMath.isBetween(rY,TileDisplayOffsetY,borderHeight+TileDisplayOffsetY)&&player.Rot==MobileRot.UP||
			   tcMath.isBetween(rY,TileDisplayHeight-borderHeight+TileDisplayOffsetY,TileDisplayHeight+TileDisplayOffsetY)&&player.Rot==MobileRot.DOWN)
			{
				var xd:int=MobileRot.toPos(Rot,1)[0]
				var yd:int=MobileRot.toPos(Rot,1)[1]
				stageMoveTo(this.worldDisplayX+xd,this.worldDisplayY+yd);
			}
		}
		
		protected function movePosToPlayer(ID:uint):void
		{
			var playerPoint:Point=new Point(this.getPx(ID).x,this.getPx(ID).y)
			var lp:Point=this.World_Sprite.localToGlobal(playerPoint)
			var moveX:Number=this.World_Sprite.x+MIDDLE_DISPLAY_X-lp.x
			var moveY:Number=this.World_Sprite.y+MIDDLE_DISPLAY_Y-lp.y
			stageMoveTo(moveX,moveY,false);
		}

		protected function stageMoveTo(X:Number,Y:Number,sizeBuff:Boolean=true):void
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
		
		protected function setZoom(Mode:String,Num1:Number=NaN,Num2:Number=NaN,...Parameters):void
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
		
		protected function ZoomIn():void
		{
			ZoomInX()
			ZoomInY()
		}
		
		protected function ZoomInX():void
		{
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				this.zoomScaleX+=ZOOM_STEP//(this.TileDisplayRadiusX+1)/this.TileDisplayRadiusX
			}
			while(this.zoomScaleX>-1&&this.zoomScaleX<1)
			ZoomUpdate()
		}
		
		protected function ZoomInY():void
		{
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				this.zoomScaleY+=ZOOM_STEP//(this.TileDisplayRadiusY+1)/this.TileDisplayRadiusY
			}
			while(this.zoomScaleY>-1&&this.zoomScaleY<1)
			ZoomUpdate()
		}
		
		protected function ZoomOn():void
		{
			ZoomOnX()
			ZoomOnY()
		}
		
		protected function ZoomOnX():void
		{
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				this.zoomScaleX-=ZOOM_STEP//(this.TileDisplayRadiusX-1)/this.TileDisplayRadiusX
			}
			while(this.zoomScaleX>-1&&this.zoomScaleX<1)
			ZoomUpdate()
		}
		
		protected function ZoomOnY():void
		{
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				this.zoomScaleY-=ZOOM_STEP//(this.TileDisplayRadiusY-1)/this.TileDisplayRadiusY
			}
			while(this.zoomScaleY>-1&&this.zoomScaleY<1)
			ZoomUpdate()
		}
		
		protected function ZoomUpdate():void
		{
			ZoomSet(tcMath.$(this.zoomScaleX),tcMath.$(this.zoomScaleY))
		}
		
		protected function ZoomSet(Num1:Number,Num2:Number=NaN):void
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
		protected function keyDown(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey
			var alt:Boolean=E.altKey
			var shift:Boolean=E.shiftKey
			if(LastKey!=Code) LastKey=Code,this.UpdateDebugText(1);
			// altKey ctrlKey shiftKey //
			//End Game
			if(ctrl&&Code==KeyCode.ESC)
			{
				fscommand("quit")
				return;
			}
			//Trun Debug Text Visible By F1,
			//Trun onlyShowBasicDebugText By Ctrl+Shift+F1
			if(Code==KeyCode.F1)//F1
			{
				if(!ctrl&&!shift)this.UpdateDebugText(-3)
				else if(ctrl&&shift)this.onlyShowBasicDebugText=!this.onlyShowBasicDebugText,this.UpdateDebugText()
				else if(ctrl)this.UpdateDebugText(-1)
				else if(shift)this.UpdateDebugText(-2)
			}
			//Rescale By F2 or Shift+F2
			if(Code==KeyCode.F2)//F2
			{
				setZoom(shift?"On":"In")
			}
			//Give A Item By Ctrl+Num<Don't Use>
			/*if(ctrl&&!shift&&Code>48&&Code<58&&Code-48<=TileSystem.TotalTileCount)
			{
				PlayerList[0].addItem(TileSystem.AllTileID[Code-48],1,0,TileTag.getTagFromID(TileSystem.AllTileID[Code-48]));
				return;
			}*/
			//Spawn New Player By Ctrl+Shift+1~4
			if(ctrl&&shift&&Code>KeyCode.NUM_0&&Code<=KeyCode.NUM_9&&Code-KeyCode.NUM_1==PlayerCount&&Code-KeyCode.NUM_0<=LIMIT_PLAYER_COUNT)
			{
				spawnPx(Code-KeyCode.NUM_0);
				return;
			}
			//Set Pos To Player By Shift+Id
			if(!ctrl&&shift&&Code>KeyCode.NUM_0&&Code<=KeyCode.NUM_9&&Code-KeyCode.NUM_0<=PlayerCount)
			{
				movePosToPlayer(Code-KeyCode.NUM_0);
				return;
			}
			//Clear All Item Entity By Ctrl+Shift+I
			if(ctrl&&shift&&Code==KeyCode.I)
			{
				this.clearAllItemEntity()
			}
			//Reset World By Ctrl+Shift+R
			if(ctrl&&shift&&Code==KeyCode.R)
			{
				ResetWorld();
				return;
			}
			//Reset World To Test Mode:Ctrl+Shift+T
			if(ctrl&&shift&&Code==KeyCode.T)
			{
				this.nextGameVariables=GameVariables.presetVariables_Test
				ResetWorld();
				return;
			}
			if(ctrl&&shift&&Code==KeyCode.N)
			{
				this.nextGameVariables=GameVariables.presetVariables_N
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

		protected function keyUp(E:KeyboardEvent):void
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

		protected function EnterWorldTick(E:TimerEvent):void
		{
			//Time Functions
			var TimeDistance:uint=getTimer()-LastTime;
			//Reset Memory
			this.tileUpdateMemory=new Vector.<flash.geom.Point>
			//Update FPS
			gameFramePerSecond=Math.round(1000/TimeDistance*FPSDir)/FPSDir;
			//=====Random Tick=====//
			if(randomTickSpeed>0&&randomTime>0)
			{
				if(randomTick+TimeDistance>=randomTime)
				{
					randomTick=0
					var ranX:int
					var ranY:int
					for(var d:uint=0;d<randomTickSpeed;d++)
					{
						ranX=random(WorldWidth*2+1)-WorldWidth
						ranY=random(WorldHeight*2+1)-WorldHeight
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
			//=====Tick Run Tile=====//
			for each(var inf:TickRunTileInformations in this.tickRunTiles)
			{
				if(inf!=null&&isTile(inf.x,inf.y))
				{
					onTickTileRun(inf)
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
				else
				{
					this.EntityList.splice(this.EntityList.indexOf(null),1)
				}
			}
			//Reset Timer
			LastTime+=TimeDistance;
		}
		
		intc function onStageResize(E:Event=null):void
		{
			this.ResizeDebugText()
		}
		
		protected function ResizeDebugText():void
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
				else if(isTile(mX,mY)&&getTileTag(mX,mY).pushable&&player.ability.canPushBlock)
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
				if(isTile(mX,mY)&&getTileTag(mX,mY).canUse&&player.ability.canUseBlock)
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
				if(player.ability.canDestroy&&Destroy||player.ability.canDestroyAll&&Destroy)
				{
					if(isTile(frontX,frontY))
					{
						if(blockTag.canDestroy||blockID!=TileID.Void&&player.ability.canDestroyAll)
						{
							if(blockHard>1&&!player.ability.InstantDestroy)
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
										dropItem(frontX,frontY,player);
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
				if(player.isSelectItem&&player.ability.canPlace&&Place)
				{
					var PlaceId:String=player.SelectedItem.Id;
					var PlaceData:int=player.SelectedItem.Data;
					var PlaceTag:TileTag=player.SelectedItem.Tag;
					var PlaceRot:int=PlaceTag.canRotate?MobileRot.toTileRot(player.Rot):0
					//trace(player.SelectedItem.Tag.canPlace,block.Tag.canPlaceBy)
					if(!hasEntityOn(frontX,frontY)&&block!=null)
					{
						if(player.SelectedItem.Count>0&&
						   PlaceTag.canPlace&&
						   blockTag.canPlaceBy)
						{
							//RemoveItem
							if(!player.ability.InfinityItem)
							{
								player.removeItem(PlaceId,1,player.SelectedItem.Data,PlaceTag,PlaceRot);
							}
							//Real Place
							setTile(frontX,frontY,PlaceId,PlaceData,PlaceTag,PlaceRot);
							this.UpdateDebugText(2);
							//Set Hook
							onPlayerPlaceBlock(player,frontX,frontY,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot,TileSystem.getHardnessFromID(PlaceId));
						}
						else if(player.SelectedItem.Count>0&&player.ability.canUseItem)
						{
							//Use Item
							onPlayerUseItem(player,frontX,frontY,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot,TileSystem.getHardnessFromID(PlaceId));
						}
					}
				}
			}
		}

		protected function get PlayerCount():uint
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
		
		intc function disregEntity(Ent:Entity):void
		{
			if(getEntityIndex(Ent)>=0)
			{
				this.EntityList.splice(getEntityIndex(Ent),1)
			}
		}
		
		intc function getEntityIndex(entity:Entity):int
		{
			if(entity==null) return -1
			for(var index:uint=0;index<this.EntityList.length;index++)
			{
				var entity2:Entity=this.EntityList[index]
				if(entity2!=null&&entity.UUID==entity2.UUID)
				{
					return index
				}
			}
			return -1
		}
		
		intc function removeEntity(entity:Entity):void
		{
			entity.deleteSelf()
			entity.visible=false
			disregEntity(entity)
		}
		
		protected function testMove(Mob:Mobile,tx:int,ty:int,sx:int=0,sy:int=0):Boolean
		{
			var canMove:Boolean=true;
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
			if(hasEntityOn(tx,ty))
			{
				canMove=false;
			}
			return canMove;
		}

		protected function getEntityOn(X:int,Y:int):Entity
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
		
		intc function hasEntityOn(X:int,Y:int):Boolean
		{
			return (getEntityOn(X,Y)!=null&&(getEntityOn(X,Y) as Entity).hasCollision)
		}
		
		intc function summonCraftRecipePreview(X:Number,Y:Number):CraftRecipePreview
		{
			var crp:CraftRecipePreview=new CraftRecipePreview(this,X,Y)
			this.Entities_Sprite.addChild(crp)
			this.Entities_Sprite.setChildIndex(crp,0)
			this.regEntity(crp)
			return crp
		}
		
		intc function summonItem(X:Number,Y:Number,
								 Id:String=TileID.Colored_Block,
								 Count:uint=1,Data:int=0,
								 Tag:TileTag=null,Rot:int=0,
								 xd:Number=NaN,yd:Number=NaN,vr:Number=NaN):TriangleCraft.Entity.Item
		{
			var item:TriangleCraft.Entity.Item=new TriangleCraft.Entity.Item(this,X*TILE_SIZE,Y*TILE_SIZE,Id,Count,Data,Tag,Rot,xd,yd,vr)
			this.Entities_Sprite.addChild(item)
			this.Entities_Sprite.setChildIndex(item,0)
			regEntity(item)
			return item
		}
		
		intc function updateAllCraftRecipePreview():void
		{
			for each(var ent:Entity in this.EntityList)
			{
				if(ent!=null)
				{
					switch(ent.entityType)
					{
						case EntityType.CraftRecipePreview:
							this.detectCraftRecipePreview(ent as CraftRecipePreview)
							break
					}
				}
				else
				{
					this.EntityList.splice(this.EntityList.indexOf(null),1)
				}
			}
		}
		
		intc function detectItem(item:TriangleCraft.Entity.Item):void
		{
			//Set Variables
			var itemX:int=item.getGridX()
			var itemY:int=item.getGridY()
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
					if(tcMath.getDistance(item.x,item.y,player.x,player.y)<item.Radius+player.Radius)
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
						item.scaleAndMove(tile.x,tile.y,0,0.1)
						tile.addItem(item.Id,item.Count,item.Data,item.Tag,item.Rot)
					}
				}
			}
		}
		
		intc function detectCraftRecipePreview(crp:CraftRecipePreview):void
		{
			//Detect
			if(crp==null||!crp.isActive) return
			var X:int=crp.getX(),Y:int=crp.getY()//+(crp.getX()>0?1:0)+(crp.getY()>0?1:0)
			if(!isTile(X,Y)||getTileID(X,Y)!=TileID.Block_Crafter)
			{
				removeEntity(crp)
				return
			}
			//Init Variables
			var inputItems:Vector.<InventoryItem>=new Vector.<InventoryItem>
			var offsetX:int=CraftRecipe.SLOT_OFFSET_X,offsetY:int=CraftRecipe.SLOT_OFFSET_Y;
			//Set inputItems
			var inputX:int,inputY:int
			for(var Yp:int=-1;Yp<=1;Yp++)
			{
				for(var Xp:int=-1;Xp<=1;Xp++)
				{
					//Set XY
					inputX=X+offsetX+Xp
					inputY=Y+offsetY+Yp
					//Detect
					if(!isTile(inputX,inputY))
					{
						inputItems.push(null)
						continue;
					}
					//Push Tile
					inputItems.push(getTileObject(inputX,inputY).invItem)
				}
			}
			//Detect 2
			if(inputItems.every(function(item:InventoryItem,i:uint,v:Vector.<InventoryItem>)
										{
											return item.Id==TileID.Void
										}))
			{
				crp.setRecipe(null,null)
				return
			}
			//Set Recipe
			var tempNum:uint,tempNum2:uint,tempRecipe:CraftRecipe
			var item:InventoryItem,item2:InventoryItem
			for each(var recipe:CraftRecipe in this.Craft_Recipes)
			{
				if(recipe==null) continue
				tempNum2=recipe.getCraftEquals(inputItems)
				if(tempNum2>tempNum||tempNum2==tempNum&&General.randomBoolean())
				{
					tempNum=tempNum2
					tempRecipe=recipe
				}
			}
			//Final Set
			crp.setRecipe(tempNum==0?null:tempRecipe,inputItems)
		}
		
		protected function dropItem(X:int,Y:int,breaker:Player=null):void
		{
			//Detect
			if(!isTile(X,Y)) return
			//Drop Items
			var blockItem:InventoryItem=getTileObject(X,Y).invItem
			var blockID:String=getTileID(X,Y);
			var blockTag:TileTag=getTileTag(X,Y);
			var blockData:int=blockTag!=null&&blockTag.resetDataOnDestroy?0:getTileData(X,Y);
			var blockHard:uint=getTileHard(X,Y);
			var blockMaxHard:uint=getTileMaxHard(X,Y);
			var blockRot:int=blockTag.canRotate?getTileRot(X,Y):0;
			var blockDropItems:ItemList=getTileDropItems(X,Y);
			var spawnedItem:TriangleCraft.Entity.Item
			if(blockDropItems==null)
			{
				if(variables.blockDropItems)
				{
					spawnedItem=summonItem(X,Y,blockID,1,blockData,blockTag,0);
					spawnedItem.pickupTime=Game.realTimeToLocalTime(0.02)
				}
				else
				{
					if(breaker!=null)
					{
						breaker.Inventory.addItem(blockID,1,blockData,blockTag,0)
					}
				}
			}
			for(var i:uint=0;i<blockDropItems.typeCount;i++)
			{
				var giveItem:InventoryItem=blockDropItems.getItemAt(i)
				var giveId:String=giveItem.Id
				var giveCount:int=giveItem.Count
				var giveTag:TileTag=giveItem.Tag
				var giveData:int=giveTag!=null&&giveTag.resetDataOnDestroy?0:giveItem.Data
				var giveRot:int=giveItem.Rot
				if(giveTag.technical) continue
				if(giveItem.isEqual(blockItem)&&
				   blockTag.resetDataOnDestroy)
				{
					giveData=0
				}
				for(var j:uint=0;j<giveCount;j++)
				{
					if(variables.blockDropItems)
					{
						spawnedItem=summonItem(X,Y,giveId,1,giveData,giveTag,giveRot);
						spawnedItem.pickupTime=Game.realTimeToLocalTime(0.04)
					}
					else
					{
						if(breaker!=null)
						{
							breaker.Inventory.addItem(giveId,1,giveData,giveTag,giveRot)
						}
					}
				}
			}
		}

		intc function removeAllEntity():void
		{
			for(var i:int=this.EntityList.length-1;i>=0;i--)
			{
				var ent:Entity=this.EntityList[i]
				if(ent!=null)
				{
					this.removeEntity(ent)
				}
				else
				{
					this.EntityList.splice(i,1)
				}
			}
		}

		intc function removeAllNotPlayerEntity():void
		{
			for(var i:int=this.EntityList.length-1;i>=0;i--)
			{
				var ent:Entity=this.EntityList[i]
				if(ent==null)
				{
					this.EntityList.splice(i,1)
					continue
				}
				if(ent.entityType!=EntityType.Player)
				{
					this.removeEntity(ent)
				}
			}
		}

		intc function clearAllItemEntity():void
		{
			for(var i:int=EntityCount-1;i>=0;i--)
			{
				var ent:Entity=this.EntityList[i]
				if(ent==null)
				{
					this.EntityList.splice(i,1)
					continue
				}
				if(ent.entityType==EntityType.Item)
				{
					this.removeEntity(ent)
				}
			}
		}

		//==============================================//
		//================Tile Functions================//
		//==============================================//
		protected function setNewTile(X:int=0,Y:int=0,Id:String=TileID.Void,
									Data:int=0,Tag:TileTag=null,Rot:int=0,
									Level:String=TileSystem.Level_Top):Tile
		{
			var tile=new Tile(TileDisplayFrom.IN_GAME,this,X*TILE_SIZE,Y*TILE_SIZE,Id,Data,Tag,Rot,Level);
			this.tileGrid.setTileAt(X,Y,tile,false)
			addTileByLevel(tile)
			return tile;
		}
		
		protected function addTileByLevel(tile:Tile):void
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
		
		protected function removeTileByLevel(tile:Tile):void
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
		
		protected function removeTile(X:int,Y:int):void
		{
			this.tileGrid.clearTileAt(x,y)
		}
		
		protected function removeAllTile():void
		{
			this.tileGrid.clearAllTile()
		}
		
		protected function get totalObjTileCount():uint
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
			return isTile(X,Y)?getTileObject(X,Y).Tag==null?TileTag.getTagFromID(getTileID(X,Y)):getTileObject(X,Y).Tag:null;
		}

		intc function getTileRot(X:int,Y:int):uint
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

		//Setters
		intc function setVoid(X:int,Y:int,causeUpdate:Boolean=true):void
		{
			if(isTile(X,Y))
			{
				setTile(X,Y,TileID.Void,0,TileTag.getTagFromID(TileID.Void),0,0,causeUpdate)
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

		intc function setTileRot(X:int,Y:int,Rot:uint):void
		{
			if(isTile(X,Y))
			{
				var block=getTileObject(X,Y)
				block.Rot=Rot
			}
		}

		intc function setTile(X:int,Y:int,Id:String,Data:int=0,
							  Tag:TileTag=null,Rot:int=0,Hard:uint=0,
							  causeUpdate:Boolean=true):void
		{
			if(isTile(X,Y))
			{
				//Define
				var tile:Tile=getTileObject(X,Y);
				var tileOldID:String=tile.ID
				var tileOldData:int=tile.Data
				var tileOldTag:TileTag=tile.Tag
				var tileOldRot:int=tile.Rot
				var tileOldHard:uint=tile.Hard
				var tileOldMaxHard:uint=tile.MaxHard
				//Reference
				if(Tag==null) Tag=Id==tileOldID?tileOldTag:TileTag.getTagFromID(Id)
				//Set
				if(TileSystem.getHardnessFromID(Id)!=0&&Hard==0)
				{
					tile.changeTile(Id,Data,Tag,Rot);
					tile.returnHardness()
					if(causeUpdate) onTileUpdate(X,Y,Id,Data,Tag,Rot,tile.MaxHard,tileOldID,tileOldData,tileOldTag,tileOldRot,tileOldHard)
				}
				else
				{
					tile.changeTile(Id,Data,Tag,Rot,Hard);
					if(causeUpdate) onTileUpdate(X,Y,Id,Data,Tag,Rot,Hard,tileOldID,tileOldData,tileOldTag,tileOldRot,tileOldHard)
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
		intc function destroyBlock(X:int,Y:int,destroyHard:uint=1,autoDrop:uint=0):void
		{
			if(!isTile(X,Y)||destroyHard<=0) return
			var block:Tile=getTileObject(X,Y)
			if(block.Tag.canDestroy)
			{
				if(getTileHard(X,Y)>destroyHard)
				{
					block.Hard-=destroyHard
				}
				else
				{
					if(autoDrop>0)
					{
						var tag:TileTag=getTileTag(X,Y)
						if(!tag.canGet||autoDrop>1)
						dropItem(X,Y)
					}
					setVoid(X,Y)
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
			if(General.hasSpellInString("swap",Mode)) setTile(x1,y1,tId,tData,tTag,tRot,tHard)
			if(General.hasSpellInString("destroy",Mode)&&!tTag.technical) dropItem(x2,y2)
			setTile(x2,y2,oId,oData,oTag,oRot,oHard)
			//Clone Inventory
			if(oBlock.Tag.hasInventory) tInventory.resetToInventory(oInventory)
			if(General.hasSpellInString("swap",Mode)&&tBlock.Tag.hasInventory) oInventory.resetToInventory(tInventory)
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

		intc function remTickRunTile(x:int,y:int):void
		{
			if(hasTickRunTile(x,y))
			this.tickRunTiles.splice(getTickRunTileIndex(x,y),1)
		}

		intc function hasTickRunTile(x:int,y:int):Boolean
		{
			return getTickRunTileIndex(x,y)>-1
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
			//trace("createExplode:"+arguments)
			var cx:int,cy:int
			var v1:Number
			var strenth:uint
			var realRadius:Number=radius*Math.SQRT2
			var tag:TileTag
			for(var xd:int=-realRadius;xd<=realRadius;xd++)
			{
				for(var yd:int=-realRadius;yd<=realRadius;yd++)
				{
					cx=x+xd,cy=y+yd
					if(!isTile(cx,cy)) continue
					tag=getTileTag(cx,cy)
					v1=tcMath.NumberBetween(realRadius-tcMath.getDistance(x,y,cx,cy),0,1)//Should In 0~1
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
		protected function onTileUpdate(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint,
										oldId:String,oldData:int,oldTag:TileTag,oldRot:int,oldHard:uint):void
		{
			//========Set Variables========//
			var changedId:Boolean=Id!=oldId
			var changedData:Boolean=Data!=oldData
			var tag:TileTag=Tag==null?TileTag.getTagFromID(Id):Tag
			var oTag:TileTag=oldTag==null?TileTag.getTagFromID(oldId):oldTag
			//========Set New Barrier========//
			if(oldId==TileID.Barrier&&oldId!=Id)
			{
				barrierExtendBorder(X,Y)
			}
			//=======Call======//
			var x2:int,y2:int
			for(var i:uint=0;i<=4;i++)
			{
				if(i==0) x2=X,y2=Y
				else
				{
					x2=X+TileRot.toPos(i-1)[0]
					y2=Y+TileRot.toPos(i-1)[1]
				}
				if(isTile(x2,y2))
				{
					onNearbyTileUpdate(x2,y2,getTileID(x2,y2),getTileData(x2,y2),getTileTag(x2,y2),getTileRot(x2,y2),getTileHard(x2,y2),
									   X,Y,Id,Data,tag,Rot,Hard,
									   oldId,oldData,oTag,oldRot,oldHard)
				}
			}
			//======Disable From Tick Run Tile======//
			if(hasTickRunTile(X,Y))
			{
				if(!tag.needTickRun||
				  changedId&&getTickRunTileDisableOnIdChange(X,Y)||
				  changedData&&getTickRunTileDisableOnDataChange(X,Y))
				{
					this.remTickRunTile(X,Y)
				}
			}
			//======Set Tick Run Tile======//
			else if(Tag!=null&&Tag.needTickRun)
			{
				this.regTickRunTile(X,Y)
			}
			//========Handle With Entity========//
			//Block
			if(Id==TileID.Block_Crafter)
			{
				this.summonCraftRecipePreview(X,Y)
			}
			//Entity
			updateAllCraftRecipePreview()
			//========Add Count========//
			if(this.isActive)
			{
				//Add
				this.tileUpdateCount++
				//Show
				this.UpdateDebugText(1);
			}
			
		}
		
		protected function onNearbyTileUpdate(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint,
											nearbyX:int,nearbyY:int,nearbyId:String,nearbyData:int,nearbyTag:TileTag,nearbyRot:int,nearbyHard:uint,
											oldNearbyId:String,oldNearbyData:int,oldNearbyTag:TileTag,oldNearbyRot:int,oldNearbyHard:uint):void
		{
			//Set Variables
			var tile:Tile=getTileObject(X,Y)
			var linkCount:uint=0
			var shouldData:int=0
			var hasLinkFront:Boolean,hasLinkBack:Boolean
			var hasLinkLeft:Boolean,hasLinkRight:Boolean
			switch(Id)
			{
				//Signal_Wire:Link Blocks
				case TileID.Signal_Wire:
					var hasLinkAbsUp:Boolean=hasLink(X,Y,TileRot.UP)
					var hasLinkAbsDown:Boolean=hasLink(X,Y,TileRot.DOWN)
					var hasLinkAbsLeft:Boolean=hasLink(X,Y,TileRot.LEFT)
					var hasLinkAbsRight:Boolean=hasLink(X,Y,TileRot.RIGHT)
					linkCount=uint(hasLinkAbsUp)+uint(hasLinkAbsDown)+uint(hasLinkAbsLeft)+uint(hasLinkAbsRight)
					var shouldRot:uint=TileRot.RIGHT
					switch(linkCount)
					{
						case 0:
							break
						case 1:
							shouldData=1
							if(hasLinkAbsUp) shouldRot=TileRot.UP
							else if(hasLinkAbsDown) shouldRot=TileRot.DOWN
							else if(hasLinkAbsLeft) shouldRot=TileRot.LEFT
							else shouldRot=TileRot.RIGHT
							break
						case 2:
							if(hasLinkAbsUp!=hasLinkAbsDown)
							{
								shouldData=2
								if(hasLinkAbsUp) shouldRot=hasLinkAbsRight?TileRot.RIGHT:TileRot.UP
								else if(hasLinkAbsDown) shouldRot=hasLinkAbsRight?TileRot.DOWN:TileRot.LEFT
							}
							else
							{
								shouldData=3
								if(hasLinkAbsUp&&hasLinkAbsDown) shouldRot=TileRot.DOWN
								else if(hasLinkAbsLeft) shouldRot=TileRot.RIGHT
							}
							break
						case 3:
							shouldData=4
							if(!hasLinkAbsUp) shouldRot=TileRot.DOWN
							else if(!hasLinkAbsDown) shouldRot=TileRot.UP
							else if(!hasLinkAbsLeft) shouldRot=TileRot.RIGHT
							else shouldRot=TileRot.LEFT
							break
						case 4:
							shouldData=5
							break
					}
					tile.Data=shouldData
					tile.Rot=shouldRot
					break;
				//Signal Diode:Link Blocks
				case TileID.Signal_Diode:
					hasLinkFront=hasLink(X,Y,Rot-TileRot.RIGHT)
					hasLinkBack=hasLink(X,Y,Rot-TileRot.LEFT)
					linkCount=uint(hasLinkFront)+uint(hasLinkBack)
					shouldData=(linkCount!=0?(linkCount==1?(hasLinkFront?1:2):3):0)
					tile.Data=shouldData
					break;
				//Signal Decelerator And Signal Delayer:Link Blocks And Change Color
				case TileID.Signal_Decelerator:
				case TileID.Signal_Delayer:
					hasLinkFront=hasLink(X,Y,Rot-TileRot.RIGHT)
					hasLinkBack=hasLink(X,Y,Rot-TileRot.LEFT)
					linkCount=uint(hasLinkFront)+uint(hasLinkBack)
					shouldData=Data>3&&getTileTag(X,Y).specialTags.hasTag("d")&&uint(getTileTag(X,Y).specialTags.getTagValue("d"))>0?4:0
					shouldData+=(linkCount!=0?(linkCount==1?(hasLinkFront?1:2):3):0)
					tile.Data=shouldData
					break;
				//Signal Byte Getter|Setter|Copyer:Link Blocks
				case TileID.Signal_Byte_Getter:
					hasLinkBack=hasByteLink(X,Y,Rot+2,false)
					shouldData=(Data>1?2:0)+(hasLinkBack?1:0)
					tile.Data=shouldData
					break
				case TileID.Signal_Byte_Setter:
					hasLinkFront=hasByteLink(X,Y,Rot,true)
					shouldData=(Data>1?2:0)+(hasLinkFront?1:0)
					tile.Data=shouldData
					break
				case TileID.Signal_Byte_Copyer:
					hasLinkFront=hasByteLink(X,Y,Rot,true)
					hasLinkBack=hasByteLink(X,Y,Rot+2,false)
					linkCount=uint(hasLinkFront)+uint(hasLinkBack)
					shouldData=(Data>3?4:0)+(linkCount!=0?(linkCount==1?(hasLinkFront?1:2):3):0)
					tile.Data=shouldData
					break
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
					hasLinkFront=hasByteLink(X,Y,Rot,true)
					hasLinkLeft=hasByteLink(X,Y,Rot+3,false)
					hasLinkRight=hasByteLink(X,Y,Rot+1,false)
					linkCount=uint(hasLinkLeft)+uint(hasLinkRight)
					shouldData=(Data>7?8:0)+(hasLinkFront?4:0)+(linkCount!=0?(linkCount==1?(hasLinkRight?1:2):3):0)
					tile.Data=shouldData
					break
				//Block Update Detector:Detect Block Update
				case TileID.Block_Update_Detector:
					//trace("hasInMemory("+this.tileUpdateMemory+","+nearbyX+","+nearbyY+"):"+hasInMemory(this.tileUpdateMemory,nearbyX,nearbyY))
					if(hasInMemory(this.tileUpdateMemory,nearbyX,nearbyY)) break
					//======Set In Tick Run Memory======//
					this.tileUpdateMemory.push(new Point(nearbyX,nearbyY))
					patchSignal(X,Y)
					break
			}
		}
		
		protected function onPlayerDestroyBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
			//summonItem(X*TILE_SIZE,Y*TILE_SIZE,Id,1,Data,Tag,Rot)
		}
		
		protected function onPlayerDestroyingBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
			//summonItem(X*TILE_SIZE,Y*TILE_SIZE,Id,1,Data,Tag,Rot)
		}

		protected function onPlayerPlaceBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}
		
		protected function onPlayerUseItem(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}

		protected function onPlayerUseBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
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
				//Spawners:Spawn Blocks
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
					if(randomBoolean(1,49)) spawnerSpawnBlock(X,Y,Id)
					break
				//Barrier:Extend Border
				case TileID.Barrier:
					barrierExtendBorder(X,Y,P)
					break
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
					patchSignal(X,Y)
					break;
				//Signal Lamp:Trun Light
				case TileID.Signal_Lamp:
					signalLampTrunLight(X,Y,(Data+1)%6)
					break;
				//Block Destroyer:Destroy Block
				case TileID.Block_Destroyer:
					blockDestroyerDestroyBlock(X,Y,P.getX(),P.getY())
					break;
				//Block Pusher:Push Block
				case TileID.Block_Pusher:
					blockPusherPushBlock(X,Y)
					break;
				//Block Puller:Pull Block
				case TileID.Block_Puller:
					blockPullerPullBlock(X,Y)
					break;
				//Block Swaper:Swap Block
				case TileID.Block_Swaper:
					blockSwaperSwapBlock(X,Y)
					break;
				//Signal Byte Storage:Trun Byte
				case TileID.Signal_Byte_Storage:
					signalByteStorageTrunByte(X,Y)
					break
				//Signal Byte Getter|Setter|Copyer|Operator:Trun Mode
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
					signalByteGetterOrSetterTrunMode(X,Y)
					break
				case TileID.Signal_Byte_Copyer:
					signalByteCopyerTrunMode(X,Y)
					break
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
					signalByteOperatorTrunMode(X,Y)
					break
			}
		}
		
		protected function onPlayerPushBlock(P:Player,X:int,Y:int,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace(arguments)
		}

		protected function onRandomTick(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int,Hard:uint):void
		{
			//trace("onRandomTick_1:",X,Y,Id)
			if(!isTile(X,Y)||Tag==null||!Tag.allowRandomTick) return
			var cx:int
			var cy:int
			var xd:int
			var yd:int
			var blockID:String
			var i:uint
			//trace("onRandomTick_2:",X,Y,Id)
			switch(Id)
			{
				//Block Spawner & Walls Spawner
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				spawnerSpawnBlock(X,Y,Id);
				break
				//XX Virus
				case TileID.XX_Virus:
				var successlyInfluence:Boolean=false
				for(var c:int=random(3)+random(2)*(1+random(2));c>=0;c--)
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
					   !hasEntityOn(cx,cy))
					{
						successlyInfluence=true
						if(tcMath.getDistance2(X-cx,Y-cy)>=1.125&&
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
				if(!successlyInfluence&&random(5)==0) setVoid(X,Y)
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
						   hasEntityOn(cx,cy)||
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
					xd=tcMath.random1()
					yd=tcMath.random1()
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
					else if(getTileTag(cx,cy).canPlaceBy&&!hasEntityOn(cx,cy))
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
						if(isVoid(cx,cy)||blockID==Id) continue;
						if(getTileTag(cx,cy).canBeMove)
						{
							cloneTile(cx,cy,X,Y,"move")
							continue;
						}
					}
				}
				if(getTileID(X,Y)!=Id) break
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
						if(getTileTag(cx,cy).canPlaceBy&&
						   General.randomBoolean())
						{
							cloneTile(X,Y,cx,cy)
							continue;
						}
					}
				}
				break
				//XX Virus Cyan
				case TileID.XX_Virus_Cyan:
				if(Hard>1)
				{
					destroyBlock(X,Y)
				}
				else
				{
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
							if(isVoid(cx,cy)&&Math.abs(xd)==2&&Math.abs(yd)==2&&General.randomBoolean())
							{
								if(getTileTag(cx,cy).canPlaceBy)
								{
									setTile(cx,cy,TileID.XX_Virus_Cyan)
								}
							}
							//Transform Math.abs(xd)>1||Math.abs(yd)>1
							else if(General.randomBoolean())
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
										case 0x00ffff:
										setTile(cx,cy,TileID.XX_Virus_Cyan)
										break
									}
								}
							}
						}
					}
					setVoid(X,Y)
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
						if(blockID==Id)
						{
							setVoid(cx,cy)
						}
						else if(getTileTag(cx,cy).canPlaceBy)
						{
							cloneTile(X,Y,cx,cy)
						}
						else if(getTileMaxHard(cx,cy)<getTileMaxHard(X,Y))
						{
							if(getTileHard(cx,cy)>4) destroyBlock(cx,cy,5)
							else cloneTile(X,Y,cx,cy)
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
						if(!isTile(cx,cy)||!isTile(X-xd,Y-yd)) continue;
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
					cx=X+random(20)*tcMath.random1()
					cy=Y+random(20)*tcMath.random1()
					blockID=getTileID(cx,cy)
				}
				if(i==63) break
				if(TileSystem.isVirus(blockID))
				{
					//trace("explode")
					createExplode(cx,cy,4,0.1,2,1)
					cloneTile(X,Y,cx,cy,"destroy")
				}
				else if(blockID==TileID.Colored_Block&&
						getTileData(cx,cy)==0xff00ff)
				{
					//trace("clone")
					createExplode(cx,cy,2,0.1,2,1)
					cloneTile(X,Y,cx,cy,"destroy")
				}
				else if(randomBoolean2(1/50))
				{
					setVoid(X,Y)
					createExplode(X,Y,6,0.1,2,1)
				}
				else if(isVoid(cx,cy))
				{
					//trace("move")
					cloneTile(X,Y,cx,cy,"move&destroy")
				}
				break
				//Crystal Wall
				case TileID.Crystal_Wall:
				crystalWallActive(X,Y);
				break
				//Random Tick Signal Generater
				case TileID.Random_Tick_Signal_Generater:
				patchSignal(X,Y)
				break
			}
		}
		
		protected function onTickTileRun(information:TickRunTileInformations):void
		{
			var x:int=information.x,y:int=information.y
			if(!isTile(x,y)) return
			var block:Tile=getTileObject(x,y)
			var sTag:TileSpecialTag=block.Tag.specialTags
			var value:uint
			var vx:int=TileRot.toPos(block.Rot)[0]
			var vy:int=TileRot.toPos(block.Rot)[1]
			switch(block.ID)
			{
				case TileID.Signal_Decelerator:
					value=uint(sTag.getTagValue("d"))
					if(value>0) sTag.setTagValue("d",value-1)
					else
					{
						//sTag.setTagValue("d",0)
						remTickRunTile(x,y)
						//trace("onTickTileRun:",getTileData(x,y))
						patchSignal(x,y,new <Point>[new Point(x-vx,y-vy)])
						if(block.Data>3) block.Data-=4
					}
					break
				case TileID.Signal_Delayer:
						if(this.LastTime==uint(sTag.getTagValue("lt"))) break
						remTickRunTile(x,y)
						patchSignal(x,y,new <Point>[new Point(x-vx,y-vy)])
						if(block.Data>3) block.Data-=4
					break
			}
		}
		
		//======================================//
		//============Block Methodss============//
		//======================================//
		//Color Mixer
		protected function colorMixerMixColor(X:int,Y:int):void
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
			var sumNotRedColorH:uint=tcMath.getSum2(notRedColors);
			var averageNotRedColorH:uint=sumNotRedColorH/(notNaNColorCount-redColorCount)
			var redH:uint=averageNotRedColorH<=180?0:360
			var AverageColorH:Number=(sumNotRedColorH+redColorCount*redH)/notNaNColorCount
			var AverageColorS:Number=tcMath.getAverage2(BlockColorsS);
			var AverageColorV:Number=tcMath.getAverage2(BlockColorsV);
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
		
		protected function getCanMixBlocks(X,Y,pastVec:Vector.<String>=null):Vector.<Tile>
		{
			var returnVec:Vector.<Tile>=new Vector.<Tile>;
			if(isVoid(X,Y)) return returnVec
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
		protected function blockCrafterCraftBlocks(X:int,Y:int):void
		{
			var Slot:Vector.<InventoryItem>=new Vector.<InventoryItem>;
			var canCraft:Boolean=true
			var offsetX:int=CraftRecipe.SLOT_OFFSET_X,offsetY:int=CraftRecipe.SLOT_OFFSET_Y;
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
				//Set Variable
				var returnLoc:uint=(Yp+1)*3+(Xp+1)
				var returnId:String=CR.getOutputID(returnLoc);
				var returnCount:uint=CR.getOutputCount(returnLoc);
				var returnData:int=CR.getOutputData(returnLoc);
				var returnTag:TileTag=CR.getOutputTag(returnLoc);
				var returnRot:int=CR.getOutputRot(returnLoc);
				var returnItem:Item
				if(TileSystem.isAllowID(returnId))
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
						//Set Return
						returnLoc=(Yp+1)*3+(Xp+1)
						returnId=CR.getOutputID(returnLoc);
						returnCount=CR.getOutputCount(returnLoc);
						returnData=CR.getOutputData(returnLoc);
						returnTag=CR.getOutputTag(returnLoc);
						returnRot=CR.getOutputRot(returnLoc);
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
									returnItem=summonItem(X+0.5,Y,returnId,returnCount,returnData,
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
								if(!OutTag.canPlaceBy||hasEntityOn(returnX,returnY))
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
				if(successfulCraft)
				{
					updateAllCraftRecipePreview()
					return
				}
			}
		}

		protected function testCanCraft(Input:Vector.<InventoryItem>,Pattern:CraftRecipe):Boolean
		{
			return Pattern.testCanCraft(Input)
		}

		//Crystal Wall
		protected function crystalWallActive(X:int,Y:int):void
		{
			var xd:int,yd:int,cx:int,cy:int,blockID:String
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
						if(xd*yd!=0||!isTile(cx,cy)) continue
						blockID=getTileID(cx,cy)
						if(TileSystem.isWall(blockID)||TileSystem.isMechine(blockID))
						{
							if(getTileHard(cx,cy)<getTileMaxHard(cx,cy))
							{
								setTileHard(cx,cy,getTileHard(cx,cy)+1)
							}
						}
						else if(TileSystem.isVirus(blockID))
						{
							destroyBlock(cx,cy)
						}
					}
				}
			}
		}

		//Spawners
		intc function spawnerSpawnBlock(X:int,Y:int,Id:String,Count:uint=0):void
		{
			if(Id!=TileID.Block_Spawner&&Id!=TileID.Walls_Spawner) return
			var vz:uint=Id==TileID.Block_Spawner?3:5
			var sc:uint=Count!=0?Count:(Id==TileID.Block_Spawner?1+random(3):1+random(2))
			var sec:uint=0
			for(var c:uint=0;c<sc;c++)
			{
				for(var i:int=0;i<10;i++)
				{
					var cx:int=X+tcMath.random1()*random(vz)
					var cy:int=Y+tcMath.random1()*random(vz)
					var blockID:String=getTileID(cx,cy)
					if(cx==X&&cy==Y||!isTile(cx,cy)||hasEntityOn(cx,cy)) break
					if((getTileTag(cx,cy)==null||getTileTag(cx,cy).canPlaceBy)||TileSystem.isVirus(blockID))
					{
						if(Id==TileID.Block_Spawner)
						{
							if(sec==0||randomBoolean2(1/(sec+1)))
							{
								sec++
								spawnRandomColoredBlock(cx,cy)
								break
							}
						}
						else if(Id==TileID.Walls_Spawner&&
								randomBoolean2(1/4))
						{
							if(sec==0||randomBoolean2(1/(sec+1)/3))
							{
								sec++
								spawnRandomColoredBlock(cx,cy)
								blockID=randomBoolean2(1/4)?TileID.Crystal_Wall:TileID.Basic_Wall
								setTile(cx,cy,blockID)
								break
							}
						}
					}
				}
			}
		}

		//Block Spawner
		protected function spawnRandomColoredBlock(X:int,Y:int)
		{
			var _data:int=0x000000
			switch(random(8)-1)
			{
				case -1:
				_data=0x000000
				break
				case 0:
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
		
		//Barrier
		protected function barrierExtendBorder(x:int,y:int,player:Player=null):void
		{
			if(player!=null&&!player.ability.canExtendBorder) return
			var cx:int,cy:int,success:Boolean=false
			/*for(var rot:uint=0;rot<=4;rot++)
			{
				cx=x+TileRot.toPos(rot)[0],cy=y+TileRot.toPos(rot)[1]
				if(!isTile(cx,cy))
				{
					setNewTile(cx,cy,TileID.Barrier,0,TileTag.getTagFromID(TileID.Barrier),0)
					success=true
				}
			}*/
			for(var vx:int=-1;vx<=1;vx++)
			{
				for(var vy:int=-1;vy<=1;vy++)
				{
					cx=x+vx,cy=y+vy
					if(vx==0&&vy==0) continue
					if(!isTile(cx,cy))
					{
						setNewTile(cx,cy,TileID.Barrier,0,TileTag.getTagFromID(TileID.Barrier),0)
						success=true
					}
				}
				
			}
			if(success)
			{
				setVoid(x,y)
				if(player!=null) player.moveForward()
			}
		}
		
		//Inventory Block
		protected function inventoryBlockTransPortItem(X:int,Y:int,IL:IhasInventory,Mode:String):void
		{
			//Set Give Item
			var block:Tile=getTileObject(X,Y)
			var upRot:uint=(block.Rot+3)%4
			var downRot:uint=(block.Rot+1)%4
			var upX:int=X+TileRot.toPos(upRot)[0]
			var upY:int=Y+TileRot.toPos(upRot)[1]
			var downX:int=X+TileRot.toPos(downRot)[0]
			var downY:int=Y+TileRot.toPos(downRot)[1]
			var upBlock:Tile=isTile(upX,upY)?getTileObject(upX,upY):null
			var downBlock:Tile=isTile(downX,downY)?getTileObject(downX,downY):null
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
				}
				break;
				case "down":
				//Not Give,Spawn Item
				giveItem=block.Inventory.lastItem
				if(giveItem!=null)
				{
					block.Inventory.removeItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
					if(isTile(downX,downY)&&
					   getTileTag(downX,downY)!=null&&
					   getTileTag(downX,downY).hasInventory&&
					   getTileObject(downX,downY).Inventory.canHasInvItemIn(giveItem))
					{
						downBlock.Inventory.addItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
					}
					else if(isTile(downX,downY)&&getTileTag(downX,downY).canPass)
					{
						var returnItem:Item=summonItem(X,Y+0.5,giveItem.Id,1,giveItem.Data,giveItem.Tag,
													   giveItem.Rot,NaN,TILE_SIZE*2)
						returnItem.pickupTime=Game.realTimeToLocalTime(0.08)
					}
				}
				break;
			}
		}
		
		//Signal Lamp
		protected function signalLampTrunLight(x:int,y:int,data:int=-1):void
		{
			if(isVoid(x,y)||getTileID(x,y)!=TileID.Signal_Lamp) return
			var tempData:int=0,sTag:TileSpecialTag=getTileTag(x,y).specialTags
			var tileData:int=getTileData(x,y)
			if(data>=0)//Custom Set
			{
				tempData=data
			}
			else if(data==-1)//Signal Trigger
			{
				//Load Data:Default Color is Black
				if(sTag!=null)
				{
					if(!sTag.hasTag("lac")||sTag.getTagValue("lac",uint)==0)
					{
						sTag.setTagValue("lac",5)
					}
					tempData=tileData==0?sTag.getTagValue("lac",uint):0
				}
				else
				{
					tempData=tileData!=0?0:5
				}
			}
			else if(data==-2)//Get Random
			{
				tempData=tcMath.randomBetween(0,7)
			}
			//Save Data
			if(tempData>0||data>=0)
			{
				sTag.setTagValue("lac",tempData)
			}
			if(tempData!=tileData) getTileObject(x,y).Data=tempData
		}

		//Block Destroyer
		protected function blockDestroyerDestroyBlock(x:int,y:int,pushX:int,pushY:int):void
		{
			if(isVoid(x,y)) return
			var rot:uint=getTileRot(x,y)
			var vx:int=TileRot.toPos(rot)[0],vy:int=TileRot.toPos(rot)[1]
			var cx:int=x+vx,cy:int=y+vy
			if(isVoid(cx,cy)) return
			if(getTileHard(cx,cy)>1)
			{
				destroyBlock(cx,cy)
			}
			/*else if(x-pushX==vx&&y-pushY==vy)//Back Push
			{
				cloneTile(x,y,cx,cy,"move&destroy")
			}*/
			else
			{
				if(getTileTag(cx,cy).canGet) dropItem(cx,cy)
				setVoid(cx,cy)
			}
		}
		
		//Block Pusher
		protected function blockPusherPushBlock(x:int,y:int):void
		{
			//Define
			var rot:int=getTileRot(x,y)
			var vx:int=TileRot.toPosPoint(rot).x
			var vy:int=TileRot.toPosPoint(rot).y
			var cx:int,cy:int,nx:int,ny:int
			var firstX:int,firstY:int,lastX:int,lastY:int,firstI:uint,lastI:uint
			var isDefinedFirst:Boolean=false
			//Detect
			for(var i:uint=1;i<=blockPusherAndPullerMaxContolDistance;i++)
			{
				cx=x+vx*i,cy=y+vy*i
				nx=x+vx*(i+1),ny=y+vy*(i+1)
				if(!isTile(cx,cy)) break
				if(!isVoid(cx,cy)&&getTileTag(cx,cy).canBeMove)
				{
					if(!isDefinedFirst)
					{
						isDefinedFirst=true
						firstX=cx
						firstY=cy
						firstI=i
						continue
					}
				}
				else if(isDefinedFirst)
				{
					lastX=cx
					lastY=cy
					lastI=i
					break
				}
			}
			//Contol
			for(i=lastI-1;i>=firstI;i--)
			{
				cx=x+vx*i,cy=y+vy*i
				nx=x+vx*(i+1),ny=y+vy*(i+1)
				if(!isTile(nx,ny)||
				!getTileTag(nx,ny).canBeMove||
				!getTileTag(nx,ny).canPlaceBy) break
				cloneTile(cx,cy,nx,ny,"move")
			}
		}
		
		//Block Puller
		protected function blockPullerPullBlock(x:int,y:int):void
		{
			//Define
			var rot:int=getTileRot(x,y)
			var vx:int=TileRot.toPosPoint(rot).x
			var vy:int=TileRot.toPosPoint(rot).y
			var cx:int,cy:int,nx:int,ny:int,lx:int,ly:int
			var firstX:int,firstY:int,lastX:int,lastY:int,firstI:uint,lastI:uint
			var isDefinedFirst:Boolean=false
			//Detect
			for(var i:uint=1;i<=blockPusherAndPullerMaxContolDistance;i++)
			{
				cx=x+vx*i,cy=y+vy*i
				nx=x+vx*(i+1),ny=y+vy*(i+1)
				if(!isTile(cx,cy)) break
				if(!isVoid(cx,cy)&&getTileTag(cx,cy).canBeMove)
				{
					if(!isDefinedFirst)
					{
						isDefinedFirst=true
						firstX=cx
						firstY=cy
						firstI=i
						continue
					}
				}
				else if(isDefinedFirst)
				{
					lastX=cx
					lastY=cy
					lastI=i
					break
				}
			}
			//Contol
			for(i=firstI;i<lastI&&i>1;i++)
			{
				cx=x+vx*i,cy=y+vy*i
				lx=x+vx*(i-1),ly=y+vy*(i-1)
				if(!isTile(lx,ly)||!getTileTag(lx,ly).canBeMove) break
				cloneTile(cx,cy,lx,ly,"move")
			}
		}
		
		//Block Swaper
		protected function blockSwaperSwapBlock(x:int,y:int):void
		{
			//Define
			var rot:int=getTileRot(x,y)
			var vx:int=TileRot.toPosPoint(rot).x
			var vy:int=TileRot.toPosPoint(rot).y
			var x1:int=x+vx,y1:int=y+vy
			var x2:int=x+vx*2,y2:int=y+vy*2
			if((getTileTag(x1,y1)==null||getTileTag(x1,y1).canBeMove)&&
			   (getTileTag(x2,y2)==null||getTileTag(x2,y2).canBeMove))
			   {
				   cloneTile(x1,y1,x2,y2,"swap")
			   }
		}
		
		//Signal Byte Storage
		protected function signalByteStorageTrunByte(x:int,y:int,mode:int=-1):void
		{
			if(!isTile(x,y)||getTileID(x,y)!=TileID.Signal_Byte_Storage) return
			setTile(x,y,TileID.Signal_Byte_Storage,mode>0?mode:(getTileData(x,y)==1?0:1))
		}
		
		//Signal Byte Getter Or Setter
		protected function signalByteGetterOrSetterTrunMode(x:int,y:int):void
		{
			if(!isTile(x,y)) return
			var isInvent:Boolean=isReversedByteMechine(x,y)
			var data:int=getTileData(x,y)
			getTileObject(x,y).Data+=isInvent?-2:2
		}
		
		protected function signalByteCopyerTrunMode(x:int,y:int):void
		{
			if(!isTile(x,y)) return
			var isInvent:Boolean=isReversedByteMechine(x,y)
			var data:int=getTileData(x,y)
			getTileObject(x,y).Data+=isInvent?-4:4
		}
		
		protected function signalByteOperatorTrunMode(x:int,y:int):void
		{
			if(!isTile(x,y)) return
			var isInvent:Boolean=isReversedByteMechine(x,y)
			var data:int=getTileData(x,y)
			getTileObject(x,y).Data+=isInvent?-8:8
		}
		
		protected function hasByteSignal(x:int,y:int):Boolean
		{
			if(!isTile(x,y)) return false
			var tileID:String=getTileID(x,y),tileData:int=getTileData(x,y)
			switch(tileID)
			{
				case TileID.Signal_Byte_Storage:
				case TileID.Signal_Lamp:
				case TileID.Colored_Block:
					return true
			}
			if(getTileTag(x,y).hasInventory) return true
			if(TileIDSpace.MECHINES_BYTE.has(tileID)) return true
			return false
		}
		
		protected function getByte(x:int,y:int,reverse:Boolean=false):Boolean
		{
			if(!isTile(x,y)) return false
			var byte:Boolean=false
			var tileID:String=getTileID(x,y),tileData:int=getTileData(x,y)
			switch(tileID)
			{
				case TileID.Signal_Byte_Storage:
				case TileID.Signal_Lamp:
					byte=tileData!=0
					break
				case TileID.Colored_Block:
					byte=tileData>0xffffff/2
					break
			}
			if(TileIDSpace.MECHINES_BYTE.has(tileID))
			{
				byte=isReversedByteMechine(x,y)
			}
			else if(getTileTag(x,y).hasInventory)
			{
				byte=getTileObject(x,y).AllItemCount>0
			}
			return reverse?!byte:byte
		}
		
		protected function setByte(x:int,y:int,byte:Boolean=false):void
		{
			if(!isTile(x,y)) return
			var tileID:String=getTileID(x,y),tileData:int=getTileData(x,y)
			var shouldData:int=tileData
			switch(tileID)
			{
				case TileID.Signal_Byte_Storage:
					if((tileData>0)!=byte) signalByteStorageTrunByte(x,y)
					return
				case TileID.Signal_Lamp:
					if((tileData>0)!=byte) signalLampTrunLight(x,y)
					return
				case TileID.Colored_Block:
					shouldData=byte?(tileData>0xffffff/2?0xffffff-shouldData:shouldData):(tileData<0xffffff/2?0xffffff-shouldData:shouldData)
					break
			}
			if(TileIDSpace.MECHINES_BYTE.has(tileID))
			{
				setByteMechineState(x,y,byte)
			}
			if(shouldData!=tileData) setTile(x,y,tileID,shouldData)
		}
		
		protected function setByteMechineState(x:int,y:int,isReverse:Boolean):void
		{
			if(!isTile(x,y)) return
			var tileID:String=getTileID(x,y),tileData:int=getTileData(x,y)
			var linkData:uint
			var shouldData:int=0
			switch(tileID)
			{
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
					linkData=tileData%2
					shouldData=linkData+(isReverse?2:0)
					break
				case TileID.Signal_Byte_Copyer:
					linkData=tileData%4
					shouldData=linkData+(isReverse?4:0)
					break
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
					linkData=tileData%8
					shouldData=linkData+(isReverse?8:0)
					break
			}
			getTileObject(x,y).Data=shouldData
		}
		
		protected function signalByteGetterGetByte(x:int,y:int,memory:Vector.<Point>=null):void
		{
			var rot:int=getTileRot(x,y)
			var bX:int=x-TileRot.toPos(rot)[0],bY:int=y-TileRot.toPos(rot)[1]
			if(hasByteSignal(bX,bY)&&getByte(bX,bY,getTileData(x,y)>1))patchSignal(x,y,memory)
		}
		
		protected function signalByteSetterSetByte(x:int,y:int,memory:Vector.<Point>=null):void
		{
			var rot:int=getTileRot(x,y)
			var fX:int=x+TileRot.toPos(rot)[0],fY:int=y+TileRot.toPos(rot)[1]
			if(!isTile(fX,fY)) return
			setByte(fX,fY,getTileData(x,y)<2)
		}
		
		protected function signalByteCopyerCopyByte(x:int,y:int,memory:Vector.<Point>=null,
													originalByteX:Number=NaN,originalByteY:Number=NaN,
													originalByteData:int=-1):void
		{
			var rot:int=getTileRot(x,y)
			var bX:int=x-TileRot.toPos(rot)[0],bY:int=y-TileRot.toPos(rot)[1]
			var fX:int=x+TileRot.toPos(rot)[0],fY:int=y+TileRot.toPos(rot)[1]
			var isReversed:Boolean=getTileData(x,y)>3
			var fromX:int=isNaN(originalByteX)?bX:originalByteX
			var fromY:int=isNaN(originalByteY)?bY:originalByteY
			var fromByte:Boolean=originalByteData<0?getByte(fromX,fromY):Boolean(originalByteData)
			if(!isTile(fX,fY)) return
			if(getTileData(x,y)%4==3)
			{
				if(getTileID(fX,fY)==TileID.Signal_Byte_Copyer&&
				   getTileRot(fX,fY)==rot)
				{
					signalByteCopyerCopyByte(fX,fY,memory/*.concat(new <Point>[new Point(x,y)])*/,
											 fromX,fromY,
											 uint(isReversed?!fromByte:fromByte))
					return
				}
				if(hasByteSignal(bX,bY))//Only Active On Full Link
				{
					setByte(fX,fY,isReversed?!fromByte:fromByte)
				}
			}
		}
		
		protected function signalByteOperatorOperationByte(x:int,y:int,memory:Vector.<Point>=null,operator:String=""):void
		{
			//"+"="|","x"="&"
			var rot:int=getTileRot(x,y)
			var frontX:int=x+TileRot.toPos(rot)[0],frontY:int=y+TileRot.toPos(rot)[1]
			var leftX:int=x-TileRot.toPos(rot+1)[0],leftY:int=y-TileRot.toPos(rot+1)[1]
			var rightX:int=x+TileRot.toPos(rot+1)[0],rightY:int=y+TileRot.toPos(rot+1)[1]
			if(!isTile(frontX,frontY)) return
			var lByte:Boolean=Boolean(getByte(leftX,leftY))
			var rByte:Boolean=Boolean(getByte(rightX,rightY))
			var returnByte:Boolean
			if(operator=="+") returnByte=lByte||rByte
			if(operator=="x") returnByte=lByte&&rByte
			if(isReversedByteMechine(x,y)) returnByte=!returnByte
			if(hasByteSignal(leftX,leftY)&&
			   hasByteSignal(rightX,rightY)&&
			   getTileData(x,y)%8==7)//Only Active On Full Link
			{
				setByte(frontX,frontY,returnByte)
			}
		}
		
		//Signal Transmitters:
		protected function hasLink(x:int,y:int,rot:uint=TileRot.RIGHT):Boolean
		{
			var vx:int=x+TileRot.toPos(rot)[0],vy:int=y+TileRot.toPos(rot)[1]
			return isTile(vx,vy)?(General.binaryToBooleans(getTileTag(x,y).canBeLink,4)[(rot-getTileRot(x,y)+4)%4]&&
								  General.binaryToBooleans(getTileTag(vx,vy).canBeLink,4)[(rot-getTileRot(vx,vy)+6)%4]):false
		}
		
		protected function hasByteLink(x:int,y:int,rot:uint=TileRot.RIGHT,isSetter:Boolean=false):Boolean
		{
			var cx:int=x+TileRot.toPos(rot)[0],cy:int=y+TileRot.toPos(rot)[1]
			if(!isTile(cx,cy)) return false
			var tileID:String=getTileID(cx,cy)
			return (tileID==TileID.Signal_Byte_Storage||
					tileID==TileID.Signal_Lamp||
					tileID==TileID.Colored_Block||
					TileIDSpace.MECHINES_BYTE.has(tileID)||
					!isSetter&&getTileTag(cx,cy).hasInventory)
		}
		
		protected function isReversedByteMechine(x:int,y:int):Boolean
		{
			if(!isTile(x,y)) return false
			var data:int=getTileData(x,y)
			switch(getTileID(x,y))
			{
				case TileID.Signal_Byte_Getter:
				case TileID.Signal_Byte_Setter:
					return data>1
				case TileID.Signal_Byte_Copyer:
					return data>3
				case TileID.Signal_Byte_Operator_OR:
				case TileID.Signal_Byte_Operator_AND:
					return data>7
				default:
					return false
			}
		}
		
		protected function getLinkedPoses(x:int,y:int):Vector.<Point>
		{
			var returnVec:Vector.<Point>=new Vector.<Point>
			if(isVoid(x,y)) return returnVec
			//Check Link
			var rot:uint=getTileRot(x,y)
			var vx:int=x+TileRot.toPos(rot,1)[0],vy:int=y+TileRot.toPos(rot,1)[1]
			var cx:int,cy:int
			for(var i:uint=0;i<=4;i++)
			{
				cx=x+TileRot.toPos(i,1)[0],cy=y+TileRot.toPos(i,1)[1]
				if(isVoid(cx,cy)) continue;
				if(getTileID(x,y)==TileID.Signal_Byte_Getter)
				{
					returnVec.push(new Point(vx,vy))
					break
				}
				else if(hasLink(x,y,i))
				{
					returnVec.push(new Point(cx,cy))
				}
			}
			return returnVec
		}
		
		protected function getLinkedBlocks(x:int,y:int):Vector.<Tile>
		{
			var returnVec:Vector.<Tile>=new Vector.<Tile>
			if(isVoid(x,y)) return returnVec
			//Check Link
			for(var i:uint=0;i<=4;i++)
			{
				var cx:int=x+TileRot.toPos(i,1)[0],cy:int=y+TileRot.toPos(i,1)[1]
				if(isVoid(cx,cy)) continue;
				if(hasLink(x,y,i))
				{
					returnVec.push(getTileObject(cx,cy))
				}
			}
			return returnVec
		}
		
		intc function patchSignal(x:int,y:int,memory:Vector.<Point>=null):void
		{
			//Conditions
			if(isVoid(x,y)) return
			//Set Variables
			var linkedPoses:Vector.<Point>=getLinkedPoses(x,y)
			var memoryBlocks:Vector.<Point>=memory==null?new Vector.<Point>:memory
			//Add Self To Memory
			memoryBlocks.push(new Point(x,y))
			//Patch
			patchLoop:for each(var p:Point in linkedPoses)
			{
				//trace("signal patched to",p.x+","+p.y,"tileID="+getTileID(p.x,p.y),"mem:",hasInMemory(memoryBlocks,p))
				//Filter
				if(isVoid(p.x,p.y)||hasInMemory(memoryBlocks,p)) continue patchLoop
				patchASignal(x,y,p,memoryBlocks)
				//Set In Memory
				memoryBlocks.push(new Point(p.x,p.y))
			}
		}

		intc function patchASignal(x:int,y:int,p:Point,memoryBlocks:Vector.<Point>):void
		{
			//Real Signal
			var block:Tile=getTileObject(p.x,p.y)
			var vp:Point=TileRot.toPosPoint(block.Rot)//Vector point
			var ovp:Point=new Point(-vp.x,-vp.y)//Opposite vector point
			var op:Point=new Point(p.x-x,p.y-y)//Offset Point(at right is 1,at up is -1)
			switch(block.ID)
			{
				//Transmitter
				case TileID.Signal_Wire:
					patchSignal(p.x,p.y,memoryBlocks)
					break;
				case TileID.Wireless_Signal_Transmitter:
					patchWirelessSignal(p.x,p.y,block.Rot,memoryBlocks)
					break;
				case TileID.Wireless_Signal_Charger:
					patchChargedWirelessSignal(p.x,p.y,block.Rot,memoryBlocks)
					break;
				case TileID.Signal_Diode:
					if(op.equals(vp))
					{
						patchSignal(p.x,p.y,memoryBlocks)
					}
					break
				case TileID.Signal_Decelerator:
				case TileID.Signal_Delayer:
					if(op.equals(vp))
					{
						if(block.Data<4) block.Data+=4
						if(block.ID==TileID.Signal_Decelerator) block.Tag.specialTags.setTagValue("d",10,uint)
						else block.Tag.specialTags.setTagValue("lt",this.LastTime,uint)
						regTickRunTile(p.x,p.y)
					}
					break
				//Byte Mechine
				case TileID.Signal_Byte_Getter:
					if(!op.equals(vp)&&!op.equals(ovp))
					{
						signalByteGetterGetByte(p.x,p.y,memoryBlocks)
					}
					break
				case TileID.Signal_Byte_Setter:
					if(!op.equals(ovp))
					{
						signalByteSetterSetByte(p.x,p.y,memoryBlocks)
					}
					break
				case TileID.Signal_Byte_Copyer:
					signalByteCopyerCopyByte(p.x,p.y,memoryBlocks)
					break
				case TileID.Signal_Byte_Operator_OR:
					signalByteOperatorOperationByte(p.x,p.y,memoryBlocks,"+")
					break
				case TileID.Signal_Byte_Operator_AND:
					signalByteOperatorOperationByte(p.x,p.y,memoryBlocks,"x")
					break
				//Use-Signal Blocks
				case TileID.Block_Spawner:
				case TileID.Walls_Spawner:
					if(randomBoolean(1,49)) spawnerSpawnBlock(p.x,p.y,block.ID,1)
					break
				case TileID.Crystal_Wall:
					if(randomBoolean(1,9)) crystalWallActive(p.x,p.y)
					break
				case TileID.Color_Mixer:
					colorMixerMixColor(p.x,p.y)
					break;
				case TileID.Block_Crafter:
					blockCrafterCraftBlocks(p.x,p.y)
					break;
				case TileID.Inventory_Block:
					inventoryBlockTransPortItem(p.x,p.y,null,"down")
					break;
				case TileID.Signal_Lamp:
					signalLampTrunLight(p.x,p.y)
					break;
				case TileID.Block_Destroyer:
					blockDestroyerDestroyBlock(p.x,p.y,x,y)
					break
				case TileID.Block_Pusher:
					blockPusherPushBlock(p.x,p.y)
					break
				case TileID.Block_Puller:
					blockPullerPullBlock(p.x,p.y)
					break
				case TileID.Block_Swaper:
					blockSwaperSwapBlock(p.x,p.y)
					break;
			}
		}

		intc function patchWirelessSignal(x:int,y:int,rot:uint,memory:Vector.<Point>=null):void
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
				if(isVoid(cx,cy)) continue
				//trace("patchWirelessSignal:",vx,vy,cx,cy,getTileID(cx,cy),getTileRot(cx,cy),(rot+2)%4)
				if(!getTileTag(cx,cy).canPass)
				{
					if(getTileID(cx,cy)==TileID.Wireless_Signal_Transmitter)
					{
						if(getTileRot(cx,cy)==(rot+2)%4)//Opposite
						{
							patchSignal(cx,cy,memoryBlocks)
							break
						}
						else
						{
							patchWirelessSignal(cx,cy,getTileRot(cx,cy),memoryBlocks)
							break
						}
					}
				}
			}
		}
		
		intc function patchChargedWirelessSignal(x:int,y:int,rot:uint,memory:Vector.<Point>=null):void
		{
			var vx:int=TileRot.toPos(rot)[0],vy:int=TileRot.toPos(rot)[1]
			var cx:int=x,cy:int=y,lcx:int,lcy:int
			var memoryBlocks:Vector.<Point>=memory==null?new Vector.<Point>:memory
			for(var i:uint=0;i<maxWirelessSignalTransmissionDistance;i++)
			{
				//Set Variables
				lcx=cx,lcy=cy
				cx+=vx
				cy+=vy
				if(isVoid(cx,cy)) continue
				//trace("patchWirelessSignal:",vx,vy,cx,cy,getTileID(cx,cy),getTileRot(cx,cy),(rot+2)%4)
				if(!getTileTag(cx,cy).canPass)
				{
					patchASignal(lcx,lcy,new Point(cx,cy),memoryBlocks)
					break
				}
			}
		}
		
		protected function hasInMemory(memory:Vector.<Point>,x:*,y:*=null):Boolean
		{
			//Test Type
			var testPoint:Point
			if(x is int&&y is int)testPoint=new Point(x,y)
			else if(x is flash.geom.Point)testPoint=x
			else if(y is flash.geom.Point)testPoint=y
			else return false
			//Test Memory/**/
			if(memory==null||memory.length<1)return false
			return memory.some(function(p2:Point,index:uint,vec:Vector.<Point>):Boolean
										{
											return testPoint.equals(p2)
										})
		}

		//================================================//
		//============Other Instance Functions============//
		//================================================//
		public function get gameFPS():uint
		{
			return this.gameFramePerSecond;
		}
		
		protected function onFPSUpdate(E:TimerEvent):void
		{
			//Reset
			this.tileUpdateCount=0
			//Show
			this.UpdateDebugText(1);
		}
		
		intc function UpdateDebugText(textNum:int=0,Resize:Boolean=true):void
		{
			var senior:Boolean=!onlyShowBasicDebugText
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
						DTT+="\nWorldSeed="+WorldSeed
						if(senior) DTT+=",TileSpawnChance="+General.NTP(TileSpawnChance);
						if(senior) DTT+="\nV1="+V1+",V2="+V2+",V3="+V3+",V4="+V4;
						DTT+="\nWorldWidth="+(WorldWidth*2+1)+",WorldHeight="+(WorldHeight*2+1);
						if(senior) DTT+="\n"+General.NTP(totalLoadTiles/ShouldLoadTiles)+" tiles loaded";
						DTT+=(senior?",":"\n")+tileUpdateCount+" tiles updated"
						DTT+="\nAllEntityCount="+this.EntityCount
						DTT+="\ndefaultPlayerGameMode="+defaultPlayerGameMode
						if(senior) DTT+="\nVirusMode="+VirusMode;
						if(senior) DTT+="\n"+virusCount+" virus generated in this world";
						if(senior) DTT+="\n"+StructureGenerateCount+" structure generated in this world"
						DTT+="\n\nLastKeyCode="+LastKey;
						if(senior) DTT+="\nstageWidth="+stage.stageWidth+",stageHeight="+stage.stageHeight
						DTT+="\nZoomX="+General.NTP(tcMath.$(this.zoomScaleX),2)+",ZoomY="+General.NTP(tcMath.$(this.zoomScaleY),2);
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
	protected static const BACKGROUND_COLOR:uint=0xbbbbbb
	protected static const BACKGROUND_ALPHA:Number=50/100
	
	protected static const DEFAULT_TEXT:String="TriangleCraft.Common.MainFont"
	protected static const DEFAULT_TEXT_SIZE_TITLE:uint=64
	protected static const DEFAULT_TEXT_SIZE_PERCENT:uint=32
	protected static const DEFAULT_TEXT_COLOR_TITLE:uint=0x666666
	protected static const DEFAULT_TEXT_COLOR_PERCENT:uint=0x666666
	protected static const DEFAULT_TEXT_FORMAT_TITLE:TextFormat=new TextFormat(DEFAULT_TEXT,
																			 DEFAULT_TEXT_SIZE_TITLE,
																			 DEFAULT_TEXT_COLOR_TITLE,
																			 true,false,false,null,null,
																			 TextFormatAlign.CENTER)
	protected static const DEFAULT_TEXT_FORMAT_PERCENT:TextFormat=new TextFormat(DEFAULT_TEXT,
																			   DEFAULT_TEXT_SIZE_PERCENT,
																			   DEFAULT_TEXT_COLOR_PERCENT,
																			   false,false,false,null,null,
																			   TextFormatAlign.CENTER)
	
	
	//==========Instance Variables==========//
	protected var titleText:TextField
	protected var percentText:TextField
	protected var _shape:Shape
	protected var _autoSize:Boolean=true
	protected var _loadElement:String=new String()
	
	//Init
	public function LoadScreen()
	{
		this.addEventListener(Event.ADDED_TO_STAGE,init)
	}
	
	protected function init(Eve:Event=null):void
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
	
	protected function addChilds():void
	{
		this.addChild(this._shape)
		this.addChild(this.percentText)
		this.addChild(this.titleText)
	}
	
	//Display Getters
	protected function get stageRect():Rectangle
	{
		return Game.getStageRect(this)
	}
	
	protected function get topLeftX():Number
	{
		return this.globalToLocal(this.stageRect.topLeft).x
	}
	
	protected function get topLeftY():Number
	{
		return this.globalToLocal(this.stageRect.topLeft).y
	}
	
	protected function get TITLE_TOP():Number
	{
		return this.topLeftY+this.stage.stageHeight/5
	}
	
	protected function get TEXT_DISTANCE():Number
	{
		return 32
	}
	
	//Draw
	protected function drawBackGround():void
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
	
	protected function initTextPos():void
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
	protected function onStageResize(E:Event=null):void
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
}