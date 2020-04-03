package 
{
	import flash.display.MovieClip
	public class TileShape extends MovieClip
	{
		public function TileShape():void
		{
			stop()
		}
		
		public function setFrame(f:uint):void
		{
			this.gotoAndStop(f)
		}
	}
}