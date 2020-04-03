package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Common.*;
	
	public class TileCustomVariables
	{
		//=============Static Variables=============//
		
		//============Instance Variables============//
		protected var _variables:Array=new Array()
		
		//============Init TileSpecialTag============//
		public function TileCustomVariables(id:TileID=null,...variables):void
		{
			if(!General.isEmptyArray(variables))
			{
				//init as tileId
				if(id!=null) this.initAsId(id)
				//init as array
				for(var i:uint=0;i<variables.length-variables.length%2;i++)
				{
					this._variables.push(String(variables[i]),variables[i+1])
				}
			}
		}
		
		public function initAsId(id:TileID):void
		{
			//Internal Ids
			if(TileSystem.isAllowID(id))
			{
				switch(id)
				{
					case TileID.Signal_Decelerator:
						this.addNewVariable("d",0,uint)//delay
						break
					case TileID.Signal_Delayer:
					case TileID.Signal_Random_Filter:
						this.addNewVariable("lt",0,uint)//last time
						break
					case TileID.Signal_Lamp:
						this.addNewVariable("lac",0,uint)//last active color
						break
				}
			}
			//Custom Ids
		}
		
		//============Instance Functions============//
		//====Getters And Setters====//
		public function get variableCount():uint
		{
			return Math.ceil(this._variables.length/2)
		}
		
		public function get allVariableNames():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=0;i<this._variables.length;i+=2)
			{
				returnArr.push(this._variables[i])
			}
			return returnArr
		}
		
		public function get allVariableValues():Array
		{
			var returnArr:Array=new Array()
			for(var i:uint=1;i<this._variables.length;i+=2)
			{
				returnArr.push(this._variables[i])
			}
			return returnArr
		}
		
		//====Functions====//
		public function hasVariable(name:String=null):Boolean
		{
			if(name==null) return !General.isEmptyArray(this._variables)
			else return this._variables.indexOf(name)>-1
		}
		
		public function addNewVariable(name:String,value:*=null,shouldClass:Class=null):void
		{
			if(this.hasVariable(name)) this.setVariableValue(name,value,shouldClass)
			else this._variables.push(name,shouldClass!=null?new shouldClass():value)
		}
		
		public function getVariableValue(name:String,shouldClass:Class=null):*
		{
			if(this.hasVariable(name)) return this._variables[this._variables.indexOf(name)+1]
			else if(shouldClass!=null) return new shouldClass()
			return undefined
		}
		
		public function setVariableValue(name:String,value:*=undefined,shouldClass:Class=null):void
		{
			if(this.hasVariable(name)) this._variables[this._variables.indexOf(name)+1]=value
			else addNewVariable(name,value,shouldClass)
		}
		
		public function removeVariable(name:String):void
		{
			if(this.hasVariable(name)) this._variables.splice(this._variables.indexOf(name),2)
		}
		
		public function removeVariables(...names):void
		{
			if(!General.isEmptyArray(names))
			{
				for each(var name in names)
				{
					removeVariable(String(name))
				}
			}
		}
		
		public function removeAllVariable():void
		{
			this._variables=null
		}
		
		//====Copy Functions====//
		public function getCopy():TileCustomVariables
		{
			var tempVariables:TileCustomVariables=new TileCustomVariables()
			tempVariables.copyFrom(this)
			return tempVariables
		}
		
		public function copyFrom(tag:TileCustomVariables):void
		{
			if(tag==null) return
			if(this.variableCount>0) this.removeAllVariable()
			for(var i:uint=0;i<this.allVariableNames.length;i++)
			{
				this.addNewVariable(this.allVariableNames[i],this.allVariableValues[i])
			}
		}
	}
}