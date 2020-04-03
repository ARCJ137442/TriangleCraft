package TriangleCraft.Common
{
	import com.adobe.tvsdk.mediacore.BufferControlParameters;
	public class RandomGenerator extends Object
	{
		//============Static Functions============//
		public function get DEFAULT_BUFFER():Vector.<Number>
		{
			return new <Number>[1,0,1]
		}
		
		public static function getBuff(value:Number,buffer:Vector.<Number>):Number
		{
			if(value==NaN||buffer==null||buffer.length<2) return NaN
			var zeroIndex:uint=uint(buffer[0])
			var resultNumber:Number=0
			for(var index:uint=1;index<buffer.length;index++)
			{
				resultNumber+=Math.pow(value,zeroIndex-index)*buffer[index]
			}
			return resultNumber
		}
		
		private static function isEqualNumVec(v1:Vector.<Number>,v2:Vector.<Number>):Boolean
		{
			if(v1.length!=v2.length) return false
			return v1.every(function(n:Number,i:uint,v:Vector.<Number>):Boolean
									 {
										 return v1[i]==v2[i]
									 })
		}
		
		//============Instance Variables============//
		protected var _mode:Number
		protected var _buffer:Vector.<Number>
		protected var _randomList:Vector.<Number>
		
		//============Init RandomGenerator============//
		public function RandomGenerator(seed:Number=0,mode:Number=0,
										buffer:Vector.<Number>=DEFAULT_BUFFER,
										length:uint=1):void
		{
			this._mode=mode
			this._buffer=buffer!=null?buffer:new Vector.<Number>
			this._randomList[0]=seed
			this.generateNaxt(length)
		}
		
		//============Instance Functions============//
		//======Getters And Setters======//
		public function get seed():Number 
		{
			return this._randomList[0]
		}
		
		public function set seed(value:Number):void 
		{
			var reGenerate:Boolean=(value!=this.seed)
			this._randomList[0]=value
			if(reGenerate) dealReset()
		}
		
		public function get mode():Number 
		{
			return this._mode
		}
		
		public function set mode(value:Number):void 
		{
			var reGenerate:Boolean=(value!=this.mode)
			this._mode=value
			if(reGenerate) dealReset()
		}
		
		public function get buffer():Vector.<Number> 
		{
			return this._buffer
		}
		
		public function set buffer(value:Vector.<Number>):void 
		{
			var reGenerate:Boolean=(!isEqualNumVec(this.buffer,value))
			this._buffer=value
			if(reGenerate) dealReset()
		}
		
		public function get numCount():uint
		{
			return this._randomList.length-1
		}
		
		public function get lastNum():Number
		{
			return this._randomList[this._randomList.length]
		}
		
		//======Public Functions======//
		public function clone():RandomGenerator
		{
			return new RandomGenerator(this.seed,this.mode,this.buffer,this.numCount)
		}
		
		public function generateNaxt(count:uint=1):void
		{
			if(count==0) return
			if(count==1)
			{
				this._randomList.push(getBuff(this.lastNum,this.buffer)%this.mode)
				return
			}
			for(var i:uint=0;i<count;i++)
			{
				this._randomList.push(getBuff(this.lastNum,this.buffer)%this.mode)
			}
		}
		
		public function getRandom(index:uint=0):Number
		{
			//index Start At 1
			if(index==0)
			{
				generateNaxtRandom()
				return this.lastNum
			}
			else if(index<=this.numCount)
			{
				return this._randomList[index]
			}
			else
			{
				generateNaxt(index-this.numCount)
				return this.lastNum
			}
		}
		
		public function reset():void
		{
			this._randomList.length=1
		}
		
		//======Protected Functions======//
		protected function dealReset()
		{
			var tempCount:uint=this.numCount
			this.reset()
			this.generateNaxt(tempCount)
		}
	}
}