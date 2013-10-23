package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SineYPositionAction implements IAIAction 
	{
		
		//For horizontal movement to achieve "Medusa Head" behavior, set the x-velocity of the FlxSprite outside of this action. This will be overwriting the y-velocity every frame
		//NOTE: frequency may not be the completely correct mathematical term here
		private var _parent:FlxSprite;
		private var _amplitude:Number;
		private var _frequency:Number;
		private var _started:Boolean = false;
		private var _t:Number = 0;
		//_tIncrement is the amount to increase t per frame - we use this instead of a timer because it would be easier to stop and continue than a timer
		private var _tIncrement:Number;
		
		private var _expiryTime:int = 0;
		private var _priority:int = 0;
		
		public function SineYPositionAction( parent:FlxSprite, amplitude:Number, tIncrement:Number ) 
		{
			_parent = parent;
			_amplitude = amplitude;
			_tIncrement = tIncrement;
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
			_t += _tIncrement;
			_parent.velocity.y = Math.sin( _t ) * _amplitude;
		}
		
	}

}