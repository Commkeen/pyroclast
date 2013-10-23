package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AddToGroupsAction implements IAIAction 
	{

		var _parent:FlxSprite;
		var _groups:Array;
		public function AddToGroupsAction(parent:FlxSprite, groups:Array)
		{
			_parent = parent;
			_groups = groups;
		}
		
		/* INTERFACE org.pyroclast.ai.Interfaces.IAIAction */
		
		public function get expiryTime():Number 
		{
			return _expiryTime;
		}
		
		public function set priority(value:int):void 
		{
			_priority = value;
		}
		
		public function get priority():int 
		{
			return _priority;
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
			for ( var i:int = 0; i < _groups.length; ++i )
			{
				var group:FlxGroup = ( _groups[i] as FlxGroup );
				group.add( _parent );
			}
		}
		
	}

}