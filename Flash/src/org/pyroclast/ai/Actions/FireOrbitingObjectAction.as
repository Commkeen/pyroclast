package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.pyroclast.ai.Utilities.OrbitingObjectLink;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class FireOrbitingObjectAction implements IAIAction 
	{
		
		private var _linkArray:Array;
		private var _player:FlxSprite;
		private var _speed:Number;
		
		private var _expiryTime:Number = 0;
		private var _priority:Number = 0;
		
		
		public function FireOrbitingObjectAction( linkArray:Array, player:FlxSprite, speed:Number )
		{
			_linkArray = linkArray;
			_player = player;
			_speed = speed;
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
			var link:OrbitingObjectLink;
			var canFire:Boolean = false;
			for ( var i:int = 0; ( i < _linkArray.length ) && ( !canFire ); ++i )
			{
				link = ( _linkArray[i] as OrbitingObjectLink );
				if ( link.isOrbiting() )
				{
					canFire = true;
				}
			}
			
			if ( canFire )
			{
				var randIndex:int = Math.floor( Math.random() * _linkArray.length );
				link = ( _linkArray[randIndex] as OrbitingObjectLink );
				while ( !link.isOrbiting() )
				{
					randIndex = Math.floor( Math.random() * _linkArray.length );
					link = ( _linkArray[randIndex] as OrbitingObjectLink );
				}
				
				link.stopOrbiting();
				var child:FlxSprite = link.getChild();
				var newVelocity:FlxPoint = new FlxPoint();
				newVelocity.x = ( _player.x + _player.origin.x ) - ( child.x + child.origin.x );
				newVelocity.y = ( _player.y + _player.origin.y ) - ( child.y + child.origin.y );
				var magnitude:Number = FlxU.getDistance( new FlxPoint(), newVelocity );
				newVelocity.x /= magnitude;
				newVelocity.y /= magnitude;
				newVelocity.x *= _speed;
				newVelocity.y *= _speed;
				child.velocity = newVelocity;
			}
		}
		
	}

}