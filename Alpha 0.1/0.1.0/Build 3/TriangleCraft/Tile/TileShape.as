package TriangleCraft.Tile
{
	//Flash
	import flash.display.MovieClip
	
	public class TileShape extends MovieClip
	{
		public function TileShape():void
		{
			stop()
		}
		
		public function set Frame(f:uint):void
		{
			this.gotoAndStop(f)
		}
	}
}