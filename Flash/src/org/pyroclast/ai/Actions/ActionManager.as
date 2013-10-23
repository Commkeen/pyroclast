package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class ActionManager 
	{
		//The highest priority for all actions in the active set
		private var activePriority:int = 0;
		
		//Actions to be performed
		private var actionQueue:Array = new Array();
		
		//Actions currently being performed
		private var activeActions:Array = new Array();
		
		public function ActionManager() 
		{
			
		}
		
		//Runs all current actions, removes any complete actions
		protected function runActive():void
		{
			for ( var i:int = 0; i < activeActions.length; ++i )
			{
				var action:IAIAction = ( activeActions[i] as IAIAction );
				
				action.execute();
				if ( action.isComplete() )
				{
					activeActions.splice( i, 1 );
					--i;
				}
			}
		}
		
		//Allow high-priority actions to interrupt the currently active set
		protected function checkInterrupts():void
		{
			for ( var i:int = 0; i < actionQueue.length; ++i )
			{
				var action:IAIAction = ( actionQueue[i] as IAIAction );
				
				//Can't interrupt with a lower priority action
				if ( action.priority < activePriority )
				{
					return;
				}
				if ( action.canInterrupt() )
				{
					//Interrupt! Clear the active action list, and replace it
					activeActions.splice( 0, activeActions.length );
					
					activeActions.push( action );
					activePriority = action.priority;
					
					actionQueue.splice( i, 1 );
					return;
				}
			}
		}
		
		//Checks all actions in the queue to see if they can be performed at the same time as the actions already in the active set. If so, they are scheduled. 
		protected function addAllToActive():void
		{
			for ( var i:int = 0; i < actionQueue.length; ++i )
			{
				var activeAction:IAIAction = ( activeActions.length > 0 ) ? ( activeActions[0] as IAIAction ) : null;
				var queuedAction:IAIAction = actionQueue[i];
				if ( ( activeAction != null && activeAction.canDoBoth( queuedAction ) && queuedAction.canDoBoth( activeAction ) ) || activeAction == null  )
				{
					activeActions.splice( 0, 0, queuedAction );
					if ( actionQueue .length > 0 )
					{
						actionQueue.splice( i, 1 );
					}
					--i;
				}
			}
		}
		
		public function scheduleAction( newAction:IAIAction ):void
		{
			//Add to the queue at the correct priority
			for ( var i:int = 0; i < actionQueue.length; ++i )
			{
				var action:IAIAction = ( actionQueue[i] as IAIAction );
				if ( newAction.priority > action.priority )
				{
					actionQueue.splice( i, 0, newAction );
					return;
				}
			}
			actionQueue.push(newAction);
		}
		
		public function execute():void
		{
			checkInterrupts();
			
			addAllToActive();
			
			runActive();
		}
		
	}

}