package TriangleCraft.Inventory
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Error.*;
	import TriangleCraft.Tile.*;
	
	//Class
	public class CraftRecipe
	{
		//============Static Consts============//
		public static const ITEM_SLOT_WIDTH:uint=3,ITEM_SLOT_HEIGHT:uint=3
		public static const ITEM_SLOT_COUNT:uint=ITEM_SLOT_WIDTH*ITEM_SLOT_HEIGHT
		public static const SLOT_OFFSET_X:int=-2,SLOT_OFFSET_Y:int=0
		
		//============Instance Variables============//
		protected var _PatternTop:String,_PatternMiddle:String,_PatternDown:String,_PatternCurrent:Array
		protected var _OutputTop:String,_OutputMiddle:String,_OutputDown:String,_OutputCurrent:Array
		protected var _returnAsItem:Boolean=true
		protected var _ignoreCount:Boolean=true
		protected var _ignoreData:Boolean=false
		protected var _ignoreRot:Boolean=false
		/* 0 1 2
		   3 4 5 
		   6 7 8 */
		protected var _inputItems:Vector.<InventoryItem>=new Vector.<InventoryItem>(ITEM_SLOT_COUNT,true)
		protected var _outputItems:Vector.<InventoryItem>=new Vector.<InventoryItem>(ITEM_SLOT_COUNT,true)
		
		//============Init CraftRecipe============//
		public function CraftRecipe(PatternTop:String,PatternMiddle:String,PatternDown:String,PatternCurrent:Array,
									OutputTop:String,OutputMiddle:String,OutputDown:String,OutputCurrent:Array,
									returnAsItem:Boolean=true,
									ignoreCount:Boolean=true,
									ignoreData:Boolean=false,
									ignoreRot:Boolean=false)
		{
			//Copy Data
			this._PatternTop=PatternTop
			this._PatternMiddle=PatternMiddle
			this._PatternDown=PatternDown
			this._PatternCurrent=PatternCurrent
			this._OutputTop=OutputTop
			this._OutputMiddle=OutputMiddle
			this._OutputDown=OutputDown
			this._OutputCurrent=OutputCurrent
			//Set Variables
			this.returnAsItem=returnAsItem
			this._ignoreCount=ignoreCount
			this._ignoreData=ignoreData
			this._ignoreRot=ignoreRot
			//Detect Variables
			var hasError:Boolean=false
			var patternChar:Vector.<String>=new Vector.<String>
			var outputChar:Vector.<String>=new Vector.<String>
			//Length
			if(PatternTop.length!=ITEM_SLOT_WIDTH||PatternMiddle.length!=ITEM_SLOT_WIDTH||PatternDown.length!=ITEM_SLOT_WIDTH||
			   OutputTop.length!=ITEM_SLOT_WIDTH||OutputMiddle.length!=ITEM_SLOT_WIDTH||OutputDown.length!=ITEM_SLOT_WIDTH)
			{
				hasError=true
				throwError("Pattern","Length")
			}
			//Load PatternBit
			var i:uint=0
			for(i=0;i<ITEM_SLOT_HEIGHT;i++)
			{
				//Input
				if(!General.IsiA(PatternTop.charAt(i),patternChar))
				{
					patternChar.push(PatternTop.charAt(i))
				}
				if(!General.IsiA(PatternMiddle.charAt(i),patternChar))
				{
					patternChar.push(PatternMiddle.charAt(i))
				}
				if(!General.IsiA(PatternDown.charAt(i),patternChar))
				{
					patternChar.push(PatternDown.charAt(i))
				}
				//Output
				if(!General.IsiA(OutputTop.charAt(i),outputChar))
				{
					outputChar.push(OutputTop.charAt(i))
				}
				if(!General.IsiA(OutputMiddle.charAt(i),outputChar))
				{
					outputChar.push(OutputMiddle.charAt(i))
				}
				if(!General.IsiA(OutputDown.charAt(i),outputChar))
				{
					outputChar.push(OutputDown.charAt(i))
				}
			}
			//Set Items
			var InputItems:Object={},OutputItems:Object={}
			for(i=0;i<patternChar.length;i++)
			{
				InputItems[patternChar[i]]=findItemAsChar(patternChar[i],PatternCurrent)
			}
			for(i=0;i<outputChar.length;i++)
			{
				OutputItems[outputChar[i]]=findItemAsChar(outputChar[i],OutputCurrent)
			}
			for(i=0;i<ITEM_SLOT_HEIGHT;i++)
			{
				this._inputItems[i]=InputItems[PatternTop.charAt(i)] as InventoryItem
				this._inputItems[ITEM_SLOT_WIDTH+i]=InputItems[PatternMiddle.charAt(i)] as InventoryItem
				this._inputItems[ITEM_SLOT_WIDTH*2+i]=InputItems[PatternDown.charAt(i)] as InventoryItem
				this._outputItems[i]=OutputItems[OutputTop.charAt(i)] as InventoryItem
				this._outputItems[ITEM_SLOT_WIDTH+i]=OutputItems[OutputMiddle.charAt(i)] as InventoryItem
				this._outputItems[ITEM_SLOT_WIDTH*2+i]=OutputItems[OutputDown.charAt(i)] as InventoryItem
			}
		}
		//============Getters And Setters============//
		public function get inputItemCount():uint
		{
			return this._inputItems.length
		}
		
		public function get outputItemCount():uint
		{
			return this._outputItems.length
		}
		
		public function get realInputItemCount():uint
		{
			var returnNum:uint=0
			for each(var item:InventoryItem in this._inputItems)
			{
				if(item!=null&&
				   item.id!=TileID.Void&&
				   TileSystem.isAllowID(item.id))
				{
					returnNum++
				}
			}
			return returnNum
		}
		
		public function get realOutputItemCount():uint
		{
			var returnNum:uint=0
			for each(var item:InventoryItem in this._outputItems)
			{
				if(item.id!=TileID.Void&&
				   TileSystem.isAllowID(item.id))
				{
					returnNum++
				}
			}
			return returnNum
		}
		
		public function get returnAsItem():Boolean
		{
			return this._returnAsItem
		}
		
		public function set returnAsItem(value:Boolean):void
		{
			this._returnAsItem=value
		}
		
		public function get ignoreRot():Boolean
		{
			return this._ignoreRot
		}
		
		public function set ignoreRot(value:Boolean):void
		{
			this._ignoreRot=value
		}
		
		public function get ignoreData():Boolean 
		{
			return this._ignoreData
		}
		
		public function set ignoreData(value:Boolean):void 
		{
			this._ignoreData=value
		}
		
		public function get ignoreCount():Boolean 
		{
			return this._ignoreCount;
		}
		
		public function set ignoreCount(value:Boolean):void 
		{
			this._ignoreCount=value;
		}
		
		public function get reversedRecipe():CraftRecipe
		{
			return new CraftRecipe(this._OutputTop,this._OutputMiddle,this._OutputDown,this._OutputCurrent,
								   this._PatternTop,this._PatternMiddle,this._PatternDown,this._PatternCurrent,
								   this._returnAsItem,
								   this._ignoreCount,
								   this._ignoreData,
								   this._ignoreRot)
		}
		
		//============Instance Functions============//
		public function getCopy():CraftRecipe
		{
			return new CraftRecipe(this._PatternTop,this._PatternMiddle,this._PatternDown,this._PatternCurrent,
								   this._OutputTop,this._OutputMiddle,this._OutputDown,this._OutputCurrent,
								   this._returnAsItem,
								   this._ignoreCount,
								   this._ignoreData,
								   this._ignoreRot)
		}
		
		protected function findItemAsChar(Char,Current:Array):InventoryItem
		{
			var Loc:int=Current.indexOf(Char)
			var ItemId:*,ItemData:*,ItemRot:*
			if(Loc>=0)
			{
				ItemId=String(Current[Loc+1])
				ItemData=int(Current[Loc+2])
				ItemRot=uint(Current[Loc+4])
				//Check
				if(ItemId==undefined||ItemData==undefined||ItemRot==undefined)
				{
					throwError("undefined")
				}
				if(!ItemId is String||!ItemData is int||!ItemRot is int)
				{
					throwError("Invalid")
				}
				return new InventoryItem(ItemId,1,ItemData)
			}
			return new InventoryItem(TileID.Void,1,0)
		}
		
		public function getInputItem(Loc:uint):InventoryItem
		{
			return this._inputItems[tcMath.NumberBetween(Loc,0,8)]
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
			return getInputItem(Loc).id
		}
		
		public function getInputCount(Loc:uint):uint
		{
			if(isInNull(Loc))
			{
				return 1
			}
			return getInputItem(Loc).count
		}
		
		public function getInputData(Loc:uint):int
		{
			if(isInNull(Loc))
			{
				return 0
			}
			return getInputItem(Loc).data
		}
		
		public function getOutputItem(Loc:uint):InventoryItem
		{
			var OI:InventoryItem=this._outputItems[tcMath.NumberBetween(Loc,0,8)]
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
			return getOutputItem(Loc).id
		}
		
		public function getOutputCount(Loc:uint):uint
		{
			if(isOutNull(Loc))
			{
				return 1
			}
			return getOutputItem(Loc).count
		}
		
		public function getOutputData(Loc:uint):int
		{
			if(isOutNull(Loc))
			{
				return 0
			}
			return getOutputItem(Loc).data
		}
		
		//============Test Functions============//
		public function testCanCraft(Inputs:Vector.<InventoryItem>):Boolean
		{
			if(Inputs==null||Inputs.length!=ITEM_SLOT_COUNT) return false
			for(var i:uint=0;i<Inputs.length;i++)
			{
				if(!testItemEqual(this._inputItems[i],Inputs[i]))
				return false
			}
			return true
		}
		
		public function getCraftPercent(Inputs:Vector.<InventoryItem>,includeVoid:Boolean=false):Number
		{
			return getCraftEquals(Inputs,includeVoid)/ITEM_SLOT_COUNT
		}
		
		protected function testItemEqual(item:InventoryItem,item2:InventoryItem):Boolean
		{
			if(item==item2) return true
			else if(item==null||item2==null) return false
			return item.isEqual(item2,
								this.ignoreCount,
								this.ignoreData||TileAttributes.fromID(item2.id).ignoreDataInCraftRecipe)
		}
		
		public function getCraftEquals(Inputs:Vector.<InventoryItem>,includeVoid:Boolean=false):uint
		{
			if(Inputs==null||Inputs.length!=ITEM_SLOT_COUNT) return 0
			var equals:uint=0,item:InventoryItem
			for(var i:uint=0;i<Inputs.length;i++)
			{
				item=this._inputItems[i]
				if(item!=null&&item.id!=TileID.Void||includeVoid)
				if(testItemEqual(this._inputItems[i],Inputs[i]))
				equals++
			}
			return equals
		}
		
		//============Error Functions============//
		protected static function throwError(Type:String,Value:*=""):void
		{
			var ES:String,VT:String
			switch(Type)
			{
				case "Pattern":
				ES="Invalid Pattern:"+String(Value)+" Error!"
				VT=CraftRecipeError.PATTERN_ERROR
				return
				case "undefined":
				ES="Undefined Value!"
				VT=CraftRecipeError.VALUE_ERROR
				return
				case "Invalid":
				ES="Invalid Value!"
				VT=CraftRecipeError.VALUE_ERROR
				return
				default:
				ES="Unknown Error"
				VT=CraftRecipeError.UNKOMN_ERROR
				return
			}
			throw new CraftRecipeError(ES,VT)
		}
	}
}