﻿package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Game
	import TriangleCraft.Inventory.*
	import TriangleCraft.Entity.Entity
	import TriangleCraft.Entity.EntityID
	import TriangleCraft.Entity.Mobile.Mobile
	import TriangleCraft.Tile.TileDisplayObj;
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileSystem
	import TriangleCraft.Common.*

	use namespace intc

	//Class
	public class Player extends Mobile
	{
		//============Consts============//
		intc static const LineSize:Number=2
		intc static const PlayerColorByID:Array=[0x66CCFF,
												 0xFF6666,
												 0xFFFF66,
												 0x66FF66,
												 0x66FFFF,
												 0x6666FF,
												 0xCC66FF,
												 0x66FFCC,
												 0xFF66CC]
		protected static const SelectAlphaDelay:uint=Game.FPS/2
		
		//========Dynamic Variables========//
		//Graphics Variables
		intc var ID:uint=1;
		intc var LineColor:uint=0x888888;
		intc var FillColor:uint=0x888888;

		//Contol Variables
		intc var isKeyDown:Boolean=false;
		//
		intc var ContolDelay_Move:uint=Game.FPS*(1/4)
		intc var ContolDelay_Use:uint=Game.FPS*(1/4)
		intc var ContolDelay_Select:uint=Game.FPS*(1/5)
		//
		intc var ContolLoop_Move:uint=Game.FPS*(1/40)
		intc var ContolLoop_Use:uint=Game.FPS*(1/15)
		intc var ContolLoop_Select:uint=Game.FPS*(1/40)
		//
		intc var ContolKey_Up:uint;
		intc var ContolKey_Down:uint;
		intc var ContolKey_Left:uint;
		intc var ContolKey_Right:uint;
		intc var ContolKey_Use:uint;
		intc var ContolKey_Select_Left:uint;
		intc var ContolKey_Select_Right:uint;
		//
		intc var isPrass_Up:Boolean;
		intc var isPrass_Down:Boolean;
		intc var isPrass_Left:Boolean;
		intc var isPrass_Right:Boolean;
		intc var isPrass_Use:Boolean;
		intc var isPrass_Select_Left:Boolean;
		intc var isPrass_Select_Right:Boolean;
		//
		intc var KeyDelay_Move:int;
		intc var KeyDelay_Use:int;
		intc var KeyDelay_Select:int;

		//Attribute Variables
		intc var Ability:PlayerAbility=new PlayerAbility()
		protected var Inventory:ItemInventory=new ItemInventory();
		protected var SelectItemRevealed:TileDisplayObj=new TileDisplayObj(xSize,0);
		protected var RevealedAlphaDelay:int=Player.SelectAlphaDelay

		//--------Set Player--------//
		public function Player(
		   Host:Game,
		   X:Number,
		   Y:Number,
		   ID:uint,
		   fillColor:Number=NaN,
		   lineColor:Number=NaN,
		   sizeX:uint=TileSystem.globalTileSize,
		   sizeY:uint=TileSystem.globalTileSize)
		{
			//Set in Entity
			this.EntityType=EntityID.Player
			//Set in Mobile
			this.hasInventory=true
			//Super
			super(Host,X,Y,sizeX,sizeY);
			//Set ID
			this.ID=ID;
			//Set Shape
			if(isNaN(fillColor))
			{
				this.FillColor=Player.getColorByID(this.ID)
			}
			else
			{
				this.FillColor=uint(fillColor)
			}
			if(isNaN(lineColor))
			{
				var RGB:Array=Color.HEXtoRGB(this.FillColor);
				this.LineColor=Color.RGBtoHEX([RGB[0]/2,RGB[1]/2,RGB[2]/2]);
			}
			else
			{
				this.LineColor=uint(lineColor);
			}
			setPlayerShape();
			//Set Contol Key
			setContolKey();
			UpdateKeyDelay()
			//Add SelectItemRevealed
			SelectItemRevealed.x=xSize;
			SelectItemRevealed.y=0;
			addChild(SelectItemRevealed);
			//Set TickFunction
			this.TickFunction=onPlayerTick
		}

		//--------Contol Function--------//
		protected function setContolKey():void
		{
			switch(this.ID)
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
					ContolKey_Up=101;//Up:Num 5
					ContolKey_Down=98;//Down:Num 2
					ContolKey_Left=97;//Left:Num 1
					ContolKey_Right=99;//Right:Num 3
					ContolKey_Use=104;//Use:Num 8
					ContolKey_Select_Left=103;//Left Select:Num 7
					ContolKey_Select_Right=105;//Right Select:Num 9
					break;
					//P4
				case 4 :
					ContolKey_Up=85;//Up:U
					ContolKey_Down=74;//Down:J
					ContolKey_Left=72;//Left:H
					ContolKey_Right=75;//Right:K
					ContolKey_Use=187;//Use:"="
					ContolKey_Select_Left=189;//Left Select:"_"
					ContolKey_Select_Right=220;//Right Select:"\"
					break;
			}
		}
		
		protected function onPlayerTick(Ent:Entity=null):void
		{
			this.UpdateKeyDelay()
			this.DealKeyContol()
			this.UpdateRevealedAlpha()
		}

		//--------Display Function--------//
		public static function getColorByID(Id:uint):uint
		{
			if(isNaN(Player.PlayerColorByID[Id-1])) return 0xffffff
			return Player.PlayerColorByID[Id-1]
		}

		protected function setPlayerShape(Alpha:Number=1):void
		{
			var realRadiusX:Number=(xSize-LineSize)/2
			var realRadiusY:Number=(ySize-LineSize)/2
			graphics.clear();
			graphics.lineStyle(LineSize,this.LineColor);
			graphics.beginFill(this.FillColor,Alpha);
			graphics.moveTo(-realRadiusX,-realRadiusY);
			graphics.lineTo(realRadiusX,0);
			graphics.lineTo(-realRadiusX,realRadiusY);
			graphics.lineTo(-realRadiusX,-realRadiusY);
			graphics.endFill();
		}
		
		//--------Inventory Function--------//
		//Getters And Setters
		public function get AllItemCount():uint
		{
			return this.Inventory.ItemCount
		}

		public function get AllItemTypeCount():uint
		{
			return this.Inventory.TypeCount
		}

		public function get InventorySelect():uint
		{
			return this.Inventory.Select
		}

		public function set InventorySelect(Num:uint):void
		{
			this.Inventory.Select=Num
			//Show Item Revealed
			ShowItemRevealed();
		}

		public function get SelectedItem():InventoryItem
		{
			return this.Inventory.SelectItem
		}

		public function get SelectAItem():Boolean
		{
			return (this.InventorySelect>0)
		}

		//Basic Functions
		public function AddItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			//Add In Inventory
			this.Inventory.AddItem(Id,Count,Data,Tag,Rot)
			//Update Debug Text
			this.Host.UpdateDebugText(2)
		}

		public function RemoveItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			this.Inventory.RemoveItem(Id,Count,Data,Tag,Rot)
			ShowItemRevealed();
			//Update Debug Text
			this.Host.UpdateDebugText(2)
		}

		public function changeInventorySelect(num:int,emableLeft:Boolean=false,emableRight:Boolean=false):void
		{
			var oldSelect:int=this.InventorySelect
			//Set InventorySelect
			if(emableLeft&&num<0)
			{
				this.InventorySelect=this.Inventory.TypeCount;
			}
			else if(emableRight&&num>this.Inventory.TypeCount)
			{
				this.InventorySelect=0;
			}
			else
			{
				//Lash InventorySelect
				this.InventorySelect=Math.max(0,Math.min(num,this.Inventory.TypeCount));
			}
			//Update DebugText
			if(this.InventorySelect!=oldSelect)
			{
				Host.UpdateDebugText(2);
			}
		}

		public function SelectLeft():void
		{
			//Set InventorySelect
			changeInventorySelect(this.InventorySelect-1,false,false);
		}

		public function SelectRight():void
		{
			//Set InventorySelect
			changeInventorySelect(this.InventorySelect+1,false,false);
		}

		protected function ShowItemRevealed():void
		{
			//trace("InventorySelect="+InventorySelect,SelectedItem.Id,SelectedItem.Data,Inventory.length);
			if(InventorySelect>0&&TileSystem.isAllowID(this.SelectedItem.Id))
			{
				SelectItemRevealed.changeTile(this.SelectedItem.Id,this.SelectedItem.Data,this.SelectedItem.Tag,this.SelectedItem.Rot);
			}
			else
			{
				SelectItemRevealed.changeTile(TileID.Void,0)
			}
			UpdateSelectRot()
		}
		
		protected function UpdateRevealedAlpha():void
		{
			if(this.SelectAItem)
			{
				if(this.RevealedAlphaDelay<=-Player.SelectAlphaDelay) this.RevealedAlphaDelay=Player.SelectAlphaDelay
				else this.RevealedAlphaDelay--
				this.SelectItemRevealed.alpha=Math.abs(this.RevealedAlphaDelay)/Player.SelectAlphaDelay
			}
		}

		public function resetInventory():void
		{
			this.Inventory.ResetInventory()
			this.ShowItemRevealed()
		}

		public function traceSelectedItem(Trace:Boolean=true,ShowItemTags:Boolean=true):String
		{
			var Str:String=new String();
			Str+="<SelectedItem id="+(this.InventorySelect)+" total="+this.Inventory.TypeCount+">\n";
			if(!this.SelectAItem)
			{
				Str+="<SelectedItem>";
				return Str;
			}
			Str+="Id="+this.SelectedItem.Id+";";
			Str+="Count="+this.SelectedItem.Count+";";
			if(this.SelectedItem.Id=="Colored_Block")
			{
				var data16x=(this.SelectedItem.Data.toString(16).toUpperCase());
				while (data16x.length<6)
				{
					data16x="0"+data16x;
				}
				Str+="Data=0x"+data16x+";";
			}
			else
			{
				Str+="Data="+this.SelectedItem.Data+";";
			}
			if(ShowItemTags)
			{
				Str+="<Tag>";
				var j;
				for(j in this.SelectedItem.Tag)
				{
					Str+=j+":"+this.SelectedItem.Tag[j]+"\n";
				}
				Str+="<Tag>";
			}
			Str+="Rot="+this.SelectedItem.Rot+";";
			Str+="\n<SelectedItem>";
			if(Trace)
			{
				trace(Str);
			}
			return Str;
		}

		//----------Rotation Functions----------//
		public override function set Rot(rot:int):void
		{
			this.setRot(rot)
			UpdateSelectRot()
		}
		
		protected function UpdateSelectRot():void
		{
			var dir:int=this.Rot-1
			if(this.SelectItemRevealed!=null&&!SelectItemRevealed.Tag.canRotate)
			{
				this.SelectItemRevealed.setRotation(-dir+0)
			}
			else if(SelectItemRevealed.Tag.canRotate)
			{
				this.SelectItemRevealed.setRotation((dir+2)%4-dir+2)
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
						this.SelectRight()
					}
					else if(this.isPrass_Select_Left)
					{
						this.SelectLeft()
					}
				}
			}
		}
		
		public function MoveLeft():void
		{
			this.Host.PlayerMove(this,Mobile.Facing_Left,this.moveDistence)
		}
		
		public function MoveRight():void
		{
			this.Host.PlayerMove(this,Mobile.Facing_Right,this.moveDistence)
		}
		
		public function MoveUp():void
		{
			this.Host.PlayerMove(this,Mobile.Facing_Up,this.moveDistence)
		}
		
		public function MoveDown():void
		{
			this.Host.PlayerMove(this,Mobile.Facing_Down,this.moveDistence)
		}
		
		public function Use():void
		{
			this.Host.PlayerUse(this,this.moveDistence)
		}
	}
}