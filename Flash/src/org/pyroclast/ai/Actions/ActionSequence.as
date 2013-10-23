package org.pyroclast.ai.Actions 
{
	/**
	 * ...
	 * @author John Lynk
	 */
	
	import org.pyroclast.ai.Interfaces.IAIAction;
	 
	public class ActionSequence implements IAIAction 
	{

		protected var _expiryTime:Number;
		protected var _priority:int;
		protected var _actions:Array;
		protected var _currentActionIndex:int;
		
		public function ActionSequence(actions:Array, priority:int = 1, expiration:int = 0 ) 
		{
			_actions = actions;
			_priority = priority;
			_expiryTime = expiration;
			_currentActionIndex = 0;
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
			return ( _actions[0] as IAIAction ).canInterrupt();
		}
		
		public function canDoBoth(otherAction:IAIAction):Boolean 
		{
			for each ( var obj in _actions )
			{
				var action:IAIAction = obj as IAIAction;
				if ( !action.canDoBoth(otherAction) ) return false;
			}
			return true;
		}
		
		public function isComplete():Boolean 
		{
			return _currentActionIndex >= _actions.length;
		}
		
		public function execute():void 
		{
			var action:IAIAction = ( _actions[_currentActionIndex] as IAIAction );
			action.execute();
			
			if ( action.isComplete() ) ++_currentActionIndex;
		}
		
	}

}