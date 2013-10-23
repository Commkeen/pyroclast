package org.pyroclast.ai.StateMachines 
{
	
	import org.pyroclast.ai.Interfaces.IAIState;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class StateMachineState implements IAIState
	{
		
		protected var _entryActions:Array;
		protected var _exitActions:Array;
		protected var _actions:Array;
		protected var _transitions:Array;
		
		public function StateMachineState( actions:Array, entryActions:Array, exitActions:Array, transitions:Array ) 
		{
			_entryActions = entryActions;
			_exitActions = exitActions;
			_actions = actions;
			_transitions = transitions;			
		}
		
		public function getEntryActions():Array
		{
			return _entryActions;
		}
		
		public function getExitActions():Array
		{
			return _exitActions;
		}
		
		public function getActions():Array
		{
			return _actions;
		}
		
		public function getTransitions():Array
		{
			return _transitions;
		}
		
	}

}