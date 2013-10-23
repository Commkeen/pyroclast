package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class DeathAction implements IAIAction 
	{
		
		private var _parent:FlxSprite;
		private var _expiryTime:int = 0;
		private var _priority:int = 0;
		
		public function DeathAction( parent:FlxSprite ) 
		{
			_parent = parent;
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
			return false;
		}
		
		public function execute():void 
		{
			_parent.kill();
		}
		
	}

}