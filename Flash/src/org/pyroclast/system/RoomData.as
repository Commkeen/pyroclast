package org.pyroclast.system
{
	import flash.geom.Point;
	import flash.media.Microphone;
	import org.flixel.FlxTilemap;

	public class RoomData
	{
		public var room_id:uint;
		public var area:uint = 0;
		public var layer_tilesets:Vector.<String>; //Each is string representing the tileset to use
		public var layer_data:Vector.<Array>; //Each layer_data is a 1D array of tile indices
		public var backgroundImage_src:String; //Optional for overriding area default
		public var backgroundMusic_src:String; //Optional for overriding area default
		public var prefabs:Array;	// This will hold any game object prefabs the room contains. These will, essentially be anything that is not a tile
		public var width:uint = 20;
		public var height:uint = 15;
		public var roomX:int;
		public var roomY:int;
		
		public var empty:Boolean; //If true, this is an empty room that we haven't modified so don't bother saving it
		
		//Exit overrides for noneuclidean maps - if undefined, will calculate based on grid pos
		public var topExit:int;
		public var bottomExit:int;
		public var leftExit:int;
		public var rightExit:int;
		
		public function RoomData(id:uint, rx:uint, ry:uint)
		{
			room_id = id;
			roomX = rx;
			roomY = ry;
			init_room();
		}
		
		// This is the only updated function so far
		// ToDo: Update all of the function in this class to work with the new layer_data structure,
		// then go and fix playstate and flxgrid to utilize that structure too
		private function init_room():void
		{
			empty = true;
			layer_data = new Vector.<Array>;
			layer_tilesets = new Vector.<String>;
			
			
			
			//prefabs = new Array();
		}
		
		public function getTileIndex(layer:uint, coords:Point):int
		{
			return layer_data[layer][coords.y * width + coords.x];
			//return tile_data[coords.y][coords.x];
		}
		
		public function checkTileSet(layer:uint, coords:Point):Boolean
		{
			return layer_data[layer][coords.y * width + coords.x] != null;
			//return tile_data[coords.y][coords.x] != null;
		}
		
		public function setTile(layer:uint, coords:Point, tileIndex:int):void
		{
			empty = false;
			layer_data[layer][coords.y * width + coords.x] = tileIndex;
			//tile_data[coords.y][coords.x] = new TileData(src, tileset_coords);
		}
		
		public function clearTile(layer:uint, coords:Point):void
		{
			layer_data[layer][coords.y * width + coords.x] = 0;
		}
		
		public function toXML():XML
		{
			var room:XML = <room>
							<layer>
							</layer>
						  </room>;
			
			//Save room attributes
			room.@id = room_id;
			room.@area = area;
			
			if (backgroundImage_src != null)
				room.@bgimage = backgroundImage_src;
			
			room.@roomx = roomX;
			room.@roomy = roomY;
			
			//TODO: Exits
			
			
			//Save layers
			for (var i:int = 0; i < layer_data.length; i++)
			{
				room.layer[i] = FlxTilemap.arrayToCSV(layer_data[i], width);
				room.layer[i].@index = i;
				room.layer[i].@tileset = layer_tilesets[i];
			}
			
			return room;
		}
		
		public function loadFromXML(room:XML):void
		{
			layer_tilesets = new Vector.<String>;
			layer_data = new Vector.<Array>;
			
			//Load room attributes
			empty = false;
			
			width = 20;
			height = 15;
			
			room_id = room.@id;
			area = room.@area;
			
			if ("@bgimage" in room)
				backgroundImage_src = room.@bgimage;
				
			roomX = room.@roomx;
			roomY = room.@roomy;
			
			//TODO: load exits
			
			//Load layers
			for each (var layer:XML in room.layer)
			{
				var layerIndex:int = layer.@index;
				layer_tilesets[layerIndex] = layer.@tileset;
				layer_data[layerIndex] = CSVToArray(layer);
			}
		}
		
		private function CSVToArray(csv:String):Array
		{
			//Mercilessly stolen from flixel
			var columns:Array;
			var rows:Array = csv.split("\n");
			var heightInTiles = rows.length;
			var widthInTiles = 20; //TODO: Figure out properly
			var returnArray = new Array();
			var row:uint = 0;
			var column:uint;
			while(row < heightInTiles)
			{
				columns = rows[row++].split(",");
				if(columns.length <= 1)
				{
					heightInTiles = heightInTiles - 1;
					continue;
				}
				if(widthInTiles == 0)
					widthInTiles = columns.length;
				column = 0;
				while(column < widthInTiles)
					returnArray.push(uint(columns[column++]));
			}
			
			return returnArray;
		}
	}
	
}