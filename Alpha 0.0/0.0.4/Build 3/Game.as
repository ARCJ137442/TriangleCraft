﻿package 
{
	import Tile;
	import TileSystem;
	import TileTag;
	import Entity;
	import EntitySystem;
	import Player;
	import General;
	import InventoryItem;
	import CraftRecipe;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class Game extends Sprite
	{
		//=====STATIC CONST=====//
		//About This Game
		public static const GameName:String="Triangle Craft";
		public static const Version:String="Alpha 0.0.4 build 3";
		public const isTriangleCraft:Boolean=true

		//Tile System
		private static const tileSize:uint=TileSystem.globalTileSize;
		private static const displayWidth:uint=672;
		private static const displayHeight:uint=672;
		private static const Width:uint=displayWidth/tileSize;
		private static const Height:uint=displayHeight/tileSize;
		private static const BorderWidth:uint=tileSize*3;
		private static const BorderHeight:uint=tileSize*3;

		//World
		private static const allowInfinityWorld:Boolean=false;
		private static const WorldTypes:Array=["Infinity","Random","Mini","Small","Medium","Large","Giant","Long","Deep"];

		//Player
		private static const LimitPlayerCount:uint=4;
		private static const PlayerColorByID:Array=[0x66CCFF,0xFF6666,0xFFFF66,0x66FF66,0x66FFFF,0x6666FF,0xCC66FF,0x66FFCC,0xFF66CC];
		
		//Physics
		public static const Fraction:Number=1/64

		//DebugText
		private static const MainFormet:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"left");
		private static const MainFormet2:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"right");
		private static const emableRadomTickOutPut:Boolean=false
		
		//Game Rule
		private static const GamePlayModes:Array=["Default","VirusStrom"]
		private static const DefaultMaxVirusCount:uint=3
		private static const DefaultVirusSpawnProbability:uint=512//==1/x==//

		//=====PRIVATE|PUBLIC VAR=====//
		//World Spawn
		private var WorldType:String;
		private var WorldWidth:uint;
		private var WorldHeight:uint;
		private var WorldSpawnSeed:int;
		private var V1:int;
		private var V2:int;
		private var V3:int;
		private var V4:int;
		private var V5:int;
		private var ShouldSpawnTiles:uint;
		private var TotalSpawnTiles:uint=0;

		//Tile System
		private var Tile_Sprite_Top:Sprite=new Sprite();
		private var Tile_Sprite_Back:Sprite=new Sprite();
		private var WorldBorder_Sprite:Sprite=new Sprite();
		private var Tiles:Object={};

		//Entities
		private var PlayerList:Array=[];
		private var EntityList:Array=[];
		private var EntityUUIDList:Array=[];
		private var Players_Sprite:Sprite=new Sprite();
		private var Entities_Sprite:Sprite=new Sprite();

		//DebugText
		private var DebugText:TextField=new TextField  ;
		private var DebugText2:TextField=new TextField  ;
		private var LastTime:uint=getTimer();
		private var LastKey:uint=0;
		private var gameFrames:Number=0;
		private var gameFramesRefrashTick:uint=0;
		private var gameFramesRefrashTime:uint=8;

		//Crafting Recipes
		private var Craft_Recipes:Array=new Array();
		
		//Game Rule
		private var GamePlayMode:String="Default"
		private var randomTickCount:uint=1
		private var VirusCount:uint=0
		private var MaxVirusCount:uint=DefaultMaxVirusCount
		private var VirusSpawnProbability:uint=DefaultVirusSpawnProbability
		
		//Random Tick
		private var randomTick:uint=0
		private var randomTime:Number=1000/32

		//--------Game Load Function--------//
		public function Game(Type:String=null,Width:uint=0,Height:uint=0):void
		{
			if(Width>0) WorldWidth=Width;
			if(Height>0) WorldHeight=Height;
			if(Type!=null) WorldType=Type;
			addEventListener(Event.ADDED_TO_STAGE,onGameLoaded);
		}

		private function onGameLoaded(E:Event):void
		{
			//Trace Seed:trace("Seed is",WorldSpawnSeed);
			setWorldVariables();
			setWorldDisplay();
			loadDefaultRecipes();
			//Set Pos
			x=displayWidth/2;
			y=displayHeight/2;
			//Spawn Player
			var P1=SpawnPlayer(PlayerColorByID[0],PlayerCount+1,0,0);
			//Spawn Tile
			for(var X:int=-WorldWidth;X<=WorldWidth;X++)
			{
				for(var Y:int=-WorldHeight;Y<=WorldHeight;Y++)
				{
					var Tile:Array=getTileBySeed(X,Y);
					var TileID:String=Tile[0];
					var TileData:int=Tile[1];
					setNewTile(X,Y,TileID,TileData);
					TotalSpawnTiles++;
				}
			}
			//Set DebugText
			stage.addChild(DebugText);
			DebugText.selectable=false;
			DebugText.width=displayWidth;
			DebugText.height=displayHeight;
			DebugText.defaultTextFormat=MainFormet;

			stage.addChild(DebugText2);
			DebugText2.selectable=false;
			DebugText2.width=displayWidth;
			DebugText2.height=displayHeight;
			DebugText2.defaultTextFormat=MainFormet2;
			UpdateDebugText();
			//addEventListener
			stage.addEventListener(KeyboardEvent.KEY_DOWN,OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,OnKeyUp);
			stage.addEventListener(Event.ENTER_FRAME,EnterFrame);
			//removeEventListener
			removeEventListener(Event.ADDED_TO_STAGE,onGameLoaded)
		}

		private function loadDefaultRecipes():void
		{
			/*
			>--Recipe Rules--<
			0:NeedIds
			1:NeedDatas
			2:NeedTags
			3:OutputId
			4:OutputData
			5:OutputTag
			>--Recipe Rules--<
			*/
			//Color Mixer
			//Gr R Gr
			//B [] G
			//Gr Y Gr
			Craft_Recipes.push([
			[Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Void,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block],
			[0x888888,0xff0000,0x888888,
			0xff,null,0xff00,
			0x888888,0xffff00,0x888888],
			[null,Tile.Color_Mixer,null,
			 Tile.Color_Mixer,null,Tile.Color_Mixer,
			null,Tile.Color_Mixer,null],
			 0,null]);
			//Block Crafter
			//G G G
			//B B B
			//G G G
			Craft_Recipes.push([
			[Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Void,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block],
			[0x888888,0x888888,0x888888,
			0x000000,0x000000,0x000000,
			0x888888,0x888888,0x888888],
			[null,null,null,
			 Tile.Block_Crafter,null,null,
			null,null,null],
			 0,null]);
			//Bacic Wall
			//B G B
			//G G G
			//B G B
			Craft_Recipes.push([
			[Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block],
			[0x000000,0x888888,0x000000,
			0x888888,0x888888,0x888888,
			0x000000,0x888888,0x000000],
			[Tile.Colored_Block,Tile.Basic_Wall,Tile.Colored_Block,
			 Tile.Basic_Wall,Tile.Basic_Wall,Tile.Basic_Wall,
			 Tile.Colored_Block,Tile.Basic_Wall,Tile.Colored_Block],
			[0x888888,Tile.Void,0x888888,
			Tile.Void,Tile.Void,Tile.Void,
			0x888888,Tile.Void,0x888888],null]);
			//Block Spawner
			//B B B
			//B G B
			//B B B
			Craft_Recipes.push([
			[Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block],
			[0x000000,0x000000,0x000000,
			0x000000,0x888888,0x000000,
			0x000000,0x000000,0x000000],
			[null,null,null,
			null,Tile.Block_Spawner,null,
			null,null,null],
			0,null]);
			//Arrow Block
			//B B
			//G G B
			//B B
			Craft_Recipes.push([
			[Tile.Colored_Block,Tile.Colored_Block,Tile.Void,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Colored_Block,
			Tile.Colored_Block,Tile.Colored_Block,Tile.Void],
			[0x000000,0x000000,null,
			0x888888,0x888888,0x000000,
			0x000000,0x000000,null],
			[null,null,null,
			null,Tile.Arrow_Block,null,
			null,null,null],
			1,null]);
			/*trace(new CraftRecipe("ttr","rrt","trt",["t",TileSystem.Basic_Wall,0,null,0,"r",TileSystem.Void,0,null,0],
								  "ttr","rrt","trt",["t",TileSystem.Block_Crafter,0,null,0,"r",TileSystem.XX_Virus,0,null,0]))*/
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
			//World Seed
			WorldSpawnSeed=Math.floor(Math.random()*16777216);
			//About World Spawn
			V1=uint(String(WorldSpawnSeed).charAt(WorldSpawnSeed%String(WorldSpawnSeed).length)+WorldSpawnSeed%10);//1~99
			V2=Math.ceil(WorldSpawnSeed/100)%11+5;//5~15
			V3=getPrimeAt(WorldSpawnSeed%10+1);//2~29
			V4=WorldSpawnSeed%(WorldSpawnSeed%64+1)+1;//1~64
			V5=Math.pow(WorldSpawnSeed%10+10,(V1+V2+V3+V4)%4+1);//0~10000
			//World Type
			if(WorldType==""||WorldType==null)
			{
				WorldType=String(WorldTypes[1+random(WorldTypes.length-2)])
			}
			//World Size
			var w,h:uint;
			if(true)//WorldWidth!=0&&WorldHeight!=0
			{
				switch(WorldType)
				{
					case "Mini":
					w=5
					h=5
					break
					case "Small":
					w=10
					h=10
					break
					case "Medium":
					w=20
					h=20
					break
					case "Large":
					w=30
					h=30
					break
					case "Giant":
					w=40
					h=40
					break
					case "Long":
					w=32
					h=12
					break
					case "Deep":
					w=12
					h=32
					break
					case "Infinity":
					w=16
					h=16
					break
					//Random
					default:
					w=16+random(17);
					h=16+random(17);
					break
				}
			}
			WorldWidth=w;
			WorldHeight=h;
			ShouldSpawnTiles=(WorldWidth*2+1)*(WorldHeight*2+1);
			TotalSpawnTiles=0
			
			//Game Rules
			GamePlayMode=String(GamePlayModes[random(GamePlayModes.length)])
			switch(GamePlayMode)
			{
				case "VirusStrom":
				MaxVirusCount=10
				VirusSpawnProbability=32
				break
				default:
				MaxVirusCount=DefaultMaxVirusCount
				VirusSpawnProbability=DefaultVirusSpawnProbability
				break
			}
			VirusCount=0
			randomTickCount=Math.min(Math.max(Math.round(ShouldSpawnTiles/256),1),16)
			//trace(randomTickCount)
		}
		
		private function setWorldDisplay():void
		{
			drawWorldBorder()
			addChild(this.Tile_Sprite_Back)
			addChild(this.Entities_Sprite)
			addChild(this.Players_Sprite)
			addChild(this.Tile_Sprite_Top)
			addChild(this.WorldBorder_Sprite)
			this.setChildIndex(this.Tile_Sprite_Back,this.numChildren-1)
			this.setChildIndex(this.Entities_Sprite,this.numChildren-1)
			this.setChildIndex(this.Players_Sprite,this.numChildren-1)
			this.setChildIndex(this.Tile_Sprite_Top,this.numChildren-1)
			this.setChildIndex(this.WorldBorder_Sprite,this.numChildren-1)
		}
		
		//Draw World Border
		private function drawWorldBorder():void
		{
		}

		//World Tile Spawner
		private function getTileBySeed(X:int=0,Y:int=0):Array
		{
			var Id:String=Tile.Void;
			var Data:int=0;
			var F1:int=Math.floor(V1*V4+Math.abs(X)*V4/V3+V2*Math.abs(Y)/V4)%100+1;//1~100
			var F2:int=Math.floor(V1*V3+V2*V4+Math.abs(X)*Math.abs(Y))%V3+1;//1~30
			var F3:int=Math.floor(Math.abs(((V5+F1/X)+F2/Y))%4096)*Math.floor(Math.abs(((V5+V3*X)-V4*Y))%4096);//0~16777216
			var Condition_1:Boolean=(X*V2+(V1*V2)%V4==WorldSpawnSeed%Math.abs(Y-F1))
			var Condition_2:Boolean=(Y*V4+(V1*V2)%V4==WorldSpawnSeed%Math.abs(X-F2))
			var Condition_3:Boolean=(Math.floor(Math.abs(X+V5)+Math.abs(Y-V5))%Math.abs(V4*X-V2*Y-X*Y*V5)==V5%V4)
			var Condition_4:Boolean=(isPrime(Math.abs(X+Y+F1+F2-V4))&&isPrime(Math.abs(X+Y-F1-F2+V4)))
			var Condition_5:Boolean=(Math.abs(V5*X+F1)%16==Math.abs(V5*Y+F1)%32)
			var Conditions:Boolean=(Condition_1||Condition_2||Condition_3||Condition_4||Condition_5);
			var Condition_Virus:Boolean=(Math.abs(V1+V2+V3+V4+F1+F2+F3+X*Y)%VirusSpawnProbability==(V1+V2+V3+V4)%VirusSpawnProbability)
			if(!detectEntity(X,Y)&&Conditions)
			{
				//Spawn Virus By 1/512
				if(Condition_Virus&&VirusCount<MaxVirusCount)
				{
					//trace("Spawn A Virus on",X,Y)
					VirusCount++
					var virusType:uint=Math.abs(F1+X-Y)%4
					switch(virusType)
					{
						case 1:
						return [Tile.XX_Virus_Red,0]
						break
						case 2:
						return [Tile.XX_Virus_Blue,0]
						break
						default:
						return [Tile.XX_Virus,0]
						break
					}
				}
				Id=Tile.Colored_Block;
				switch((F1+F2+F3)%13)
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
			return [Id,Data];
		}

		function ResetWorld():void
		{
			var X:int
			var Y:int
			//Reset Tile System:Remove All Tile Sprite
			for(X=-WorldWidth;X<=WorldWidth;X++)
			{
				for(Y=-WorldHeight;Y<=WorldHeight;Y++)
				{
					removeTile(X,Y);
				}
			}
			//Reset World Variables
			WorldType=null
			setWorldVariables();
			setWorldDisplay()
			this.Tiles={}
			//Respawn Tiles
			for(X=-WorldWidth;X<=WorldWidth;X++)
			{
				for(Y=-WorldHeight;Y<=WorldHeight;Y++)
				{
					var tile:Array=getTileBySeed(X,Y);
					var TileID:String=tile[0];
					var TileData:int=tile[1];
					setNewTile(X,Y,TileID,TileData,null);
					TotalSpawnTiles++;
				}
			}
			//Reset Stage
			x=displayWidth/2;
			y=displayHeight/2;
			//Reset Player
			for(var i:uint=0;i<PlayerCount;i++)
			{
				var player:Player=PlayerList[i];
				player.MoveTo(0,player.ID-1);
				player.resetInventory();
				//Give Player A Block Crafter;
				player.AddItem("Block_Crafter",1,0,TileTag.getTagFromID("Block_Crafter"));
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
			//Show Text
			UpdateDebugText();
		}

		//--------Player Functions--------//
		private function SpawnPlayer(color:uint,ID:uint,X:int=0,Y:int=0):Player
		{
			//Spawn New Player
			var player:Player=new Player(this,X*tileSize,Y*tileSize,ID,color);
			PlayerList.push(player);
			regEntity(player)
			//Give Player A Block Crafter;
			player.AddItem("Block_Crafter",1,0,TileTag.getTagFromID("Block_Crafter"));
			//Add Player To Display;
			Players_Sprite.addChild(player);
			return player;
		}

		private function spawnPx(ID:uint):void
		{
			if(ID>0&&PlayerCount>0&&PlayerColorByID.length>0)
			{
				var P=getPx(PlayerCount);
				if(P is Entity)
				{
					var Px=SpawnPlayer(PlayerColorByID[PlayerCount],PlayerCount+1,
									   P.getX()+random(2)*2-1,P.getY()+random(2)*2-1);
					this.Players_Sprite.setChildIndex(Px,0);
				}
			}
			UpdateDebugText(2);
		}

		public function getPx(ID:uint):Player
		{
			if(ID>0&&ID<=PlayerCount)
			{
				return (PlayerList[ID-1] as Player);
			}
			return null;
		}

		private function movePosToPlayer(ID:uint):void
		{
			StageMoveTo(displayWidth/2-this.getPx(ID).x,displayHeight/2-this.getPx(ID).y);
		}

		//==========Listener Functions==========//
		private function OnKeyDown(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			LastKey=Code;
			UpdateDebugText(1);
			// altKey ctrlKey shiftKey //
			//Give A Item By Ctrl+Num
			if(E.ctrlKey&&!E.shiftKey&&Code>48&&Code<58&&Code-48<=TileSystem.TotalTileCount)
			{
				PlayerList[0].AddItem(TileSystem.AllTileID[Code-48],1,0,TileTag.getTagFromID(TileSystem.AllTileID[Code-48]));
				return;
			}
			//Spawn New Player By Ctrl+Shift+1~4
			if(E.ctrlKey&&E.shiftKey&&Code>48&&Code<58&&Code-49==PlayerCount&&Code-48<=LimitPlayerCount)
			{
				spawnPx((Code-48));
				return;
			}
			//Set Pos To Player
			if(!E.ctrlKey&&E.shiftKey&&Code>48&&Code<58&&Code-48<=PlayerCount)
			{
				movePosToPlayer((Code-48));
				return;
			}
			//Reset World By Ctrl+Shift+R
			if(E.ctrlKey&&E.shiftKey&&Code==82)
			{
				ResetWorld();
				return;
			}
			//End Game
			if(Code==27)
			{
				fscommand("quit")
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
					var ContolType:String="None";
					//Set Rot
					switch(Code)
					{
						case player.ContolKey_Up:
							player.isKeyDown=true;
							player.ActiveKey_Up=true;
							ContolType="Move";
							Rot=4;
							break;
						case player.ContolKey_Down:
							player.isKeyDown=true;
							player.ActiveKey_Down=true;
							ContolType="Move";
							Rot=2;
							break;
						case player.ContolKey_Left:
							player.isKeyDown=true;
							player.ActiveKey_Left=true;
							ContolType="Move";
							Rot=3;
							break;
						case player.ContolKey_Right:
							player.isKeyDown=true;
							player.ActiveKey_Right=true;
							ContolType="Move";
							Rot=1;
							break;
						case player.ContolKey_Use:
							player.isKeyDown=true;
							player.ActiveKey_Use=true;
							ContolType="Use";
							break;
						case player.ContolKey_Select_Left:
							player.isKeyDown=true;
							player.ActiveKey_Select_Left=true;
							ContolType="SelectLeft";
							break;
						case player.ContolKey_Select_Right:
							player.isKeyDown=true;
							player.ActiveKey_Right=true;
							ContolType="SelectRight";
							break;
					}
					//Move
					if(ContolType=="Move")
					{
						PlayerMove(player,Rot,Distance);
						break;
					}
					//Use
					if(ContolType=="Use")
					{
						PlayerUse(player,Distance);
						break;
					}
					//Select
					if(ContolType=="SelectLeft")
					{
						player.SelectLeft();
						UpdateDebugText(2);
						break;
					}
					if(ContolType=="SelectRight")
					{
						player.SelectRight();
						UpdateDebugText(2);
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
							player.ActiveKey_Up=false;
							break;
						case player.ContolKey_Down:
							player.ActiveKey_Down=false;
							break;
						case player.ContolKey_Left:
							player.ActiveKey_Left=false;
							break;
						case player.ContolKey_Right:
							player.ActiveKey_Right=false;
							break;
						case player.ContolKey_Use:
							player.ActiveKey_Use=false;
							break;
						case player.ContolKey_Select_Left:
							player.ActiveKey_Select_Left=false;
							break;
						case player.ContolKey_Select_Right:
							player.ActiveKey_Select_Right=false;
							break;
					}
					if(
					!player.ActiveKey_Up&&
					!player.ActiveKey_Down&&
					!player.ActiveKey_Left&&
					!player.ActiveKey_Right&&
					!player.ActiveKey_Use&&
					!player.ActiveKey_Select_Left&&
					!player.ActiveKey_Select_Right)
					{
						player.isKeyDown=false;
					}
				}
			}
		}

		private function EnterFrame(E:Event):void
		{
			//Time Functions
			var TimeDistance:uint=getTimer()-LastTime;
			if(gameFramesRefrashTick>=gameFramesRefrashTime)
			{
				if(Math.round(1000/TimeDistance*10)/10!=gameFrames)
				{
					gameFramesRefrashTick=0;
					gameFrames=Math.round(((1000/TimeDistance)*10))/10;
					UpdateDebugText(1);
				}
			}
			else
			{
				gameFramesRefrashTick++;
			}
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
			//Reset Timer
			LastTime=getTimer();
		}
		
		//----------Player Contol Functions----------//
		private function PlayerMove(player:MovieClip,Rot:uint,Distance:uint):void
		{
			player.setPlayerPos(Rot);
			var pX:int=player.getX();
			var pY:int=player.getY();
			var mX:int=player.getX()+Entity.getPos(Rot,Distance/tileSize)[0];
			var mY:int=player.getY()+Entity.getPos(Rot,Distance/tileSize)[1];
			var rX:int=player.x+this.x;//+tileSize/2;
			var rY:int=player.y+this.y;//+tileSize/2;
			//setTile(mX,mY,0)
			if(testMove(player,pX,pY,mX,mY))
			{
				//Border Test
				if(rX<BorderWidth&&rX>0&&Rot==3||
				   rX>displayWidth-BorderWidth&&rX<displayWidth&&Rot==1||
				   rY<BorderHeight&&rY>0&&Rot==4||
				   rY>displayHeight-BorderHeight&&rY<displayHeight&&Rot==2)
				{
					StageMove((Rot+1)%4+1,tileSize);
				}
				//Real Move
				player.MoveByDir(Rot,Distance,false);
				UpdateDebugText(2);
			}
			else if(isTile(mX,mY)&&getTileObject(mX,mY).Tag.canUse)
			{
				onBlockUse(mX,mY,player,Rot,getTileID(mX,mY),getTileData(mX,mY),getTileTag(mX,mY),getTileRot(mX,mY));
			}
		}

		private function PlayerUse(player:MovieClip,Distance:uint):void
		{
			var Rot=player.getRot();
			var frontX:int=player.getX()+Entity.getPos(Rot,Distance/tileSize)[0];
			var frontY:int=player.getY()+Entity.getPos(Rot,Distance/tileSize)[1];
			var block:Tile=getTileObject(frontX,frontY);
			var blockID:String=getTileID(frontX,frontY);
			var blockData:int=getTileData(frontX,frontY);
			var blockTag:TileTag=getTileTag(frontX,frontY);
			var blockHard:uint=getTileHard(frontX,frontY);
			var blockMaxHard:uint=getTileMaxHard(frontX,frontY);
			var blockRot:int=getTileRot(frontX,frontY);
			var blockDropItems:Array=getTileDropItems(frontX,frontY);
			var Destroy:Boolean=true;
			var Place:Boolean=true;
			//trace(frontX,frontY,getTileObject(frontX,frontY))
			//Destroy Block
			if(player.GameMode.CanDestroy&&Destroy)
			{
				if(isTile(frontX,frontY))
				{
					//blockID>0
					if(block.Tag.canDestroy)
					{
						if(blockHard>1&&!player.GameMode.InstantDestroy)
						{
							destroyBlock(frontX,frontY);
						}
						else
						{
							//Clean Item
							if(player.InventorySelect<0||
							player.InventorySelect>-1&&!block.Tag.canPlaceBy)
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
							//Set Hook
							onBlockDestroy(frontX,frontY,player,Rot,blockID,blockData,blockTag,blockRot);
							//Set Variable
							Place=false;
						}
					}
				}
			}
			//Place Block
			if(player.InventorySelect>-1&&player.GameMode.CanPlace&&Place)
			{
				var PlaceId:String=player.SelectedItem.Id;
				var PlaceData:int=player.SelectedItem.Data;
				var PlaceTag:TileTag=player.SelectedItem.Tag;
				var PlaceRot:int=0
				if(PlaceTag is Object&&PlaceTag["canRotate"])
				{
					PlaceRot=player.getPlayerPos()+1
				}
				//trace(player.SelectedItem.Tag.canPlace,block.Tag.canPlaceBy)
				if(!detectEntity(frontX,frontY)&&block!=null)
				{
					if(player.SelectedItem.Count>0&&
						PlaceTag["canPlace"]&&
						block.Tag.canPlaceBy)
					{
						//Real Place
						setTile(frontX,frontY,PlaceId,PlaceData,PlaceTag,PlaceRot);
						player.RemoveItem(PlaceId,1,player.SelectedItem.Data,PlaceTag);
						UpdateDebugText(2);
						//Set Hook
						onBlockPlace(frontX,frontY,player,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot);
					}
					else if(!PlaceTag["canPlace"])
					{
						onItemUse(frontX,frontY,player,Rot,PlaceId,PlaceData,PlaceTag,PlaceRot);
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
			this.EntityList.splice(General.IinA(Ent.UUID,EntityUUIDList),1)
			this.EntityUUIDList.splice(General.IinA(Ent.UUID,EntityUUIDList),1)
		}
		
		private function testMove(Entity:Object,sx:int,sy:int,tx:int,ty:int):Boolean
		{
			var canMove:Boolean=true;
			//trace("Tile:",getTileObject(tx,ty).canPass);
			//Test Border
			if(getTileObject(tx,ty)==null)
			{
				return false;
			}
			//Test Blocks
			switch(Entity.moveType)
			{
				default:
					if(getTileID(tx,ty)!=Tile.Void&&!getTileTag(tx,ty).canPass)
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

		private function StageMove(dir:int,dis:uint=1):void
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
			StageMoveTo(this.x+Pos[0],this.y+Pos[1]);
		}

		private function StageMoveTo(X:int,Y:int,sizeBuff:Boolean=false):void
		{
			if(sizeBuff)
			{
				this.x=X*tileSize;
				this.y=Y*tileSize;
			}
			else
			{
				this.x=X;
				this.y=Y;
			}
		}
		
		public function spawnItem(X:Number,Y:Number,
								  Id:String=TileSystem.Colored_Block,
								  Count:uint=1,Data:int=0,
								  Tag:TileTag=null,Rot:int=0):void
		{
			var item:Item=new Item(this,X*TileSystem.globalTileSize,
								   Y*TileSystem.globalTileSize,
								   Id,Count,Data,Tag,Rot)
			this.Entities_Sprite.addChild(item)
			this.Entities_Sprite.setChildIndex(item,0)
			this.EntityList.push(item)
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
				if(General.getDistance(item.x,item.y,p.x,p.y)<item.Radius+p.Radius)
				{
					//trace(item.x,item.y,p.x,p.y)
					var IT:InventoryItem=item.item
					p.AddItem(IT.Id,IT.Count,IT.Data,IT.Tag,IT.Rot)
					item.deleteSelf()
					removeEntity(item)
				}
			}
		}

		//--------Tile Functions--------//
		private function setNewTile(X:int=0,Y:int=0,Id:String=TileSystem.Void,
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
		
		private function removeTile(X,Y):void
		{
			if(isTile(X,Y))
			{
				var tile=(getTileObject(X,Y) as Tile)
				tile.removeSelf()
				Tiles[X+"_"+Y]=null
			}
		}

		private function resetTile(X:int,Y:int,Id:String,Data:int=0,Tag:TileTag=null,Rot:int=0):Boolean
		{
			var tile=getTileObject(X,Y);
			if(tile!=null)
			{
				tile.changeTile(Id,Data,Tag,Rot);
				return true;
			}
			return false;
		}
		
		private function snapToGrid(x:Number):int
		{
			return Math.floor(x/TileSystem.globalTileSize)
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
		
		public function getTileDropItems(X:int,Y:int):Array
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
				var block=getTileObject(X,Y)
				if(getTileHard(X,Y)>1)
				{
					block.setHardness(block.Hard-1)
				}
			}
		}
		
		private function setVoid(X:int,Y:int):void
		{
			if(isTile(X,Y))
			{
				setTile(X,Y,TileSystem.Void,0)
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
			var blockDropItems:Array=getTileDropItems(X,Y);
			if(blockDropItems is Array&&blockDropItems.length>0)
			{
				for(var i in blockDropItems)
				{
					var giveItem:InventoryItem=blockDropItems[i]
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
								 Tag:TileTag=null,Rot:int=0,KeepHard:Boolean=false):Boolean
		{
			var tile:Tile=getTileObject(X,Y);
			if(tile!=null)
			{
				tile.changeTile(Id,Data,Tag,Rot);
				if(!KeepHard)
				{
					tile.setHardness(tile.MaxHard)
				}
				return true;
			}
			return false;
		}
		
		//--------Pro Block Functions--------//
		private function cloneTile(x1:int,y1:int,x2:int,y2:int,Mode:String="Replace"):void
		{
			var oId:String=getTileID(x1,y1)
			var oData:int=getTileData(x1,y1)
			var oTag:TileTag=getTileTag(x1,y1)
			var oRot:int=getTileRot(x1,y1)
			var tId:String=getTileID(x2,y2)
			var tData:int=getTileData(x2,y2)
			var tTag:TileTag=getTileTag(x2,y2)
			var tRot:int=getTileRot(x2,y2)
			if(Mode.indexOf("Keep")>=0&&!tTag.canPlaceBy) return
			if(Mode.indexOf("Move")>=0) setVoid(x1,y1)
			if(Mode.indexOf("Destroy")>=0) DropItem(x2,y2)
			setTile(x2,y2,oId,oData,oTag,oRot)
		}

		//--------Hook Functions--------//
		private function onBlockDestroy(X:int,Y:int,P:MovieClip,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
			//spawnItem(X*TileSystem.globalTileSize,Y*TileSystem.globalTileSize,Id,1,Data,Tag,Rot)
		}

		private function onBlockPlace(X:int,Y:int,P:MovieClip,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
		}
		
		private function onItemUse(X:int,Y:int,P:MovieClip,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			//trace(arguments)
		}

		private function onBlockUse(X:int,Y:int,P:MovieClip,Pos:uint,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			switch(Id)
			{
				//Color Mixer:Mix Color
				case Tile.Color_Mixer:
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
					var AverageColorH:uint=Math.round(getAverage(BlockColorsH));
					var AverageColorS:uint=Math.round(getAverage(BlockColorsS));
					var AverageColorV:uint=Math.round(getAverage(BlockColorsV));
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
				case Tile.Block_Crafter:
					//Recipe Rules:
					//0:NeedIds
					//1:NeedDatas
					//2:OutputId
					//3:OutputData
					//4:OutputTag
					var SlotId:Array=new Array();
					var SlotData:Array=new Array();
					var SlotTag:Array=new Array();
					var canCraft:Boolean=true
					var offsetX:int=-2;
					var offsetY:int=0;
					/////////
					//1 2 3//
					//4 5 6//
					//7 8 9//
					/////////
					for(var Yp:int=-1;Yp<=1;Yp++)
					{
						for(var Xp:int=-1;Xp<=1;Xp++)
						{
							//Detect CanPut
							var OutId:String=getTileID(X-offsetX+Xp,Y-offsetY+Yp);
							var OutData:uint=getTileData(X-offsetX+Xp,Y-offsetY+Yp);
							var OutTag:TileTag=getTileTag(X-offsetX+Xp,Y-offsetY+Yp);
							if(!OutTag.canPlaceBy||detectEntity(X-offsetX+Xp,Y-offsetY+Yp))
							{
								canCraft=false
							}
							//Push Tile
							SlotId.push(getTileID(X+offsetX+Xp,Y+offsetY+Yp));
							SlotData.push(getTileData(X+offsetX+Xp,Y+offsetY+Yp));
							SlotTag.push(getTileTag(X+offsetX+Xp,Y+offsetY+Yp));
						}
					}
//
					if(canCraft)
					{
						for(var I=0;I<Craft_Recipes.length;I++)
						{
							var NeedSlotId:Array=Craft_Recipes[I][0];
							var NeedSlotData:Array=Craft_Recipes[I][1];
							var OutputId:Array=Craft_Recipes[I][2];
							var OutputData:*=Craft_Recipes[I][3];
							var OutputTag:TileTag=Craft_Recipes[I][4];
							if(TestCanCraft(SlotId,NeedSlotId,SlotData,NeedSlotData)==true)
							{
								for(Yp=-1;Yp<=1;Yp++)
								{
									for(Xp=-1;Xp<=1;Xp++)
									{
										var l:uint=(Yp+1)*3+Xp+1;
										//Clean
										setVoid(X+offsetX+Xp,Y+offsetY+Yp);
										if(OutputId[l]==null)
										{
											continue;
										}
										setVoid(X-offsetX+Xp,Y-offsetY+Yp);
										//Return And Place Block
										var placeData:uint;
										if(OutputData is Number)
										{
											placeData=Math.floor(Math.abs(OutputData))
										}
										else if(OutputData is Array)
										{
											placeData=Math.floor(Math.abs(uint(OutputData[l])))
										}
										if(TileSystem.isAllowID(OutputId[l]))
										{
											setTile(X-offsetX+Xp,Y-offsetY+Yp,OutputId[l],placeData,OutputTag);
										}
									}
								}
							}
						}
					}
					break;
			}
		}

		private function onRandomTick(X:int,Y:int,Id:String,Data:int,Tag:TileTag,Rot:int):void
		{
			if(Tag==null||!Tag.allowRandomTick) return
			/*if(emableRadomTickOutPut)
			{
				trace("Random X:"+X,"Random Y:"+Y,"Arguments:"+arguments)
			}*/
			var cx:int
			var cy:int
			var xd:int
			var yd:int
			var bId:String
			switch(Id)
			{
				//Block Spawner
				case "Block_Spawner":
				for(var Xl:int=-2;Xl<=2;Xl++)
				{
					for(var Yl:int=-2;Yl<=2;Yl++)
					{
						if(Xl==0&&Yl==0) continue;
						if(isTile(X+Xl,Y+Yl)>=0&&
						   !detectEntity(X+Xl,Y+Yl))
						{
							if(getTileTag(X+Xl,Y+Yl)["canPlaceBy"]||
							   getTileID(X+Xl,Y+Yl)==Tile.XX_Virus)//&&getTileData(X+Xl,Y+Yl)>0
							{
								var r:uint=3
								var t:Array=getTileBySeed(X+random(r)-random(r),
														  Y+random(r)-random(r))
								if(t[0]!=0&&random(r)==0)
								{
									setTile(X+Xl,Y+Yl,t[0],t[1])
									return
								}
							}
						}
					}
				}
				break
				//XX Virus
				case Tile.XX_Virus:
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
					//var InfluenceModes:Array=["Influence","SpawnChild"]
					//var InfluenceMode:String=InfluenceModes[random(InfluenceModes.length)]
					var rd:uint=1+random(2)*(random(4)+1)
					cx=X+random(rd)-random(rd)
					cy=Y+random(rd)-random(rd)
					if(isTile(cx,cy)&&
					   getTileID(cx,cy)!=Id&&
					   !detectEntity(cx,cy))
					{
						successlyInfluence=true
						if(getDis(X-cx,Y-cy)>=1.125)
						{
							if(getTileID(cx,cy)==Tile.Void)
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
							else if(random(3)==0)
							{
								cloneTile(X,Y,cx,cy)
								setTileHard(cx,cy,getTileMaxHard(cx,cy))
							}
							else if(getTileID(cx,cy)==Tile.Void)
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
				case Tile.XX_Virus_Red:
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
						if(bId!=Tile.XX_Virus_Red)
						{
							if(bId!=Tile.Void||
							   detectEntity(cx,cy)||
							   bId==Tile.Void&&random(128)==0)
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
				case Tile.XX_Virus_Blue:
				//Influence
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
					if(bId==Tile.XX_Virus_Blue)
					{
						if(getTileHard(cx,cy)<getTileMaxHard(cx,cy))
						{
							setTileHard(cx,cy,getTileHard(cx,cy)+1)
						}
					}
					else if(bId==Tile.Void&&!detectEntity(cx,cy))
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
							else if(getTileID(cx,cy)==Tile.Colored_Block&&
									getTileData(cx,cy)==0x0000ff||
									getTileID(cx,cy)==Tile.Colored_Block&&
									getTileData(cx,cy)==0x000000)
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
				if(General.IinA(Str,memoryArr)>-1)
				{
					return returnArr;
				}
			}
			memoryArr.push(Str);
			if(nowId==Tile.Colored_Block)
			{
				returnArr.push(nowBlock);
			}
			else if(nowId==Tile.Color_Mixer)
			{
				returnArr=returnArr.concat(getCanMixBlocks((X+1),Y,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks((X-1),Y,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks(X,Y+1,memoryArr));
				returnArr=returnArr.concat(getCanMixBlocks(X,Y-1,memoryArr));
			}
			return returnArr;
		}

		private function TestCanCraft(SI:Array,NSI:Array,SD:Array,NSD:Array):Boolean
		{
			//trace("TestCraft:"+arguments+";"+General.isEqualArray(SI,NSI)+","+General.isEqualArray(SD,NSD))
			if(General.isEqualArray(SI,NSI)&&
			   General.isEqualArray(SD,NSD))
			{
				return true;
			}
			else
			{
				return false;
			}
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
			return Game.Version.split(" ")[2]
		}
		
		public function get FPS():uint
		{
			return gameFrames;
		}

		public function UpdateDebugText(textNum:uint=0):void
		{
			if(textNum==1||textNum<1)
			{
				var DTT:String="";
				DTT+=GameName+" "+Version;
				DTT+="\n"+FPS+" FPS";
				DTT+="\n\nWorldSeed="+WorldSpawnSeed+"\nV1="+V1+"\nV2="+V2+"\nV3="+V3+"\nV4="+V4;
				DTT+="\nWorldWidth="+(WorldWidth*2+1)+"\nWorldHeight="+(WorldHeight*2+1);
				DTT+="\n"+ShouldSpawnTiles+" tiles shoule be load"+"\n"+TotalSpawnTiles+" tiles loaded";
				DTT+="\nWorldType="+WorldType;
				DTT+="\nGamePlayMode="+GamePlayMode;
				DTT+="\n"+VirusCount+" virus spawn in the world"
				DTT+="\n\nLastKeyCode="+LastKey;
				DebugText.text=DTT;
			}
			if(textNum==2||textNum<1)
			{
				var DT2T:String="";
				for(var i=1;i<=PlayerCount;i++)
				{
					var P=PlayerList[i-1];
					if((PlayerCount>1))
					{
						DT2T+="<Player id="+i+">\n";
					}
					DT2T+=P.traceSelectedItem(false,false);
					DT2T+="\nX="+P.getX()+" Y="+P.getY();
					DT2T+="\nTotal Item Count="+P.getAllItemCount();
					if(PlayerCount>1)
					{
						DT2T+="\n<Player>";
					}
					if(i<PlayerCount)
					{
						DT2T+="\n\n";
					}
				}
				DebugText2.text=DT2T;
			}
		}

		public function CleanDebugText(textNum:uint=0):void
		{
			if(textNum==1||textNum<1)
			{
				DebugText.text="";
			}
			if(textNum==2||textNum<1)
			{
				DebugText2.text="";
			}
		}

		//--------Math Functions--------//
		public static function random(X:Number):uint
		{
			return General.random(X)
		}

		public static function RandomByWeight(A:Array):uint
		{
			if(A.length>=1)
			{
				var All=0;
				var i;
				for(i in A)
				{
					if(!isNaN(Number(A[i])))
					{
						All+=Number(A[i]);
					}
				}
				if(A.length==1)
				{
					return 1;
				}
				else
				{
					var R=Math.random()*All;
					for(i=0;i<A.length;i++)
					{
						var N=Number(A[i]);
						var rs=0;
						for(var l=0;l<i;l++)
						{
							rs+=Number(A[l]);
						}
						//trace(R+"|"+(rs+N)+">R>="+rs+","+(i+1))
						if(((R>=rs)&&R<rs+N))
						{
							return i+1;
						}
					}
				}
			}
			return random(A.length)+1;
		}
		
		public static function RandomByWeight2(...A):uint
		{
			return RandomByWeight(A)
		}

		public static function getAverage(a:Array):Number
		{
			var sub:Number=0;
			for(var i=0;i<a.length;i++)
			{
				sub+=Number(a[i]);
			}
			return sub/a.length;
		}

		public static function getAverage2(...a):Number
		{
			return getAverage(a)
		}
		
		public static function getDis(X:Number,Y:Number):Number
		{
			return Math.sqrt(Math.pow(X,2)+Math.pow(Y,2))
		}

		public static function getPrime(X:Number):Array
		{
			var returnArr:Array=[];
			var t;
			for(var i:uint=2;i<=Math.ceil(Math.abs(X));i++)
			{
				var Push:Boolean=true;
				for(t in returnArr)
				{
					if(i%returnArr[t]==0)
					{
						Push=false;
					}
				}
				if(Push)
				{
					returnArr.push(i);
				}
			}
			return returnArr;
		}

		public static function getPrimeAt(X:Number):uint
		{
			var returnUin:uint=2;
			var Arr:Array=[];
			var t;
			for(var i:uint=1;Arr.length<=X;i+=10)
			{
				Arr=getPrime(i);
			}
			if(Arr.length>=X)
			{
				returnUin=Arr[X];
			}
			return returnUin;
		}

		public static function isPrime(X:Number):Boolean
		{
			if(Math.abs(X)<2)
			{
				return false;
			}
			var ps:Array=getPrime((X+1));
			var i;
			for(i in ps)
			{
				if(ps[i]==X)
				{
					return true;
				}
			}
			return false;
		}
	}
}