package TriangleCraft.Error
{
	public class CraftRecipeError extends Error 
	{
		//============Static Variables============//
		public static const PATTERN_ERROR:String="PATTERN_ERROR"
		public static const VALUE_ERROR:String="VALUE_ERROR"
		public static const UNKOMN_ERROR:String="UNKOMN_ERROR"
		
		//============Instance Variables============//
		protected var _type:String
		
		//============Init CraftRecipeError============//
		public function CraftRecipeError(message:*="",type:String="")
		{
			super(message,0)
			this._type=type
		}
		
		//============Instance Functions============//
		//Getters And Setters
		public function get type():String
		{
			return this._type
		}
	}
}