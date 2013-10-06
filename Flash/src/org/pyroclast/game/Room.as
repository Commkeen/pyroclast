package org.pyroclast.game
{
	import flash.display.Bitmap;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class Room
	{
		public var roomID:Number;
		
		public var roomX:int; //Coordinates on map
		public var roomY:int; //Coordinates on map
		
		public var area:uint; //What game area we are in
		
		public var backgroundImage:Class; //Splash background, if any
		
		public var LayerTilesets:Vector.<String>; //Each layer's tileset is a string here
		public var LayerMaps:Vector.<String>; //Each layer's tilemap is a CSV string here
		
		public var musicID:String; //The name of the music for this room (optional, area default overrides)
		
		public var actors:Array; //2D array of values for each tile position
		
		//Exits
		//Optional, they override default coordinate system checking
		public var topExit:Number;
		public var bottomExit:Number;
		public var leftExit:Number;
		public var rightExit:Number;
		
		public function Room() 
		{
			musicID = "";
			
			roomID = 99999;
			roomX = 10000;
			roomY = 10000;
			
			area = 0;
			
			LayerMaps = new Vector.<String>;
			LayerTilesets = new Vector.<String>;
		}
		
	}

}