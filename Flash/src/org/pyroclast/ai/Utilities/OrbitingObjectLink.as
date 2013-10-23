package org.pyroclast.ai.Utilities 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author John Lynk
	 */
	public class OrbitingObjectLink 
	{
		private var _parent:FlxSprite;
		private var _child:FlxSprite;
		private var _distance:Number;
		private var _currentAngle:Number;
		private var _speed:Number;
		private var _currentlyOrbiting:Boolean;
		
		//Parent is what we are orbiting around
		//Child is what is orbiting
		//Speed is how much the angle should increase per update
		public function OrbitingObjectLink( parent:FlxSprite, child:FlxSprite, speed:Number ) 
		{
			_parent = parent;
			_child = child;
			_speed = speed;
			var parentCenter:FlxPoint = new FlxPoint( _parent.x + _parent.origin.x, _parent.y + _parent.origin.y );
			var childCenter:FlxPoint = new FlxPoint( _child.x + _child.origin.x, _child.y + _child.origin.y );
			_distance = FlxU.getDistance( parentCenter, childCenter );
			//May need to offset this
			//Subtracting 90 so 0 degrees is directly to the right instead of straight up
			_currentAngle = FlxU.getAngle( parentCenter, childCenter ) - 90;
			if ( _currentAngle < 0 ) _currentAngle += 360;
			_currentAngle *= ( ( 2 * Math.PI ) / 360.0 );
			_currentlyOrbiting = true;
		}
		
		public function update():void
		{
			if ( _currentlyOrbiting )
			{
				_currentAngle += _speed;
				_child.y = ( Math.sin( _currentAngle ) * _distance ) + _parent.y + _parent.origin.y - _child.origin.y;
				_child.x = ( Math.cos( _currentAngle ) * _distance ) + _parent.x + _parent.origin.x - _child.origin.x;
				
				var parentCenter:FlxPoint = new FlxPoint( _parent.x + _parent.origin.x, _parent.y + _parent.origin.y );
				var childCenter:FlxPoint = new FlxPoint( _child.x + _child.origin.x, _child.y + _child.origin.y );
			}
		}
		
		public function stopOrbiting():void
		{
			_currentlyOrbiting = false;
		}
		
		public function isOrbiting():Boolean
		{
			return _currentlyOrbiting;
		}
		
		public function getChild():FlxSprite
		{
			return _child;
		}
		
		public function printAngle():void
		{
			trace( "ANGLE: " + _currentAngle );
		}
		
	}

}