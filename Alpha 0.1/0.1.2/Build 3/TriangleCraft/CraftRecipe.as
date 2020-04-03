package TriangleCraft
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.InventoryItem
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Tile.TileTag;
	import TriangleCraft.Tile.TileID;
	import TriangleCraft.Tile.Tile;
	use namespace intc
	
	//Flash
	import flash.errors.IllegalOperationError;
	
	//Class
	public class CraftRecipe
	{
		private static var ErrorMessage:String=""
		
		private var Input:Array=new Array()
		private var Output:Array=new Array()
		public var returnAsItem:Boolean=false
		
		//Example:"lll","fff","lll",["l",TileSystem.Colored_Block,"f",TileSystem.Block_Spawner],
		//"lll","fff","lll",["l",TileSystem.Colored_Block,"f",TileSystem.Block_Spawner]
		public function CraftRecipe(PatternTop:String,PatternMiddle:String,PatternDown:String,PatternCurrent:Array,
									OutputTop:String,OutputMiddle:String,OutputDown:String,OutputCurrent:Array,
									returnAsItem:Boolean=true)
		{
			//Detect Variables
			this.returnAsItem=returnAsItem
			var hasError:Boolean=false
			var PatternBit:Array=new Array()
			var OutputBit:Array=new Array()
			//Length
			if(PatternTop.length!=3||PatternMiddle.length!=3||PatternDown.length!=3||
			   OutputTop.length!=3||OutputMiddle.length!=3||OutputDown.length!=3)
			{
				hasError=true
				addError("Pattern","Length")
			}
			//Load PatternBit
			var i:uint=0
			for(i=0;i<3;i++)
			{
				//Input
				if(!General.IsiA(PatternTop.charAt(i),PatternBit))
				{
					PatternBit.push(PatternTop.charAt(i))
				}
				if(!General.IsiA(PatternMiddle.charAt(i),PatternBit))
				{
					PatternBit.push(PatternMiddle.charAt(i))
				}
				if(!General.IsiA(PatternDown.charAt(i),PatternBit))
				{
					PatternBit.push(PatternDown.charAt(i))
				}
				//Output
				if(!General.IsiA(OutputTop.charAt(i),OutputBit))
				{
					OutputBit.push(OutputTop.charAt(i))
				}
				if(!General.IsiA(OutputMiddle.charAt(i),OutputBit))
				{
					OutputBit.push(OutputMiddle.charAt(i))
				}
				if(!General.IsiA(OutputDown.charAt(i),OutputBit))
				{
					OutputBit.push(OutputDown.charAt(i))
				}
			}
			//Set Items
			var InputItems:Object={},OutputItems:Object={}
			for(i=0;i<PatternBit.length;i++)
			{
				InputItems[PatternBit[i]]=findItemAsBit(PatternBit[i],PatternCurrent)
			}
			for(i=0;i<OutputBit.length;i++)
			{
				OutputItems[OutputBit[i]]=findItemAsBit(OutputBit[i],OutputCurrent)
			}
			for(i=0;i<3;i++)
			{
				this.Input[i]=InputItems[PatternTop.charAt(i)]
				this.Input[3+i]=InputItems[PatternMiddle.charAt(i)]
				this.Input[6+i]=InputItems[PatternDown.charAt(i)]
				this.Output[i]=OutputItems[OutputTop.charAt(i)]
				this.Output[3+i]=OutputItems[OutputMiddle.charAt(i)]
				this.Output[6+i]=OutputItems[OutputDown.charAt(i)]
			}
			//Throw Error
			throwError()
		}
		
		private function findItemAsBit(Bit,Current:Array):InventoryItem
		{
			var Loc:int=Current.indexOf(Bit)
			var ItemId:*,ItemData:*,ItemTag:*,ItemRot:*
			if(Loc>=0)
			{
				ItemId=Current[Loc+1]
				ItemData=Current[Loc+2]
				ItemTag=Current[Loc+3]
				ItemRot=Current[Loc+4]
				//Check
				if(ItemId==undefined||ItemData==undefined||ItemTag==undefined||ItemRot==undefined)
				{
					addError("undefined")
				}
				if(!ItemId is String||!ItemData is int||!ItemTag is TileTag||!ItemRot is int)
				{
					addError("Invalid")
				}
				return new InventoryItem(ItemId,1,ItemData,ItemTag,ItemRot)
			}
			return new InventoryItem(TileID.Void,1,0,null,0)
		}
		
		//============Getter Functions============//
		public function getInputItem(Loc:uint):InventoryItem
		{
			return this.Input[General.NumberBetween(Loc,0,8)]
		}
		
		public function isInNull(Loc:uint):Boolean
		{
			if(getInputItem(Loc)==null)
			{
				return true
			}
			return false
		}
		
		public function getInputID(Loc:uint):String
		{
			if(isInNull(Loc))
			{
				return TileID.Void
			}
			return getInputItem(Loc).Id
		}
		
		public function getInputCount(Loc:uint):uint
		{
			if(isInNull(Loc))
			{
				return 1
			}
			return getInputItem(Loc).Count
		}
		
		public function getInputData(Loc:uint):int
		{
			if(isInNull(Loc))
			{
				return 0
			}
			return getInputItem(Loc).Data
		}
		
		public function getInputTag(Loc:uint):TileTag
		{
			if(isInNull(Loc))
			{
				return null
			}
			return getInputItem(Loc).Tag
		}
		
		public function getInputRot(Loc:uint):int
		{
			if(isInNull(Loc))
			{
				return 0
			}
			return getInputItem(Loc).Rot
		}
		
		public function getOutputItem(Loc:uint):InventoryItem
		{
			var OI:InventoryItem=this.Output[General.NumberBetween(Loc,0,8)]
			return OI
		}
		
		public function isOutNull(Loc:uint):Boolean
		{
			if(getOutputItem(Loc)==null)
			{
				return true
			}
			return false
		}
		
		public function getOutputID(Loc:uint):String
		{
			if(isOutNull(Loc))
			{
				return TileID.Void
			}
			return getOutputItem(Loc).Id
		}
		
		public function getOutputCount(Loc:uint):uint
		{
			if(isOutNull(Loc))
			{
				return 1
			}
			return getOutputItem(Loc).Count
		}
		
		public function getOutputData(Loc:uint):int
		{
			if(isOutNull(Loc))
			{
				return 0
			}
			return getOutputItem(Loc).Data
		}
		
		public function getOutputTag(Loc:uint):TileTag
		{
			if(isOutNull(Loc))
			{
				return null
			}
			return getOutputItem(Loc).Tag
		}
		
		public function getOutputRot(Loc:uint):int
		{
			if(isOutNull(Loc))
			{
				return 0
			}
			return getOutputItem(Loc).Rot
		}
		
		//============Test Functions============//
		public function testCanCraft(Inputs:Array):Boolean
		{
			if(Inputs.length!=9)
			{
				return false
			}
			for(var i:uint=0;i<Inputs.length;i++)
			{
				if(!this.Input[i].isEqual(Inputs[i]))
				{
					return false
				}
			}
			return true
		}
		
		//============Error Functions============//
		private static function addError(Type:String,Value:*=""):void
		{
			var ES:String
			switch(Type)
			{
				case "Pattern":
				ES="Invalid Pattern:"+Value+" Error!"
				return
				case "undefined":
				ES="Undefined Value!"
				return
				case "Invalid":
				ES="Invalid Value!"
				return
				default:
				ES="Unknown Error"
				return
			}
			if(ErrorMessage.length>0)
			{
				ErrorMessage+="\n"
			}
			ErrorMessage+=ES
		}
		
		private static function throwError():void
		{
			if(ErrorMessage.length>0)
			{
				throw new IllegalOperationError(ErrorMessage)
			}
		}
	}
}