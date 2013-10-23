package org.pyroclast.ai.Interfaces 
{
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public interface ITransition 
	{
		//Test if the transition is triggered. Usually one or more condition objects are tested. 
		function isTriggered():Boolean;
		
		//Return the actions that should be called when firing this transition
		function getActions():Array;
		
		//Return the state this transition leads to
		function getState():IAIState;
		
		//TODO - remove this?
		function setState(state:IAIState):void;
		
		//On entering a state, reset all transitions. Mainly here for time-based transitions to function properly
		function reset():void;
	}
	
}