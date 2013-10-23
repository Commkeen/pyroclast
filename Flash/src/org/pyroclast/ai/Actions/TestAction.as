package org.pyroclast.ai.Actions 
{
	
	import org.pyroclast.ai.Interfaces.IAIAction;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class TestAction implements IAIAction 
	{
		private var message:String;
		public function TestAction( inMessage:String ) 
		{
			message = inMessage;
		}
		
		/* INTERFACE com.john.Jumper.IAIAction */
		
		public function get expiryTime():Number 
		{
			//return _expiryTime;
			return -1;
		}
		
		public function set priority(value:int):void 
		{
			//_priority = value;
			//return -1;
		}
		
		public function get priority():int 
		{
			//return _priority;
			return -1;
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
			return true;
		}
		
		public function execute():void 
		{
			trace( "TestAction: "+message );
		}
		
	}

}