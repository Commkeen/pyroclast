package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class KillArray implements IAIAction 
	{
		
		private var _array:Array;
		protected var _expiryTime:Number;
		protected var _priority:int;
		
		public function KillArray(array:Array) 
		{
			_array = array;
		}
		
		/* INTERFACE org.pyroclast.ai.Interfaces.IAIAction */
		
		public function get expiryTime():Number 
		{
			return _expiryTime;
		}
		
		public function set priority(value:int):void 
		{
			_priority = value;
		}
		
		public function get priority():int 
		{
			return _priority;
		}
		
		public function canInterrupt():Boolean 
		{
			return false;
		}
		
		public function canDoBoth(otherAction:IAIAction):Boolean 
		{
			return false;
		}
		
		public function isComplete():Boolean 
		{
			return true;
		}
		
		public function execute():void 
		{
			for ( var i:int = 0; i < _array.length; ++i )
			{
				if ( _array[i] )
				{
					( _array[i] as FlxSprite ).kill();
				}
			}
		}
		
	}

}