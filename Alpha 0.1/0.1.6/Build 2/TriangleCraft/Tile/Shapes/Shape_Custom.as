package TriangleCraft.Tile.Shapes
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
	
	public class Shape_Custom extends Sprite
	{
		//============Static Variables============//
		protected static var _loadingID:Vector.<TileID>=new Vector.<TileID>
		protected static var _loadingData:Vector.<int>=new Vector.<int>
		protected static var _loadingURL:Vector.<String>=new Vector.<String>
		protected static var _currentID:Vector.<TileID>=new Vector.<TileID>
		protected static var _currentData:Vector.<int>=new Vector.<int>
		protected static var _currentBitmap:Vector.<Bitmap>=new Vector.<Bitmap>
		
		//============Static Functions============//
		public static function setCurrent(url:String,id:String,data:int=0):void
		{
			if(Shape_Custom.hasCurrent(id,data)) return
			if(!Shape_Custom.isLoading)
			{
				var current:Loader=new Loader()
				current.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete)
				current.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError)
				current.load(new URLRequest(url))
			}
			Shape_Custom._loadingURL.push(url)
			Shape_Custom._loadingID.push(id)
			Shape_Custom._loadingData.push(data)
		}
		
		//============Load============//
		public static function get isLoading():Boolean
		{
			return Shape_Custom._loadingURL.length>0
		}
		
		public static function loadComplete(event:Event=null):void
		{
			if(event.target is LoaderInfo)
			{
				var image:Bitmap=event.target.content as Bitmap
				image.x=-TileSystem.globalTileSize/2
				image.y=-TileSystem.globalTileSize/2
				image.scaleX=TileSystem.globalTileSize/image.width
				image.scaleY=TileSystem.globalTileSize/image.height
				trace(Shape_Custom._loadCurrents,event.target.url)
				var loc:int=Shape_Custom._currentURL.indexOf(event.target.url)
				if(loc>=0)
				{
					Shape_Custom._currentID.push(Shape_Custom._loadingID[loc])
					Shape_Custom._currentData.push(Shape_Custom._loadingData[loc])
					Shape_Custom._currentBitmap.push(image)
					Shape_Custom._loadingID.splice(loc,1)
					Shape_Custom._loadingData.splice(loc,1)
					Shape_Custom._loadingURL.splice(loc,1)
				}
				//Continue
				if(isLoading)
				{
					loc=Shape_Custom._loadingURL.length-1
					var url:String=Shape_Custom._loadingURL[0]
					var id:TileID=Shape_Custom._loadingID[0]
					var data:int=Shape_Custom._loadingData[0]
					Shape_Custom.setCurrent(url,id,data)
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
			for(var i:uint=0;i<Shape_Custom._currentID.length;i++)
			{
				if(Shape_Custom._currentID[i]==id)
				{
					if(uint(Shape_Custom._currentBitmap[i])==data)
					{
						return copyBitmap(Shape_Custom._currentBitmap as Bitmap)
					}
				}
			}
			if(reloadData)
			{
				for(i=0;i<Shape_Custom._currentBitmap.length;i++)
				{
					if(Shape_Custom._currentBitmap[i] is String&&Shape_Custom._currentBitmap[i]==id)
					{
						return copyBitmap(Shape_Custom._currentBitmap[i-1] as Bitmap)
					}
				}
			}
			return null
		}
		
		public static function hasCurrent(Id:TileID,Data:uint=0,ReloadData:Boolean=true):Boolean
		{
			for(var i:uint=0;i<Shape_Custom._currentID.length;i++)
			{
				if(Shape_Custom._currentID[i]==id)
				{
					if(uint(Shape_Custom._currentBitmap[i])==data)
					{
						return true
					}
				}
			}
			if(reloadData)
			{
				for(i=0;i<Shape_Custom._currentBitmap.length;i++)
				{
					if(Shape_Custom._currentBitmap[i] is String&&Shape_Custom._currentBitmap[i]==id)
					{
						return true
					}
				}
			}
			return false
		}
		
		//============Instance Variables============//
		public function Shape_Custom():void
		{
			
		}
		
		//============Instance Functions============//
		public function setCurrent(id:String,data:int=0,reloadData:Boolean=true):void
		{
			var current:Bitmap=Shape_Custom.getCurrent(id,data,reloadData)
			if(current!=null)
			{
				this.activeChild=current
			}
		}
		
		protected function set activeChild(Child:DisplayObject):void
		{
			//Display
			if(Child!=null&&!this.contains(Child))
			{
				this.addChild(Child)
			}
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
		
		//============Utils Functions============//
		protected static function copyBitmap(bitmap:Bitmap):Bitmap
		{
			return bitmap==null?null:new Bitmap(bitmap.bitmapData)
		}
	}
}