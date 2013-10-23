package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class ChaseWithDistance implements IAIAction 
	{
		private var _parent:FlxSprite;
		private var _target:FlxSprite;
		private var _distance:Number;
		
		private var _expiryTime:int = 0;
		private var _priority:int = 0;
		
		public function ChaseWithDistance( parent:FlxSprite, target:FlxSprite, distance:Number ) 
		{
			_parent = parent;
			_target = target;
			_distance = distance;
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
			var parentCenter = new FlxPoint( _parent.x + _parent.origin.x, _parent.y + _parent.origin.y );
			var targetCenter = new FlxPoint( _target.x + _target.origin.x, _target.y + _target.origin.y );
			
			if ( FlxU.getDistance( parentCenter, targetCenter ) > _distance )
			{
				var desiredVelocity:FlxPoint = new FlxPoint();
				desiredVelocity.x = targetCenter.x - parentCenter.x;
				desiredVelocity.y = targetCenter.y - parentCenter.y;
				
				var magnitude:Number = ( Math.sqrt( desiredVelocity.x * desiredVelocity.x ) + Math.sqrt( desiredVelocity.y * desiredVelocity.y ) );
				desiredVelocity.x /= magnitude;
				desiredVelocity.y /= magnitude;
				
				desiredVelocity.x *= 100;
				desiredVelocity.y *= 100;
				
				_parent.velocity = desiredVelocity;
			}
		}
		
	}

}