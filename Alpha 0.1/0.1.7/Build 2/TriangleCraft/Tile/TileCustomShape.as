package TriangleCraft.Tile
{
	//TriangleCraft
	import TriangleCraft.Tile.*;
	import TriangleCraft.Common.*;
	
	//Flash
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	
	public class TileCustomShape extends Sprite
	{
		//============Static Variables============//
		protected static var _loadingID:Vector.<TileID>=new Vector.<TileID>
		protected static var _loadingData:Vector.<int>=new Vector.<int>
		protected static var _loadingURL:Vector.<String>=new Vector.<String>
		protected static var _currentID:Vector.<TileID>=new Vector.<TileID>
		protected static var _currentData:Vector.<int>=new Vector.<int>
		protected static var _currentBitmap:Vector.<Bitmap>=new Vector.<Bitmap>
		
		//============Static Functions============//
		public static function addCurrent(url:String,id:TileID,data:int=0):void
		{
			if(TileCustomShape.hasCurrent(id,data)) return
			var current:Loader=new Loader()
			current.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete)
			current.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError)
			current.load(new URLRequest(url))
			TileCustomShape._loadingURL.push(url)
			TileCustomShape._loadingID.push(id)
			TileCustomShape._loadingData.push(data)
		}
		
		//============Load============//
		public static function get isLoading():Boolean
		{
			return TileCustomShape._loadingURL.length>0
		}
		
		public static function loadComplete(event:Event=null):void
		{
			if(event.target is LoaderInfo)
			{
				var image:Bitmap=event.target.content as Bitmap
				image.x=-TileSystem.globalTileSize/2
				image.y=-TileSystem.globalTileSize/2
				image.scaleX=TileSystem.globalTileSize/image.bitmapData.width
				image.scaleY=TileSystem.globalTileSize/image.bitmapData.height
				//trace(TileCustomShape._currentID,event.target.url)
				var loc:int=TileCustomShape._loadingURL.indexOf(event.target.url)
				if(loc>=0)
				{
					TileCustomShape._currentID.push(TileCustomShape._loadingID[loc])
					TileCustomShape._currentData.push(TileCustomShape._loadingData[loc])
					TileCustomShape._currentBitmap.push(image)
					TileCustomShape._loadingID.splice(loc,1)
					TileCustomShape._loadingData.splice(loc,1)
					TileCustomShape._loadingURL.splice(loc,1)
				}
				//Continue
				if(isLoading)
				{
					loc=TileCustomShape._loadingURL.length-1
					var url:String=TileCustomShape._loadingURL[0]
					var id:TileID=TileCustomShape._loadingID[0]
					var data:int=TileCustomShape._loadingData[0]
					TileCustomShape.addCurrent(url,id,data)
				}
			}
		}
		
		public static function loadError(event:IOErrorEvent=null):void
		{
			trace("Error "+event.errorID+": "+event.text)
			if(event.target!=null&&event.target is Loader)
			{
				(event.target as Loader).unload()
			}
		}
		
		public static function getCurrent(id:TileID,data:int=0,reloadData:Boolean=true):Bitmap
		{
			var tempID:TileID
			var tempData:int
			for(var i:uint=0;i<TileCustomShape._currentID.length;i++)
			{
				tempID=TileCustomShape._currentID[i]
				tempData=TileCustomShape._currentData[i]
				if(tempID==id)
				{
					if(reloadData&&tempData==0||TileCustomShape._currentData[i]==data)
					{
						return copyBitmap(TileCustomShape._currentBitmap[i] as Bitmap)
					}
				}
			}
			return null
		}
		
		public static function hasCurrent(id:TileID,data:int=0,reloadData:Boolean=true):Boolean
		{
			var tempID:TileID
			var tempData:int
			for(var i:uint=0;i<TileCustomShape._currentID.length;i++)
			{
				tempID=TileCustomShape._currentID[i]
				tempData=TileCustomShape._currentData[i]
				if(tempID==id)
				{
					if(reloadData&&tempData==0||TileCustomShape._currentData[i]==data)
					{
						return true
					}
				}
			}
			return false
		}
		
		//============Instance Variables============//
		public function TileCustomShape():void
		{
			
		}
		
		//============Instance Functions============//
		public function setCurrent(id:TileID,data:int=0,reloadData:Boolean=true):void
		{
			var current:Bitmap=TileCustomShape.getCurrent(id,data,reloadData)
			if(current!=null)
			{
				this.activeChild=current
			}
		}
		
		public function removeCurrent():void
		{
			this.activeChild=null
		}
		
		protected function set activeChild(child:DisplayObject):void
		{
			//Display
			if(child!=null&&!this.contains(child))
			{
				this.addChild(child)
			}
			//Remove
			for(var i:uint=0;i<this.numChildren;i++)
			{
				if(child==null||i!=this.getChildIndex(child))
				{
					if(this.contains(this.getChildAt(i)))
					{
						this.removeChild(this.getChildAt(i))
					}
				}
			}
		}
		
		//============Utils Functions============//
		protected static function copyBitmap(bitmap:Bitmap):Bitmap
		{
			return bitmap==null?null:new Bitmap(bitmap.bitmapData)
		}
	}
}