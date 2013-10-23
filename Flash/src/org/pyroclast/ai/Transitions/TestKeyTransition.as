package org.pyroclast.ai.Transitions 
{
	
	import org.flixel.FlxG;
	import org.pyroclast.ai.Interfaces.ITransition;
	import org.pyroclast.ai.Interfaces.IAIState;
	import org.pyroclast.ai.Actions.TestAction;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class TestKeyTransition implements ITransition 
	{
		
		private var actions:Array;
		public var testState:IAIState;
		private var _key:String;
		
		public function TestKeyTransition( key:String ) 
		{
			actions = new Array();
			actions.push( new TestAction( "Firing a testkey transition" ) );
			_key = key;
		}
		
		/* INTERFACE com.john.Jumper.ITransition */
		
		public function isTriggered():Boolean 
		{
			return FlxG.keys.justPressed(_key);
		}
		
		public function getActions():Array 
		{
			return actions;
		}
		
		public function getState():IAIState 
		{
			return testState;
		}
		
		public function setState(state:IAIState):void
		{
			testState = state;
		}
		
		public function reset():void
		{
			
		}
		
	}

}