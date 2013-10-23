package org.pyroclast.ai.Transitions 
{
	import org.pyroclast.ai.Interfaces.IAIState;
	import org.pyroclast.ai.Interfaces.IStateCondition;
	import org.pyroclast.ai.Interfaces.ITransition;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class ConditionBasedTransition implements ITransition 
	{
		
		private var _conditions:Array;
		private var _actions:Array;
		private var _targetState:IAIState;
		
		public function ConditionBasedTransition( conditions:Array, actions:Array ) 
		{
			_conditions = conditions;
			_actions = actions;
		}
		
		/* INTERFACE org.pyroclast.ai.Interfaces.ITransition */
		
		public function isTriggered():Boolean 
		{
			for ( var i:int = 0; i < _conditions.length; ++i )
			{
				if ( !( _conditions[i] as IStateCondition ).test() )
				{
					return false;
				}
			}
			return true;
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
			
		}
		
	}

}