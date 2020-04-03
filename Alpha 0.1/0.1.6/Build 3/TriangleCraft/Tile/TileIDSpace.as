package TriangleCraft.Tile 
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID;
	import TriangleCraft.Inventory.*;
	import TriangleCraft.Common.*;
	
	
	public class TileIDSpace extends Object
	{
		//============Static Variables============//
		public static const VIRUS:TileIDSpace=new TileIDSpace(
			TileID.XX_Virus,TileID.XX_Virus_Red,
			TileID.XX_Virus_Green,TileID.XX_Virus_Blue,
			TileID.XX_Virus_Cyan,TileID.XX_Virus_Purple,
			TileID.XX_Virus_Yellow,TileID.XX_Virus_Black)
			
		public static const WALL:TileIDSpace=new TileIDSpace(
			TileID.Basic_Wall,
			TileID.Ruby_Wall,
			TileID.Emerald_Wall,
			TileID.Sapphire_Wall)
			
		public static const SPECIAL_WALL:TileIDSpace=new TileIDSpace(
			TileID.Ruby_Wall,
			TileID.Emerald_Wall,
			TileID.Sapphire_Wall)
			
		public static const MECHINES:TileIDSpace=new TileIDSpace(
			TileID.Color_Mixer,
			TileID.Block_Crafter,
			TileID.Block_Spawner,
			TileID.Walls_Spawner,
			TileID.Inventory_Block)
			
		public static const MECHINES_SIGNAL:TileIDSpace=new TileIDSpace(
			TileID.Signal_Wire,
			TileID.Signal_Patcher,
			TileID.Random_Tick_Signal_Generater,
			TileID.Block_Update_Detector,
			TileID.Signal_Lamp,
			TileID.Signal_Diode,
			TileID.Wireless_Signal_Transmitter,
			TileID.Wireless_Signal_Charger,
			TileID.Signal_Decelerator,
			TileID.Signal_Delayer,
			TileID.Signal_Random_Filter,
			TileID.Block_Destroyer,
			TileID.Block_Pusher,
			TileID.Block_Puller,
			TileID.Block_Swaper)
			
		public static const MECHINES_BYTE:TileIDSpace=new TileIDSpace(
			TileID.Signal_Byte_Getter,
			TileID.Signal_Byte_Setter,
			TileID.Signal_Byte_Copyer,
			TileID.Signal_Byte_Operator_OR,
			TileID.Signal_Byte_Operator_AND)
		
		//============Instance Variables============//
		protected var _idList:Vector.<TileID>=new Vector.<TileID>
		
		//============Init TileIDSpace============//
		public function TileIDSpace(...Ids):void
		{
			for each(var id:* in Ids)
			{
				if(id is TileID) this._idList.push(id as TileID)
			}
		}
		
		//============Static Functions============//
		public static function fromIDVector(v:Vector.<TileID>):TileIDSpace
		{
			var s:TileIDSpace=new TileIDSpace()
			if(v==null||v.length<1) return s
			for each(var str:TileID in v)
			{
				if(str!=null||TileSystem.isAllowID(str)) s.add(str)
			}
			return s
		}
		
		public static function fromItemList(il:ItemList):TileIDSpace
		{
			var s:TileIDSpace=new TileIDSpace()
			if(il==null||il.isEmpty) return s
			var id:TileID
			for each(var item:InventoryItem in il.inventory)
			{
				id=item.id
				if(id!=null||TileSystem.isAllowID(id)) s.add(id)
			}
			return s
		}
		
		//============Instance Getter And Setter============//
		public function get length():int
		{
			return this._idList.length
		}
		
		public function get isEmpty():Boolean
		{
			return (this._idList==null||this._idList.length<1)
		}
		
		public function get randomID():TileID
		{
			if(isEmpty) return null
			return this._idList[tcMath.random(this._idList.length)]
		}
		
		//============Instance Functions============//
		public function concat(...spaces):TileIDSpace
		{
			var returnV:Vector.<TileID>=new Vector.<TileID>
			returnV=returnV.concat(this._idList)
			for each(var i:* in spaces)
			{
				if(i is TileIDSpace)
				{
					returnV=returnV.concat((i as TileIDSpace)._idList)
				}
			}
			return this.clone()
		}
		
		public function clone():TileIDSpace
		{
			return TileIDSpace.fromIDVector(this._idList)
		}
		
		public function toVector():Vector.<TileID>
		{
			var vec:Vector.<TileID>=new Vector.<TileID>
			for each(var str:TileID in this._idList)
			{
				vec.push(str)
			}
			return vec
		}
		
		public function toItemList():ItemList
		{
			var il:ItemList=new ItemList()
			for each(var str:TileID in this._idList)
			{
				il.addItem(str)
			}
			return il
		}
		
		public function has(id:TileID):Boolean
		{
			return this._idList.indexOf(id)>=0
		}
		
		public function remove(id:TileID):void
		{
			if(this.has(id)) this._idList.splice(this._idList.indexOf(id),1)
			if(this.has(id)) remove(id)
		}
		
		public function add(id:TileID):void
		{
			if(!this.has(id)) this._idList.push(id)
		}
		
		public function reset():void
		{
			this._idList=new Vector.<TileID>
		}
	}
}