package org.pyroclast.ai.Conditions 
{
	import org.pyroclast.ai.Interfaces.IStateCondition;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class HealthCondition implements IStateCondition 
	{
		
		public static const EQUALS:int = 0;
		public static const NOT_EQUALS:int = 1;
		public static const GREATER_THAN:int = 2;
		public static const GREATER_THAN_EQUAL_TO:int = 3;
		public static const LESS_THAN:int = 4;
		public static const LESS_THAN_EQUAL_TO:int = 5;
		
		private var _parent:FlxSprite;
		private var _target:Number;
		private var _function:int;
		
		public function HealthCondition( parent:FlxSprite, target:Number, equality:int) 
		{
			_parent = parent;
			_target = target;
			_function = equality;
		}
		
		/* INTERFACE org.pyroclast.ai.Interfaces.IStateCondition */
		
		public function test():Boolean 
		{
			switch( _function )
			{
				case EQUALS:
					return _parent.health == _target;
					break;
				case NOT_EQUALS:
					return _parent.health != _target;
					break;
				case GREATER_THAN:
					return _parent.health > _target;
					break;
				case GREATER_THAN_EQUAL_TO:
					return _parent.health >= _target;
					break;
				case LESS_THAN:
					return _parent.health < _target;
					break;
				case LESS_THAN_EQUAL_TO:
					return _parent.health <= _target;
					break;
			}
			return false;
		}
		
	}

}