package org.pyroclast.ai.Transitions 
{
	import org.pyroclast.ai.Interfaces.IAIState;
	import org.pyroclast.ai.Interfaces.ITransition;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TimeBasedTransition implements ITransition 
	{
		
		private var _timer:FlxTimer;
		private var _duration:Number;
		private var _isDone:Boolean = false;
		private var _actions:Array;
		private var _targetState:IAIState;
		
		public function TimeBasedTransition( actions:Array, duration:Number ) 
		{
			_timer = new FlxTimer();
			_duration = duration;
			_actions = actions;
		}
		
		/* INTERFACE org.pyroclast.ai.Interfaces.ITransition */
		
		public function isTriggered():Boolean 
		{
			return _isDone;
		}
		
		public function getActions():Array 
		{
			return _actions;
		}
		
		public function getState():IAIState 
		{
			return _targetState;
		}
		
		public function setState(state:IAIState):void 
		{
			_targetState = state;
		}
		
		public function reset():void 
		{
			_isDone = false;
			_timer.start( _duration, 1, onTimerFinish );
		}
		
		private function onTimerFinish(Timer:FlxTimer):void
		{
			_isDone = true;
		}
		
	}

}