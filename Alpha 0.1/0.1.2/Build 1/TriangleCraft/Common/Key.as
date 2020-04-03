package TriangleCraft.Common
{
	//TriangleCraft
	import TriangleCraft.Common.*;
	use namespace intc
	
	//Flash
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	//Class
	public class Key
	{
		//Variables
		private static var ListenTo:Stage=null
		private static var prassedKeys:Array=new Array()
		private static var ctrlKey:Boolean=false
		private static var shiftKey:Boolean=false
		private static var altKey:Boolean=false
		
		//Getters And Setters
		public static function get Listens():*
		{
			return ListenTo
		}
		
		public static function set Listens(_stage:Stage):void
		{
			if(_stage!=null)
			{
				//Set Old
				if(ListenTo!=null)
				{
					if(ListenTo.hasEventListener(KeyboardEvent.KEY_DOWN))
					{
						ListenTo.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
					}
					if(ListenTo.hasEventListener(KeyboardEvent.KEY_UP))
					{
						ListenTo.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp)
					}
				}
				//Set New
				ListenTo=_stage
				ListenTo.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
				ListenTo.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			}
		}
		
		//Public Functions
		public static function isDown(Code:uint):Boolean
		{
			return General.IsiA(Code,prassedKeys)
		}
		
		public static function isUp(Code:uint):Boolean
		{
			return !isDown(Code)
		}
		
		public static function isAnyKeyPrass():Boolean
		{
			if(Key.prassedKeys.length>0)
			{
				return true
			}
			else if(ctrlKey||shiftKey||altKey)
			{
				
			}
			return false
		}
		
		//Private Functions
		private static function onKeyDown(E:KeyboardEvent):void
		{
			ctrlKey=E.ctrlKey
			shiftKey=E.shiftKey
			altKey=E.altKey
			prassedKeys.push(E.keyCode)
		}
		
		private static function onKeyUp(E:KeyboardEvent):void
		{
			ctrlKey=E.ctrlKey
			shiftKey=E.shiftKey
			altKey=E.altKey
			General.SinA(E.keyCode,prassedKeys)
		}
	}
}