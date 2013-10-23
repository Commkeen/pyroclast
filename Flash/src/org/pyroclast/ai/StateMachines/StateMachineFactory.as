package org.pyroclast.ai.StateMachines 
{
	/**
	 * ...
	 * @author John Lynk
	 */
	public class StateMachineFactory 
	{
		
		import org.pyroclast.ai.Actions.ChaseAction;
		import org.pyroclast.ai.Actions.ChaseWithDistance;
		import org.pyroclast.ai.Actions.CreateProjectileAction;
		import org.pyroclast.ai.Actions.FireOrbitingObjectAction;
		import org.pyroclast.ai.Actions.FleeAction;
		import org.pyroclast.ai.Actions.KillAction;
		import org.pyroclast.ai.Actions.KillArray;
		import org.pyroclast.ai.Actions.SineYPositionAction;
		import org.pyroclast.ai.Actions.TurnAtEdgeAction;
		import org.pyroclast.ai.Actions.UpdateCirclingChildren;
		import org.pyroclast.ai.Conditions.HealthCondition;
		import org.pyroclast.ai.Interfaces.IAIState;
		import org.pyroclast.ai.Interfaces.ITransition;
		import org.pyroclast.ai.StateMachines.AIStateMachine;
		import org.pyroclast.ai.StateMachines.AISubStateMachine;
		import org.pyroclast.ai.StateMachines.StateMachineState;
		import org.pyroclast.ai.Transitions.ConditionBasedTransition;
		import org.pyroclast.ai.Transitions.TestKeyTransition;
		import org.pyroclast.ai.Transitions.TestTransition;
		import org.pyroclast.ai.Actions.TestAction;
		import org.pyroclast.ai.Transitions.TimeBasedTransition;
		import org.flixel.FlxSprite;
		import org.flixel.FlxTilemap;
		
		public function StateMachineFactory() 
		{
			
		}
		
		public static function createScorpionStateMachine( _scorpion:FlxSprite, _tilemap:FlxTilemap ):AIStateMachine
		{
			//Create an array to store your states
			var states:Array = new Array();
			
			//Create all your necessary transitions here
			var transitionToDead:ITransition = new ConditionBasedTransition( [new HealthCondition( _scorpion, 0, HealthCondition.LESS_THAN_EQUAL_TO )], [] );
			
			//Create your actions here
			
			var patrolActions:Array = new Array();
			patrolActions.push( new TurnAtEdgeAction( _scorpion, _tilemap ) );
			
			
			//Create your states here
			var deadState:IAIState = new StateMachineState( [], [new KillAction(_scorpion)], [], [] );
			
			var patrolState:IAIState = new StateMachineState( patrolActions, [], [], [transitionToDead] );
			
			//Set your transition target states here
			transitionToDead.setState( deadState );
			
			//Return a new AIStateMachine with the proper initial state
			return new AIStateMachine( patrolState );
		}
		
		public static function createBatStateMachine( _bat:FlxSprite ):AIStateMachine
		{
			//Create an array to store your states
			var states:Array = new Array();
			
			//Create all your necessary transitions here
			var transitionToDead:ITransition = new ConditionBasedTransition( [new HealthCondition( _bat, 0, HealthCondition.LESS_THAN_EQUAL_TO )], [] );
			
			//Create your actions here
			var flyingActions:Array = new Array();
			flyingActions.push( new SineYPositionAction( _bat, 500, 0.1 ) );
			
			//Create your states here
			var flyingState:IAIState = new StateMachineState( flyingActions, [], [], [transitionToDead] );
			var deadState:IAIState = new StateMachineState( [], [new KillAction( _bat )], [], [] );
			
			//Set your transition target states here
			transitionToDead.setState( deadState );
			
			//Return a new AIStateMachine with the proper initial state
			return new AIStateMachine( flyingState );
		}
		
		public static function createSpitfireStateMachine( _spitfire:FlxSprite, _rocks:Array, _player:FlxSprite ):AIStateMachine
		{
			var states:Array = new Array();
			
			//Transitions
			var transitionToFireState:ITransition = new TimeBasedTransition( [], 1 );
			var transitionToOrbitingState:ITransition = new TimeBasedTransition( [], 1 );
			var transitionToDeadState:ITransition = new HealthCondition( _spitfire, 0, HealthCondition.LESS_THAN_EQUAL_TO );
			
			var orbitingActions:Array = new Array();
			var circlingAction:UpdateCirclingChildren = new UpdateCirclingChildren( _spitfire, _rocks, .1 );
			
			//These need to be in THIS ORDER!!!
			orbitingActions.push( new ChaseWithDistance( _spitfire, _player, 50 ) );
			orbitingActions.push( circlingAction );
			
			var fireActions:Array = new Array();
			fireActions.push( new FireOrbitingObjectAction( circlingAction.getLinks(), _player, 50 ) );
			
			var orbitingState:IAIState = new StateMachineState( orbitingActions, [], [], [transitionToFireState] );
			var fireState:IAIState = new StateMachineState( orbitingActions, fireActions, [], [transitionToOrbitingState] );
			var deadState:IAIState = new StateMachineState( [], [new KillAction(_spitfire), new KillArray(_rocks)], [], [] );
			
			var subMachine:AISubStateMachine = new AISubStateMachine( orbitingState, [transitionToDeadState] );
			
			transitionToFireState.setState( fireState );
			transitionToOrbitingState.setState( orbitingState );
			
			return new AIStateMachine( subMachine );
		}
		
		public static function createSpiderStateMachine( _spider:FlxSprite, _projectileClass:Class, _tilemap:FlxTilemap )
		{
			var states:Array = new Array();
			
			//Transitions
			var transitionToShootingState:ITransition = new TimeBasedTransition( [], 5 );
			var transitionToPatrolState:ITransition = new TimeBasedTransition( [], 1 );
			var transitionToDeadState:ITransition = new HealthCondition( _spider, 0, HealthCondition.LESS_THAN_EQUAL_TO );
			
			//TODO - FINISH PROJECTILE STUFF
		}
	}

}