﻿package TriangleCraft
{
	//TriangleCraft
	import TriangleCraft.Key;
	import TriangleCraft.General;
	import TriangleCraft.CraftRecipe;
	import TriangleCraft.InventoryItem;
	import TriangleCraft.GameVariables;
	import TriangleCraft.Player.Player;
	import TriangleCraft.Tile.Tile;
	import TriangleCraft.Tile.TileID;
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Tile.TileTag;
	import TriangleCraft.Entity.Item;
	import TriangleCraft.Entity.Entity;
	import TriangleCraft.Entity.EntitySystem;
	import TriangleCraft.Entity.Mobile.Mobile;
	
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

	//Class
	public class Game extends Sprite
	{
		//=====STATIC CONST=====//
		//About This Game
		public static const GameName:String="Triangle Craft";
		public static const Version:String="Alpha 0.1.1 build 3";

		//Tile System
		private static const tileSize:uint=TileSystem.globalTileSize;
		private static const displayWidth:uint=672;
		private static const displayHeight:uint=672;
		private static const middleDisplayX:uint=displayWidth /2
		private static const middleDisplayY:uint=displayHeight /2

		//World
		private static const allowInfinityWorld:Boolean=false;
		public static const FPS:uint=100
		private static const FPSDir:uint=Math.pow(10,2)
		private static const FPSUPS:uint=4

		//Player
		private static const LimitPlayerCount:uint=4;
		
		//DebugText
		private static const MainFormet:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"left");
		private static const MainFormet2:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"right");
		private static const emableRadomTickOutPut:Boolean=false

		//=====PRIVATE|PUBLIC VAR=====//
		//Game
		public const isTriangleCraft:Boolean=true
		public var Variables:GameVariables
		
		//Display
		private var DebugTextVisible:Boolean=true
		private var ZoomScaleX:Number=1;
		private var ZoomScaleY:Number=1;
		private var WidthByBlock:uint=displayWidth/tileSize;
		private var HeightByBlock:uint=displayHeight/tileSize;
		private var BorderWidth:uint=3
		private var BorderHeight:uint=3
		
		//World Spawn
		private var V1:int,V2:int,V3:int,V4:int,V5:int;
		private var E1:Boolean,E2:Boolean,E3:Boolean,E4:Boolean,E5:Boolean;
		private var VirusCount:uint=0
		private var ShouldSpawnTiles:uint;
		private var TotalSpawnTiles:uint=0;
		
		//Display Containers
		private var Tile_Sprite_Top:Sprite=new Sprite();
		private var Tile_Sprite_Back:Sprite=new Sprite();
		private var Players_Sprite:Sprite=new Sprite();
		private var Entities_Sprite:Sprite=new Sprite();
		private var DebugText_Sprite:Sprite=new Sprite();
		
		//World System
		private var WorldTickTimer:Timer=new Timer(1000/FPS,Infinity);
		private var FPSUpdateTickTimer:Timer=new Timer(1000/FPSUPS,Infinity);
		private var gameFramePerSecond:Number=0;
		private var LastFPSUpdateTime:uint
		private var LastTime:uint;
		private var LastKey:uint=0;

		//Tile System
		private var Tiles:Object={};

		//Entities
		private var PlayerList:Array=[];
		private var EntityList:Array=[];
		private var EntityUUIDList:Array=[];

		//DebugText
		private var DebugText:TextField=new TextField();
		private var DebugText2:TextField=new TextField();

		//Crafting Recipes
		private var Craft_Recipes:Array=new Array();
		
		//Game Rule
		private var randomTickCount:uint=1
		
		//Random Tick
		private var randomTick:uint=0
		private var randomTime:Number=1000/32//Static 32 Random Tick Per A Secord

		//--------Game Load Function--------//
		public function Game(Variables:GameVariables=null):void
		{
			addEventListener(Event.ADDED_TO_STAGE,onGameLoaded);
		}

		private function onGameLoaded(E:Event=null):void
		{
			//Trace Version trace("Version is",Game.versionStage,Game.versionMajor,Game.versionBuild);
			setWorldVariables();
			setGameDisplay();
			loadDefaultRecipes();
			//Set Pos
			x=middleDisplayX;
			y=middleDisplayY;
			//Spawn Tile
			spawnTiles()
			//Spawn Player
			var P1:Player=SpawnPlayer(PlayerCount+1,0,0);
			randomSpawnPlayer(P1)
			movePosToPlayer(P1.ID)
			//Set DebugText
			DebugText.selectable=false;
			DebugText.defaultTextFormat=MainFormet;

			DebugText2.selectable=false;
			DebugText2.defaultTextFormat=MainFormet2;
			UpdateDebugText();
			ResizeDebugText();
			//addEventListener
			stage.addEventListener(KeyboardEvent.KEY_DOWN,OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,OnKeyUp);
			stage.addEventListener(Event.RESIZE,ResizeDebugText)
			this.WorldTickTimer.addEventListener(TimerEvent.TIMER,EnterWorldTick)
			this.FPSUpdateTickTimer.addEventListener(TimerEvent.TIMER,FPSUpdate)
			Key.Listens=this.stage
			//removeEventListener
			removeEventListener(Event.ADDED_TO_STAGE,onGameLoaded)
			//Start Timer
			this.WorldTickTimer.start()
			this.FPSUpdateTickTimer.start()
			//getTimer
			this.LastTime=getTimer()
			this.LastFPSUpdateTime=getTimer()
		}

		private function loadDefaultRecipes():void
		{
			//Color Mixer
			addCraftRecipe("gbg","bbb","gbg",["g",TileID.Colored_Block,0x888888,null,0,
											  "b",TileID.Colored_Block,0x000000,null,0],
						   "vav","ava","vav",["a",TileID.Color_Mixer,0,null,0])
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
			//Pushable Block
			addCraftRecipe("bbb","bvb","bbb",["b",TileID.Colored_Block,0x0000ff,null,0],
						   "vbv","vvv","vbv",["b",TileID.Pushable_Block,0,null,0])
			//Inventory Block
			addCraftRecipe("www","wvw","www",["w",TileID.Basic_Wall,0,null,0],
						   "vvv","vbv","vvv",["b",TileID.Inventory_Block,0,null,0])
		}
		
		public function addCraftRecipe(PatternTop:String,PatternMiddle:String,PatternDown:String,
									   PatternCurrent:Array,
									   OutputTop:String,OutputMiddle:String,OutputDown:String,
									   OutputCurrent:Array)
		{
			Craft_Recipes.push(new CraftRecipe(PatternTop,PatternMiddle,PatternDown,PatternCurrent,
											   OutputTop,OutputMiddle,OutputDown,OutputCurrent))
		}

		//--------World Functions--------//
		private function setWorldVariables():void
		{
			//Load A Random GameVariables
			this.Variables=GameVariables.RandomVariables
			
			//About World Spawn
			V1=uint(String(WorldSpawnSeed).charAt(WorldSpawnSeed%String(WorldSpawnSeed).length)+WorldSpawnSeed%10);//1~99
			V2=Math.ceil(WorldSpawnSeed/100)%11+5;//5~15
			V3=General.getPrimeAt(WorldSpawnSeed%10+1);//2~29
			V4=WorldSpawnSeed%(WorldSpawnSeed%64+1)+1;//1~64
			V5=Math.pow(WorldSpawnSeed%10+10,(V1+V2+V3+V4)%4+1);//0~10000
			setWorldSpawnConditions()
			
			//World Size
			ShouldSpawnTiles=(WorldWidth*2+3)*(WorldHeight*2+3);
			TotalSpawnTiles=0
			
			//Game Rules
			VirusCount=0
			randomTickCount=General.NumberBetween(Math.round(ShouldSpawnTiles/256),1,64)
			//trace(randomTickCount)
		}
		
		//Random Spawn Player
		private function randomSpawnPlayer(player:Player):void
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
		}
		
		//WorldVariables Getter
		//====WorldSpawn====//
		private function get WorldSize():String
		{
			return this.Variables.WorldSize
		}
		
		private function get WorldWidth():uint
		{
			return this.Variables.WorldWidth
		}
		
		private function get WorldHeight():uint
		{
			return this.Variables.WorldHeight
		}
		
		private function get WorldSeed():String
		{
			return this.Variables.WorldSeed
		}
		
		private function get WorldSpawnSeed():int
		{
			return this.Variables.WorldSpawnSeed
		}
		
		private function get WorldSpawnConditions():Array
		{
			return this.Variables.WorldSpawnConditions
		}
		
		private function get PlayerRandomSpawnRange():uint
		{
			return this.Variables.PlayerRandomSpawnRange
		}
		
		private function get VirusMode():String
		{
			return this.Variables.VirusMode
		}
		
		private function get MaxVirusCount():uint
		{
			return this.Variables.MaxVirusCount
		}
		
		private function get VirusSpawnProbability():uint
		{
			return this.Variables.VirusSpawnProbability
		}
		
		//====Physics====//
		public function get Fraction():Number
		{
			return this.Variables.Fraction
		}
		
		private function setWorldSpawnConditions():void
		{
			this.E1=General.IsiA(1,this.WorldSpawnConditions)
			this.E2=General.IsiA(2,this.WorldSpawnConditions)
			this.E3=General.IsiA(3,this.WorldSpawnConditions)
			this.E4=General.IsiA(4,this.WorldSpawnConditions)
			this.E5=General.IsiA(5,this.WorldSpawnConditions)
		}

		//World Tile Spawner
		private function getTileBySeed(X:int=0,Y:int=0):InventoryItem
		{
			var Id:String=TileID.Void;
			var Data:int=0;
			//Barrier Test
			var Condition_Barrier:Boolean=(Math.abs(X)==this.WorldWidth+1||Math.abs(Y)==this.WorldHeight+1)
			if(Condition_Barrier)
			{
				return new InventoryItem(TileID.Barrier)
			}
			//Spawn Block Spawner::Structure 1
			var Condition_Spawner:Boolean=(X==Str_1_X&&Y==Str_1_Y)
			if(Condition_Spawner)
			{
				return new InventoryItem(TileID.Walls_Spawner)
			}
			//Spawn Basic Walls::Structure 1
			var Condition_Wall:Boolean=(Math.abs(X-Str_1_X)+Math.abs(Y-Str_1_Y)==Str_1_Radius)
			if(Condition_Wall)
			{
				if(Math.abs(Str_1_X)%Math.abs(Str_1_Y)==0)
				{
					return new InventoryItem(TileID.Crystal_Wall)
				}
				return new InventoryItem(TileID.Basic_Wall)
			}
			//Spawn Void::Structure 1
			var Condition_Void:Boolean=(Math.abs(X-Str_1_X)+Math.abs(Y-Str_1_Y)<Str_1_Radius)
			if(Condition_Void)
			{
				return new InventoryItem(TileID.Void)
			}
			//Spawn Colored_Block
			var F1:int=General.NumTo1(V1+V2+V3+V4)*Math.abs(Math.floor(V1*V4+Math.abs(X)*V4+V2*Math.abs(Y)))%100+1;//1~100
			var F2:int=Math.floor(V1*V3+V2*V4+Math.abs(X)*Math.abs(Y))%V3+1;//1~30
			var F3:int=Math.floor(V5%4096)*Math.floor(Math.abs(V5+V3*X-V4*Y))%4096//0~16777216
			
			var Condition_1:Boolean,Condition_2:Boolean,Condition_3:Boolean,Condition_4:Boolean,Condition_5:Boolean
			Condition_1=E1&&(Math.abs(X*Y+(V1+V2))%F2==Math.min(F1,F2)%10&&Math.min(X+Y+(V1*V2))%F1==Math.min(F1,F2)%10)
			Condition_2=E2&&(X%2+Y%2==(V1*V2)%(F1%F2)&&(X+Y)%4==(F1%F2)%(V1*V2))
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
				if(Condition_Virus&&VirusCount<MaxVirusCount)
				{
					//trace("Spawn A Virus on",X,Y)
					VirusCount++
					var virusType:uint=Math.abs(F1+X-Y)%4
					switch(virusType)
					{
						case 1:
						return new InventoryItem(TileID.XX_Virus_Red)
						break
						case 2:
						return new InventoryItem(TileID.XX_Virus_Blue)
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
		//Str_1:Walls With A Block Spawner
		private function get Str_1_X():int
		{
			return 32+V2-V4
		}
		
		private function get Str_1_Y():int
		{
			return 15-V3*2+V1
		}
		
		private function get Str_1_Radius():int
		{
			return (V1+V2+V3+V4)%4+5
		}

		//-=-=-=-=-=Structure Functions=-=-=-=-=-//
		private function ResetWorld():void
		{
			//Reset Player
			for(var i:uint=0;i<PlayerCount;i++)
			{
				var player:Player=PlayerList[i];
				player.resetInventory();
				//Give Player A Block Crafter;
				player.AddItem(TileID.Block_Crafter,1,0,TileTag.getTagFromID(TileID.Block_Crafter));
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
			//Reset Tiles:Remove All Tile Sprite
			var X:int
			var Y:int
			removeAllTile()
			//Reset World Variables
			setWorldVariables();
			this.Tiles={}
			//Respawn Tiles
			spawnTiles()
			//Random Spawn Player
			for(var p:uint=0;p<PlayerCount;p++)
			{
				randomSpawnPlayer(player)
			}
			//Reset Stage
			movePosToPlayer(random(PlayerCount)+1)
			//Show Text
			UpdateDebugText();
		}
		
		private function spawnTiles():void
		{
			for(var X:int=-WorldWidth-1;X<=WorldWidth+1;X++)
			{
				for(var Y:int=-WorldHeight-1;Y<=WorldHeight+1;Y++)
				{
					var tile:InventoryItem=getTileBySeed(X,Y);
					var ID:String=tile.Id;
					var Data:int=tile.Data;
					var Tag:TileTag=tile.Tag;
					var Rot:int=tile.Rot;
					setNewTile(X,Y,ID,Data,Tag,Rot);
					TotalSpawnTiles++;
				}
			}
		}
		
		private function setGameDisplay():void
		{
			addChild(this.Tile_Sprite_Back)
			addChild(this.Entities_Sprite)
			addChild(this.Players_Sprite)
			addChild(this.Tile_Sprite_Top)
			stage.addChild(this.DebugText_Sprite)
			this.DebugText_Sprite.addChild(DebugText)
			this.DebugText_Sprite.addChild(DebugText2)
		}

		//--------Player Functions--------//
		private function SpawnPlayer(ID:uint,X:int=0,Y:int=0,color:Number=NaN):Player
		{
			//Spawn New Player
			var player:Player=new Player(this,X*tileSize,Y*tileSize,ID,color);
			PlayerList.push(player);
			regEntity(player)
			//Give Player A Block Crafter;
			player.AddItem(TileID.Block_Crafter,1,0,TileTag.getTagFromID(TileID.Block_Crafter));
			//Add Player To Display;
			Players_Sprite.addChild(player);
			return player;
		}

		private function spawnPx(ID:uint):void
		{
			if(ID>0)
			{
				var Px=SpawnPlayer(PlayerCount+1,0,0);
				this.Players_Sprite.setChildIndex(Px,0);
				this.randomSpawnPlayer(Px)
				this.movePosToPlayer(ID)
				UpdateDebugText(2);
			}
		}

		public function getPx(ID:uint):Player
		{
			if(ID>0&&ID<=PlayerCount)
			{
				return (PlayerList[ID-1] as Player);
			}
			return null;
		}

		//============Display Functions============//
		//Getters
		public function get ZoomX():Number
		{
			return this.ZoomScaleX
		}
		
		public function get ZoomY():Number
		{
			return this.ZoomScaleY
		}
		
		private function get TileDisplaySizeX():Number
		{
			return Game.tileSize*this.ZoomScaleX
		}
		
		private function get TileDisplaySizeY():Number
		{
			return Game.tileSize*this.ZoomScaleY
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
			return (Game.displayWidth-this.stage.stageWidth)/2
		}
		
		private function get displayOffsetY():Number
		{
			return (Game.displayHeight-this.stage.stageHeight)/2
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
			return this.x/this.TileDisplaySizeX
		}
		
		private function get displayY():Number
		{
			return this.y/this.TileDisplaySizeY
		}
		
		//----====Main Functions====----//
		private function BorderTest(player:Player):void
		{
			var rX:Number=player.getX()+this.displayX;
			var rY:Number=player.getY()+this.displayY;
			var Rot:int=player.Rot
			if(General.isBetween(rX,TileDisplayOffsetX,BorderWidth+TileDisplayOffsetX)&&Rot==Mobile.Facing_Left||
			   General.isBetween(rX,TileDisplayWidth-BorderWidth+TileDisplayOffsetX,TileDisplayWidth+TileDisplayOffsetX)&&Rot==Mobile.Facing_Right)//X
			{
				StageMove((Rot+1)%4+1,1);
			}
			if(General.isBetween(rY,TileDisplayOffsetY,BorderHeight+TileDisplayOffsetY)&&Rot==Mobile.Facing_Up||
			   General.isBetween(rY,TileDisplayHeight-BorderHeight+TileDisplayOffsetY,TileDisplayHeight+TileDisplayOffsetY)&&Rot==Mobile.Facing_Down)//Y
			{
				StageMove((Rot+1)%4+1,1);
			}
		}

		private function StageMove(dir:int,dis:Number=1):void
		{
			var Pos:Array=[0,0];
			switch((dir-1)%4+1)
			{
				case 1:
					Pos=[dis,0];
					break;
				case 2:
					Pos=[0,dis];
					break;
				case 3:
					Pos=[-dis,0];
					break;
				case 4:
					Pos=[0,-dis];
					break;
			}
			StageMoveTo(this.displayX+Pos[0],this.displayY+Pos[1]);
		}
		
		private function movePosToPlayer(ID:uint):void
		{
			var playerPoint:Point=new Point(this.getPx(ID).x,this.getPx(ID).y)
			var lp:Point=this.localToGlobal(playerPoint)
			var moveX:Number=this.x+middleDisplayX-lp.x
			var moveY:Number=this.y+middleDisplayY-lp.y
			StageMoveTo(moveX,moveY,false);
		}

		private function StageMoveTo(X:Number,Y:Number,sizeBuff:Boolean=true):void
		{
			if(sizeBuff)
			{
				this.x=X*this.TileDisplaySizeX;
				this.y=Y*this.TileDisplaySizeY;
			}
			else
			{
				this.x=X;
				this.y=Y;
			}
		}
		
		private function SetZoom(Mode:String,Num1:Number=NaN,Num2:Number=NaN,...Parameters):void
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
			var newScaleX:Number=this.ZoomScaleX
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				newScaleX+=0.125//(this.TileDisplayRadiusX+1)/this.TileDisplayRadiusX
			}
			while(newScaleX==0)
			ZoomSet(newScaleX,this.ZoomScaleY)
		}
		
		private function ZoomInY():void
		{
			var newScaleY:Number=this.ZoomScaleY
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				newScaleY+=0.125//(this.TileDisplayRadiusY+1)/this.TileDisplayRadiusY
			}
			while(newScaleY==0)
			ZoomSet(this.ZoomScaleX,newScaleY)
		}
		
		private function ZoomOn():void
		{
			ZoomOnX()
			ZoomOnY()
		}
		
		private function ZoomOnX():void
		{
			var newScaleX:Number=this.ZoomScaleX
			do
			{
				//if(this.TileDisplayRadiusX==0) continue;
				newScaleX-=0.125//(this.TileDisplayRadiusX-1)/this.TileDisplayRadiusX
			}
			while(newScaleX==0)
			ZoomSet(newScaleX,this.ZoomScaleY)
		}
		
		private function ZoomOnY():void
		{
			var newScaleY:Number=this.ZoomScaleY
			do
			{
				//if(this.TileDisplayRadiusY==0) continue;
				newScaleY-=0.125//(this.TileDisplayRadiusY-1)/this.TileDisplayRadiusY
			}
			while(newScaleY==0)
			ZoomSet(this.ZoomScaleX,newScaleY)
		}
		
		private function ZoomSet(Num1:Number,Num2:Number=NaN):void
		{
			if(!isNaN(Num1))
			{
				var point0:Point=new Point(middleDisplayX,middleDisplayY)
				var point:Point=this.globalToLocal(point0)
				this.scaleX=Num1
				if(isNaN(Num2))//One Scale
				{
					this.scaleY=Num1
				}
				else//Two Scale
				{
					this.scaleY=Num2
					this.ZoomScaleY=Num2
				}
				this.ZoomScaleX=this.scaleX
				this.ZoomScaleY=this.scaleY
				var lp:Point=this.localToGlobal(point)
				var lp2:Point=point0
				this.x+=lp2.x-lp.x
				this.y+=lp2.y-lp.y
				//Update Debug Text
				UpdateDebugText(1)
			}
		}

		//==========Listener Functions==========//
		private function OnKeyDown(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			var ctrl:Boolean=E.ctrlKey
			var alt:Boolean=E.altKey
			var shift:Boolean=E.shiftKey
			LastKey=Code;
			UpdateDebugText(1);
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
					UpdateDebugText(-3)
				}
				else
				{
					if(ctrl)
					{
						UpdateDebugText(-1)
					}
					if(shift)
					{
						UpdateDebugText(-2)
					}
				}
			}
			//Rescale By F2 or Shift+F2
			if(Code==113)//F2
			{
				if(shift)
				{
					SetZoom("On")
				}
				else
				{
					SetZoom("In")
				}
			}
			//Give A Item By Ctrl+Num
			if(ctrl&&!shift&&Code>48&&Code<58&&Code-48<=TileSystem.TotalTileCount)
			{
				PlayerList[0].AddItem(TileSystem.AllTileID[Code-48],1,0,TileTag.getTagFromID(TileSystem.AllTileID[Code-48]));
				return;
			}
			//Spawn New Player By Ctrl+Shift+1~4
			if(ctrl&&shift&&Code>48&&Code<58&&Code-49==PlayerCount&&Code-48<=LimitPlayerCount)
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

		private function OnKeyUp(E:KeyboardEvent):void
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
			if(randomTickCount>0&&randomTime>0)
			{
				if(randomTick+TimeDistance>=randomTime)
				{
					randomTick=0
					for(var d=0;d<randomTickCount;d++)
					{
						var ranX=random(WorldWidth*2+1)-WorldWidth
						var ranY=random(WorldHeight*2+1)-WorldHeight
						onRandomTick(ranX,ranY,getTileID(ranX,ranY),
									 getTileData(ranX,ranY),getTileTag(ranX,ranY),getTileRot(ranX,ranY))
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
			//=====Player Set=====//
			for each(var player:Player in this.PlayerList)
			{
				if(player!=null)
				{
					player.UpdateKeyDelay()
					player.DealKeyContol()
				}
			}
			//Reset Timer
			LastTime+=TimeDistance;
		}
		
		private function ResizeDebugText(E:Event=null):void
		{
			//====Rescale Debug Text====//
			if(this.DebugText.visible)
			{
				this.DebugText.width=this.DebugText.textWidth+10
				this.DebugText.height=this.DebugText.textHeight+10
				this.DebugText.x=-(stage.stageWidth-Game.displayWidth)/2
				this.DebugText.y=-(stage.stageHeight-Game.displayHeight)/2
			}
			if(this.DebugText2.visible)
			{
				this.DebugText2.width=this.DebugText2.textWidth+10
				this.DebugText2.height=this.DebugText2.textHeight+10
				this.DebugText2.x=(stage.stageWidth+Game.displayWidth)/2-this.DebugText2.width
				this.DebugText2.y=-(stage.stageHeight-Game.displayHeight)/2
			}
		}
		
		//----------Player Functions----------//
		public function PlayerMove(player:Player,Rot:uint,Distance:uint):void
		{
			if(player!=null)
			{
				player.Rot=Rot;
				var pX:int=player.getX();
				var pY:int=player.getY();
				var mX:int=player.getX()+Mobile.getPos(Rot,Distance/tileSize)[0];
				var mY:int=player.getY()+Mobile.getPos(Rot,Distance/tileSize)[1];
				if(testMove(player,mX,mY,pX,pY))
				{
					//Border Test
					BorderTest(player)
					//Real Move
					player.MoveByDir(Rot,Distance,false);
					UpdateDebugText(2);
				}
				//Push
				else if(isTile(mX,mY)&&getTileTag(mX,mY).pushable)
				{
					//Test Push
					var moveX:int=mX+Mobile.getPos(Rot)[0]
					var moveY:int=mY+Mobile.getPos(Rot)[1]
					if(isTile(moveX,moveY))
					{
						if(getTileTag(moveX,moveY).canPass)
						{
							cloneTile(mX,mY,moveX,moveY,"Move",getTileHard(mX,mY))
						}
					}
					//Test Again
					if(testMove(player,mX,mY,pX,pY))
					{
						//Border Test
						BorderTest(player)
						//Real Move
						player.MoveByDir(Rot,Distance,false);
						UpdateDebugText(2);
					}
					//Set After Push
					mX=moveX
					mY=moveY
				}
				//Use
				if(isTile(mX,mY)&&getTileTag(mX,mY).canUse&&player.Ability.CanUseBlock)
				{
					onBlockUse(mX,mY,player,Rot,getTileID(mX,mY),getTileData(mX,mY),getTileTag(mX,mY),getTileRot(mX,mY));
				}
			}
		}

		public function PlayerUse(player:Player,Distance:uint):void
		{
			if(player!=null)
			{
				var Rot=player.getRot();
				var frontX:int=player.getX()+Mobile.getPos(Rot,Distance/tileSize)[0];
				var frontY:int=player.getY()+Mobile.getPos(Rot,Distance/tileSize)[1];
				var block:Tile=getTileObject(frontX,frontY);
				var blockID:String=getTileID(frontX,frontY);
				var blockData:int=getTileData(frontX,frontY);
				var blockTag:TileTag=getTileTag(frontX,frontY);
				var blockHard:uint=getTileHard(frontX,frontY);
				var blockMaxHard:uint=getTileMaxHard(frontX,frontY);
				var blockRot:int=getTileRot(frontX,frontY);
				var blockDropItems:ItemInventory=getTileDropItems(frontX,frontY);
				var Destroy:Boolean=true;
				var Place:Boolean=true;
				//trace(frontX,frontY,getTileObject(frontX,frontY))
				//Destroy Block
				if(player.Ability.CanDestroy&&Destroy)
				{
					if(isTile(frontX,frontY))
					{
						//blockID>0
						if(block.Tag.canDestroy)
						{
							if(blockHard>1&&!player.Ability.InstantDestroy)
							{
								destroyBlock(frontX,frontY);
							}
							else
							{
								//Clean Item
								if(!player.SelectAItem||
									player.SelectAItem&&!block.Tag.canPlaceBy)
								{
									//Give Items
									if(block.Tag.canGet)
									{
										DropItem(frontX,frontY);
									}
								}
								//Real Destroy
								block.clearDestroyStage();
								setVoid(frontX,frontY);
								Place=false;
								//Set Hook
								onBlockDestroy(frontX,frontY,player,Rot,blockID,blockData,blockTag,blockRot);
							}
						}
					}
				}
				//Place Block
				if(player.SelectAItem&&player.Ability.CanPlace&&Place)
				{
					var PlaceId:String=player.SelectedItem.Id;
					var PlaceData:int=player.SelectedItem.Data;
					var PlaceTag:TileTag=player.SelectedItem.Tag;
					var PlaceRot:int=0
					if(PlaceTag.canRotate)
					{
						PlaceRot=Mobile.MoblieRotToTileRot(player.Rot)
					}
					//trace(player.SelectedItem.Tag.canPlace,block.Tag.canPlaceBy)
					if(!detectEntity(frontX,frontY)&&block!=null)
					{
						if(player.SelectedItem.Count>0&&
						   PlaceTag.canPlace&&
						   block.Tag.canPlaceBy)
						{
							//Real Place
							player.RemoveItem(PlaceId,1,player.SelectedItem.Data,PlaceTag,PlaceRot);
							setTile(frontX,frontY,PlaceId,PlaceData,PlaceTag,PlaceRot);
							UpdateDebugText(2);
							//Set Hook
							onBlockPlace(frontX,frontY,player,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot);
						}
						else if(player.SelectedItem.Count>0&&player.Ability.CanUseItem)
						{
							onItemUse(frontX,frontY,player,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot);
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

		//--------Entity Functions--------//
		private function get EntityCount():uint
		{
			if(EntityList.length>0)
			{
				return EntityList.length;
			}
			return 0;
		}

		private function regEntity(Ent:Entity):void
		{
			this.EntityList.push(Ent)
			this.EntityUUIDList.push(Ent.UUID)
		}
		
		public function removeEntity(Ent:Entity):void
		{
			General.SinA(Ent.UUID,EntityUUIDList)
			General.SinA(Ent.UUID,EntityUUIDList)
		}
		
		private function testMove(Mob:Mobile,tx:int,ty:int,sx:int,sy:int):Boolean
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
		
		public function detectEntity(X:int,Y:int):Boolean
		{
			if(testEntity(X,Y)!=null&&(testEntity(X,Y) as Entity).hasCollision)
			{
				return true
			}
			return false
		}
		
		public function spawnItem(X:Number,Y:Number,
								  Id:String=TileID.Colored_Block,
								  Count:uint=1,Data:int=0,
								  Tag:TileTag=null,Rot:int=0,
								  xd:Number=NaN,yd:Number=NaN,vr:Number=NaN):void
		{
			var item:Item=new Item(this,X*tileSize,
								   Y*tileSize,
								   Id,Count,Data,Tag,Rot,xd,yd,vr)
			this.Entities_Sprite.addChild(item)
			this.Entities_Sprite.setChildIndex(item,0)
			regEntity(item)
		}
		
		public function detectItem(item:Item):void
		{
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
			//Detect Players
			for(var i:uint=0;i<this.PlayerCount;i++)
			{
				var p:Player=this.PlayerList[i] as Player
				//Detect Distance
				if(General.getDistance(item.x,item.y,p.x,p.y)<item.Radius+p.Radius)
				{
					if(item.pickupTime<=0)
					{
						p.AddItem(item.Id,item.Count,item.Data,item.Tag,item.Rot)
						item.pickupTime=16777216
						item.scaleAndMove(p.x,p.y,0,0.1)
					}
				}
			}
		}
		
		private function DropItem(X:int,Y:int):void
		{
			//Drop Items
			var blockID:String=getTileID(X,Y);
			var blockData:int=getTileData(X,Y);
			var blockTag:TileTag=getTileTag(X,Y);
			var blockHard:uint=getTileHard(X,Y);
			var blockMaxHard:uint=getTileMaxHard(X,Y);
			var blockRot:int=getTileRot(X,Y);
			var blockDropItems:ItemInventory=getTileDropItems(X,Y);
			if(blockDropItems!=null)
			{
				for(var i:uint=0;i<blockDropItems.TypeCount;i++)
				{
					var giveItem:InventoryItem=blockDropItems.getItemAt(i)
					var giveId:String=giveItem.Id
					var giveCount:int=giveItem.Count
					var giveData:int=giveItem.Data
					var giveTag:TileTag=giveItem.Tag.getCopy()
					var giveRot:int=giveItem.Rot
					spawnItem(X,Y,giveId,giveCount,giveData,giveTag,giveRot);
				}
			}
			else
			{
				spawnItem(X,Y,blockID,1,blockData,blockTag,0);
			}
		}

		//--------Tile Functions--------//
		private function setNewTile(X:int=0,Y:int=0,Id:String=TileID.Void,
									Data:int=0,Tag:TileTag=null,Rot:int=0,
									Level:String=TileSystem.Level_Top):Tile
		{
			if(getTileObject(X,Y)==null)
			{
				var tile=new Tile(X*tileSize,Y*tileSize,Id,Data,Tag,Rot,Level);
				if(tile!=null)
				{
					Tiles[X+"_"+Y]=tile;
				}
				addTileByLevel(tile)
				return tile;
			}
			return null;
		}
		
		private function addTileByLevel(tile:Tile):void
		{
			switch(tile.Level)
			{
				case TileSystem.Level_Back:
				this.Tile_Sprite_Back.addChild(tile)
				break
				default:
				this.Tile_Sprite_Top.addChild(tile)
				break
			}
		}
		
		private function removeTileByLevel(tile:Tile):void
		{
			switch(tile.Level)
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
			if(isTile(X,Y))
			{
				var tile:Tile=(getTileObject(X,Y) as Tile)
				tile.removeSelf()
				this.Tiles[X+"_"+Y]=null
			}
		}
		
		private function removeAllTile():void
		{
			for(var i in this.Tiles)
			{
				if(Tiles[i] is Tile)
				{
					var tile:Tile=Tiles[i]
					tile.removeSelf()
					Tiles[i]=null
				}
			}
		}
		
		private function snapToGrid(x:Number):int
		{
			return Math.floor(x/tileSize)
		}
		
		//Getters
		public function getTileObject(X:int,Y:int):Tile
		{
			if(Tiles[X+"_"+Y] is Tile)
			{
				return (Tiles[X+"_"+Y] as Tile);
			}
			return null;
		}

		public function isTile(X:int,Y:int):Boolean
		{
			if(getTileObject(X,Y)!=null)
			{
				return true
			}
			return false;
		}

		public function getTileX(tile:Tile):int
		{
			return tile.x/tileSize;
		}

		public function getTileY(tile:Tile):int
		{
			return tile.y/tileSize;
		}

		public function getTile(X:int,Y:int):Array
		{
			if(isTile(X,Y))
			{
				return [getTileID(X,Y),getTileData(X,Y),getTileTag(X,Y),getTileRot(X,Y)];
			}
			return null;
		}

		public function getTileID(X:int,Y:int):String
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).ID;
			}
			return null;
		}

		public function getTileData(X:int,Y:int):int
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).Data;
			}
			return -1;
		}

		public function getTileTag(X:int,Y:int):TileTag
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).Tag;
			}
			return null;
		}
		
		public function getTileHard(X:int,Y:int):int
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).Hard
			}
			return -1
		}
		
		public function getTileMaxHard(X:int,Y:int):int
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).MaxHard
			}
			return -1
		}
		
		public function getTileRot(X:int,Y:int):int
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).Rot;
			}
			return 0;
		}
		
		public function getTileDropItems(X:int,Y:int):ItemInventory
		{
			if(isTile(X,Y))
			{
				return getTileObject(X,Y).DropItems;
			}
			return null;
		}
		
		//Setters
		private function destroyBlock(X:int,Y:int):void
		{
			if(isTile(X,Y))
			{
				var block:Tile=getTileObject(X,Y)
				if(block.Tag.canDestroy&&getTileHard(X,Y)>1)
				{
					block.setHardness(block.Hard-1)
				}
			}
		}
		
		private function setVoid(X:int,Y:int):void
		{
			if(isTile(X,Y))
			{
				setTile(X,Y,TileID.Void,0)
			}
		}
		
		private function setTileHard(X:int,Y:int,Hard:uint):void
		{
			if(isTile(X,Y))
			{
				var block=getTileObject(X,Y)
				block.setHardness(Math.min(getTileMaxHard(X,Y),Math.max(Hard,0)))
			}
		}
		
		private function setTileRot(X:int,Y:int,Rot:int):void
		{
			if(isTile(X,Y))
			{
				var block=getTileObject(X,Y)
				block.setRotation(Math.min(3,Math.max(Rot%4,-3)))
			}
		}

		private function setTile(X:int,Y:int,Id:String,Data:int=0,
								 Tag:TileTag=null,Rot:int=0,Hard:uint=0):Boolean
		{
			var tile:Tile=getTileObject(X,Y);
			if(tile!=null)
			{
				tile.changeTile(Id,Data,Tag,Rot);
				if(TileSystem.getHardnessFromID(Id)!=0&&Hard==0)
				{
					tile.setHardness(tile.MaxHard)
				}
				else
				{
					tile.setHardness(Hard)
				}
				return true;
			}
			return false;
		}
		
		//--------Pro Block Functions--------//
		private function cloneTile(x1:int,y1:int,x2:int,y2:int,Mode:String="Replace",Hardness:uint=0):void
		{
			var oId:String=getTileID(x1,y1)
			var oData:int=getTileData(x1,y1)
			var oTag:TileTag=getTileTag(x1,y1)
			var oRot:int=getTileRot(x1,y1)
			var oHard:uint=getTileHard(x1,y1)
			var tId:String=getTileID(x2,y2)
			var tData:int=getTileData(x2,y2)
			var tTag:TileTag=getTileTag(x2,y2)
			var tRot:int=getTileRot(x2,y2)
			var tHard:uint=getTileHard(x2,y2)
			if(Mode.toLowerCase().indexOf("keep")>=0&&!tTag.canPlaceBy) return
			if(Mode.toLowerCase().indexOf("move")>=0) setVoid(x1,y1)
			if(Mode.toLowerCase().indexOf("destroy")>=0) DropItem(x2,y2)
			setTile(x2,y2,oId,oData,oTag,oRot,oHard)
		}

		//--------Hook Functions--------//
		private function onBlockDestroy(X:int,Y:int,P:Mobile,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
			//spawnItem(X*tileSize,Y*tileSize,Id,1,Data,Tag,Rot)
		}

		private function onBlockPlace(X:int,Y:int,P:Mobile,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
		}
		
		private function onItemUse(X:int,Y:int,P:Mobile,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
		}

		private function onBlockUse(X:int,Y:int,P:Player,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			var block:Tile=getTileObject(X,Y)
			switch(Id)
			{
				//Color Mixer:Mix Color
				case TileID.Color_Mixer:
					var MixBlocks:Array=getCanMixBlocks(X,Y);
					var BlockColors:Array=General.getPropertyInObject(MixBlocks,"Data");
					//====HSV====
					var BlockColorsH:Array=[];
					var BlockColorsS:Array=[];
					var BlockColorsV:Array=[];
					var c;
					for(c in BlockColors)
					{
						BlockColorsH.push(Color.HEXtoHSV(BlockColors[c])[0]);
						BlockColorsS.push(Color.HEXtoHSV(BlockColors[c])[1]);
						BlockColorsV.push(Color.HEXtoHSV(BlockColors[c])[2]);
					}
					var AverageColorH:uint=Math.round(General.getAverage(BlockColorsH));
					var AverageColorS:uint=Math.round(General.getAverage(BlockColorsS));
					var AverageColorV:uint=Math.round(General.getAverage(BlockColorsV));
					var AverageColor:uint=Color.HSVtoHEX([AverageColorH,AverageColorS,AverageColorV]);
					var i;
					for(i in MixBlocks)
					{
						var t=MixBlocks[i];
						var tX=getTileX(t);
						var tY=getTileY(t);
						var tI=t.ID;
						var tT=t.Tag;
						setTile(tX,tY,tI,AverageColor,tT);
					}
					break;
					//Block Crafter:Craft Blocks
				case TileID.Block_Crafter:
					var Slot:Array=new Array();
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
					if(canCraft)
					{
						for(var I=0;I<Craft_Recipes.length;I++)
						{
							var CR:CraftRecipe=Craft_Recipes[I]
							canCraft=TestCanCraft(Slot,CR)
							if(canCraft)
							{
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
													spawnItem(X+0.5,Y,returnId,returnCount,returnData,
															  returnTag,returnRot,tileSize*1.5)
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
								if(successfulCraft) break
							}
						}
					}
					break;
				//Inventory Block:Input Or Output Items
				case TileID.Inventory_Block:
					if(P.hasInventory)
					{
						var giveItem:InventoryItem
						switch(Pos)
						{
							//Upload
							case Mobile.Facing_Up:
								if(P.InventorySelect>0)
								{
									giveItem=P.SelectedItem
									block.AddItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
									P.RemoveItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
								}
								break
							//Download
							case Mobile.Facing_Down:
								if(block.Inventory.hasItem)
								{
									block.Inventory.Select=block.Inventory.TypeCount
									giveItem=block.Inventory.SelectItem
									block.RemoveItem(giveItem.Id,1,giveItem.Data,giveItem.Tag,giveItem.Rot)
									spawnItem(X,Y+0.5,giveItem.Id,1,giveItem.Data,
											  giveItem.Tag,giveItem.Rot,NaN,tileSize*1.5)
								}
							break
							case Mobile.Facing_Left:
							break
							case Mobile.Facing_Right:
							break
						}
					}
					break;
			}
		}

		private function onRandomTick(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			if(Tag==null||!Tag.allowRandomTick) return
			var cx:int
			var cy:int
			var xd:int
			var yd:int
			var bId:String
			switch(Id)
			{
				//Block Spawner & Walls Spawner
				case TileID.Walls_Spawner:
				case TileID.Block_Spawner:
				for(var Xl:int=-2;Xl<=2;Xl++)
				{
					for(var Yl:int=-2;Yl<=2;Yl++)
					{
						if(Xl==0&&Yl==0) continue;
						if(isTile(X+Xl,Y+Yl)&&
						   !detectEntity(X+Xl,Y+Yl))
						{
							if(getTileTag(X+Xl,Y+Yl)!=null)
							{
								if(getTileTag(X+Xl,Y+Yl).canPlaceBy||
							 	   getTileID(X+Xl,Y+Yl)==TileID.XX_Virus)//&&getTileData(X+Xl,Y+Yl)>0
								{
									var r:uint=10
									var r2:uint=5
									var t:InventoryItem=getTileBySeed(X+random(r)-random(r),
																	  Y+random(r)-random(r))
									if(Id==TileID.Block_Spawner&&
									   t.Id==TileID.Colored_Block&&
									   randomBoolean(1/r2))
									{
										setTile(X+Xl,Y+Yl,t.Id,t.Data,t.Tag,t.Rot)
										return
									}
									else if(Id==TileID.Walls_Spawner&&
											randomBoolean(1/r2/3))
									{
										if(randomBoolean(1/4))
										{
											setTile(X+Xl,Y+Yl,TileID.Crystal_Wall)
										}
										else
										{
											setTile(X+Xl,Y+Yl,TileID.Basic_Wall)
										}
										return
									}
								}
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
						if(General.getDistance2(X-cx,Y-cy)>=1.125)
						{
							if(getTileID(cx,cy)==TileID.Void)
							{
								setTile(cx,cy,Id,Data+2+random(2)*(random(2)+1))
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
							}
						}
						else
						{
							if(getTileHard(cx,cy)>1)
							{
								destroyBlock(cx,cy)
							}
							else if(randomBoolean(1/3))
							{
								cloneTile(X,Y,cx,cy)
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
							}
							else if(getTileID(cx,cy)==TileID.Void)
							{
								setTile(cx,cy,Id,Data+2+random(2)*(random(2)+1))
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
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
						bId=getTileID(cx,cy)
						//Influence
						if(bId!=TileID.XX_Virus_Red)
						{
							if(bId!=TileID.Void||
							   detectEntity(cx,cy)||
							   bId==TileID.Void&&random(128)==0)
							{
								if(getTileHard(cx,cy)>1)
								{
									destroyBlock(cx,cy)
								}
								else
								{
									cloneTile(X,Y,cx,cy)
									setTileHard(cx,cy,getTileMaxHard(cx,cy))
								}
							}
						}
					}
				}
				break
				//XX Virus Blue
				case TileID.XX_Virus_Blue:
				for(var C:uint=0;C<9;C++)
				{
					xd=random(2)*2-1
					yd=random(2)*2-1
					cx=X+xd
					cy=Y+yd
					if(!isTile(cx,cy)) continue;
					if(Math.abs(xd)==Math.abs(yd)&&xd==0) continue;
					bId=getTileID(cx,cy)
					//Recover
					if(bId==TileID.XX_Virus_Blue)
					{
						if(getTileHard(cx,cy)<getTileMaxHard(cx,cy))
						{
							setTileHard(cx,cy,getTileHard(cx,cy)+1)
						}
					}
					else if(bId==TileID.Void&&!detectEntity(cx,cy))
					{
						cloneTile(X,Y,cx,cy,"Move")
						setTileHard(X,Y,1)
						return
					}
					else
					{
						for(var i:uint=0;i<2+random(3);i++)
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
			}
		}
		
		//--------Condition Functions--------//
		private function getCanMixBlocks(X,Y,pastArr:Array=null):Array
		{
			var nowBlock=getTileObject(X,Y);
			var nowId=getTileID(X,Y);
			var memoryArr:Array=[];
			var returnArr:Array=[];
			var Str:String=String(X)+"_"+String(Y);
			if(pastArr!=null)
			{
				memoryArr=pastArr;
			}
			if(nowBlock==null)
			{
				return returnArr;
			}
			else if(pastArr!=null)
			{
				if(General.IsiA(Str,memoryArr))
				{
					return returnArr;
				}
			}
			memoryArr.push(Str);
			if(nowId==TileID.Colored_Block)
			{
				returnArr.push(nowBlock);
			}
			else if(nowId==TileID.Color_Mixer)
			{
				returnArr=returnArr.concat(getCanMixBlocks((X+1),Y,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks((X-1),Y,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks(X,Y+1,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks(X,Y-1,memoryArr));
			}
			return returnArr;
		}

		private function TestCanCraft(Input:Array,Pattern:CraftRecipe):Boolean
		{
			//trace("TestCraft:"+arguments+";"+General.isEqualArray(SI,NSI)+","+General.isEqualArray(SD,NSD))
			return Pattern.testCanCraft(Input)
		}

		//--------Other Functions--------//
		public static function get versionStage():String
		{
			return Game.Version.split(" ")[0]
		}
		
		public static function get versionMajor():String
		{
			return Game.Version.split(" ")[1]
		}
		
		public static function get versionBuild():String
		{
			//[2] is "build"
			return Game.Version.split(" ")[3]
		}
		
		public function get gameFPS():uint
		{
			return this.gameFramePerSecond;
		}

		public function UpdateDebugText(textNum:int=0):void
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
						DTT+=GameName+" "+Version;
						DTT+="\n"+gameFPS+" FPS";
						DTT+="\n\nWorldSeed="+WorldSeed+"\nWorldSpawnConditions="+WorldSpawnConditions;
						DTT+="\nV1="+V1+",V2="+V2+",V3="+V3+",V4="+V4;
						DTT+="\nWorldWidth="+(WorldWidth*2+1)+",WorldHeight="+(WorldHeight*2+1);
						DTT+="\n"+General.NTP(TotalSpawnTiles/ShouldSpawnTiles)+" tiles loaded";
						DTT+="\nWorldSize="+WorldSize;
						DTT+="\nVirusMode="+VirusMode;
						DTT+="\n"+VirusCount+" virus spawn in the world";
						DTT+="\n\nLastKeyCode="+LastKey;
						DTT+="\nstageWidth="+stage.stageWidth+",stageHeight="+stage.stageHeight
						DTT+="\nZoomX="+General.NTP(this.ZoomScaleX,2)+",ZoomY="+General.NTP(this.ZoomScaleY,2);
						this.DebugText.text=DTT;
						ResizeDebugText()
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
						ResizeDebugText()
					}
				}
			}
		}

		public function CleanDebugText(textNum:uint=0):void
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
		
		private function FPSUpdate(E:TimerEvent):void
		{
			UpdateDebugText(1);
		}

		//--------Math Functions Copy By General--------//
		public static function random(x:Number):uint
		{
			return General.random(x)
		}
		
		public static function randomBoolean(x:Number):Boolean
		{
			return General.randomBoolean(x)
		}
	}
}