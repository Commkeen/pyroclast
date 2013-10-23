package org.pyroclast.ai.StateMachines 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.pyroclast.ai.Interfaces.IStateCondition;
	import org.pyroclast.ai.Interfaces.IAIState;
	import org.pyroclast.ai.Interfaces.ITransition;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class AIStateMachine 
	{
		
		public var initialState:IAIState;
		public var currentState:IAIState;
		
		public function AIStateMachine( _initialState:IAIState ) 
		{
			initialState = _initialState;
			currentState = _initialState;
			
			resetCurrentTransitions();
		}
		
		//Check for transitions, apply them, and return a list of actions
		public function update():Array
		{
			var transitions:Array = currentState.getTransitions();
			var hasFoundTransition:Boolean = false;
			var transition:ITransition = null;
			for ( var i:int = 0; ( i < transitions.length ) && !hasFoundTransition; ++i )
			{
				transition = transitions[i] as ITransition;
				if ( transition.isTriggered() )
				{
					hasFoundTransition = true;
				}
			}
			
			
			
			//TODO - make this more memory friendly
			var actions:Array = new Array();
			
			if ( hasFoundTransition && transition != null )
			{
				//Need to transition states
				actions = actions.concat( currentState.getExitActions() );
				actions = actions.concat( transition.getActions() );
				actions = actions.concat( transition.getState().getEntryActions() );
				currentState = transition.getState();
				resetCurrentTransitions();
			}
			else
			{
				actions = actions.concat( currentState.getActions() );
			}
			
			return actions;
		}
		
		private function resetCurrentTransitions():void
		{
			var transitions:Array = currentState.getTransitions();
			{
				for ( var i:int = 0; i < transitions.length; ++i )
				{
					var transitionToReset:ITransition = ( transitions[i] as ITransition );
					transitionToReset.reset();
				}
			}
		}
		
	}

}