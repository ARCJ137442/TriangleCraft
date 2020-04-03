package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Inventory.*
	import TriangleCraft.Entity.*
	import TriangleCraft.Entity.Mobile.*
	import TriangleCraft.Tile.*
	import TriangleCraft.Common.*
	

	//Class
	public class Player extends Mobile implements IhasSelectableInventory
	{
		//============Static Variables============//
		public static const LineSize:Number=2
		protected static const SelectAlphaDelay:uint=Game.FPS/2
		
		//============Static Functions============//
		public static function getColorByID(Id:uint):uint
		{
			if(isNaN(Player.PlayerColorByID[Id-1])) return 0xffffff
			return Player.PlayerColorByID[Id-1]
		}
		
		public static function get PlayerColorByID():Vector.<uint>
		{
			var returnVec:Vector.<uint>=new Vector.<uint>
			//Set
			returnVec[0]=0x66CCFF//Blue Cyan
			returnVec[1]=0xFF6666//Red
			returnVec[2]=0x66FF66//Green
			returnVec[3]=0xFFFF66//Yellow
			returnVec[4]=0x66FFFF//Cyan
			returnVec[5]=0xFF66FF//Purple
			returnVec[6]=0x6666FF//Blue
			returnVec[7]=0xCC66FF//Blue Purple
			returnVec[8]=0x66FFCC//Green Cyan
			returnVec[9]=0xCCFF66//Green Yellow
			returnVec[10]=0xFF66CC//Red Purple
			returnVec[11]=0xFFCC66//Red Yellow
			returnVec[12]=0x0000FF//Only Blue
			returnVec[13]=0x00FF00//Only Green
			returnVec[14]=0xFF0000//Only Red
			returnVec[15]=0xFFFF00//Only Yellow
			returnVec[16]=0xFF00FF//Only Purple
			returnVec[17]=0x00FFFF//Only Cyan
			//Return
			return returnVec
		}
		
		//============Instance Variables============//
		//Graphics Variables
		protected var _playerID:uint=1;
		protected var _lineColor:uint=0x888888;
		protected var _fillColor:uint=0x888888;

		//====Contol Variables====//
		public var isKeyDown:Boolean=false;
		//ContolDelay
		public var ContolDelay_Move:uint=Game.FPS*(1/4)
		public var ContolDelay_Use:uint=Game.FPS*(1/4)
		public var ContolDelay_Select:uint=Game.FPS*(1/5)
		//ContolLoop
		public var ContolLoop_Move:uint=Game.FPS*(1/40)
		public var ContolLoop_Use:uint=Game.FPS*(1/15)
		public var ContolLoop_Select:uint=Game.FPS*(1/40)
		//ContolKey
		public var ContolKey_Up:uint;
		public var ContolKey_Down:uint;
		public var ContolKey_Left:uint;
		public var ContolKey_Right:uint;
		public var ContolKey_Use:uint;
		public var ContolKey_Select_Left:uint;
		public var ContolKey_Select_Right:uint;
		//isPrass
		public var isPrass_Up:Boolean;
		public var isPrass_Down:Boolean;
		public var isPrass_Left:Boolean;
		public var isPrass_Right:Boolean;
		public var isPrass_Use:Boolean;
		public var isPrass_Select_Left:Boolean;
		public var isPrass_Select_Right:Boolean;
		//KeyDelay
		public var KeyDelay_Move:int;
		public var KeyDelay_Use:int;
		public var KeyDelay_Select:int;

		//====Attribute Variables====
		protected var _ability:PlayerAbility=new PlayerAbility()
		protected var _inventory:ItemInventory=new ItemInventory();
		protected var _selectItemRevealed:TileDisplayObj=new TileDisplayObj(TileDisplayFrom.IN_ENTITY,xSize,0);
		protected var _revealedAlphaDelay:int=Player.SelectAlphaDelay

		//============Init Player============//
		public function Player(
		   Host:Game,
		   X:Number,
		   Y:Number,
		   ID:uint,
		   fillColor:Number=NaN,
		   lineColor:Number=NaN,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize):void
		{
			//Set in Entity
			this._entityType=EntityType.Player
			//Super
			super(Host,X,Y,sizeX,sizeY);
			//Set ID
			this._playerID=ID;
			//Set Shape
			if(isNaN(fillColor)) this._fillColor=Player.getColorByID(this.playerID)
			else this._fillColor=uint(fillColor)
			if(isNaN(lineColor))
			{
				var HSV:Vector.<Number>=Color.HEXtoHSV(this.fillColor);
				this._lineColor=Color.HSVtoHEX(HSV[0],HSV[1],HSV[2]/2);
			}
			else this._lineColor=uint(lineColor);
			setPlayerShape();
			//Set Contol Key
			setContolKey();
			UpdateKeyDelay()
			//Add SelectItemRevealed
			_selectItemRevealed.x=xSize;
			_selectItemRevealed.y=0;
			this.UpdateItemRevealed()
			addChild(_selectItemRevealed);
			//Set TickFunction
			this._tickRunFunction=onPlayerTick
		}
		
		//============Instance Functions============//
		public function loadInventory(Mode:String):void
		{
			switch(Mode)
			{
				case PlayerGameMode.BASIC:
				this.inventory.resetInventory()
				this.inventory.addItem(TileID.Block_Crafter)
				break
				case PlayerGameMode.ADMIN:
				this.inventory.resetInventory()
				for(var i:uint=0;i<TileSystem.TotalTileCount;i++)
				{
					var tileID:String=String(TileSystem.AllTileID[i])
					if(TileSystem.isAllowID(tileID)&&!TileAttributes.fromID(tileID).technical)
					{
						this.inventory.addItem(tileID,1)
					}
				}
				break
				case PlayerGameMode.NULL:
				this.inventory.resetInventory()
				break
			}
		}
		
		//==========Getters And Setters==========//
		public function get ability():PlayerAbility
		{
			return this._ability
		}
		
		public function get inventory():ItemList
		{
			return this._inventory as ItemInventory
		}
		
		public function set gameMode(Mode:String):void
		{
			switch(Mode)
			{
				case PlayerGameMode.BASIC:
				this._ability.loadDefault()
				break
				case PlayerGameMode.ADMIN:
				this._ability.loadFull()
				break
				case PlayerGameMode.NULL:
				this._ability.loadEmpty()
				break
			}
			this.loadInventory(Mode)
		}

		//--------Contol Function--------//
		protected function setContolKey():void
		{
			switch(this.playerID)
			{
					//P1
				default :
					ContolKey_Up=87;//Up:W
					ContolKey_Down=83;//Down:S
					ContolKey_Left=65;//Left:A
					ContolKey_Right=68;//Right:D
					ContolKey_Use=32;//Use:Space
					ContolKey_Select_Left=81;//Left Select:Q
					ContolKey_Select_Right=69;//Right Select:E
					break;
					//P2
				case 2 :
					ContolKey_Up=38;//Up:Key_UP
					ContolKey_Down=40;//Down:Key_DOWN
					ContolKey_Left=37;//Left:Key_Left
					ContolKey_Right=39;//Right:Key_RIGHT
					ContolKey_Use=190;//Use:">"
					ContolKey_Select_Left=188;//Left Select:"<"
					ContolKey_Select_Right=191;//Right Select:"/"
					break;
					//P3
				case 3 :
					ContolKey_Up=85;//Up:U
					ContolKey_Down=74;//Down:J
					ContolKey_Left=72;//Left:H
					ContolKey_Right=75;//Right:K
					ContolKey_Use=80;//Use:P
					ContolKey_Select_Left=89;//Left Select:Y
					ContolKey_Select_Right=73;//Right Select:I
					break;
					//P4
				case 4 :
					ContolKey_Up=101;//Up:Num 5
					ContolKey_Down=98;//Down:Num 2
					ContolKey_Left=97;//Left:Num 1
					ContolKey_Right=99;//Right:Num 3
					ContolKey_Use=105;//Use:Num 9
					ContolKey_Select_Left=100;//Left Select:Num 4
					ContolKey_Select_Right=102;//Right Select:Num 6
					break;
			}
		}
		
		protected function onPlayerTick(Ent:Entity=null):void
		{
			this.UpdateKeyDelay()
			this.DealKeyContol()
			this.UpdateRevealedAlpha()
		}

		//-----==---Display Functions---==-----//

		protected function setPlayerShape(Alpha:Number=1):void
		{
			var realRadiusX:Number=(xSize-LineSize)/2
			var realRadiusY:Number=(ySize-LineSize)/2
			graphics.clear();
			graphics.lineStyle(LineSize,this.lineColor);
			graphics.beginFill(this.fillColor,Alpha);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			graphics.endFill();
		}
		
		public function UpdateItemRevealed():void
		{
			if(this.selectedItem!=null&&this.inventorySelect>0)
			{
				_selectItemRevealed.visible=true
				_selectItemRevealed.changeTile(this.selectedItem.id,this.selectedItem.data);
			}
			else
			{
				_selectItemRevealed.visible=false
			}
			UpdateSelectRot()
		}
		
		protected function UpdateRevealedAlpha():void
		{
			if(this._selectItemRevealed.visible&&this.isSelectItem)
			{
				if(this._revealedAlphaDelay<=-Player.SelectAlphaDelay) this._revealedAlphaDelay=Player.SelectAlphaDelay
				else this._revealedAlphaDelay--
				this._selectItemRevealed.alpha=Math.abs(this._revealedAlphaDelay)/Player.SelectAlphaDelay
			}
		}
		
		//--------Inventory Function--------//
		//Getters And Setters
		public function get allItemCount():uint
		{
			return this.inventory.itemCount
		}

		public function get allItemTypeCount():uint
		{
			return this.inventory.typeCount
		}

		public function get inventorySelect():uint
		{
			return (this.inventory as ItemInventory)!=null?(this.inventory as ItemInventory).select:0
		}

		public function set inventorySelect(num:uint):void
		{
			(this.inventory as ItemInventory).select=num
			//Show Item Revealed
			UpdateItemRevealed();
		}

		public function get selectedItem():InventoryItem
		{
			return (this.inventory as ItemInventory)!=null?(this.inventory as ItemInventory).selectItem:null
		}

		public function get isSelectItem():Boolean
		{
			return (this.inventorySelect>0)
		}

		//Basic Methods Implement From Interface
		public function addItem(id:String,count:uint=1,data:int=0):void
		{
			//Add In Inventory
			this.inventory.addItem(id,count,data)
			//Update ItemRevealed
			this.UpdateItemRevealed()
			//Update Debug Text
			this.host.UpdateDebugText(2)
		}

		public function removeItem(id:String,count:uint=1,data:int=0):void
		{
			this.inventory.removeItem(id,count,data)
			//Update ItemRevealed
			this.UpdateItemRevealed()
			//Update Debug Text
			this.host.UpdateDebugText(2)
		}
		
		public function hasItemIn(id:String,count:uint=1,data:int=0):Boolean
		{
			return this.inventory.hasItemIn(new InventoryItem(id,count,data))
		}

		public function changeInventorySelect(num:int,emableLeft:Boolean=false,emableRight:Boolean=false):void
		{
			var oldSelect:int=this.inventorySelect
			//Set InventorySelect
			if(emableLeft&&num<0)
			{
				this.inventorySelect=this.inventory.typeCount;
			}
			else if(emableRight&&num>this.inventory.typeCount)
			{
				this.inventorySelect=0;
			}
			else
			{
				//Lash InventorySelect
				this.inventorySelect=Math.max(0,Math.min(num,this.inventory.typeCount));
			}
			//Update DebugText
			if(this.inventorySelect!=oldSelect)
			{
				host.UpdateDebugText(2);
			}
		}

		public function selectLeft():void
		{
			//Set InventorySelect
			changeInventorySelect(this.inventorySelect-1,false,false);
		}

		public function selectRight():void
		{
			//Set InventorySelect
			changeInventorySelect(this.inventorySelect+1,false,false);
		}

		public function resetInventory():void
		{
			this.inventory.resetInventory()
			this.UpdateItemRevealed()
		}

		public function traceSelectedItem(Trace:Boolean=true,ShowItemAttributes:Boolean=true):String
		{
			var Str:String=new String();
			Str+="<SelectedItem id="+(this.inventorySelect)+" total="+this.inventory.typeCount+">\n";
			if(!this.isSelectItem)
			{
				Str+="<SelectedItem>";
				return Str;
			}
			Str+="Id="+this.selectedItem.id+";";
			Str+="Count="+this.selectedItem.count+";";
			if(this.selectedItem.id=="Colored_Block")
			{
				var data16x=(this.selectedItem.data.toString(16).toUpperCase());
				while (data16x.length<6)
				{
					data16x="0"+data16x;
				}
				Str+="Data=0x"+data16x+";";
			}
			else
			{
				Str+="Data="+this.selectedItem.data+";";
			}/*
			if(ShowItemAttributes)
			{
				Str+="<attributes>";
				var j;
				for(j in this.SelectedItem.attributes)
				{
					Str+=j+":"+this.SelectedItem.attributes[j]+"\n";
				}
				Str+="</attributes>";
			}*/
			Str+="\n<SelectedItem>";
			if(Trace)
			{
				trace(Str);
			}
			return Str;
		}

		//----------Rotation Functions----------//
		public override function set rot(rot:int):void
		{
			super.rot=rot
			UpdateSelectRot()
		}
		
		protected function UpdateSelectRot():void
		{
			var dir:int=MobileRot.toTileRot(this.rot)
			if(this._selectItemRevealed!=null&&!_selectItemRevealed.attributes.canRotate)
			{
				this._selectItemRevealed.rot=-dir
			}
			else if(_selectItemRevealed.attributes.canRotate)
			{
				this._selectItemRevealed.rot=(dir+2)%4-dir+2
			}
		}
		
		//----------Contol Functions----------//
		public function set PrassLeft(Turn:Boolean):void
		{
			this.isPrass_Left=Turn
		}
		
		public function set PrassRight(Turn:Boolean):void
		{
			this.isPrass_Right=Turn
		}
		
		public function set PrassUp(Turn:Boolean):void
		{
			this.isPrass_Up=Turn
		}
		
		public function set PrassDown(Turn:Boolean):void
		{
			this.isPrass_Down=Turn
		}
		
		public function set PrassUse(Turn:Boolean):void
		{
			this.isPrass_Use=Turn
		}
		
		public function set PrassLeftSelect(Turn:Boolean):void
		{
			this.isPrass_Select_Left=Turn
		}
		
		public function set PrassRightSelect(Turn:Boolean):void
		{
			this.isPrass_Select_Right=Turn
		}
		
		public function get playerID():uint 
		{
			return this._playerID
		}
		
		public function get fillColor():uint 
		{
			return this._fillColor;
		}
		
		public function get lineColor():uint 
		{
			return this._lineColor;
		}
		
		public function UpdateKeyDelay():void
		{
			//trace(this.KeyDelay_Move,this.ContolDelay_Move,this.ContolLoop_Move)
			//Set
			if(this.isKeyDown)
			{
				//Move
				if(this.isPrass_Left||this.isPrass_Right||
				   this.isPrass_Up||this.isPrass_Down)
				{
					this.KeyDelay_Move++
					if(this.KeyDelay_Move>=this.ContolLoop_Move)
					{
						this.KeyDelay_Move=0
					}
				}
				else
				{
					this.KeyDelay_Move=-ContolDelay_Move
				}
				//Use
				if(this.isPrass_Use)
				{
					this.KeyDelay_Use++
					if(this.KeyDelay_Use>=this.ContolLoop_Use)
					{
						this.KeyDelay_Use=0
					}
				}
				else
				{
					this.KeyDelay_Use=-ContolDelay_Use
				}
				//Select_Left
				if(this.isPrass_Select_Left||this.isPrass_Select_Right)
				{
					this.KeyDelay_Select++
					if(this.KeyDelay_Select>=this.ContolLoop_Select)
					{
						this.KeyDelay_Select=0
					}
				}
				else
				{
					this.KeyDelay_Select=-ContolDelay_Select
				}
			}
			//Reset
			else
			{
				this.KeyDelay_Move=-ContolDelay_Move
				this.KeyDelay_Use=-ContolDelay_Use
				this.KeyDelay_Select=-ContolDelay_Select
			}
		}
		
		public function DealKeyContol():void
		{
			if(this.isKeyDown)
			{
				//Move
				if(this.KeyDelay_Move==0)
				{
					//Up
					if(this.isPrass_Up)
					{
						this.MoveUp()
					}
					//Down
					else if(this.isPrass_Down)
					{
						this.MoveDown()
					}
					//Left
					else if(this.isPrass_Left)
					{
					this.MoveLeft()
					}
					//Right
					else if(this.isPrass_Right)
					{
						this.MoveRight()
					}
				}
				//Use
				if(this.KeyDelay_Use==0)
				{
					if(this.isPrass_Use)
					{
						this.Use()
					}
				}
				//Select_Left
				if(this.KeyDelay_Select==0)
				{
					//Select_Right
					if(this.isPrass_Select_Right)
					{
						this.selectRight()
					}
					else if(this.isPrass_Select_Left)
					{
						this.selectLeft()
					}
				}
			}
		}
		
		public function moveForward():void
		{
			switch(this.rot)
			{
				case MobileRot.RIGHT:
					MoveRight()
					break
				case MobileRot.LEFT:
					MoveLeft()
					break
				case MobileRot.UP:
					MoveUp()
					break
				case MobileRot.DOWN:
					MoveDown()
					break
			}
		}
		
		public function MoveLeft():void
		{
			this.host.PlayerMove(this,MobileRot.LEFT,this.moveDistence)
		}
		
		public function MoveRight():void
		{
			this.host.PlayerMove(this,MobileRot.RIGHT,this.moveDistence)
		}
		
		public function MoveUp():void
		{
			this.host.PlayerMove(this,MobileRot.UP,this.moveDistence)
		}
		
		public function MoveDown():void
		{
			this.host.PlayerMove(this,MobileRot.DOWN,this.moveDistence)
		}
		
		public function Use():void
		{
			this.host.PlayerUse(this,this.moveDistence)
		}
	}
}