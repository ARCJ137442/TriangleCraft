package TriangleCraft.Tile.Shapes
{
	//TriangleCraft
	import TriangleCraft.Tile.TileID
	import TriangleCraft.Tile.TileSystem
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	
	public class Shape_Custom extends Sprite
	{
		//======Dynamic Variables======//
		intc var loadCurrents:Array=new Array()
		intc var currentList:Array=new Array()
		
		public function Shape_Custom():void
		{
			
		}
		
		intc function addCurrent(url:String,id:String,data:int=0):void
		{
			if(TileSystem.isAllowID(id))
			{
				this.loadCurrents.push(url,id,data)
				var current:Loader=new Loader()
				current.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete)
				current.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError)
				current.load(new URLRequest(url))
			}
		}
		
		intc function getCurrent(Id:String,Data:int=0,ReloadData:Boolean=true):Bitmap
		{
			if(General.isEmptyArray(this.currentList))
			{
				return null
			}
			var i:uint
			for(i=0;i<this.currentList.length;i++)
			{
				if(this.currentList[i] is String&&this.currentList[i]==Id)
				{
					if(uint(this.currentList[i+1])==Data)
					{
						return (this.currentList[i-1] as Bitmap)
					}
				}
			}
			if(ReloadData)
			{
				for(i=0;i<this.currentList.length;i++)
				{
					if(this.currentList[i] is String&&this.currentList[i]==Id)
					{
						return (this.currentList[i-1] as Bitmap)
					}
				}
			}
			return null
		}
		
		public function hasCurrent(Id:String,Data:uint=0,ReloadData:Boolean=true):Boolean
		{
			return (getCurrent(Id,Data,ReloadData)!=null)
		}
		
		public function setCurrent(Id:String,Data:int=0,ReloadData:Boolean=true):void
		{
			if(this.hasCurrent(Id,Data,ReloadData))
			{
				if(this.getCurrent(Id,Data,ReloadData)!=null)
				{
					this.ActiveChild=this.getCurrent(Id,Data,ReloadData)
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
		
		//======Load======//
		intc function get isLoading():Boolean
		{
			return !General.isEmptyArray(this.loadCurrents)
		}
		
		intc function loadComplete(event:Event=null):void
		{
			var image:Bitmap=Bitmap(event.target.loader.content)
			image.scaleX=TileSystem.globalTileSize/image.width
			image.scaleY=TileSystem.globalTileSize/image.height
			var loc:int=this.loadCurrents.indexOf(event.target.loader.contentLoaderInfo.url)
			if(loc>0)
			{
				var Id:String=String(this.loadCurrents[loc+1])
				var Data:int=int(this.loadCurrents[loc+2])
				this.loadCurrents.splice(loc,3)
				this.currentList.push(image,Id,Data)
			}
		}
		
		intc function loadError(event:IOErrorEvent=null):void
		{
			trace("Error "+event.errorID+": "+event.text)
			if(event.target!=null&&event.target is Loader)
			{
				(event.target as Loader).unload()
			}
		}
	}
}