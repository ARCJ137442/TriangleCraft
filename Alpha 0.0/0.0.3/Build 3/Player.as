package 
{
	import Entity
	import Tile
	import TileTag
	import InventoryItem

	public class Player extends Entity
	{
		//Graphics Variables
		public var ID:uint=1;
		public var LineColor:uint=0x888888;
		public var FillColor:uint=0x888888;

		//Contol Variables
		public var ContolKey_Up:uint;
		public var ContolKey_Down:uint;
		public var ContolKey_Left:uint;
		public var ContolKey_Right:uint;
		public var ContolKey_Use:uint;
		public var ContolKey_Select_Left:uint;
		public var ContolKey_Select_Right:uint;
		public var ActiveKey_Up:Boolean=false;
		public var ActiveKey_Down:Boolean=false;
		public var ActiveKey_Left:Boolean=false;
		public var ActiveKey_Right:Boolean=false;
		public var ActiveKey_Use:Boolean=false;
		public var ActiveKey_Select_Left:Boolean=false;
		public var ActiveKey_Select_Right:Boolean=false;
		public var isKeyDown:Boolean=false;

		//Attribute Variables
		public var GameMode:Object={CanDestroy:true,CanPlace:true,InstantDestroy:false};
		public var Inventory:Array=[];
		public var InventorySelect:int=-1;
		public var SelectedItem:InventoryItem=null;
		public var SelectItemRevealed:Tile=new Tile(xSize,0);

		//--------Set Player--------//
		public function Player(
		   X:int,
		   Y:int,
		   sizeX:uint,
		   sizeY:uint,
		   ID:uint,
		   fillColor:uint=0xffffff,
		   lineColor:uint=0x888888)
		{
			//Set in Entity
			super(X,Y,sizeX,sizeY);
			this.ID=ID;
			//Set Shape
			if(fillColor!=0xffffff)
			{
				var RGB:Array=Color.HEXtoRGB(fillColor);
				this.LineColor=Color.RGBtoHEX([RGB[0]/2,RGB[1]/2,RGB[2]/2]);
			}
			else
			{
				this.LineColor=lineColor;
			}
			this.FillColor=fillColor;
			setPlayerShape(this.LineColor,this.FillColor);
			//Set Contol Key
			setContolKey();
			//Add SelectItemRevealed
			SelectItemRevealed.x=xSize;
			SelectItemRevealed.y=0;
			addChild(SelectItemRevealed);
		}

		//--------Contol Function--------//
		private function setContolKey():void
		{
			switch (this.ID)
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

		//--------Draw Function--------//
		private function setPlayerShape(lineColor:uint=0x000000,fillColor:uint=0x888888,Alpha:Number=1):void
		{
			graphics.clear();
			graphics.lineStyle(2,lineColor);
			graphics.beginFill(fillColor,Alpha);
			graphics.moveTo(-xSize/2,-ySize/2);
			graphics.lineTo(xSize/2,0);
			graphics.lineTo(-xSize/2,ySize/2);
			graphics.lineTo(-xSize/2,-ySize/2);
			graphics.endFill();
		}

		//--------Inventory Function--------//
		public function AddItem(Id:String,Count:uint=1,Data:int=0,Tag:TileTag=null,Rot:int=0):void
		{
			var traceMode:Boolean=false;
			//Spawn An Item
			var Item:InventoryItem=null;
			var ItemTag:TileTag=new TileTag(Id)
			if(traceMode)
			{
				trace("This is import Tags:");
				var ji;
				for (ji in Tag)
				{
					trace(ji+":"+Tag[ji]);
				}
			}
			if(Tag==null)
			{
				if(traceMode)
				{
					trace("Function have select Null Tag!");
				}
			}
			else
			{
				if(traceMode)
				{
					trace("Function have select Full Tag!");
				}
				ItemTag=Tag.getCopy()
			}
			Item=new InventoryItem(Id,Count,Data,ItemTag,Rot);
			//Add To Inventory
			var AddNewItem:Boolean=true;
			var i;
			for (i in this.Inventory)
			{
				var Item2=this.Inventory[i];
				if(traceMode)
				{
					trace("This is Item2 Tags:");
					var ti;
					for (ti in Item2.Tag)
					{
						trace(ti+":"+Item2.Tag[ti]);
					}
				}
				//&&Item2.Tag==Item.Tag//
				if(Item2.Id==Item.Id&&Item2.Data==Item.Data)
				{
					AddNewItem=false;
					Item2.Count+=Item.Count;
					return;
				}
			}
			if(AddNewItem)
			{
				this.Inventory.push(Item);
			}
			if(traceMode)
			{
				trace("This is Final Tags:");
				var hi;
				for (hi in Item.Tag)
				{
					trace(hi+":"+Item.Tag[hi]);
				}
			}
		}

		public function RemoveItem(Id:String,Count:uint=1,Data:int=0,Tag:Object=null):void
		{
			var i;
			for (i in this.Inventory)
			{
				var Item=this.Inventory[i];
				if(Item.Id==Id&&Item.Data==Data&&Item.Tag==Tag)
				{
					if(this.Inventory[i].Count-Count>0)
					{
						this.Inventory[i].Count-=Count;
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
			for (i in this.Inventory)
			{
				if(Inventory[i].Count is Number)
				{
					Num+=Inventory[i].Count;
				}
			}
			return Num;
		}

		public function changeInventorySelect(num:int,emableLeft:Boolean=true,emableRight:Boolean=true):void
		{
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

		private function ShowItemRevealed():void
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
				SelectItemRevealed.changeTile(Tile.Void,0)
			}
			UpdateSelectRot()
		}

		public function resetInventory():void
		{
			this.SelectedItem=null;
			this.InventorySelect=-1;
			this.Inventory=[];
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
			if(this.SelectedItem.Id==Tile.Colored_Block)
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
				for (j in this.SelectedItem.Tag)
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
			for (i in this.Inventory)
			{
				Str+="<Item Slot="+(i+1)+">";
				if(Inventory[i] is Object)
				{
					var j;
					for (j in Inventory[i])
					{
						if(j=="Tag"&&ShowItemTags)
						{
							Str+="<Tag>\n";
							var k;
							for (k in Inventory[i][j])
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

		//----Player Own Special Functions----//
		public function setPlayerPos(dir:uint):void
		{
			this.rotation=dir*90-90;
			UpdateSelectRot()
		}
		
		public function getPlayerPos():int
		{
			return this.rotation/90
		}
		
		private function UpdateSelectRot():void
		{
			var dir:int=getPlayerPos()
			if(this.SelectItemRevealed!=null&&!SelectItemRevealed.Tag.canRotate)
			{
				this.SelectItemRevealed.setRotation(-dir+0)
			}
			else if(SelectItemRevealed.Tag.canRotate)
			{
				this.SelectItemRevealed.setRotation((dir+2)%4-dir+2)
			}
		}
	}
}