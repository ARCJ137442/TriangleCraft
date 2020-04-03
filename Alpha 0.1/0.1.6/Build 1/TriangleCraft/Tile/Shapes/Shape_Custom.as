package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileSystem
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
		public static var loadCurrents:Array=new Array()
		public static var currents:Array=new Array()
		
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
			Shape_Custom.loadCurrents.push(url,id,data)
		}
		
		//============Load============//
		public static function get isLoading():Boolean
		{
			return !General.isEmptyArray(Shape_Custom.loadCurrents)
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
				trace(Shape_Custom.loadCurrents,event.target.url)
				var loc:int=Shape_Custom.loadCurrents.indexOf(event.target.url)
				if(loc>=0)
				{
					var Id:String=String(Shape_Custom.loadCurrents[loc+1])
					var Data:int=int(Shape_Custom.loadCurrents[loc+2])
					Shape_Custom.loadCurrents.splice(loc,3)
					Shape_Custom.currents.push(image,Id,Data)
				}
				if(isLoading)
				{
					var url:String=String(Shape_Custom.loadCurrents[Shape_Custom.loadCurrents.length-3])
					var id:String=String(Shape_Custom.loadCurrents[Shape_Custom.loadCurrents.length-2])
					var data:int=int(Shape_Custom.loadCurrents[Shape_Custom.loadCurrents.length-1])
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
		
		public static function getCurrent(Id:String,Data:int=0,ReloadData:Boolean=true):Bitmap
		{
			if(General.isEmptyArray(Shape_Custom.currents))
			{
				return null
			}
			var i:uint
			for(i=0;i<Shape_Custom.currents.length;i++)
			{
				if(Shape_Custom.currents[i] is String&&Shape_Custom.currents[i]==Id)
				{
					if(uint(Shape_Custom.currents[i+1])==Data)
					{
						return copyBitmap(Shape_Custom.currents[i-1] as Bitmap)
					}
				}
			}
			if(ReloadData)
			{
				for(i=0;i<Shape_Custom.currents.length;i++)
				{
					if(Shape_Custom.currents[i] is String&&Shape_Custom.currents[i]==Id)
					{
						return copyBitmap(Shape_Custom.currents[i-1] as Bitmap)
					}
				}
			}
			return null
		}
		
		public static function hasCurrent(Id:String,Data:uint=0,ReloadData:Boolean=true):Boolean
		{
			return (getCurrent(Id,Data,ReloadData)!=null)
		}
		
		//============Instance Variables============//
		public function Shape_Custom():void
		{
			
		}
		
		//============Instance Functions============//
		public function setCurrent(Id:String,Data:int=0,ReloadData:Boolean=true):void
		{
			if(Shape_Custom.hasCurrent(Id,Data,ReloadData))
			{
				if(Shape_Custom.getCurrent(Id,Data,ReloadData)!=null)
				{
					this.ActiveChild=Shape_Custom.getCurrent(Id,Data,ReloadData)
				}
			}
		}
		
		protected function set ActiveChild(Child:DisplayObject):void
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