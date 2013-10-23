package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.pyroclast.ai.Utilities.OrbitingObjectLink;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class UpdateCirclingChildren implements IAIAction 
	{

		private var _children:Array;
		private var _parent:FlxSprite;
		private var _numberOfChildren:int;
		private var _angleIncrement:Number;
		private var _linkArray:Array;
		
		private var _expiryTime:Number = 0;
		private var _priority:Number = 0;
		
		private var hasUpdated:Boolean = false;
		
		public function UpdateCirclingChildren( parent:FlxSprite, children:Array, angleIncrement:Number ) 
		{
			_parent = parent;
			_children = children;
			_numberOfChildren = _children.length;
			_angleIncrement = angleIncrement;
			_linkArray = new Array();
			for ( var i:int = 0; i < _numberOfChildren; ++i )
			{
				//Need to create a link object here, store in array
				_linkArray.push( new OrbitingObjectLink( _parent, ( _children[i] as FlxSprite ), angleIncrement ) );
			}
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
			return false
		}
		
		public function isComplete():Boolean 
		{
			return true;
		}
		
		public function execute():void 
		{
			//if ( !hasUpdated )
			//{
				for ( var i:int = 0; i < _linkArray.length; ++i )
				{
					( _linkArray[i] as OrbitingObjectLink ).update();
				}
				hasUpdated = true;
			//}
		}
		
		public function getLinks():Array
		{
			return _linkArray;
		}
		
	}

}