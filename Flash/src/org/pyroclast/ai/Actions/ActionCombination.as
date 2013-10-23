package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class ActionCombination implements IAIAction 
	{
		protected var _actions:Array;
		protected var _priority:int;
		protected var _expiryTime:int;
		
		public function ActionCombination( actions:Array, priority:int = 1, expiration:int = 0 )
		{
			_actions = actions;
			_priority = priority;
			_expiryTime = expiration;
		}
		
		/* INTERFACE com.john.Jumper.IAIAction */
		
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
			for each( var obj in _actions )
			{
				var action:IAIAction = obj as IAIAction;
				if ( action.canInterrupt() ) return true;
			}
			return false;
		}
		
		public function canDoBoth(otherAction:IAIAction):Boolean 
		{
			for each ( var obj in _actions )
			{
				var action:IAIAction = obj as IAIAction;
				if ( !action.canDoBoth(otherAction:IAIAction) ) return false;
			}
			return true;
		}
		
		public function isComplete():Boolean 
		{
			for each ( var obj in _actions )
			{
				var action:IAIAction = obj as IAIAction;
				if ( !action.isComplete() ) return false;
			}
			return true;
		}
		
		public function execute():void
		{
			for each( var obj in _actions )
			{
				var action:IAIAction = obj as IAIAction;
				action.execute();
			}
		}
		
	}

}