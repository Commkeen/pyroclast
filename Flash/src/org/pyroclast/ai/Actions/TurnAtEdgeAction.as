package org.pyroclast.ai.Actions 
{
	import org.pyroclast.ai.Interfaces.IAIAction;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author John Lynk
	 */
	public class TurnAtEdgeAction implements IAIAction 
	{
		
		private var _parent:FlxSprite;
		private var _expiryTime:int = 0;
		private var _priority:int = 0;
		private var _tilemap:FlxTilemap;
		private var _worldToTileX:Number;
		private var _worldToTileY:Number;
		private var _previousVelocityX:Number;
		
		public function TurnAtEdgeAction(parent:FlxSprite, tilemap:FlxTilemap) 
		{
			_parent = parent;
			_tilemap = tilemap;
			
			_worldToTileX = _tilemap.widthInTiles / _tilemap.width;
			_worldToTileY = _tilemap.heightInTiles / _tilemap.height;
			
			_previousVelocityX = _parent.velocity.x;
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
			var tileX:Number = _parent.x - _tilemap.x;
			if ( _parent.velocity.x > 0 )
			{
				tileX += _parent.width;
			}
			tileX *= _worldToTileX;
			tileX = Math.floor( tileX );
			var tileY:int = _parent.y + ( _parent.height * 1.5 ) - _tilemap.y;
			tileY *= _worldToTileY;			
			if ( _tilemap.getTile( tileX, tileY ) == 0 )
			{
				_parent.velocity.x = -_parent.velocity.x;
			}
			else if ( _parent.velocity.x == 0 )
			{
				_parent.velocity.x = -_previousVelocityX;
			}
			_previousVelocityX = _parent.velocity.x;
			if ( _parent.velocity.x > 0 )
			{
				_parent.facing = FlxObject.RIGHT;
			}
			else if ( _parent.velocity.x < 0 )
			{
				_parent.facing = FlxObject.LEFT;
			}
		}
		
	}

}