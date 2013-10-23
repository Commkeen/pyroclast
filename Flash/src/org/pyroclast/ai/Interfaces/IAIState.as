package org.pyroclast.ai.Interfaces 
{
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public interface IAIState 
	{
		//Get the actions associated with entering, exiting, and being in this state
		function getEntryActions():Array;
		function getExitActions():Array;
		function getActions():Array;
		
		//Get the transitions for leaving this state
		function getTransitions():Array;
	}
	
}