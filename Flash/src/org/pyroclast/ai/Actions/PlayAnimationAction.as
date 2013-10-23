package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayAnimationAction implements IAIAction 
	{

		private var _parent:FlxSprite;
		private var _animation:String;
		private var _hasFired:Boolean = false;
		private var _loop:Boolean;
		public function PlayAnimationAction(parent:FlxSprite, animation:String, loop:Boolean) 
		{
			_parent = parent;
			_animation = animation;
			_loop = loop;
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
			if ( _loop )
			{
				return true;
			}
			else if ( _hasFired )
			{
				return _parent.finished;
			}
			
			return true;
		}
		
		public function execute():void 
		{
			_parent.play( _animation );
			_hasFired = true;
		}
		
	}

}