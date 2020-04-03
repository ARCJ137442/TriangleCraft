package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Tile.Shapes.*;
	
	import TriangleCraft.Common.*;
	
	
	//Flash
	import flash.utils.Dictionary
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	public class TileShape extends MovieClip
	{
		//============Static Variables============//
		protected static var _isClassInit:Boolean=false
		protected static var _currents:Dictionary=new Dictionary()
		
		//============Static Functions============//
		private static function classInit():void
		{
			//Detect
			if(_isClassInit) return
			else _isClassInit=true
			//Init Currents
			//================Error================//
			addCurrent(TileID.NoCurrent)
			addCurrent(TileID.Technical)
			addCurrent(TileID.Unknown)
			//================Mechine================//
			addCurrent(TileID.Color_Mixer)
			addCurrent(TileID.Block_Crafter)
			addCurrent(TileID.Block_Spawner)
			addCurrent(TileID.Arrow_Block)
			addCurrent(TileID.Walls_Spawner)
			addCurrent(TileID.Inventory_Block)
			//================Wall================//
			addCurrent(TileID.Basic_Wall,0)
			addCurrent(TileID.Crystal_Wall,0)
			//================Other================//
			addCurrent(TileID.Barrier,0)
			addCurrent(TileID.Pushable_Block,0)
			addCurrent(TileID.Pushable_Block,1)
			addCurrent(TileID.Pushable_Block,2)
			addCurrent(TileID.Pushable_Block,3)
			addCurrent(TileID.Pushable_Block,4)
			addCurrent(TileID.Pushable_Block,5)
			addCurrent(TileID.Pushable_Block,6)
			//================Virus================//
			addCurrent(TileID.XX_Virus)
			addCurrent(TileID.XX_Virus_Red)
			addCurrent(TileID.XX_Virus_Green)
			addCurrent(TileID.XX_Virus_Blue)
			addCurrent(TileID.XX_Virus_Cyan)
			addCurrent(TileID.XX_Virus_Purple)
			addCurrent(TileID.XX_Virus_Yellow)
			addCurrent(TileID.XX_Virus_Black)
			//================Signal================//
			//====Signal Wire====//
			addCurrent(TileID.Signal_Wire,0)
			addCurrent(TileID.Signal_Wire,1)
			addCurrent(TileID.Signal_Wire,2)
			addCurrent(TileID.Signal_Wire,3)
			addCurrent(TileID.Signal_Wire,4)
			addCurrent(TileID.Signal_Wire,5)
			//====Signal Diode====//
			addCurrent(TileID.Signal_Diode,0)//None
			addCurrent(TileID.Signal_Diode,2)//Back
			addCurrent(TileID.Signal_Diode,3)//All
			addCurrent(TileID.Signal_Diode,1)//Front
			//====Signal Decelerator====//
			addCurrent(TileID.Signal_Decelerator,0)
			addCurrent(TileID.Signal_Decelerator,2)
			addCurrent(TileID.Signal_Decelerator,3)
			addCurrent(TileID.Signal_Decelerator,1)
			addCurrent(TileID.Signal_Decelerator,4)
			addCurrent(TileID.Signal_Decelerator,6)
			addCurrent(TileID.Signal_Decelerator,7)
			addCurrent(TileID.Signal_Decelerator,5)
			//====Signal Delayer====//
			addCurrent(TileID.Signal_Delayer,0)
			addCurrent(TileID.Signal_Delayer,2)
			addCurrent(TileID.Signal_Delayer,3)
			addCurrent(TileID.Signal_Delayer,1)
			addCurrent(TileID.Signal_Delayer,4)
			addCurrent(TileID.Signal_Delayer,6)
			addCurrent(TileID.Signal_Delayer,7)
			addCurrent(TileID.Signal_Delayer,5)
			//====Signal  Random Filter====//
			addCurrent(TileID.Signal_Random_Filter,0)
			addCurrent(TileID.Signal_Random_Filter,2)
			addCurrent(TileID.Signal_Random_Filter,3)
			addCurrent(TileID.Signal_Random_Filter,1)
			addCurrent(TileID.Signal_Random_Filter,4)
			addCurrent(TileID.Signal_Random_Filter,6)
			addCurrent(TileID.Signal_Random_Filter,7)
			addCurrent(TileID.Signal_Random_Filter,5)
			//====Signal Machines====//
			addCurrent(TileID.Wireless_Signal_Transmitter)
			addCurrent(TileID.Wireless_Signal_Charger)
			addCurrent(TileID.Signal_Patcher)
			addCurrent(TileID.Random_Tick_Signal_Generater)
			addCurrent(TileID.Block_Update_Detector)
			//====Signal Lamp With Colors====//
			addCurrent(TileID.Signal_Lamp,0)
			addCurrent(TileID.Signal_Lamp,1)
			addCurrent(TileID.Signal_Lamp,2)
			addCurrent(TileID.Signal_Lamp,3)
			addCurrent(TileID.Signal_Lamp,4)
			addCurrent(TileID.Signal_Lamp,5)
			//====Signal Machines II====//
			addCurrent(TileID.Block_Destroyer)
			addCurrent(TileID.Block_Pusher)
			addCurrent(TileID.Block_Puller)
			addCurrent(TileID.Block_Swaper)
			//====Signal Byte Storage====//
			addCurrent(TileID.Signal_Byte_Storage,0)
			addCurrent(TileID.Signal_Byte_Storage,1)
			//====Signal Byte Getter====//
			addCurrent(TileID.Signal_Byte_Getter,0)
			addCurrent(TileID.Signal_Byte_Getter,1)
			addCurrent(TileID.Signal_Byte_Getter,2)
			addCurrent(TileID.Signal_Byte_Getter,3)
			//====Signal Byte Setter====//
			addCurrent(TileID.Signal_Byte_Setter,0)
			addCurrent(TileID.Signal_Byte_Setter,1)
			addCurrent(TileID.Signal_Byte_Setter,2)
			addCurrent(TileID.Signal_Byte_Setter,3)
			//====Signal Byte Copyer====//
			addCurrent(TileID.Signal_Byte_Copyer,0)
			addCurrent(TileID.Signal_Byte_Copyer,2)
			addCurrent(TileID.Signal_Byte_Copyer,3)
			addCurrent(TileID.Signal_Byte_Copyer,1)
			addCurrent(TileID.Signal_Byte_Copyer,4)
			addCurrent(TileID.Signal_Byte_Copyer,6)
			addCurrent(TileID.Signal_Byte_Copyer,7)
			addCurrent(TileID.Signal_Byte_Copyer,5)
			//====Signal Byte Operator OR====//8 radix
			addCurrent(TileID.Signal_Byte_Operator_OR,0)//
			addCurrent(TileID.Signal_Byte_Operator_OR,2)//l
			addCurrent(TileID.Signal_Byte_Operator_OR,3)//l r
			addCurrent(TileID.Signal_Byte_Operator_OR,1)//r
			addCurrent(TileID.Signal_Byte_Operator_OR,4)//f
			addCurrent(TileID.Signal_Byte_Operator_OR,6)//f l
			addCurrent(TileID.Signal_Byte_Operator_OR,7)//f l r
			addCurrent(TileID.Signal_Byte_Operator_OR,5)//f r
			addCurrent(TileID.Signal_Byte_Operator_OR,8+0)//
			addCurrent(TileID.Signal_Byte_Operator_OR,8+2)//l
			addCurrent(TileID.Signal_Byte_Operator_OR,8+3)//l r
			addCurrent(TileID.Signal_Byte_Operator_OR,8+1)//r
			addCurrent(TileID.Signal_Byte_Operator_OR,8+4)//f
			addCurrent(TileID.Signal_Byte_Operator_OR,8+6)//f l
			addCurrent(TileID.Signal_Byte_Operator_OR,8+7)//f l r
			addCurrent(TileID.Signal_Byte_Operator_OR,8+5)//f r
			//====Signal Byte Operator AND====//8 radix
			addCurrent(TileID.Signal_Byte_Operator_AND,0)//
			addCurrent(TileID.Signal_Byte_Operator_AND,2)//l
			addCurrent(TileID.Signal_Byte_Operator_AND,3)//l r
			addCurrent(TileID.Signal_Byte_Operator_AND,1)//r
			addCurrent(TileID.Signal_Byte_Operator_AND,4)//f
			addCurrent(TileID.Signal_Byte_Operator_AND,6)//f l
			addCurrent(TileID.Signal_Byte_Operator_AND,7)//f l r
			addCurrent(TileID.Signal_Byte_Operator_AND,5)//f r
			addCurrent(TileID.Signal_Byte_Operator_AND,8+0)//
			addCurrent(TileID.Signal_Byte_Operator_AND,8+2)//l
			addCurrent(TileID.Signal_Byte_Operator_AND,8+3)//l r
			addCurrent(TileID.Signal_Byte_Operator_AND,8+1)//r
			addCurrent(TileID.Signal_Byte_Operator_AND,8+4)//f
			addCurrent(TileID.Signal_Byte_Operator_AND,8+6)//f l
			addCurrent(TileID.Signal_Byte_Operator_AND,8+7)//f l r
			addCurrent(TileID.Signal_Byte_Operator_AND,8+5)//f r
			//====Signal Byte Pointer====//
			addCurrent(TileID.Signal_Byte_Pointer)
		}
		
		private static function getIndex(id:TileID,data:int):String
		{
			return String(id.name+" "+data)
		}
		
		private static function setCurrent(frame:uint,id:TileID,data:int=0):void
		{
			if(frame>0&&!hasCurrent(id,data,false))
			{
				TileShape._currents[getIndex(id,data)]=frame
			}
		}
		
		private static function addCurrent(id:TileID,data:int=0):void
		{
			var frame:uint=1
			while(hasCurrentOnFrame(frame)) frame++
			setCurrent(frame,id,data)
		}
		
		private static function getCurrentFrame(id:TileID,data:int=0,reloadData:Boolean=true):uint
		{
			var frame:uint=0
			if(hasCurrent(id,data,false))
			{
				frame=TileShape._currents[getIndex(id,data)]
			}
			else if(hasCurrent(id,data,true))
			{
				frame=TileShape._currents[getIndex(id,0)]
			}
			return frame
		}
		
		public static function hasCurrent(id:TileID,data:uint=0,reloadData:Boolean=true):Boolean
		{
			return Boolean(getIndex(id,data) in TileShape._currents)||reloadData&&Boolean(getIndex(id,0) in TileShape._currents)
		}
		
		public static function hasCurrentOnFrame(frame:uint):Boolean
		{
			for each(var current:* in TileShape._currents)
			{
				if(current==frame) return true
			}
			return false
		}
		
		//============Init TileShape============//
		public function TileShape(id:TileID,data:int=0):void
		{
			TileShape.classInit()
			this.stop()
			this.setDisplay(id,data)
		}
		
		//============Instance Functions============//
		//=====frame Functions=====//
		public function get frame():uint
		{
			return this.currentFrame
		}
		
		public function set frame(f:uint):void
		{
			this.gotoAndStop(f)
		}
		
		//=====Current Functions=====//
		public function setCurrentFrame(id:TileID,data:int=0,reloadData:Boolean=true):void
		{
			if(hasCurrent(id,data,reloadData))
			{
				this.frame=getCurrentFrame(id,data,reloadData)
			}
			return
		}
		
		public function setDisplay(Id:TileID,Data:int=0,displayFrom:TileDisplayFrom=null):void
		{
			var attributes:TileAttributes=TileAttributes.fromID(Id)
			//Void
			if(attributes==null||Id==TileID.Void)
			{
				this.visible=false
				return
			}
			//Technical
			if(attributes.technical&&displayFrom==TileDisplayFrom.IN_ENTITY)
			{
				this.setCurrentFrame(TileID.Technical,0)
				return
			}
			//Main
			if(hasCurrent(Id,Data))
			{
				this.setCurrentFrame(Id,Data)
				return
			}
			//No Current
			this.setCurrentFrame(TileID.NoCurrent,0)
		}
		
		protected function set ActiveChild(Child:DisplayObject):void
		{
			//Display
			if(Child!=null&&!this.contains(Child)) this.addChild(Child)
			//Remove
			for(var i:uint=0;i<this.numChildren;i++)
			{
				if(Child==null||i!=this.getChildIndex(Child))
				{
					if(this.contains(this.getChildAt(i)))
					{
						this.removeChild(this.getChildAt(i))
					}
				}
			}
		}
	}
}