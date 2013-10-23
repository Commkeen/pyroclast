package org.pyroclast.ai.Transitions 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.pyroclast.ai.Interfaces.ITransition;
	import org.pyroclast.ai.Interfaces.IAIState;
	import org.pyroclast.ai.Actions.TestAction;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class TestTransition implements ITransition 
	{
		
		private var timer:Timer;
		private var isDone:Boolean;
		private var actions:Array;
		public var testState:IAIState;
		
		public function TestTransition( delay:int ) 
		{
			isDone = false;
			timer = new Timer( delay, 1 );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void { isDone = true; } );
			actions = new Array();
			actions.push( new TestAction( "Firing a test transition" ) );
			timer.start();
			//testState = new StateMachineState( [ new TestAction( "In a state" ), new TestAction( "Second action in a state" ) ], [ new TestAction( "Entering a state" ) ], [ new TestAction( "Exiting a state" ) ] );
		}
		
		/* INTERFACE com.john.Jumper.ITransition */
		
		public function isTriggered():Boolean 
		{
			return isDone;
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