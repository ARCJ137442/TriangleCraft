﻿package TriangleCraft.Player
{
	//TriangleCraft
	import TriangleCraft.Color
	import TriangleCraft.Game
	import TriangleCraft.Player.*
	import TriangleCraft.Entity.Entity
	import TriangleCraft.Entity.EntitySystem
	import TriangleCraft.Entity.Mobile.Mobile
	import TriangleCraft.Tile.Tile
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileTag
	import TriangleCraft.Tile.TileSystem
	import TriangleCraft.InventoryItem

	//Class
	public class Player extends Mobile
	{
		//============Consts============//
		public static const LineSize:Number=2
		public static const PlayerColorByID:Array=[0x66CCFF,
												   0xFF6666,
												   0xFFFF66,
												   0x66FF66,
												   0x66FFFF,
												   0x6666FF,
												   0xCC66FF,
												   0x66FFCC,
												   0xFF66CC]
		
		//========Dynamic Variables========//
		//Graphics Variables
		public var ID:uint=1;
		public var LineColor:uint=0x888888;
		public var FillColor:uint=0x888888;

		//Contol Variables
		public var isKeyDown:Boolean=false;
		//
		public var ContolDelay_Move:uint=Game.FPS*(1/4)
		public var ContolDelay_Use:uint=Game.FPS*(1/4)
		public var ContolDelay_Select:uint=Game.FPS*(1/5)
		//
		public var ContolLoop_Move:uint=Game.FPS*(1/40)
		public var ContolLoop_Use:uint=Game.FPS*(1/15)
		public var ContolLoop_Select:uint=Game.FPS*(1/40)
		//
		public var ContolKey_Up:uint;
		public var ContolKey_Down:uint;
		public var ContolKey_Left:uint;
		public var ContolKey_Right:uint;
		public var ContolKey_Use:uint;
		public var ContolKey_Select_Left:uint;
		public var ContolKey_Select_Right:uint;
		//
		public var isPrass_Up:Boolean;
		public var isPrass_Down:Boolean;
		public var isPrass_Left:Boolean;
		public var isPrass_Right:Boolean;
		public var isPrass_Use:Boolean;
		public var isPrass_Select_Left:Boolean;
		public var isPrass_Select_Right:Boolean;
		//
		public var KeyDelay_Move:int;
		public var KeyDelay_Use:int;
		public var KeyDelay_Select:int;

		//Attribute Variables
		public var Ability:PlayerAbility=new PlayerAbility()
		public var SelectedItem:InventoryItem=null;
		protected var Inventory:Array=[];
		protected var InventorySelect:int=-1;
		protected var SelectItemRevealed:Tile=new Tile(xSize,0);

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
			this.EntityType=EntitySystem.Player
			super(Host,X,Y,sizeX,sizeY);
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
		public function AddItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			//Spawn An Item
			var Item:InventoryItem=null;
			var ItemTag:TileTag=new TileTag(Id)
			if(Tag==null)
			{
			}
			else
			{
				ItemTag=Tag.getCopy()
			}
			Item=new InventoryItem(Id,Count,Data,ItemTag,Rot);
			//Add To Inventory
			var AddNewItem:Boolean=true;
			var i;
			for(i in this.Inventory)
			{
				var Item2:InventoryItem=this.Inventory[i];
				if(Item.isEqual(Item2))
				{
					AddNewItem=false;
					Item2.Count+=Item.Count;
				}
			}
			if(AddNewItem)
			{
				this.Inventory.push(Item);
			}
			//Update Debug Text
			this.Host.UpdateDebugText(2)
		}

		public function RemoveItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			var Item2:InventoryItem=new InventoryItem(Id,Count,Data,Tag,Rot)
			for(var i in this.Inventory)
			{
				var Item:InventoryItem=this.Inventory[i];
				if(Item.isEqual(Item2))
				{
					if(Item.Count-Count>0)
					{
						Item.Count-=Count;
					}
					else
					{
						this.Inventory.splice(i,1);
					}
					break;
				}
			}
			ShowItemRevealed();
		}

		public function getAllItemCount():uint
		{
			var Num:uint=0;
			var i;
			for(i in this.Inventory)
			{
				if(Inventory[i].Count is Number)
				{
					Num+=Inventory[i].Count;
				}
			}
			return Num;
		}
		
		public function get SelectAItem():Boolean
		{
			return (this.InventorySelect>=0)
		}

		public function changeInventorySelect(num:int,emableLeft:Boolean=true,emableRight:Boolean=true):void
		{
			var oldSelect:int=this.InventorySelect
			//Set InventorySelect
			if(num<-1&&emableLeft)
			{
				this.InventorySelect=this.Inventory.length-1;
				//trace(num,emableLeft,emableRight,InventorySelect)
			}
			else if(num>=this.Inventory.length&&emableRight)
			{
				this.InventorySelect=-1;
			}
			//Lash InventorySelect
			this.InventorySelect=Math.min(Math.max(num,-1),this.Inventory.length-1);
			//Show Item Revealed
			ShowItemRevealed();
			//Update DebugText
			if(this.InventorySelect!=oldSelect)
			{
				Host.UpdateDebugText(2);
			}
		}

		public function SelectLeft():void
		{
			//Set InventorySelect
			changeInventorySelect(this.InventorySelect-1,true,false);
		}

		public function SelectRight():void
		{
			//Set InventorySelect
			changeInventorySelect(this.InventorySelect+1,true,false);
		}

		protected function ShowItemRevealed():void
		{
			//trace("InventorySelect="+InventorySelect,SelectedItem.Id,SelectedItem.Data,Inventory.length);
			if(InventorySelect>-1&&Inventory[InventorySelect]!=undefined)
			{
				SelectedItem=Inventory[InventorySelect];
			}
			else if(Inventory[InventorySelect]==undefined&&Inventory[InventorySelect-1]!=undefined)
			{
				InventorySelect--;
				SelectedItem=Inventory[InventorySelect];
			}
			else
			{
				InventorySelect=-1;
				SelectedItem=null;
			}
			if(InventorySelect>=0&&TileSystem.isAllowID(SelectedItem.Id))
			{
				SelectItemRevealed.changeTile(SelectedItem.Id,SelectedItem.Data);
			}
			else
			{
				SelectItemRevealed.changeTile(TileID.Void,0)
			}
			UpdateSelectRot()
		}

		public function resetInventory():void
		{
			this.SelectedItem=null;
			this.InventorySelect=-1;
			this.Inventory=[];
			this.ShowItemRevealed()
		}

		public function traceSelectedItem(Trace:Boolean=true,ShowItemTags:Boolean=true):String
		{
			var Str:String=new String();
			Str+="<SelectedItem id="+(this.InventorySelect+1)+" total="+(this.Inventory.length)+">\n";
			if(this.InventorySelect<0)
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

		public function traceInventory(Trace:Boolean=true,ShowItemTags:Boolean=true):String
		{
			var Str:String=new String();
			Str+="<Inventory>\n";
			var i;
			for(i in this.Inventory)
			{
				Str+="<Item Slot="+(i+1)+">";
				if(Inventory[i] is Object)
				{
					var j;
					for(j in Inventory[i])
					{
						if(j=="Tag"&&ShowItemTags)
						{
							Str+="<Tag>\n";
							var k;
							for(k in Inventory[i][j])
							{
								Str+=k+":"+Inventory[i][j][k]+"\n";
							}
							Str+="<Tag>\n";
						}
						else if(j!="Tag"&&j=="Data")
						{
							Str+=j+":"+Inventory[i][j].toString(16)+";";
						}
						else
						{
							Str+=j+":"+Inventory[i][j]+";";
						}
					}
				}
				Str+="<Item>\n";
			}
			Str+="<Inventory>";
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