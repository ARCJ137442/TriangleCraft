package 
{
	import Tile;
	import Entity;
	import Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.system.fscommand;

	public class Game extends Sprite
	{
		//=====STATIC CONST=====//
		//About This Game
		static const GameName:String="Triangle Craft";
		static const Version:String="Alpha 0.0.1 build 1";
		//Tile System
		static const tileSize:uint=32;
		static const displayWidth:uint=672;
		static const displayHeight:uint=672;
		static const Width:uint=displayWidth/tileSize;
		static const Height:uint=displayHeight/tileSize;
		static const BorderWidth:uint=tileSize*3;
		static const BorderHeight:uint=tileSize*3;

		//World
		static const LoadRadiusBuff:uint=4;
		static const WorldWidth:uint=40;//Math.floor(Width/2*LoadRadiusBuff)
		static const WorldHeight:uint=40;//Math.floor(Height/2*LoadRadiusBuff)
		static const isInfinityWorld:Boolean=false;

		//Player
		static const LimitPlayerCount:uint=4;
		static const PlayerColorByID:Array=[0x66CCFF,0xFF6666,0xFFFF66,0x66FF66,0x66FFFF,0x6666FF,0xCC66FF,0x66FFCC,0xFF66CC];

		//DebugText
		static const MainFormet:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"left");
		static const MainFormet2:TextFormat=new TextFormat("MainFont",16,0x000000,false,false,null,null,null,"right");

		//=====PRIVATE VAR=====//
		//World Spawn
		private var WorldSpawnSeed:int=Math.floor(Math.random()*16777216);
		private var V1:int;
		private var V2:int;
		private var V3:int;
		private var V4:int;
		private var V5:int;
		private var ShouldSpawnTiles:uint=(WorldWidth*2+1)*(WorldHeight*2+1)
		private var TotalSpawnTiles:uint=0

		//Tile
		private var Tiles:Object={};

		//Entities
		private var PlayerList:Array=[];
		private var EntityList:Array=[];
		private var CenterPlayerID:uint=1;

		//DebugText
		private var DebugText:TextField=new TextField();
		private var DebugText2:TextField=new TextField();
		private var LastTime:uint=getTimer();
		private var LastKey:uint=0;
		private var gameFrames:Number=0;
		private var gameFramesRefrashTick:uint=0;
		private var gameFramesRefrashTime:uint=8;

		//--------Game Load Function--------//
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE,onGameLoaded);
		}

		private function onGameLoaded(E:Event):void
		{
			//Trace Seed:trace("Seed is",WorldSpawnSeed);
			setWorldVariables();
			//Set Pos
			x=displayWidth/2;
			y=displayHeight/2;
			//Spawn Player
			var P1=SpawnPlayer(PlayerColorByID[0],getPlayerCount()+1,0,0);
			//Spawn Tile
			for (var X:int=-WorldWidth; X<=WorldWidth; X++)
			{
				for (var Y:int=-WorldHeight; Y<=WorldHeight; Y++)
				{
					var Tile:Array=getTileBySeed(X,Y);
					var TileID:int=Tile[0];
					var TileData:int=Tile[1];
					setNewTile(X,Y,TileID,TileData);
				}
			}
			//Set ChildIndex
			setChildIndex(P1,numChildren-1);
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
		}

		//--------World Functions--------//
		private function setWorldVariables():void
		{
			V1=Number(String(WorldSpawnSeed).charAt(WorldSpawnSeed%String(WorldSpawnSeed).length)+WorldSpawnSeed%10);//1~Seed
			V2=Math.ceil(WorldSpawnSeed/100)%11+5;//5~15
			V3=getPrimeAt(WorldSpawnSeed%10+1);//2~29
			V4=WorldSpawnSeed%(WorldSpawnSeed%64+1)+1;//1~64
			V5=Math.pow(WorldSpawnSeed%10+10,(V1+V2+V3+V4)%4+1);//0~10000
		}

		//World Tile Spawner
		private function getTileBySeed(X:int=0,Y:int=0):Array
		{
			var Id:int=0;
			var Data:int=0;
			var F1:int=Math.floor(V1*V4+Math.abs(X)*V4/V3+V2*Math.abs(Y)/V4)%100+1;//1~100
			var F2:int=Math.floor(V1*V3+V2*V4+Math.abs(X)*Math.abs(Y))%V3+1;//1~30
			var F3:int=Math.floor(Math.abs(V5+F1/X+F2/Y)%4096)*Math.floor(Math.abs(V5+V3*X-V4*Y)%4096);//0~16777216
			var Conditions:Boolean=(
			X*V2+(V1*V2)%V4==WorldSpawnSeed%Math.abs(Y-F1)||
			Y*V4+(V1*V2)%V4==WorldSpawnSeed%Math.abs(X-F2)||
			Math.floor(Math.abs(X+V5)+Math.abs(Y-V5))%Math.abs(V4*X-V2*Y-X*Y*V5)==V5%V4||
			isPrime(Math.abs(X+Y+F1+F2)-V4)&&isPrime(Math.abs(X+Y-F1-F2)+V4)||
			Math.abs(V5*X+F1)%16==Math.abs(V5*Y+F1)%32
			);
			if (testEntity(X,Y)==null&&Conditions)
			{
				Id=1;
				switch ((F1+F2+F3)%17)
				{
						//Black
					case 0 :
						Data=0x000000;
						break;
						//Gray
					case 1 :
						Data=0x888888;
						break;
						//RGB
					case 2 :
						Data=0xff0000;
						break;
					case 3 :
						Data=0x00ff00;
						break;
					case 4 :
						Data=0x0000ff;
						break;
						//CPY
					case 5 :
						Data=0xffff00;
						break;
					case 6 :
						Data=0xff00ff;
						break;
					case 7 :
						Data=0x00ffff;
						break;
						//Random By Seed
					default :
						Data=F3;
						break;
				}
			}
			return [Id,Data];
		}

		function ResetWorld()
		{
			//Reset Tiles
			WorldSpawnSeed=Math.floor(Math.random()*16777216);
			setWorldVariables();
			for (var X:int=-Math.floor(Width/2)*LoadRadiusBuff; X<=Math.floor(Width/2)*LoadRadiusBuff; X++)
			{
				for (var Y:int=-Math.floor(Height/2)*LoadRadiusBuff; Y<=Math.floor(Height/2)*LoadRadiusBuff; Y++)
				{
					var tile:Array=getTileBySeed(X,Y);
					var TileID:int=tile[0];
					var TileData:int=tile[1];
					resetTile(X,Y,TileID,TileData,null);
				}
				import flash.display.MovieClip;
				import flashx.textLayout.operations.MoveChildrenOperation;

			}
			//Reset Stage
			x=displayWidth/2;
			y=displayHeight/2;
			//Reset Player
			for (var i=0; i<getPlayerCount(); i++)
			{
				var player:Player=PlayerList[i];
				player.MoveTo(0,player.ID-1);
				player.resetInventory();
			}
			//Show Text
			UpdateDebugText();
		}

		//--------Player Functions--------//
		private function SpawnPlayer(color:uint,ID:int,X:int=0,Y:int=0):Player
		{
			var player:Player=new Player(X*tileSize,Y*tileSize,tileSize,tileSize,ID,color);
			PlayerList.push(player);
			EntityList.push(player);
			addChild(player);
			return player;
		}

		private function getPx(ID:uint):MovieClip
		{
			if (ID>0&&ID<=getPlayerCount())
			{
				return PlayerList[ID-1];
			}
			return null;
		}

		private function spawnPx(ID:uint):void
		{
			if (ID>0&&getPlayerCount()>0&&PlayerColorByID.length>0)
			{
				var P1=getPx(1);
				if (P1 is Entity)
				{
					var Px=SpawnPlayer(PlayerColorByID[getPlayerCount()],getPlayerCount()+1,P1.getX()+random(2)*2-1,P1.getY()+random(2)*2-1);
					setChildIndex(Px,numChildren-1);
				}
			}
			UpdateDebugText(2);
		}

		private function movePosToPlayer(ID:uint):void
		{
			StageMoveTo(displayWidth/2-this.getPx(ID).x,displayHeight/2-this.getPx(ID).y);
			CenterPlayerID=ID;
			UpdateDebugText(1);
		}

		//KeyBoard Contol
		private function OnKeyDown(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			LastKey=Code;
			UpdateDebugText(1);
			// altKey ctrlKey shiftKey //
			//Give A Color Mixer By Ctrl+C
			if (Code==67)
			{
				PlayerList[0].AddItem(2,1,0,Tile.getTagFromID(2));
				UpdateDebugText(2);
				return;
			}
			//Spawn New Player By Ctrl+Shift+1~4
			if (E.ctrlKey&&E.shiftKey&&Code>48&&Code<57&&Code-48>getPlayerCount()&&Code-48<=LimitPlayerCount)
			{
				spawnPx(Code-48);
				return;
			}
			//Set Pos To Player
			if (! E.ctrlKey&&E.shiftKey&&Code>48&&Code<57&&Code-48<=getPlayerCount())
			{
				movePosToPlayer(Code-48);
				return;
			}
			//Reset World By Ctrl+Shift+R
			if (E.ctrlKey&&E.shiftKey&&Code==82)
			{
				ResetWorld();
				return;
			}
			//End Game
			if (Code==27)
			{
				fscommand("quit");
				return;
			}
			//Player Contol
			if (getPlayerCount()>0)
			{
				for (var i=0; i<getPlayerCount(); i++)
				{
					var player:Player=PlayerList[i];
					var Rot:uint;
					var Distance:int=player.moveDistence;
					var ContolType:String="None";
					//Set Rot
					switch (Code)
					{
						case player.ContolKey_Up :
							player.isKeyDown=true;
							player.ActiveKey_Up=true;
							ContolType="Move";
							Rot=4;
							break;
						case player.ContolKey_Down :
							player.isKeyDown=true;
							player.ActiveKey_Down=true;
							ContolType="Move";
							Rot=2;
							break;
						case player.ContolKey_Left :
							player.isKeyDown=true;
							player.ActiveKey_Left=true;
							ContolType="Move";
							Rot=3;
							break;
						case player.ContolKey_Right :
							player.isKeyDown=true;
							player.ActiveKey_Right=true;
							ContolType="Move";
							Rot=1;
							break;
						case player.ContolKey_Use :
							player.isKeyDown=true;
							player.ActiveKey_Use=true;
							ContolType="Use";
							break;
						case player.ContolKey_Select_Left :
							player.isKeyDown=true;
							player.ActiveKey_Select_Left=true;
							ContolType="SelectLeft";
							break;
						case player.ContolKey_Select_Right :
							player.isKeyDown=true;
							player.ActiveKey_Right=true;
							ContolType="SelectRight";
							break;
					}
					//Set Player Variables
					var pX:int=player.getX();
					var pY:int=player.getY();
					//Move
					if (ContolType=="Move")
					{
						PlayerMove(player,Rot,Distance);
					}
					//Use
					if (ContolType=="Use")
					{
						PlayerUse(player,Distance);
					}
					//Select
					if (ContolType=="SelectLeft")
					{
						player.SelectLeft();
						UpdateDebugText(2);
					}
					if (ContolType=="SelectRight")
					{
						player.SelectRight();
						UpdateDebugText(2);
					}
				}
			}
		}

		private function OnKeyUp(E:KeyboardEvent):void
		{
			var Code:uint=E.keyCode;
			//Player Contol
			if (getPlayerCount()>0)
			{
				for (var i=0; i<getPlayerCount(); i++)
				{
					var player:Player=PlayerList[i];
					//Set Rot
					switch (Code)
					{
						case player.ContolKey_Up :
							player.ActiveKey_Up=false;
							break;
						case player.ContolKey_Down :
							player.ActiveKey_Down=false;
							break;
						case player.ContolKey_Left :
							player.ActiveKey_Left=false;
							break;
						case player.ContolKey_Right :
							player.ActiveKey_Right=false;
							break;
						case player.ContolKey_Use :
							player.ActiveKey_Use=false;
							break;
						case player.ContolKey_Select_Left :
							player.ActiveKey_Select_Left=false;
							break;
						case player.ContolKey_Select_Right :
							player.ActiveKey_Select_Right=false;
							break;
					}
					if (!player.ActiveKey_Up&&
					   !player.ActiveKey_Down&&
					   !player.ActiveKey_Left&&
					   !player.ContolKey_Right&&
					   !player.ContolKey_Use&&
					   !player.ContolKey_Select_Left&&
					   !player.ContolKey_Select_Right)
					{
						player.isKeyDown=false;
					}
				}
			}
		}

		private function EnterFrame(E:Event)
		{
			//Time Functions
			var TimeDistance:uint=getTimer()-LastTime;
			if (gameFramesRefrashTick>=gameFramesRefrashTime)
			{
				if (Math.round(1000/TimeDistance*10)/10!=gameFrames)
				{
					gameFramesRefrashTick=0;
					gameFrames=Math.round(1000/TimeDistance*10)/10;
					UpdateDebugText(1);
				}
			}
			else
			{
				gameFramesRefrashTick++;
			}
			//trace("TimeDistance="+TimeDistance)
			//Player Contol

			//Reset Timer
			LastTime=getTimer();
		}

		private function UpdatePlayerTick(player:MovieClip,TimeDistance:uint):Boolean
		{
			if (player.isKeyDown&&player.moveTick<=player.moveDelay&&
			player.moveTick+TimeDistance>=player.moveDelay)
			{
				if (player.moveTick<=player.moveDelay+player.moveLoop&&
				player.moveTick+TimeDistance>=player.moveDelay+player.moveLoop)
				{
					player.moveTick=(player.moveTick+TimeDistance)-(player.moveDelay+player.moveLoop);
				}
				else
				{
					player.moveTick+=TimeDistance;
				}
			}
			else if (player.isKeyDown)
			{
				player.moveTick+=TimeDistance;
			}
			else
			{
				player.moveTick=0;
			}
			return false;
		}

		private function PlayerMove(player:MovieClip,Rot:uint,Distance:uint):void
		{
			player.setPos(Rot);
			var pX:int=player.getX();
			var pY:int=player.getY();
			var mX:int=player.getX()+player.getPos(Rot,Distance/tileSize)[0];
			var mY:int=player.getY()+player.getPos(Rot,Distance/tileSize)[1];
			var rX:int=player.x+this.x;//+tileSize/2;
			var rY:int=player.y+this.y;//+tileSize/2;
			//setTile(mX,mY,0)
			if (testMove(player,pX,pY,mX,mY))
			{
				//Border Test
				if (rX<BorderWidth&&Rot==3||rX>displayWidth-BorderWidth&&Rot==1||rY<BorderHeight&&Rot==4||rY>displayHeight-BorderHeight&&Rot==2)
				{
					if (getTileObject(mX,mY)==null)
					{
						trace("Player is off the edge!");
					}
					if (player.ID==CenterPlayerID)
					{
						StageMove((Rot+1)%4+1,tileSize);
					}
				}
				//Real Move
				player.MoveByDir(Rot,Distance,false);
				UpdateDebugText(2);
			}
		}

		private function PlayerUse(player:MovieClip,Distance:uint):void
		{
			var Rot=player.getRot();
			var frontX:int=player.getX()+player.getPos(Rot,Distance/tileSize)[0];
			var frontY:int=player.getY()+player.getPos(Rot,Distance/tileSize)[1];
			var block=getTileObject(frontX,frontY);
			var blockID=getTileID(frontX,frontY);
			var blockData=getTileData(frontX,frontY);
			var blockTag=getTileTag(frontX,frontY);
			var Destroy:Boolean=true;
			var Place:Boolean=true;
			//trace(frontX,frontY,getTileObject(frontX,frontY))
			//Destroy Block
			if (player.GameMode.CanDestroy&&Destroy)
			{
				if (block!=null)
				{
					//blockID>0
					if (block.TileTag.canDestroy)
					{
						//Clean Item
						if (player.InventorySelect<0&&block.TileTag.canGet||
						player.InventorySelect>-1&&!block.TileTag.canPlaceBy)
						{
							player.AddItem(blockID,1,blockData,blockTag);
							//player.traceInventory();
							UpdateDebugText(2);
						}
						//Real Destroy
						setTile(frontX,frontY,0,0);
						//Set Hook
						onBlockDestroy(frontX,frontY,blockID,blockData,blockTag);
						//Set Variable
						Place=false;
					}
				}
			}
			//Place Block
			if (player.InventorySelect>-1&&player.GameMode.CanPlace&&Place)
			{
				var PlaceId=player.SelectedItem.Id;
				var PlaceData=player.SelectedItem.Data;
				var PlaceTag=player.SelectedItem.Tag;
				//trace(player.SelectedItem.Tag.canPlace,block.TileTag.canPlaceBy)
				if (testEntity(frontX,frontY)==null&&block!=null)
				{
					if (player.SelectedItem.Count>0&&player.SelectedItem.Tag.canPlace&&block.TileTag.canPlaceBy)
					{
						//Real Place
						setTile(frontX,frontY,PlaceId,PlaceData,PlaceTag);
						player.RemoveItem(PlaceId,1,PlaceData,PlaceTag);
						UpdateDebugText(2);
						//Set Hook
						onBlockPlace(frontX,frontY,PlaceId,PlaceData,PlaceTag);
					}
				}
			}
		}

		//--------Move Functions--------//
		private function testMove(Entity:Object,sx:int,sy:int,tx:int,ty:int):Boolean
		{
			var canMove:Boolean=true;
			//trace("Tile:",getTileObject(tx,ty).canPass);
			//Test Blocks
			if (getTileObject(tx,ty)==null)
			{
				return false;
			}
			switch (Entity.moveType)
			{
				default :
					if (getTileID(tx,ty)>0&&!getTileTag(tx,ty).canPass)
					{
						canMove=false;
					}
					break;
			}
			//Test Entities
			var ent=testEntity(tx,ty);
			if (ent!=null)
			{
				if (ent.hasCollision)
				{
					canMove=false;
				}
			}
			return canMove;
		}

		private function testEntity(X:int,Y:int):Object
		{
			for (var i=0; i<this.EntityList.length; i++)
			{
				var ent=this.EntityList[i];
				if (ent!=null)
				{
					if (X==ent.getX()&&Y==ent.getY())
					{
						return ent;
					}
				}
			}
			return null;
		}

		private function StageMove(dir:int,dis:uint=1):void
		{
			var Pos:Array=[0,0];
			switch ((dir-1)%4+1)
			{
				case 1 :
					Pos=[dis,0];
					break;
				case 2 :
					Pos=[0,dis];
					break;
				case 3 :
					Pos=[- dis,0];
					break;
				case 4 :
					Pos=[0,- dis];
					break;
			}
			StageMoveTo(this.x+Pos[0],this.y+Pos[1]);
		}

		private function StageMoveTo(X:int,Y:int,sizeBuff:Boolean=false):void
		{
			if (sizeBuff)
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

		private function getPlayerCount()
		{
			if (PlayerList.length>0)
			{
				return PlayerList.length;
			}
			return 0;
		}

		//--------Tile Functions--------//
		private function setNewTile(X:int=0,Y:int=0,Id:int=1,Data:int=0x888888,Tag:Object=null):Object
		{
			if (getTileObject(X,Y)==null)
			{
				var tile=new Tile(X*tileSize,Y*tileSize,tileSize,tileSize,Id,Data,Tag);
				if (tile!=null)
				{
					Tiles["Tile_"+X+"_"+Y]=tile;
				}
				addChild(tile);
				TotalSpawnTiles++
				return tile;
			}
			return null;
		}

		private function resetTile(X:int,Y:int,Id:int,Data:int=0,Tag:Object=null):Boolean
		{
			var tile=getTileObject(X,Y);
			if (tile!=null)
			{
				tile.changeTile(Id,Data,Tag);
				return true;
			}
			return false;
		}

		private function getTile(X:int,Y:int):Array
		{
			if (getTileObject(X,Y)!=null)
			{
				return [getTileID(X,Y),getTileData[X,Y]];
			}
			else
			{
				return null;
			}
		}

		private function getTileObject(X:int,Y:int):Object
		{
			if (Tiles["Tile_"+X+"_"+Y] is Tile)
			{
				return Tiles["Tile_"+X+"_"+Y];
			}
			else
			{
				return null;
			}
		}

		private function getTileID(X:int,Y:int):int
		{
			if (getTileObject(X,Y)!=null)
			{
				return getTileObject(X,Y).TileID;
			}
			else
			{
				return -1;
			}
		}

		private function getTileData(X:int,Y:int):int
		{
			if (getTileObject(X,Y)!=null)
			{
				return getTileObject(X,Y).TileData;
			}
			else
			{
				return -1;
			}
		}

		private function getTileTag(X:int,Y:int):Object
		{
			if (getTileObject(X,Y)!=null)
			{
				return getTileObject(X,Y).TileTag;
			}
			else
			{
				return null;
			}
		}

		private function setTile(X:int,Y:int,Id:int,Data:int=0,Tag:Object=null):Boolean
		{
			var tile=getTileObject(X,Y);
			if (tile!=null)
			{
				tile.changeTile(Id,Data,Tag);
				return true;
			}
			return false;
		}

		//--------Hook Functions--------//
		private function onBlockDestroy(X:int,Y:int,Id:int,Data:int,Tag:Object):void
		{

		}

		private function onBlockPlace(X:int,Y:int,Id:int,Data:int,Tag:Object):void
		{

		}

		//--------Other Functions--------//
		private function getGameFrames():uint
		{
			return gameFrames;
		}

		private function UpdateDebugText(textNum:uint=0):void
		{
			if (textNum==1||textNum<1)
			{
				var DTT:String="";
				DTT+=GameName+" "+Version
				;
				DTT+="\n"+getGameFrames()+" frames per 1 secord";
				DTT+="\n\nWorldSeed="+WorldSpawnSeed+"\nV1="+V1+"\nV2="+V2+"\nV3="+V3+"\nV4="+V4;
				DTT+="\nWorldWidth="+WorldWidth+"\nWorldHeight="+WorldHeight
				DTT+="\n"+ShouldSpawnTiles+" tiles shoule be load"+"\n"+TotalSpawnTiles+" tiles loaded"
				DTT+="\nInfinityWorld="+isInfinityWorld;
				DTT+="\n\nLastKeyCode="+LastKey+"\nCenterPlayerID="+CenterPlayerID;
				DebugText.text=DTT;
			}
			if (textNum==2||textNum<1)
			{
				var DT2T:String="";
				for (var i=1; i<=getPlayerCount(); i++)
				{
					var P=PlayerList[i-1];
					if (getPlayerCount()>1)
					{
						DT2T+="<Player id="+i+">\n";
					}
					DT2T+=P.traceSelectedItem(false,false);
					DT2T+="\nX="+P.getX()+" Y="+P.getY();
					DT2T+="\nTotal Item Count="+P.getAllItemCount();
					if (getPlayerCount()>1)
					{
						DT2T+="\n<Player>";
					}
					if (i<getPlayerCount())
					{
						DT2T+="\n\n";
					}
				}
				DebugText2.text=DT2T;
			}
		}

		private function CleanDebugText(textNum:uint=0):void
		{
			if (textNum==1||textNum<1)
			{
				DebugText.text="";
			}
			if (textNum==2||textNum<1)
			{
				DebugText2.text="";
			}
		}

		//--------Math Functions--------//
		public static function random(X:Number):uint
		{
			return Math.floor(Math.random()*Math.abs(X));
		}

		public static function getPrime(X:Number):Array
		{
			var returnArr:Array=[];
			var t;
			for (var i:uint=2; i<=Math.ceil(Math.abs(X)); i++)
			{
				var Push:Boolean=true;
				for (t in returnArr)
				{
					if (i%returnArr[t]==0)
					{
						Push=false;
					}
				}
				if (Push)
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
			for (var i:uint=1; Arr.length<=X; i+=10)
			{
				Arr=getPrime(i);
			}
			if (Arr.length>=X)
			{
				returnUin=Arr[X];
			}
			return returnUin;
		}

		public static function isPrime(X:Number):Boolean
		{
			if (Math.abs(X)<2)
			{
				return false;
			}
			var ps:Array=getPrime(X+1);
			var i;
			for (i in ps)
			{
				if (ps[i]==X)
				{
					return true;
				}
			}
			return false;
		}
	}
}