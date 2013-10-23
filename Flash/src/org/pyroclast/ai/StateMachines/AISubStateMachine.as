package org.pyroclast.ai.StateMachines 
{
	
	import org.pyroclast.ai.Interfaces.IAIState;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class AISubStateMachine extends AIStateMachine implements IAIState 
	{
		
		protected var _transitions:Array;
		
		public function AISubStateMachine(_initialState:IAIState, transitions:Array ) 
		{
			super(_initialState);
			_transitions = transitions;
		}
		
		/* INTERFACE com.john.Jumper.IAIState */
		
		public function getEntryActions():Array 
		{
			return currentState.getEntryActions();
		}
		
		public function getExitActions():Array 
		{
			return currentState.getExitActions();
		}
		
		public function getActions():Array 
		{
			//return currentState.getActions();
			return this.update();
		}
		
		public function getTransitions():Array 
		{
			//return currentState.getTransitions();
			return _transitions;
		}
		
	}

}