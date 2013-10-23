package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class FleeAction implements IAIAction 
	{
		
		private var _parent:FlxSprite;
		private var _target:FlxSprite;
		private var _expiryTime:int = 0;
		private var _priority:int = 0;
		public function FleeAction( parent:FlxSprite, target:FlxSprite ) 
		{
			_parent = parent;
			_target = target;
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
			var desiredVelocity:FlxPoint = new FlxPoint();
			desiredVelocity.x = _parent.x - _target.x;
			desiredVelocity.y = _parent.y - _target.y;
			
			var magnitude:Number = ( Math.sqrt( desiredVelocity.x * desiredVelocity.x ) + Math.sqrt( desiredVelocity.y * desiredVelocity.y ) );
			desiredVelocity.x /= magnitude;
			desiredVelocity.y /= magnitude;
			
			desiredVelocity.x *= 100;
			desiredVelocity.y *= 100;
			
			_parent.velocity = desiredVelocity;
		}
	}

}