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
		//============Static Variables============//
		protected static var ErrorMessage:String=""
		
		//============Instance Variables============//
		protected var Input:Vector.<InventoryItem>=new Vector.<InventoryItem>(9,true)
		protected var Output:Vector.<InventoryItem>=new Vector.<InventoryItem>(9,true)
		
		protected var _returnAsItem:Boolean=false
		protected var _ignoreTag:Boolean=true
		protected var _ignoreHard:Boolean=true
		
		//============Init CraftRecipe============//
		public function CraftRecipe(PatternTop:String,PatternMiddle:String,PatternDown:String,PatternCurrent:Array,
									OutputTop:String,OutputMiddle:String,OutputDown:String,OutputCurrent:Array,
									returnAsItem:Boolean=true,ignoreTag:Boolean=true,ignoreHard:Boolean=true)
		{
			//Set Variables
			this.returnAsItem=returnAsItem
			this.ignoreTag=ignoreTag
			this.ignoreHard=ignoreHard
			//Detect Variables
			var hasError:Boolean=false
			var PatternBit:Vector.<String>=new Vector.<String>
			var OutputBit:Vector.<String>=new Vector.<String>
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
				this.Input[i]=InputItems[PatternTop.charAt(i)] as InventoryItem
				this.Input[3+i]=InputItems[PatternMiddle.charAt(i)] as InventoryItem
				this.Input[6+i]=InputItems[PatternDown.charAt(i)] as InventoryItem
				this.Output[i]=OutputItems[OutputTop.charAt(i)] as InventoryItem
				this.Output[3+i]=OutputItems[OutputMiddle.charAt(i)] as InventoryItem
				this.Output[6+i]=OutputItems[OutputDown.charAt(i)] as InventoryItem
			}
			//Throw Error
			throwError()
		}
		//============Getters And Setters============//
		public function get returnAsItem():Boolean
		{
			return this._returnAsItem
		}
		
		public function set returnAsItem(value:Boolean):void
		{
			this._returnAsItem=value
		}
		
		public function get ignoreTag():Boolean
		{
			return this._ignoreTag
		}
		
		public function set ignoreTag(value:Boolean):void
		{
			this._ignoreTag=value
		}
		
		public function get ignoreHard():Boolean
		{
			return this._ignoreHard
		}
		
		public function set ignoreHard(value:Boolean):void
		{
			this._ignoreHard=value
		}
		//============Instance Functions============//
		protected function findItemAsBit(Bit,Current:Array):InventoryItem
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
		public function testCanCraft(Inputs:Vector.<InventoryItem>):Boolean
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
		protected static function addError(Type:String,Value:*=""):void
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
		
		protected static function throwError():void
		{
			if(ErrorMessage.length>0)
			{
				throw new IllegalOperationError(ErrorMessage)
			}
		}
	}
}