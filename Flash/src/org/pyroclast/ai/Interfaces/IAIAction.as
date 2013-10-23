package org.pyroclast.ai.Interfaces 
{
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public interface IAIAction 
	{
		//This is used as a way to show that if too much time passes, the action should not be used. 
		//Could do this in frames? Do we have access to real time in Flixel?
		function get expiryTime():Number;
		
		//Higher priority = top of the list. Do we really need this for what we're doing?
		function set priority(value:int):void;
		function get priority():int;
		
		//Says if this action can interrupt another action - do need this. Simple boolean return of true/false implemented in concrete classes
		function canInterrupt():Boolean;
		
		//Not sure how we should implement, also unsure if really necessary. 
		function canDoBoth(otherAction:IAIAction):Boolean;
		
		//Says if this action is complete yet or not. Good for action sequences/combinations
		function isComplete():Boolean;
		
		//Perform the action
		function execute():void;
	}
	
}