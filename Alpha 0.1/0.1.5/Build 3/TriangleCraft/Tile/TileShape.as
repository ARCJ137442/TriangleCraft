package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.TileSystem;
	import TriangleCraft.Tile.Shapes.*;
	
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.utils.Dictionary
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	public class TileShape extends MovieClip
	{
		//============Static Variables============//
		public static var _isClassInit:Boolean=false
		public static var currents:Dictionary=new Dictionary()
		
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
			//====Signal Machines====//
			addCurrent(TileID.Wireless_Signal_Transmitter)
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
			//====Signal Byte Storage====//
			addCurrent(TileID.Signal_Byte_Storage,0)
			addCurrent(TileID.Signal_Byte_Storage,1)
		}
		
		private static function getIndex(id:String,data:int):String
		{
			return String(id+" "+data)
		}
		
		private static function setCurrent(frame:uint,id:String,data:int=0):void
		{
			if(frame>0&&!hasCurrent(id,data,false))
			{
				TileShape.currents[getIndex(id,data)]=frame
			}
		}
		
		private static function addCurrent(id:String,data:int=0):void
		{
			var frame:uint=1
			while(hasCurrentOnFrame(frame)) frame++
			setCurrent(frame,id,data)
		}
		
		private static function getCurrentFrame(id:String,data:int=0,reloadData:Boolean=true):uint
		{
			if(hasCurrent(id,data,false)) return TileShape.currents[getIndex(id,data)]
			else if(hasCurrent(id,data,true)) return TileShape.currents[getIndex(id,0)]
			return 0
		}
		
		public static function hasCurrent(id:String,data:uint=0,reloadData:Boolean=true):Boolean
		{
			return Boolean(getIndex(id,data) in TileShape.currents)||reloadData&&Boolean(getIndex(id,0) in TileShape.currents)
		}
		
		public static function hasCurrentOnFrame(frame:uint):Boolean
		{
			for each(var current:* in TileShape.currents)
			{
				if(current==frame) return true
			}
			return false
		}
		
		//============Init TileShape============//
		public function TileShape(Id:String=TileID.Void,Data:int=0):void
		{
			TileShape.classInit()
			this.stop()
			this.setDisplay(Id,Data)
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
		public function setCurrentFrame(id:String,data:int=0,reloadData:Boolean=true):void
		{
			if(hasCurrent(id,data,reloadData))
			{
				this.frame=getCurrentFrame(id,data,reloadData)
			}
		}
		
		public function setDisplay(Id:String,Data:int=0,displayFrom:String=null):void
		{
			//Technical
			if(TileTag.getTagFromID(Id).technical&&displayFrom==TileDisplayFrom.IN_ENTITY)
			{
				this.setCurrentFrame(TileID.Technical,0)
				return
			}
			//Void
			if(Id==TileID.Void)
			{
				this.visible=false
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