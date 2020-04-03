package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	use namespace intc
	
	public class TileDisplaySettings
	{
		//========Static Variables========//
		
		//========Instance Variables========//
		private var _isExternal:Boolean
		
		intc var internalType:String
		intc var internalFrame:uint
		intc var externalUrl:String
		
		//========Instance Functions========//
		public function TileDisplaySettings(url:String=null):void
		{
			//Constructor Code
			this.loadDefault()
			this.externalUrl=url
		}
		
		public function get isInternal():Boolean
		{
			return !this._isExternal
		}
		public function get isExternal():Boolean
		{
			return this._isExternal
		}
		
		public function set isInternal(input:Boolean):void
		{
			this._isExternal=!input
		}
		public function set isExternal(input:Boolean):void
		{
			this._isExternal=input
		}
		
		public function loadDefault():void
		{
			this._isExternal=false
			this.internalType="Other"
			this.internalFrame=0
			this.externalUrl=null
		}
		
		//========Static Functions========//
		public static function get DefaultSettings():TileDisplaySettings
		{
			return new TileDisplaySettings()
		}
	}
}